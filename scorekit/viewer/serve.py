#!/usr/bin/env python3
"""Open the portable ScoreKit web viewer on localhost; no LilyPond required."""
from __future__ import annotations

import functools
import http.server
import threading
import webbrowser
from pathlib import Path
import argparse
import tempfile
from build_site import PROJECT, build_site

def main() -> None:
    parser = argparse.ArgumentParser(description="Serve ScoreKit Viewer and parent site")
    parser.add_argument("--project-root", type=Path, default=PROJECT)
    parser.add_argument("--port", type=int, default=8000)
    parser.add_argument("--no-browser", action="store_true")
    args = parser.parse_args()
    with tempfile.TemporaryDirectory(prefix="scorekit-viewer-") as directory:
        root = build_site(args.project_root, Path(directory) / "site")
        handler = functools.partial(http.server.SimpleHTTPRequestHandler, directory=str(root))
        with http.server.ThreadingHTTPServer(("127.0.0.1", args.port), handler) as server:
            url = f"http://127.0.0.1:{server.server_port}/viewer/"
            print(f"ScoreKit Viewer: {url}", flush=True)
            print("Press Ctrl+C to stop.", flush=True)
            if not args.no_browser:
                timer = threading.Timer(0.5, lambda: webbrowser.open(url))
                timer.daemon = True
                timer.start()
            try:
                server.serve_forever()
            except KeyboardInterrupt:
                print("\\nStopping viewer.")


if __name__ == "__main__":
    main()
