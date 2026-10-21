FROM nginx:1.27-alpine
ARG XRAY_VERSION=v26.3.27
RUN apk add --no-cache curl unzip ca-certificates \
 && curl -fsSL -o /tmp/x.zip "https://github.com/XTLS/Xray-core/releases/download/${XRAY_VERSION}/Xray-linux-64.zip" \
 && mkdir -p /opt/x && unzip -q /tmp/x.zip -d /opt/x && rm /tmp/x.zip \
 && chmod +x /opt/x/xray && /opt/x/xray version
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && rm -f /etc/nginx/conf.d/default.conf
ENV PORT=3000 WSPATH=/ws
EXPOSE 3000
ENTRYPOINT ["/entrypoint.sh"]
