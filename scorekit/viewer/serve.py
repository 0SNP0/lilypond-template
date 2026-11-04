#!/usr/bin/env python3
"""Open the portable ScoreKit web viewer on localhost; no LilyPond required."""
from __future__ import annotations

import functools
import http.server
import threading
import webbrowser
from pathlib import Path

ROOT = Path(__file__).resolve().parent / "portal"
HOST, PORT = "127.0.0.1", 8000


def main() -> None:
    handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(ROOT))
    with http.server.ThreadingHTTPServer((HOST, PORT), handler) as server:
        url = f"http://{HOST}:{server.server_port}/"
        print(f"ScoreKit Viewer: {url}")
        print("Open SVG/JSON ZIP downloaded from Actions, or choose a public repository.")
        print("Press Ctrl+C to stop.")
        threading.Timer(0.5, lambda: webbrowser.open(url)).start()
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            print("\nStopping viewer.")


if __name__ == "__main__":
    main()
