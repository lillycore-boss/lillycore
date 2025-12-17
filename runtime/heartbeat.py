# lillycore/runtime/heartbeat.py

from typing import Callable, Optional, Any


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

    # ---- control surface -------------------------------------------------

    def request_stop(self):
        self._stop_requested = True

    # ---- lifecycle -------------------------------------------------------

    def run(self):
        try:
            if self._on_start:
                self._on_start()

            while not self._stop_requested:
                try:
                    if self._on_tick:
                        self._on_tick()
                except RuntimeStopRequested:
                    self.request_stop()
                except Exception as exc:
                    self._propagate_error(exc)

        finally:
            if self._on_stop:
                self._on_stop()

    # ---- error handling --------------------------------------------------

    def _propagate_error(self, exc: Exception):
        """
        Treat envelope as opaque.

        Phase 1 boundary:
        - runtime converts an exception into an envelope via the
          envelope authority (factory)
        - runtime forwards the envelope to the logging seam (sink)

        This method MUST NOT inspect or mutate envelope contents.
        """
        if self._envelope_factory and self._envelope_sink:
            env = self._envelope_factory(exc, where="runtime.tick")
            self._envelope_sink(env)
            return

        # existing fallback behaviour remains intact
        if self._logger:
            self._logger.error("Unhandled exception in heartbeat loop", exc_info=exc)
        else:
            raise
