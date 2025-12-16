# run_runtime.py

from lillycore.runtime.interactive_runner import run_interactive


class DummyLogger:
    def info(self, msg): print(msg)
    def error(self, msg, exc_info=None): print(msg, exc_info)


class DummyIngress:
    def poll(self): pass


def load_settings():
    return {}


def handle_envelope(exc):
    print("Envelope received:", exc)


loop = run_interactive(
    settings_loader=load_settings,
    logger=DummyLogger(),
    ingress_adapter=DummyIngress(),
    envelope_handler=handle_envelope,
)

try:
    loop.run()
except KeyboardInterrupt:
    loop.request_stop()

