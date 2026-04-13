#!/bin/zsh
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
RUN_DIR="$PROJECT_DIR/.run"
LOG_DIR="$PROJECT_DIR/logs"
SERVER_PORT="8000"

mkdir -p "$RUN_DIR" "$LOG_DIR" "/Users/ameyakulkarni/Desktop/Excel"

if [[ -f "$RUN_DIR/flask.pid" ]] && kill -0 "$(cat "$RUN_DIR/flask.pid")" 2>/dev/null; then
  kill "$(cat "$RUN_DIR/flask.pid")" || true
  rm -f "$RUN_DIR/flask.pid"
fi

if [[ -f "$RUN_DIR/cloudflared.pid" ]] && kill -0 "$(cat "$RUN_DIR/cloudflared.pid")" 2>/dev/null; then
  kill "$(cat "$RUN_DIR/cloudflared.pid")" || true
  rm -f "$RUN_DIR/cloudflared.pid"
fi

pkill -f "cloudflared tunnel --url http://localhost:$SERVER_PORT" 2>/dev/null || true
PORT_PID="$(lsof -ti tcp:$SERVER_PORT 2>/dev/null | head -n 1 || true)"
if [[ -n "$PORT_PID" ]]; then
  kill "$PORT_PID" 2>/dev/null || true
  sleep 1
fi

nohup /bin/zsh -lc "cd '$PROJECT_DIR' && python3 -c \"from server import app, init_excel; init_excel(); app.run(host='0.0.0.0', port=$SERVER_PORT, debug=False)\"" \
  > "$LOG_DIR/flask.log" 2>&1 &
echo $! > "$RUN_DIR/flask.pid"

sleep 2

nohup /bin/zsh -lc "cd '$PROJECT_DIR' && cloudflared tunnel --url 'http://localhost:$SERVER_PORT'" \
  > "$LOG_DIR/cloudflared.log" 2>&1 &
echo $! > "$RUN_DIR/cloudflared.pid"

for _ in {1..20}; do
  if grep -q "trycloudflare.com" "$LOG_DIR/cloudflared.log" 2>/dev/null; then
    break
  fi
  sleep 1
done

URL="$(grep -Eo 'https://[a-z0-9-]+\.trycloudflare\.com' "$LOG_DIR/cloudflared.log" | tail -n 1 || true)"

echo "Flask PID: $(cat "$RUN_DIR/flask.pid")"
echo "Tunnel PID: $(cat "$RUN_DIR/cloudflared.pid")"
if [[ -n "$URL" ]]; then
  echo "Public URL: $URL"
else
  echo "Public URL not found yet. Check $LOG_DIR/cloudflared.log"
fi
