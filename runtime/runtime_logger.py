from __future__ import annotations

import json
import sys
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Any, Dict, Optional


def _utc_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def _safe(obj: Any) -> Any:
    """
    Phase 1 rule: do not invent schema for envelopes or other opaque objects.
    We try to JSON-encode; if not possible, fall back to a repr wrapper.
    """
    try:
        json.dumps(obj)
        return obj
    except TypeError:
        return {"__repr__": repr(obj), "__type__": type(obj).__name__}


@dataclass(frozen=True)
class LoggingConfig:
    level: str = "INFO"

    # Heartbeat logging must be bounded and avoid spam by default.
    heartbeat_enabled: bool = False
    heartbeat_every_n_ticks: int = 10

    # Optional: allow explicit runtime loop tick interval logging
    include_tick_timing: bool = False


class RuntimeLogger:
    """
    Phase 1 unified logger:
    - Emits JSON Lines to stdout/stderr
    - Minimal levels
    - First-class events: lifecycle, heartbeat, envelope
    """

    def __init__(self, config: Optional[LoggingConfig] = None, stream=None):
        self.config = config or LoggingConfig()
        self.stream = stream or sys.stdout
        self._tick_counter = 0
        self._last_tick_ts = None  # type: Optional[float]

    def _level_allows(self, level: str) -> bool:
        order = {"DEBUG": 10, "INFO": 20, "WARN": 30, "ERROR": 40}
        cfg = order.get(self.config.level.upper(), 20)
        lvl = order.get(level.upper(), 20)
        return lvl >= cfg

    def _emit(self, level: str, event: str, fields: Dict[str, Any]) -> None:
        if not self._level_allows(level):
            return

        record = {
            "ts": _utc_iso(),
            "level": level.upper(),
            "event": event,
            "fields": {k: _safe(v) for k, v in fields.items()},
        }
        self.stream.write(json.dumps(record, ensure_ascii=False) + "\n")
        self.stream.flush()

    # ---- public event helpers ----

    def finalize(self, **fields: Any) -> None:
        """
        Phase 1 shutdown finalization hook (P1.1.6).

        Even though we flush per line, the runtime loop should have an explicit
        place to ask logging to finish/flush any buffered work.
        """
        self._emit("INFO", "runtime.logging.finalize", fields)
        try:
            self.stream.flush()
        except Exception:
            # Logging MUST NOT break runtime control flow in Phase 1.
            pass

    def flush(self, **fields: Any) -> None:
        """
        Phase 1 shutdown finalization alias (P1.1.6).
        HeartbeatLoop may call flush() if present.
        """
        self.finalize(**fields)

    def finish(self, **fields: Any) -> None:
        """
        Phase 1 shutdown finalization alias (P1.1.6).
        HeartbeatLoop may call finish() if present.
        """
        self.finalize(**fields)

    def lifecycle_start(self, **fields: Any) -> None:
        self._emit("INFO", "runtime.lifecycle.start", fields)

    def lifecycle_stop(self, **fields: Any) -> None:
        self._emit("INFO", "runtime.lifecycle.stop", fields)

    def configure_from_settings(self, settings: Dict[str, Any]) -> None:
        """
        Optional Phase 1 seam: allow runtime to configure logging from settings (P1.1.5).
        Must never throw in a way that breaks runtime control flow; caller already guards,
        but keep this safe anyway.
        """
        try:
            self.config = logging_config_from_settings(settings)
        except Exception:
            pass

    def tick(self, tick_id: int, **fields: Any) -> None:
        """
        Bounded heartbeat/tick logging.
        """
        self._tick_counter += 1

        if not self.config.heartbeat_enabled:
            return

        n = max(1, int(self.config.heartbeat_every_n_ticks))
        if (self._tick_counter % n) != 0:
            return

        if self.config.include_tick_timing:
            now = time.time()
            if self._last_tick_ts is not None:
                fields["tick_dt_seconds"] = now - self._last_tick_ts
            self._last_tick_ts = now

        fields["tick_id"] = tick_id
        fields["heartbeat_every_n_ticks"] = n
        self._emit("INFO", "runtime.heartbeat.tick", fields)

    def envelope(self, envelope_obj: Any, **fields: Any) -> None:
        """
        Log envelope as a structured event without inventing schema.
        We include the envelope object as an opaque payload.
        """
        fields["envelope"] = envelope_obj
        self._emit("ERROR", "runtime.envelope.received", fields)

    def info(self, event: str, **fields: Any) -> None:
        self._emit("INFO", event, fields)

    def warn(self, event: str, **fields: Any) -> None:
        self._emit("WARN", event, fields)

    def error(self, event: str, **fields: Any) -> None:
        self._emit("ERROR", event, fields)


def logging_config_from_settings(settings: Dict[str, Any]) -> LoggingConfig:
    """
    Settings keys are operational only (P1.1.3). Keep minimal.
    This reads a small "runtime_logging" namespace and falls back safely.
    """
    cfg = (
        (settings or {}).get("runtime_logging", {})
        if isinstance(settings, dict)
        else {}
    )
    return LoggingConfig(
        level=str(cfg.get("level", "INFO")).upper(),
        heartbeat_enabled=bool(cfg.get("heartbeat_enabled", False)),
        heartbeat_every_n_ticks=int(cfg.get("heartbeat_every_n_ticks", 10)),
        include_tick_timing=bool(cfg.get("include_tick_timing", False)),
    )
