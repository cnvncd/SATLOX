#!/bin/bash

# Скрипт для развертывания сайта kireshe.xyz на Ubuntu сервере

echo "=== Развертывание сайта kireshe.xyz ==="

# 1. Создаем директорию для сайта
echo "Создание директории для сайта..."
sudo mkdir -p /var/www/kireshe.xyz
sudo chown -R $USER:$USER /var/www/kireshe.xyz
sudo chmod -R 755 /var/www/kireshe.xyz

# 2. Копируем конфигурацию Nginx
echo "Настройка Nginx..."
sudo cp kireshe.xyz.conf /etc/nginx/sites-available/kireshe.xyz
sudo ln -sf /etc/nginx/sites-available/kireshe.xyz /etc/nginx/sites-enabled/

# 3. Проверяем конфигурацию Nginx
echo "Проверка конфигурации Nginx..."
sudo nginx -t

# 4. Перезапускаем Nginx
echo "Перезапуск Nginx..."
sudo systemctl restart nginx

# 5. Устанавливаем Certbot для SSL (если еще не установлен)
echo "Установка Certbot..."
sudo apt update
sudo apt install -y certbot python3-certbot-nginx

# 6. Получаем SSL сертификат
echo "Получение SSL сертификата..."
sudo certbot --nginx -d kireshe.xyz -d www.kireshe.xyz --non-interactive --agree-tos --email admin@kireshe.xyz

echo "=== Развертывание завершено! ==="
echo "Сайт доступен по адресу: https://kireshe.xyz"
