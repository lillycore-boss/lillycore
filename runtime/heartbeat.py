# lillycore/runtime/heartbeat.py

from typing import Callable, Optional, Any
import os

class RuntimeStopRequested(Exception):
    """
    Internal control signal.
    Not an error envelope.
    """
    pass


class HeartbeatLoop:
    """
    Phase 1 interactive heartbeat loop.

    Owns:
    - lifecycle sequencing
    - stop flag
    - deterministic tick progression

    Does NOT own:
    - ingress implementation
    - logging implementation
    - envelope schema
    """

    def __init__(
        self,
        on_start: Optional[Callable[[], None]] = None,
        on_tick: Optional[Callable[[], None]] = None,
        on_stop: Optional[Callable[[], None]] = None,
        *,
        logger=None,
        ingress=None,

        # Phase 1 envelope integration:
        # - factory: creates an opaque envelope from an exception
        # - sink: emits the envelope to logging or other consumers
        envelope_factory: Optional[Callable[..., Any]] = None,
        envelope_sink: Optional[Callable[[Any], None]] = None,
    ):
        self._on_start = on_start
        self._on_tick = on_tick
        self._on_stop = on_stop

        self._logger = logger
        self._ingress = ingress
        self._envelope_factory = envelope_factory
        self._envelope_sink = envelope_sink

        self._stop_requested = False
        self._stop_reason = None

        #This line made unneccesary in P1.1.6
        # Phase 1 stop command triggers (P1.1.6):
        # Keep this small and explicit; command routing beyond stop remains out of scope.
        # self._stop_commands = {"stop", "quit", "exit", "/stop", "/quit"}

        # Phase 1 logging hook support (P1.1.5):
        # Keep a deterministic tick counter so heartbeat logging can reference
        # a stable tick_id without relying on wall-clock time.
        self._tick_id = 0

    # ---- control surface -------------------------------------------------

    def request_stop(self, reason: Optional[str] = None):
        self._stop_requested = True
        if reason is not None:
            self._stop_reason = reason

    # ---- lifecycle -------------------------------------------------------

    def run(self):
        try:
            # Phase 1 logging hook: lifecycle start
            # - Do not assume a logging backend.
            # - If a unified runtime logger exists (P1.1.5), it can expose
            #   lifecycle_start(). If not, this becomes a no-op.
            if self._logger and hasattr(self._logger, "lifecycle_start"):
                try:
                    self._logger.lifecycle_start(component="core_runtime")
                except Exception:
                    # Logging MUST NOT break runtime control flow in Phase 1.
                    pass

            if self._on_start:
                self._on_start()

            while not self._stop_requested:

                # Phase 1 stop/shutdown semantics (P1.1.6):
                # Ingress is a seam. Adapters may implement command handling via
                # a handler callback (raising RuntimeStopRequested as control flow).
                if self._ingress and hasattr(self._ingress, "poll"):
                    try:
                        self._ingress.poll()
                    except RuntimeStopRequested:
                        # Control signal: not an envelope.
                        self.request_stop(reason="command:handler")
                        continue
                    except Exception as exc:
                        # Ingress failure is a boundary error: envelope it.
                        self._propagate_error(exc, where="runtime.ingress")

                try:
                    # Deterministic tick progression (owned by the loop).
                    self._tick_id += 1

                    # Phase 1 logging hook: bounded heartbeat/tick
                    # Heartbeat "spam control" is handled by the logger/settings,
                    # not by the runtime loop. The loop only provides tick_id.
                    if self._logger and hasattr(self._logger, "tick"):
                        try:
                            self._logger.tick(tick_id=self._tick_id)
                        except Exception:
                            # Logging MUST NOT break runtime control flow in Phase 1.
                            pass

                    if self._on_tick:
                        self._on_tick()
                except RuntimeStopRequested:
                    # Stop requested; reason may already be set.
                    self._stop_requested = True
                except Exception as exc:
                    self._propagate_error(exc)

        finally:
            # Phase 1 logging hook: lifecycle stop
            if self._logger and hasattr(self._logger, "lifecycle_stop"):
                try:
                    self._logger.lifecycle_stop(component="core_runtime")
                except Exception as exc:
                    # Shutdown-time errors MUST be enveloped and logged (P1.1.6).
                    self._propagate_error(exc, where="runtime.shutdown.lifecycle_stop")

            if self._on_stop:
                try:
                    # Negative-path shutdown proof hook (P1.1.6):
                    # FORCE_SHUTDOWN_ERROR=1 forces an exception during shutdown (on_stop)
                    # which MUST be enveloped and logged.
                    if os.getenv("FORCE_SHUTDOWN_ERROR") == "1":
                        raise RuntimeError("Forced shutdown error (FORCE_SHUTDOWN_ERROR=1)")

                    self._on_stop()
                except RuntimeStopRequested:
                    # Control signal: MUST NOT be wrapped as an envelope.
                    # Shutdown is already in progress; treat as no-op.
                    pass
                except Exception as exc:
                    # Shutdown-time errors MUST be enveloped and logged (P1.1.6).
                    self._propagate_error(exc, where="runtime.shutdown.on_stop")

            # Phase 1 logging finalization (P1.1.6):
            # Prefer a single finalization hook if present (avoid triple-calling aliases).
            if self._logger:
                hook_name = None
                for candidate in ("finalize", "flush", "finish"):
                    if hasattr(self._logger, candidate):
                        hook_name = candidate
                        break

                if hook_name is not None:
                    try:
                        getattr(self._logger, hook_name)()
                    except Exception as exc:
                        self._propagate_error(exc, where=f"runtime.shutdown.logger.{hook_name}")

    # ---- error handling --------------------------------------------------

    def _propagate_error(self, exc: Exception, where: str = "runtime.tick"):
        """
        Treat envelope as opaque.

        Phase 1 boundary:
        - runtime converts an exception into an envelope via the
          envelope authority (factory)
        - runtime forwards the envelope to the logging seam (sink)

        This method MUST NOT inspect or mutate envelope contents.
        """
        if self._envelope_factory and self._envelope_sink:
            env = self._envelope_factory(exc, where=where)
            self._envelope_sink(env)
            return

        # existing fallback behaviour remains intact
        if self._logger:
            self._logger.error("Unhandled exception in heartbeat loop", exc_info=exc)
        else:
            raise
