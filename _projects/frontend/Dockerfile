# Stage 1: Builder
FROM php:8.3.26RC1-zts-alpine3.21 AS builder

# Install build dependencies
RUN apk update && apk add --no-cache \
    apache2 \
    apache2-utils \
    libpng-dev \
    libjpeg-turbo-dev \
    oniguruma-dev \
    libxml2-dev \
    zip \
    unzip \
    bash \
    build-base \
 && docker-php-ext-configure gd --with-jpeg \
 && docker-php-ext-install gd mysqli pdo pdo_mysql

WORKDIR /var/www/html
COPY . .

# Stage 2: Runtime
FROM php:8.3.26RC1-zts-alpine3.21 AS runtime

# Install runtime dependencies
RUN apk update && apk add --no-cache \
    apache2 \
    apache2-utils \
    libpng \
    libjpeg-turbo \
    oniguruma \
    libxml2 \
 && rm -rf /var/cache/apk/*

WORKDIR /var/www/html

# Copy PHP extensions & config from builder
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
COPY --from=builder /var/www/html /var/www/html

# Configure Apache (enable mod_rewrite)
RUN sed -i 's/#LoadModule rewrite_module/LoadModule rewrite_module/' /etc/apache2/httpd.conf \
 && sed -i 's|#ServerName www.example.com:80|ServerName localhost|' /etc/apache2/httpd.conf \
 && echo '<Directory "/var/www/html">\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' >> /etc/apache2/httpd.conf

EXPOSE 80
CMD ["httpd", "-D", "FOREGROUND"]


