# Dockerfile برای Moodle
FROM php:8.2-apache

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