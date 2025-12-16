# lillycore/runtime/interactive_runner.py

import time
from lillycore.runtime.heartbeat import HeartbeatLoop


def run_interactive(
    *,
    settings_loader,
    logger,
    ingress_adapter,
    envelope_handler,
    tick_interval_sec: float = 0.5,
):
    """
    Phase 1 interactive runtime runner.

    All integrations are passed in.
    """

    # ---- settings -------------------------------------------------------
    settings = settings_loader()

    # ---- lifecycle hooks ------------------------------------------------
    def on_start():
        logger.info("Runtime starting (Phase 1 interactive)")

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
        envelope_handler=envelope_handler,
    )

    return loop
