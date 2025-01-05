# Menggunakan Image PHP 8.3
FROM php:8.3-fpm

# Menyalin file composer
COPY composer.* /var/www/laravel-docker/

# Menetapkan direktori kerja
WORKDIR /var/www/laravel-docker

# Memperbarui dan menginstal dependensi sistem
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    jpegoptim \
    optipng \
    pngquant \
    gifsicle \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    zip

# Menginstal Node.js versi 16
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Membersihkan cache apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Menginstal ekstensi PHP
RUN docker-php-ext-install pdo pdo_mysql gd zip

# Menginstal Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Membuat grup dan user untuk menjalankan aplikasi
RUN groupadd -g 1000 www
RUN useradd -u 1000 -ms /bin/bash -g www www

# Menyalin semua file aplikasi
COPY . .
COPY --chown=www:www . .

# Mengatur user untuk menjalankan aplikasi
USER www

# Mengekspos port 9000
EXPOSE 9000

# Menjalankan PHP-FPM
CMD [ "php-fpm" ]
