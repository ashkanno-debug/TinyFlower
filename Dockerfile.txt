FROM alpine:latest

# نصب پیش‌نیازها
RUN apk add --no-cache bash curl ca-certificates tzdata sqlite

# دانلود و استخراج باینری 3x-ui
RUN mkdir -p /usr/local/x-ui /etc/x-ui && \
    curl -Lo /tmp/x-ui-linux-amd64.tar.gz https://github.com/MHSanaei/3x-ui/releases/latest/download/x-ui-linux-amd64.tar.gz && \
    tar -C /usr/local/ -xzf /tmp/x-ui-linux-amd64.tar.gz && \
    rm -f /tmp/x-ui-linux-amd64.tar.gz

WORKDIR /usr/local/x-ui

# ساخت یک دیتابیس پیش‌فرض و تنظیم اجباری پورت روی 2053 و ست کردن یوزر/پسورد پیش‌فرض (admin)
RUN sqlite3 /etc/x-ui/x-ui.db "CREATE TABLE IF NOT EXISTS settings (id INTEGER PRIMARY KEY AUTOINCREMENT, key TEXT, value TEXT);" && \
    sqlite3 /etc/x-ui/x-ui.db "INSERT OR REPLACE INTO settings (id, key, value) VALUES (1, 'webPort', '2053'), (2, 'webUsername', 'admin'), (3, 'webPassword', 'admin');"

EXPOSE 2053 8080

CMD ["./x-ui"]
