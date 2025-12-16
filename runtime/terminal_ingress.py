# lillycore/runtime/terminal_ingress.py

from __future__ import annotations

import queue
import sys
import threading
from typing import Optional

from runtime.command_ingress import Command, CommandHandler, CommandIngress


class TerminalIngressAdapter(CommandIngress):
    """
    Phase 1 ingress adapter: interactive terminal input.

    Design:
    - Background thread blocks on stdin.readline()
    - poll() drains a queue (non-blocking) and emits commands to handler
    """

    def __init__(
        self,
        on_command: CommandHandler,
        *,
        prompt: str = "> ",
        strip: bool = True,
    ):
        self._on_command = on_command
        self._prompt = prompt
        self._strip = strip

        self._q: queue.SimpleQueue[Optional[str]] = queue.SimpleQueue()
        self._started = False
        self._lock = threading.Lock()

    def start(self) -> None:
        with self._lock:
            if self._started:
                return
            self._started = True

            t = threading.Thread(target=self._reader_thread, name="terminal-ingress", daemon=True)
            t.start()

    def poll(self) -> None:
        # Ensure thread exists, but keep tick path non-blocking.
        if not self._started:
            self.start()

        while True:
            try:
                line = self._q.get_nowait()
            except Exception:
                return

            if line is None:
                # EOF
                self._on_command("EOF")
                return

            cmd = line
            if self._strip:
                cmd = cmd.strip()

            if not cmd:
                continue

            self._on_command(cmd)

    # ---- internal --------------------------------------------------------

    def _reader_thread(self) -> None:
        try:
            while True:
                # Prompt without relying on input() (lets us control thread/EOF cleanly)
                sys.stdout.write(self._prompt)
                sys.stdout.flush()

                line = sys.stdin.readline()
                if line == "":
                    self._q.put(None)
                    return

                self._q.put(line)
        except Exception:
            # In Phase 1, treat reader failure as EOF-ish; handler decides.
            self._q.put(None)
