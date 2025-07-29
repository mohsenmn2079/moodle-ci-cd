# راه‌اندازی CI/CD Pipeline برای Moodle

## مشخصات پروژه
- سورس کد: Moodle
- سرور: 62.60.210.162
- هدف: اتوماسیون نصب و به‌روزرسانی با Docker

## مراحل راه‌اندازی

### مرحله 1: آماده‌سازی سورس کد Moodle
```bash
# کلون کردن Moodle
git clone git://git.moodle.org/moodle.git
cd moodle

# ایجاد فایل Dockerfile
```

### مرحله 2: ایجاد Dockerfile
```dockerfile
# Dockerfile برای Moodle
FROM php:8.1-apache

# نصب پیش‌نیازها
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libxml2-dev \
    libldap2-dev \
    libsodium-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libmcrypt-dev \
    libgd-dev \
    libmagickwand-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# نصب PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo_mysql \
    zip \
    xml \
    soap \
    ldap \
    intl \
    mbstring \
    curl \
    bcmath \
    opcache

# نصب Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# تنظیم Apache
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2enmod headers

# ایجاد پوشه‌های مورد نیاز
RUN mkdir -p /var/moodledata
RUN chown -R www-data:www-data /var/moodledata
RUN chmod -R 755 /var/moodledata

# کپی کردن فایل‌های Moodle
COPY . /var/www/html/
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

# تنظیم PHP
RUN echo "memory_limit = 256M" >> /usr/local/etc/php/conf.d/moodle.ini
RUN echo "max_execution_time = 300" >> /usr/local/etc/php/conf.d/moodle.ini
RUN echo "max_input_vars = 5000" >> /usr/local/etc/php/conf.d/moodle.ini
RUN echo "post_max_size = 100M" >> /usr/local/etc/php/conf.d/moodle.ini
RUN echo "upload_max_filesize = 100M" >> /usr/local/etc/php/conf.d/moodle.ini

EXPOSE 80 443

CMD ["apache2-foreground"]
```

### مرحله 3: ایجاد docker-compose.yml
```yaml
version: '3.8'

services:
  moodle:
    build: .
    container_name: moodle-app
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - moodle_data:/var/moodledata
      - ./config.php:/var/www/html/config.php
    environment:
      - MOODLE_DB_HOST=moodle_db
      - MOODLE_DB_NAME=moodle
      - MOODLE_DB_USER=moodle
      - MOODLE_DB_PASS=your_password_here
    depends_on:
      - moodle_db

  moodle_db:
    image: mysql:8.0
    container_name: moodle-db
    restart: unless-stopped
    environment:
      - MYSQL_ROOT_PASSWORD=root_password_here
      - MYSQL_DATABASE=moodle
      - MYSQL_USER=moodle
      - MYSQL_PASSWORD=your_password_here
    volumes:
      - moodle_mysql:/var/lib/mysql
    command: --default-authentication-plugin=mysql_native_password

volumes:
  moodle_data:
  moodle_mysql:
```

### مرحله 4: ایجاد GitHub Actions Workflow
```yaml
# .github/workflows/deploy.yml
name: Deploy Moodle to Server

on:
  push:
    branches: [ main ]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
      
    - name: Login to Docker Hub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}
        
    - name: Build and push Docker image
      run: |
        docker build -t your-username/moodle:latest .
        docker push your-username/moodle:latest
        
    - name: Deploy to server
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.SERVER_HOST }}
        username: ${{ secrets.SERVER_USERNAME }}
        key: ${{ secrets.SERVER_SSH_KEY }}
        script: |
          # Pull latest image
          docker pull your-username/moodle:latest
          
          # Stop and remove old containers
          docker stop moodle-app moodle-db || true
          docker rm moodle-app moodle-db || true
          
          # Start new containers
          docker-compose up -d
          
          # Clean up old images
          docker image prune -f
```

### مرحله 5: تنظیمات GitHub Secrets
در GitHub repository خود این secrets را اضافه کنید:
- `DOCKER_USERNAME`: نام کاربری Docker Hub
- `DOCKER_PASSWORD`: رمز عبور Docker Hub
- `SERVER_HOST`: 62.60.210.162
- `SERVER_USERNAME`: root
- `SERVER_SSH_KEY`: کلید SSH سرور

### مرحله 6: نصب Docker روی سرور
```bash
# اتصال به سرور
ssh root@62.60.210.162

# نصب Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# نصب Docker Compose
curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# راه‌اندازی Docker service
systemctl start docker
systemctl enable docker
```

### مرحله 7: راه‌اندازی اولیه
```bash
# کلون کردن repository
git clone https://github.com/your-username/moodle-repo.git
cd moodle-repo

# اجرای docker-compose
docker-compose up -d

# بررسی وضعیت
docker-compose ps
docker logs moodle-app
```

## نکات مهم
- حتماً از رمزهای عبور قوی استفاده کنید
- فایل config.php را در volume قرار دهید
- از backup منظم استفاده کنید
- SSL certificate نصب کنید

## دستورات مفید
```bash
# بررسی لاگ‌ها
docker logs moodle-app
docker logs moodle-db

# ورود به container
docker exec -it moodle-app bash

# backup دیتابیس
docker exec moodle-db mysqldump -u root -p moodle > backup.sql

# restart سرویس‌ها
docker-compose restart
``` 