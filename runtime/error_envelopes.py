# lillycore/runtime/error_envelopes.py

from __future__ import annotations

from dataclasses import dataclass
from typing import Any, Mapping, Optional
import time
import traceback


@dataclass(frozen=True)
class ErrorEnvelope:
    """
    Opaque structured error container.

    NOTE:
    - Treat this as the envelope authority object.
    - Other modules (runtime/logging) should NOT rely on its internal shape.
    """

    _exc: BaseException
    _where: Optional[str]
    _severity: str
    _context: Mapping[str, Any]
    _tags: Mapping[str, Any]
    _ts: float
    _traceback: str


def wrap_exception(
    exc: BaseException,
    *,
    where: str | None = None,
    severity: str = "error",
    context: Mapping[str, Any] | None = None,
    tags: Mapping[str, Any] | None = None,
    clock: float | None = None,
) -> ErrorEnvelope:
    """
    Envelope authority entrypoint for Phase 1.

    Returns an opaque ErrorEnvelope object. Callers must not assume fields.
    """
    ts = clock if clock is not None else time.time()
    tb = "".join(traceback.format_exception(type(exc), exc, exc.__traceback__))

    return ErrorEnvelope(
        _exc=exc,
        _where=where,
        _severity=severity,
        _context=dict(context or {}),
        _tags=dict(tags or {}),
        _ts=ts,
        _traceback=tb,
    )
