FROM alpine:latest

# نصب پیش‌نیازها
RUN apk add --no-cache bash curl ca-certificates tzdata sqlite

# نصب cloudflared
RUN curl -Lo /usr/local/bin/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && \
    chmod +x /usr/local/bin/cloudflared

# دانلود و استخراج باینری 3x-ui
RUN mkdir -p /usr/local/x-ui /etc/x-ui && \
    curl -Lo /tmp/x-ui-linux-amd64.tar.gz https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-amd64.tar.gz && \
    tar -C /usr/local/ -xzf /tmp/x-ui-linux-amd64.tar.gz && \
    rm -f /tmp/x-ui-linux-amd64.tar.gz

WORKDIR /usr/local/x-ui

# ساخت دیتابیس
RUN sqlite3 /etc/x-ui/x-ui.db "CREATE TABLE IF NOT EXISTS settings (id INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT, value TEXT);" && \
    sqlite3 /etc/x-ui/x-ui.db "INSERT OR REPLACE INTO settings (id, key, value) VALUES (1, 'webPort', '2053'), (2, 'webUsername', 'admin'), (3, 'webPassword', 'admin');"

# کپی start.sh
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 2053 8080 2097 2098

# اینجا باید start.sh رو اجرا کنی، نه x-ui رو!
CMD ["/start.sh"]
