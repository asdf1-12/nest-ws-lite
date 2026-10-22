# nest-ws-lite

Tiny websocket relay demo in one container.

- `GET /` → `ok`
- `GET /ip` → egress IP info captured at startup
- `WSPATH` (default `/ws`) → websocket endpoint

## Env

| name | required | default |
|---|---|---|
| `UUID` | yes, unless `SECRET` set | – |
| `SECRET` | no (derives `UUID`) | – |
| `WSPATH` | no | `/ws` |
| `PORT` | no | `3000` |

Build: `docker build -t nest-ws-lite .`

## Deploy to Render (free web service)

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/free-dam-man/nest-ws-lite)

`render.yaml` creates a free Docker web service with a random `SECRET`.
Render injects `PORT` (default `10000`); nginx listens on it.

If `UUID` is not set, the container derives it from `SECRET`:

1. `h` = lowercase hex SHA-256 of the SECRET string (no trailing newline)
2. take the first 32 hex chars
3. char 13 (index 12) := `4`; char 17 (index 16) := `(x & 3) | 8` → one of `8 9 a b`
4. format as 8-4-4-4-12

Compute it from the SECRET shown in the Render dashboard (Environment tab):

```sh
scripts/derive_uuid.sh '<SECRET>'
```
```sh
python3 -c "import hashlib,sys;h=list(hashlib.sha256(sys.argv[1].encode()).hexdigest()[:32]);h[12]='4';h[16]='%x'%(int(h[16],16)&3|8);h=''.join(h);print(f'{h[:8]}-{h[8:12]}-{h[12:16]}-{h[16:20]}-{h[20:]}')" '<SECRET>'
```

Client link template (`<host>` = `<name>.onrender.com`):

```
vless://<UUID>@<host>:443?encryption=none&security=tls&sni=<host>&type=ws&host=<host>&path=%2Fws#Render
```

Note: free services sleep after ~15 min idle and have a monthly bandwidth cap.
