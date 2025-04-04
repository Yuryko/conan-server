
Как использовать:

Dockerfile nginx.conf должны лежать в одной директории.

Соберите образ:

```
docker build -t conan-nginx .
```

Запустите контейнер:

```
docker run -p 8080:8080 -p 8443:8443 -p 9300:9300 conan-serv
```


Примечания:

- Conan Server по умолчанию работает на порту 9300;
- Nginx проксирует запросы с порта 8080 на 9300;
- Для настройки аутентификации и других параметров Conan Server можно добавить файл server.conf в /home/demo/.conan_server/
- Если нужно сохранять данные Conan между перезапусками, используйте Docker volumes для /home/conan/.conan_server/data.


Проверка:

http://localhost:8080 

Настройка клиента:

Необходимо найти действующий файл настроек, например ./conan2/global.conf

```
[storage]
path = ~/.conan2/p  # Путь к кешу пакетов

[log]
level = info  # Уровень логирования (debug, info, warning, error)

[proxies]
# http = http://proxy.example.com:8080
# https = http://proxy.example.com:8080

[general]
default_profile = default  # Используемый профиль

```
