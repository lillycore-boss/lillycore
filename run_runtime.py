from runtime.interactive_runner import run_interactive
from runtime.terminal_ingress import TerminalIngressAdapter
from runtime.heartbeat import RuntimeStopRequested
from runtime.error_envelopes import wrap_exception

from runtime.runtime_system_settings import (
    resolve_runtime_system_settings,
    temp_override_from_env,
)

class DummyLogger:
    def info(self, msg, *args):
        print(msg % args if args else msg)

    def warning(self, msg, *args):
        print(("WARN: " + (msg % args if args else msg)))

    def error(self, msg, exc_info=None):
        print("ERROR:", msg, exc_info)

    # P1.1.5 can later formalise this:
    def envelope(self, env):
        print("ENVELOPE_EVENT:", env)  # opaque object


def load_settings(logger):
    return resolve_runtime_system_settings(
        temp_override=temp_override_from_env(),
        logger=logger,
    )

logger = DummyLogger()
settings = load_settings(logger)

def envelope_sink(env):
    # runtime -> logging seam (P1.1.5 will harden this)
    if hasattr(logger, "envelope"):
        logger.envelope(env)
    else:
        logger.error("Envelope event (no logger.envelope)", exc_info=None)

def _noop_handler(cmd: str) -> None:
    print(f"[ingress] {cmd}")

    # forced negative path for P1.1.4 proof:
    if cmd.strip().lower() == "boom":
        raise ValueError("forced error for envelope proof")

    if cmd.strip().lower() in {"quit", "exit"}:
        raise RuntimeStopRequested()

ingress = TerminalIngressAdapter(on_command=_noop_handler, prompt="lilly> ")

loop = run_interactive(
    settings_loader=lambda: settings,
    logger=logger,
    ingress_adapter=ingress,
    envelope_factory=wrap_exception,
    envelope_sink=envelope_sink,
    tick_interval_sec=settings.tick_interval_ms / 1000.0,
)

try:
    loop.run()
except KeyboardInterrupt:
    loop.request_stop()
