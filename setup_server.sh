#!/bin/bash

# اسکریپت نصب Docker و Docker Compose روی سرور
# آدرس سرور: 62.60.210.162

echo "=== نصب Docker روی سرور ==="

# بررسی اتصال به سرور
if ! ping -c 1 62.60.210.162 &> /dev/null; then
    echo "❌ سرور در دسترس نیست!"
    exit 1
fi

echo "✅ سرور در دسترس است"

# نصب Docker و Docker Compose روی سرور
ssh root@62.60.210.162 << 'EOF'

echo "=== شروع نصب Docker ==="

# به‌روزرسانی سیستم
apt update && apt upgrade -y

# نصب پیش‌نیازها
apt install -y apt-transport-https ca-certificates curl gnupg lsb-release

# اضافه کردن GPG key رسمی Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# اضافه کردن repository Docker
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# به‌روزرسانی package index
apt update

# نصب Docker
apt install -y docker-ce docker-ce-cli containerd.io

# راه‌اندازی Docker service
systemctl start docker
systemctl enable docker

# اضافه کردن کاربر root به گروه docker
usermod -aG docker root

# نصب Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# ایجاد لینک نمادین
ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "=== بررسی نصب ==="

# بررسی نسخه Docker
docker --version

# بررسی نسخه Docker Compose
docker-compose --version

# بررسی وضعیت Docker service
systemctl status docker

echo "✅ Docker و Docker Compose با موفقیت نصب شدند"

EOF

echo "✅ نصب Docker روی سرور تکمیل شد"
echo "📝 حالا می‌توانید repository را کلون کنید و docker-compose را اجرا کنید" 