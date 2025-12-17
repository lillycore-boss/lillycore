# run_runtime.py

from runtime.interactive_runner import run_interactive
from runtime.terminal_ingress import TerminalIngressAdapter
from runtime.heartbeat import RuntimeStopRequested

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


def load_settings(logger):
    # defaults < file < temp override
    return resolve_runtime_system_settings(
        temp_override=temp_override_from_env(),
        logger=logger,
    )


def handle_envelope(exc):
    print("Envelope received:", exc)


def _noop_handler(cmd: str) -> None:
    print(f"[ingress] {cmd}")
    if cmd.strip().lower() in {"quit", "exit"}:
        raise RuntimeStopRequested()


logger = DummyLogger()

# Resolve once, then pass a stable loader into the runner seam.
settings = load_settings(logger)

ingress = TerminalIngressAdapter(on_command=_noop_handler, prompt="lilly> ")

loop = run_interactive(
    settings_loader=lambda: settings,
    logger=logger,
    ingress_adapter=ingress,
    envelope_handler=handle_envelope,
    tick_interval_sec=settings.tick_interval_ms / 1000.0,
)

try:
    loop.run()
except KeyboardInterrupt:
    loop.request_stop()
