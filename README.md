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
├── Dockerfile              # تعریف Docker image برای Moodle
├── docker-compose.yml      # تنظیمات multi-container application
├── .github/workflows/      # GitHub Actions workflows
│   └── deploy.yml         # Workflow برای deploy خودکار
├── setup_server.sh        # اسکریپت نصب Docker روی سرور
├── README.md              # مستندات پروژه
└── .gitignore             # فایل‌های نادیده گرفته شده توسط Git
```

## مراحل راه‌اندازی

### مرحله 1: آماده‌سازی سرور
```bash
# اجرای اسکریپت نصب Docker
./setup_server.sh
```

### مرحله 2: تنظیم GitHub Secrets
در GitHub repository، به Settings > Secrets and variables > Actions بروید و این secrets را اضافه کنید:

- `DOCKER_USERNAME`: نام کاربری Docker Hub
- `DOCKER_PASSWORD`: رمز عبور یا Personal Access Token Docker Hub
- `SERVER_HOST`: آدرس سرور (62.60.210.162)
- `SERVER_USERNAME`: نام کاربری سرور (root)
- `SERVER_SSH_KEY`: کلید SSH خصوصی برای اتصال به سرور

### مرحله 3: تست CI/CD
```bash
# ایجاد تغییر در کد
git add .
git commit -m "تست CI/CD pipeline"
git push origin main
```

## نحوه کار CI/CD

1. **Trigger**: هر بار که کد به branch `main` push شود
2. **Build**: ساخت Docker image جدید
3. **Push**: آپلود image به Docker Hub
4. **Deploy**: اجرای خودکار روی سرور

## دستورات مفید

### بررسی وضعیت Container ها
```bash
ssh root@62.60.210.162 "cd /root/moodle-ci-cd/moodle-source && docker ps"
```

### مشاهده Log ها
```bash
ssh root@62.60.210.162 "cd /root/moodle-ci-cd/moodle-source && docker-compose logs"
```

### توقف و راه‌اندازی مجدد
```bash
ssh root@62.60.210.162 "cd /root/moodle-ci-cd/moodle-source && docker-compose down && docker-compose up -d"
```

## عیب‌یابی

### مشکل اتصال به سرور
- بررسی دسترسی SSH
- بررسی تنظیمات firewall
- بررسی آدرس IP سرور

### مشکل Docker
- بررسی نصب Docker
- بررسی دسترسی‌های کاربر
- بررسی فضای دیسک

### مشکل CI/CD
- بررسی GitHub Secrets
- بررسی Docker Hub credentials
- بررسی SSH key

## اطلاعات تماس

- **توسعه‌دهنده**: Mohsen
- **آدرس سرور**: 62.60.210.162
- **Repository**: https://github.com/mohsenmn2079/moodle-ci-cd

---

**تست CI/CD Pipeline - آخرین به‌روزرسانی: 30 جولای 2025**

**تست مجدد - اصلاح Docker Hub credentials** 