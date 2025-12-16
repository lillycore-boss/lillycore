# lillycore/runtime/command_ingress.py

from __future__ import annotations

from typing import Callable, Protocol, TypeAlias

Command: TypeAlias = str
CommandHandler = Callable[[Command], None]


class CommandIngress(Protocol):
    """
    Replaceable boundary for command ingress.

    Phase 1 contract:
    - poll() must be non-blocking
    - any blocking IO must happen outside the tick path
    """
    def poll(self) -> None: ...
