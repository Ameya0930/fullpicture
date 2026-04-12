#!/bin/zsh
set -euo pipefail

PROJECT_DIR="/Users/ameyakulkarni/Desktop/fullpicture"
RUN_DIR="$PROJECT_DIR/.run"

if [[ -f "$RUN_DIR/cloudflared.pid" ]] && kill -0 "$(cat "$RUN_DIR/cloudflared.pid")" 2>/dev/null; then
  kill "$(cat "$RUN_DIR/cloudflared.pid")" || true
fi

if [[ -f "$RUN_DIR/flask.pid" ]] && kill -0 "$(cat "$RUN_DIR/flask.pid")" 2>/dev/null; then
  kill "$(cat "$RUN_DIR/flask.pid")" || true
fi

rm -f "$RUN_DIR/flask.pid" "$RUN_DIR/cloudflared.pid"
pkill -f "cloudflared tunnel --url http://localhost:8000" 2>/dev/null || true
PORT_PID="$(lsof -ti tcp:8000 2>/dev/null | head -n 1 || true)"
if [[ -n "$PORT_PID" ]]; then
  kill "$PORT_PID" 2>/dev/null || true
fi

echo "FullPicture public app stopped."
