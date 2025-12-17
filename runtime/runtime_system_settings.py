from __future__ import annotations

import json
import os
from dataclasses import dataclass, asdict
from typing import Any, Dict, Optional, Tuple, List


# Phase 1 canonical path (per card)
CANONICAL_SYSTEM_SETTINGS_PATH = "runtime/config/runtime.system.json"


@dataclass(frozen=True)
class RuntimeSystemSettings:
    """
    Operational/runtime settings only.
    Explicitly NOT persona / AI behaviour settings.
    """
    async_enabled: bool
    tick_interval_ms: int
    log_level: str      # DEBUG|INFO|WARNING|ERROR|CRITICAL
    log_format: str     # text|json


def default_runtime_system_settings() -> RuntimeSystemSettings:
    # Internal defaults (lowest precedence)
    return RuntimeSystemSettings(
        async_enabled=True,
        tick_interval_ms=100,
        log_level="INFO",
        log_format="text",
    )


def _load_json_file(path: str) -> Tuple[Optional[Dict[str, Any]], Optional[str]]:
    """
    Returns (data, warning). Missing file is not an error.
    Invalid JSON / wrong shape raises ValueError.
    """
    if not os.path.exists(path):
        return None, f"Runtime system settings file not found at '{path}' (using defaults)."

    with open(path, "r", encoding="utf-8") as f:
        data = json.load(f)

    if not isinstance(data, dict):
        raise ValueError(f"Runtime system settings JSON must be an object/dict: {path}")

    return data, None


def _coerce_and_validate(settings: Dict[str, Any]) -> RuntimeSystemSettings:
    allowed_keys = {"async_enabled", "tick_interval_ms", "log_level", "log_format"}
    unknown = set(settings.keys()) - allowed_keys
    if unknown:
        raise ValueError(f"Unknown runtime system settings keys: {sorted(unknown)}")

    base = asdict(default_runtime_system_settings())
    merged = {**base, **settings}

    async_enabled = bool(merged["async_enabled"])
    tick_interval_ms = int(merged["tick_interval_ms"])
    log_level = str(merged["log_level"]).upper()
    log_format = str(merged["log_format"]).lower()

    if tick_interval_ms <= 0:
        raise ValueError("tick_interval_ms must be > 0")
    if log_level not in {"DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"}:
        raise ValueError(f"Unsupported log_level: {log_level}")
    if log_format not in {"text", "json"}:
        raise ValueError(f"Unsupported log_format: {log_format}")

    return RuntimeSystemSettings(
        async_enabled=async_enabled,
        tick_interval_ms=tick_interval_ms,
        log_level=log_level,
        log_format=log_format,
    )


def resolve_runtime_system_settings(
    *,
    system_settings_path: str = CANONICAL_SYSTEM_SETTINGS_PATH,
    temp_override: Optional[Dict[str, Any]] = None,
    logger: Optional[Any] = None,
) -> RuntimeSystemSettings:
    """
    Precedence (exact): defaults < file < temp_override
    Logging: sources applied + changed key names only (no values).
    """
    sources: List[str] = ["defaults"]
    changed: Dict[str, List[str]] = {"file": [], "temp_override": []}

    base = asdict(default_runtime_system_settings())

    file_data, warn = _load_json_file(system_settings_path)
    if warn and logger:
        logger.warning(warn)

    if file_data:
        sources.append("file")
        for k, v in file_data.items():
            if k in base and v != base.get(k):
                changed["file"].append(k)
        base.update(file_data)

    if temp_override:
        sources.append("temp_override")
        for k, v in temp_override.items():
            if k in base and v != base.get(k):
                changed["temp_override"].append(k)
        base.update(temp_override)

    settings = _coerce_and_validate(base)

    if logger:
        logger.info(
            "Runtime system settings resolved. sources=%s changed_keys=%s",
            sources,
            {k: v for k, v in changed.items() if v},
        )

    return settings

def temp_override_from_env(env_var: str = "LILLYCORE_RUNTIME_TEMP_OVERRIDE_JSON") -> Optional[Dict[str, Any]]:
    """
    Phase 1 temp override mechanism:
    - Set env var to a JSON object string, e.g.:
      export LILLYCORE_RUNTIME_TEMP_OVERRIDE_JSON='{\"tick_interval_ms\":50}'
    """
    raw = os.environ.get(env_var)
    if not raw:
        return None
    data = json.loads(raw)
    if not isinstance(data, dict):
        raise ValueError(f"{env_var} must be a JSON object/dict")
    return data
