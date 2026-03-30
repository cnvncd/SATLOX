# Инструкция по развертыванию сайта kireshe.xyz

## Шаг 1: Настройка DNS

Зайдите в панель управления доменом kireshe.xyz и добавьте следующие DNS записи:

```
Тип: A
Имя: @
Значение: [IP-адрес вашего сервера Timeweb]
TTL: 3600

Тип: A
Имя: www
Значение: [IP-адрес вашего сервера Timeweb]
TTL: 3600
```

Замените `[IP-адрес вашего сервера Timeweb]` на реальный IP-адрес вашего сервера.

## Шаг 2: Загрузка файлов на сервер

Подключитесь к серверу по SSH:
```bash
ssh root@[IP-адрес-сервера]
```

Создайте директорию для проекта:
```bash
mkdir -p ~/kireshe-site
cd ~/kireshe-site
```

Загрузите файлы на сервер одним из способов:

### Способ 1: SCP (с вашего компьютера)
```bash
scp index.html kireshe.xyz.conf deploy.sh root@[IP-адрес-сервера]:~/kireshe-site/
```

### Способ 2: Создать файлы вручную на сервере
```bash
nano index.html
# Скопируйте содержимое index.html и сохраните (Ctrl+O, Enter, Ctrl+X)

nano kireshe.xyz.conf
# Скопируйте содержимое kireshe.xyz.conf и сохраните

nano deploy.sh
# Скопируйте содержимое deploy.sh и сохраните
```

## Шаг 3: Установка Nginx (если еще не установлен)

```bash
sudo apt update
sudo apt install -y nginx
sudo systemctl enable nginx
sudo systemctl start nginx
```

## Шаг 4: Развертывание сайта

Скопируйте index.html в директорию сайта:
```bash
sudo mkdir -p /var/www/kireshe.xyz
sudo cp index.html /var/www/kireshe.xyz/
sudo chown -R www-data:www-data /var/www/kireshe.xyz
sudo chmod -R 755 /var/www/kireshe.xyz
```

Настройте Nginx:
```bash
sudo cp kireshe.xyz.conf /etc/nginx/sites-available/kireshe.xyz
sudo ln -sf /etc/nginx/sites-available/kireshe.xyz /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Шаг 5: Настройка SSL сертификата

Установите Certbot:
```bash
sudo apt install -y certbot python3-certbot-nginx
```

Получите SSL сертификат:
```bash
sudo certbot --nginx -d kireshe.xyz -d www.kireshe.xyz
```

Следуйте инструкциям Certbot (введите email для уведомлений).

## Шаг 6: Проверка

Откройте в браузере:
- http://kireshe.xyz
- https://kireshe.xyz

Сайт должен отображаться с надписью "САТ ЛОХ"!

## Автоматическое развертывание (опционально)

Вместо ручных команд можно использовать скрипт:
```bash
chmod +x deploy.sh
./deploy.sh
```

## Устранение неполадок

Если сайт не открывается:
1. Проверьте статус Nginx: `sudo systemctl status nginx`
2. Проверьте логи: `sudo tail -f /var/log/nginx/error.log`
3. Убедитесь, что порты 80 и 443 открыты в файрволе
4. Проверьте DNS: `nslookup kireshe.xyz`
