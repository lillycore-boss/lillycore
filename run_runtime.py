# run_runtime.py

from lillycore.runtime.interactive_runner import run_interactive
from lillycore.runtime.terminal_ingress import TerminalIngressAdapter
from lillycore.runtime.heartbeat import RuntimeStopRequested
from lillycore.runtime.error_envelopes import wrap_exception

from lillycore.runtime.runtime_system_settings import (
    resolve_runtime_system_settings,
    temp_override_from_env,
)

class DummyLogger:
    def info(self, msg, *args):
        print(msg % args if args else msg)

    # NOTE: existing code used "warning" (not "warn"); keep it intact.
    def warning(self, msg, *args):
        print(("WARN: " + (msg % args if args else msg)))

    def error(self, msg, exc_info=None):
        print("ERROR:", msg, exc_info)

    # P1.1.5 can later formalise this:
    # Updated to accept optional metadata without breaking older callers.
    def envelope(self, env, **kwargs):
        if kwargs:
            print("ENVELOPE_EVENT:", {"envelope": env, "meta": kwargs})  # opaque object + meta
        else:
            print("ENVELOPE_EVENT:", env)  # opaque object


class Phase1RuntimeLogger:
    """
    Phase 1 unified logging adapter (P1.1.5):
    - Default sink is console/stdout via DummyLogger.
    - Adds lifecycle + bounded heartbeat + envelope event helpers.
    - Heartbeat is bounded and OFF by default to avoid spam.
    """

    def __init__(self, base_logger: DummyLogger):
        self._base = base_logger

        # Heartbeat logging must be bounded; avoid spam by default (P1.1.5).
        self._heartbeat_enabled = False
        self._heartbeat_every_n_ticks = 10

    # Optional: allow runtime settings to enable heartbeat logging.
    # This must be defensive: do not assume schema; only read if present.
    def configure_from_settings(self, settings):
        # settings may be a dict or an object; support both without assumptions.
        try:
            if isinstance(settings, dict):
                cfg = settings.get("runtime_logging", {}) or {}
                self._heartbeat_enabled = bool(cfg.get("heartbeat_enabled", self._heartbeat_enabled))
                self._heartbeat_every_n_ticks = int(cfg.get("heartbeat_every_n_ticks", self._heartbeat_every_n_ticks))
            else:
                # Object-style: only apply if attributes exist.
                if hasattr(settings, "heartbeat_enabled"):
                    self._heartbeat_enabled = bool(getattr(settings, "heartbeat_enabled"))
                if hasattr(settings, "heartbeat_every_n_ticks"):
                    self._heartbeat_every_n_ticks = int(getattr(settings, "heartbeat_every_n_ticks"))
        except Exception:
            # Settings must not break logging in Phase 1.
            pass

        # Hard safety clamp: ensure we never divide/mod by 0.
        try:
            if self._heartbeat_every_n_ticks < 1:
                self._heartbeat_every_n_ticks = 1
        except Exception:
            self._heartbeat_every_n_ticks = 10

    # ---- lifecycle hooks (called by heartbeat loop if present) ----
    def lifecycle_start(self, **fields):
        self._base.info("RUNTIME_START %s", fields if fields else "")

    def lifecycle_stop(self, **fields):
        self._base.info("RUNTIME_STOP %s", fields if fields else "")

    # ---- bounded heartbeat (called by heartbeat loop if present) ----
    def tick(self, tick_id: int, **fields):
        if not self._heartbeat_enabled:
            return

        n = self._heartbeat_every_n_ticks if self._heartbeat_every_n_ticks else 10
        if (tick_id % n) != 0:
            return

        # Keep output simple and Phase 1-friendly.
        merged = dict(fields or {})
        merged["tick_id"] = tick_id
        merged["every_n_ticks"] = n
        self._base.info("HEARTBEAT %s", merged)

    # ---- envelope event (called by interactive runner wrapper if present) ----
    def envelope(self, env, **fields):
        # Treat envelope as opaque; do not inspect schema.
        self._base.envelope(env, **(fields or {}))

    # ---- pass-through for existing callsites ----
    def info(self, msg, *args):
        self._base.info(msg, *args)

    def warning(self, msg, *args):
        self._base.warning(msg, *args)

    def error(self, msg, exc_info=None):
        self._base.error(msg, exc_info=exc_info)


def load_settings(logger):
    return resolve_runtime_system_settings(
        temp_override=temp_override_from_env(),
        logger=logger,
    )

# Use a Phase 1 unified logger wrapper (P1.1.5) so heartbeat.py hook calls work.
logger = Phase1RuntimeLogger(DummyLogger())
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
