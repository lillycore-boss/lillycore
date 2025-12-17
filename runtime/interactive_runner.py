# lillycore/runtime/interactive_runner.py

import time
from runtime.heartbeat import HeartbeatLoop, RuntimeStopRequested


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

    # ---- command handling (Phase 1: demonstrate ingestion, minimal semantics)
    def on_command(cmd: str):
        logger.info(f"COMMAND: {cmd}")
        if cmd.lower() in {"exit", "quit"}:
            raise RuntimeStopRequested()

    # If the ingress adapter supports a handler injection pattern, prefer it.
    # Otherwise, adapters can close over on_command internally.
    if ingress_adapter and hasattr(ingress_adapter, "set_handler"):
        ingress_adapter.set_handler(on_command)

    # ---- lifecycle hooks ------------------------------------------------
    def on_start():
        logger.info("Runtime starting (Phase 1 interactive)")
        if ingress_adapter and hasattr(ingress_adapter, "start"):
            ingress_adapter.start()

    def on_tick():
        # ingress polling is a seam, not behaviour
        if ingress_adapter:
            ingress_adapter.poll()

        time.sleep(tick_interval_sec)

    def on_stop():
        logger.info("Runtime stopping (Phase 1 interactive)")

    loop = HeartbeatLoop(
        on_start=on_start,
        on_tick=on_tick,
        on_stop=on_stop,
        logger=logger,
        ingress=ingress_adapter,
        envelope_factory=envelope_factory,
        envelope_sink=envelope_sink,
    )

    return loop
