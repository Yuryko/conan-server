
## Как использовать

Dockerfile,  nginx.conf и server.conf должны лежать в одной директории.

Собираем образ: `docker build -t conan-server .`

Создайте папку для хранения пакетов. `<DATA>`

Запускаем контейнер:
```
docker run -p 8080:8080 -p 8443:8443 -p 9300:9300 -v <DATA>:/home/demo/.conan_server/data conan-server
```

Например 


``` 
docker run -p 8080:8080 -p 8443:8443 -p 9300:9300 -v /home/yury/git/conan-server/data:/home/demo/.conan_server/data conan-server 
```

проверка 


Запуск вручную `conan_server > /home/demo/.conan_server/logs/server.log 2>&1 & 



>[!note] Примечания:
>- Conan Server по умолчанию работает на порту 9300;
>- Nginx проксирует запросы с порта 8080 на 9300;
>- Для настройки аутентификации и других параметров Conan Server следует менять server.conf в контейнере /root/.conan_server/
>- Если нужно сохранять данные Conan между перезапусками, > используйте Docker volumes для /root/.conan_server/data.


Проверка Nginx в браузере:`http://localhost:8080`
  Должна выдавать **Not found: '/'** 
  Nginx работает, но html для вывода отсутствует.

### Настройка клиента

Проверьте, что все работает, команда:`conan --version`
Должна выдавать версию.

>[!attention] Важно!
>Изменение файла /home/user/.conan/global.conf путем добавления секций типа:
> [storage]
path = ~/.conan2/p  # Путь к кешу пакетов
>Вызывает сбой в работе conan, не смотря на все советы в интернетах. 

Добавляем наше хранилище пакетов:`conan remote add myremote http://localhost:9300`

Проверка conan-server: `conan remote list`
Должно быть два источника:
```
conancenter: https://center2.conan.io [Verify SSL: True, Enabled: True]
myremote: http://localhost:9300 [Verify SSL: True, Enabled: True]
```
Удаляем общественный репозиторий, для этого из файла **/home/user/.conan/remotes.json**  следует вырезать секцию.    
```
  {
   "name": "conancenter",
   "url": "https://center2.conan.io",
   "verify_ssl": true
  },
```

Проверка: `conan remote list`
```
myremote: http://localhost:9300 [Verify SSL: True, Enabled: True]
```