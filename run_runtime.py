# run_runtime.py

from lillycore.runtime.interactive_runner import run_interactive
from lillycore.runtime.terminal_ingress import TerminalIngressAdapter


class DummyLogger:
    def info(self, msg): print(msg)
    def error(self, msg, exc_info=None): print(msg, exc_info)


def load_settings():
    return {}


def handle_envelope(exc):
    print("Envelope received:", exc)


# Ingress owns its own handler (closure) OR runner injects one.
# Here we rely on closure by making a trivial passthrough and letting runner log + exit.
# (runner’s on_command is used if you implement set_handler; otherwise this just logs itself)
def _noop_handler(cmd: str) -> None:
    print(f"[ingress] {cmd}")


ingress = TerminalIngressAdapter(on_command=_noop_handler, prompt="lilly> ")

loop = run_interactive(
    settings_loader=load_settings,
    logger=DummyLogger(),
    ingress_adapter=ingress,
    envelope_handler=handle_envelope,
)

try:
    loop.run()
except KeyboardInterrupt:
    loop.request_stop()
