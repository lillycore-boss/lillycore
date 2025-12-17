# lillycore/runtime/interactive_runner.py

import time
import os
from lillycore.runtime.heartbeat import HeartbeatLoop, RuntimeStopRequested


def run_interactive(
    *,
    settings_loader,
    logger,
    ingress_adapter,

    # Phase 1 envelope integration seams
    envelope_factory,
    envelope_sink,

    tick_interval_sec: float = 0.5,
):
    """
    Phase 1 interactive runtime runner.

    All integrations are passed in.
    """

    # ---- settings -------------------------------------------------------
    settings = settings_loader()

    # Phase 1 settings contract (P1.1.3): settings are operational/runtime-focused.
    # We apply only minimal operational values here to avoid expanding scope.
    #
    # If present, allow settings to override the tick interval used by this runner.
    # If absent or invalid, we keep the provided default argument.
    if isinstance(settings, dict):
        try:
            maybe_interval = settings.get("tick_interval_sec", None)
            if maybe_interval is not None:
                tick_interval_sec = float(maybe_interval)
        except Exception:
            # Settings must not break the runtime in Phase 1; keep the default.
            pass

    # If the logger supports being configured from settings, allow it.
    # This keeps logging verbosity/heartbeat emission controlled by settings (P1.1.5)
    # without assuming a specific logging backend implementation.
    if logger and hasattr(logger, "configure_from_settings"):
        try:
            logger.configure_from_settings(settings)
        except Exception:
            # Logging configuration MUST NOT break runtime control flow in Phase 1.
            pass

    # ---- command handling (Phase 1: demonstrate ingestion, minimal semantics)
    def on_command(cmd: str):
        logger.info(f"COMMAND: {cmd}")
        if cmd.strip().lower() in {"stop", "/stop", "exit", "quit", "/quit"}:
            raise RuntimeStopRequested()

    # If the ingress adapter supports a handler injection pattern, prefer it.
    # Otherwise, adapters can close over on_command internally.
    if ingress_adapter and hasattr(ingress_adapter, "set_handler"):
        ingress_adapter.set_handler(on_command)

    # ---- envelope sink wrapping -----------------------------------------
    # Phase 1 envelope integration boundary (P1.1.4):
    # - treat envelope as opaque (do not inspect schema)
    # - ensure envelope propagation reaches unified logging (P1.1.5)
    def _envelope_sink_wrapped(envelope_obj):
        # If the logger supports a first-class envelope event, emit it.
        if logger and hasattr(logger, "envelope"):
            try:
                logger.envelope(envelope_obj, source="runtime_boundary")
            except Exception:
                # Logging MUST NOT break runtime control flow in Phase 1.
                pass

        # Preserve existing sink behaviour if provided.
        if envelope_sink:
            return envelope_sink(envelope_obj)

        return None

    # ---- lifecycle hooks ------------------------------------------------
    def on_start():
        logger.info("Runtime starting (Phase 1 interactive)")
        if ingress_adapter and hasattr(ingress_adapter, "start"):
            ingress_adapter.start()

    def on_tick():
        # NOTE (P1.1.6): ingress polling for stop semantics is handled by the
        # heartbeat loop (via the ingress seam). Avoid double polling here.
        time.sleep(tick_interval_sec)

    def on_stop():
        logger.info("Runtime stopping (Phase 1 interactive)")

        # P1.1.6 negative-path proof hook:
        # if set, force an error during shutdown so HeartbeatLoop must envelope+log it.
        if os.environ.get("FORCE_SHUTDOWN_ERROR", "").strip() == "1":
            raise RuntimeError("forced shutdown failure (P1.1.6 negative-path proof)")

    loop = HeartbeatLoop(
        on_start=on_start,
        on_tick=on_tick,
        on_stop=on_stop,
        logger=logger,
        ingress=ingress_adapter,
        envelope_factory=envelope_factory,
        envelope_sink=_envelope_sink_wrapped,
    )

    return loop
