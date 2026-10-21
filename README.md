# nest-ws-lite

Tiny websocket relay demo in one container.

- `GET /` → `ok`
- `GET /ip` → egress IP info captured at startup
- `WSPATH` (default `/ws`) → websocket endpoint

## Env

| name | required | default |
|---|---|---|
| `UUID` | yes | – |
| `WSPATH` | no | `/ws` |
| `PORT` | no | `3000` |

Build: `docker build -t nest-ws-lite .`
