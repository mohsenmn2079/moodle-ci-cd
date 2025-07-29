# Moodle CI/CD Pipeline

این پروژه شامل راه‌اندازی CI/CD pipeline برای Moodle با استفاده از Docker و GitHub Actions است.

## مشخصات پروژه

- **سورس کد**: Moodle
- **سرور**: 62.60.210.162
- **تکنولوژی**: Docker, Docker Compose, GitHub Actions
- **هدف**: اتوماسیون نصب و به‌روزرسانی Moodle

## ساختار پروژه

```
moodle-uni/
├── Dockerfile              # Docker image برای Moodle
├── docker-compose.yml      # تنظیمات Docker Compose
├── .github/
│   └── workflows/
│       └── deploy.yml      # GitHub Actions workflow
├── setup_server.sh         # اسکریپت نصب Docker روی سرور
├── todo.md                 # راهنمای کامل پروژه
└── README.md              # این فایل
```

## مراحل راه‌اندازی

### 1. آماده‌سازی سورس کد Moodle

```bash
# کلون کردن Moodle
git clone git://git.moodle.org/moodle.git
cd moodle

# کپی کردن فایل‌های Docker
cp ../moodle-uni/Dockerfile .
cp ../moodle-uni/docker-compose.yml .
cp -r ../moodle-uni/.github .
```

### 2. نصب Docker روی سرور

```bash
# اجرای اسکریپت نصب Docker
./setup_server.sh
```

### 3. تنظیمات GitHub Secrets

در GitHub repository خود این secrets را اضافه کنید:

- `DOCKER_USERNAME`: نام کاربری Docker Hub
- `DOCKER_PASSWORD`: رمز عبور Docker Hub
- `SERVER_HOST`: 62.60.210.162
- `SERVER_USERNAME`: root
- `SERVER_SSH_KEY`: کلید SSH سرور

### 4. راه‌اندازی اولیه

```bash
# کلون کردن repository روی سرور
ssh root@62.60.210.162
git clone https://github.com/your-username/moodle-repo.git
cd moodle-repo

# اجرای docker-compose
docker-compose up -d
```

## نحوه کارکرد CI/CD

1. **Push به main branch**: هر بار که کد را به main branch push کنید
2. **GitHub Actions**: workflow به صورت خودکار اجرا می‌شود
3. **Build Docker Image**: ایمیج جدید ساخته می‌شود
4. **Push to Docker Hub**: ایمیج به Docker Hub ارسال می‌شود
5. **Deploy to Server**: ایمیج جدید روی سرور اجرا می‌شود

## دستورات مفید

### بررسی وضعیت
```bash
# بررسی containers
docker-compose ps

# بررسی لاگ‌ها
docker logs moodle-app
docker logs moodle-db

# ورود به container
docker exec -it moodle-app bash
```

### Backup و Restore
```bash
# Backup دیتابیس
docker exec moodle-db mysqldump -u root -p moodle > backup.sql

# Restore دیتابیس
docker exec -i moodle-db mysql -u root -p moodle < backup.sql
```

### مدیریت سرویس‌ها
```bash
# Restart سرویس‌ها
docker-compose restart

# Stop سرویس‌ها
docker-compose down

# Start سرویس‌ها
docker-compose up -d
```

## نکات مهم

- حتماً از رمزهای عبور قوی استفاده کنید
- فایل `config.php` را در volume قرار دهید
- از backup منظم استفاده کنید
- SSL certificate نصب کنید
- فایروال را تنظیم کنید

## عیب‌یابی

### مشکل اتصال به دیتابیس
```bash
# بررسی وضعیت MySQL container
docker logs moodle-db

# بررسی تنظیمات شبکه
docker network ls
docker network inspect moodle-uni_default
```

### مشکل دسترسی به فایل‌ها
```bash
# تنظیم مجدد مجوزها
docker exec moodle-app chown -R www-data:www-data /var/www/html/
docker exec moodle-app chmod -R 755 /var/www/html/
```

## پشتیبانی

برای سوالات و مشکلات، لطفاً issue در GitHub repository ایجاد کنید. 