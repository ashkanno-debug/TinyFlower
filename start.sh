#!/bin/sh

# اجرای پنل 3x-ui
/usr/local/x-ui/x-ui &

sleep 5

# اجرای cloudflared برای پنل (پورت 2053)
/usr/local/bin/cloudflared tunnel --url http://localhost:2053 --no-autoupdate --protocol http2 &

# اجرای cloudflared برای اینباندها (پورت 8080)
/usr/local/bin/cloudflared tunnel --url http://localhost:8080 --no-autoupdate --protocol http2
