#!/bin/sh
set -e
: "${UUID:?UUID env is required}"
PORT="${PORT:-3000}"; WSPATH="${WSPATH:-/ws}"
mkdir -p /srv/www
echo ok > /srv/www/index.txt
curl -fsS --max-time 10 https://ipinfo.io/json > /srv/www/ip.json 2>/dev/null || echo '{"error":"lookup failed"}' > /srv/www/ip.json
cat > /opt/x/config.json <<J
{"log":{"loglevel":"warning"},
 "inbounds":[{"listen":"127.0.0.1","port":10000,"protocol":"vless",
  "settings":{"clients":[{"id":"$UUID"}],"decryption":"none"},
  "streamSettings":{"network":"ws","wsSettings":{"path":"$WSPATH"}}}],
 "outbounds":[{"protocol":"freedom"}]}
J
cat > /etc/nginx/conf.d/app.conf <<N
map \$http_upgrade \$conn_up { default upgrade; '' close; }
server {
  listen 0.0.0.0:$PORT;
  location = / { default_type text/plain; alias /srv/www/index.txt; }
  location = /ip { default_type application/json; alias /srv/www/ip.json; }
  location = $WSPATH {
    proxy_pass http://127.0.0.1:10000;
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection \$conn_up;
    proxy_set_header Host \$host;
    proxy_read_timeout 3600s; proxy_send_timeout 3600s;
  }
  location / { return 404; }
}
N
/opt/x/xray run -c /opt/x/config.json &
exec nginx -g 'daemon off;'
