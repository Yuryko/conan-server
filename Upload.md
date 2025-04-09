### Доступ

Для загрузки пакета на сервер необходимо иметь доступ, который настраивается в файле **server.conf** сервера.

```
[read_permissions]
*/*@*/*: *

[users]
conan: conan
```

Пользователь **demo**, пароль **demo**. Правило `*/*@*/*: *` означает чтение и запись для всех.

### Первичная настройка - профили

Добавьте профиль **QPOS**  и **clang-qp** в файл **~/.conan2/settings.yaml** 
```
os:
	QPOS:
    Windows:
    ....
 
 ...
compiler:
	...
    clang-qp:
        version: ["3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "4.0",
                  "5.0", "6.0", "7.0", "7.1",
                  "8", "9", "10", "11", "12", "13", "14", "15", "16", "17",
                  "18", "19", "20"]
        libcxx: [null, libstdc++, libstdc++11, libc++, c++_shared, c++_static]
        cppstd: [null, 98, gnu98, 11, gnu11, 14, gnu14, 17, gnu17, 20, gnu20, 23, gnu23, 26, gnu26]
        runtime: [null, static, dynamic]
        runtime_type: [null, Debug, Release]
        runtime_version: [null, v140, v141, v142, v143, v144]
        cstd: [null, 99, gnu99, 11, gnu11, 17, gnu17, 23, gnu23]
```

Для перезагрузки параметров cona следует выполнить команду:

```
conan config install settings.yml
```

Создайте профиль (если он не создан), например так: **conan profile detect --force**. И отредактируйте файл профиля **~/.conan2/profiles/qpos** :
```
[settings]
arch=x86_64
build_type=Release
compiler=clang-qp
compiler.cppstd=gnu17
compiler.libcxx=libstdc++11
compiler.version=18
os=QPOS

[conf]
tools.cmake.cmaketoolchain:user_toolchain=["/home/yury/qpsdk/platforms/QPOS.cmake"]
```

>[!varning] Важно!
>Обязательно указать toolchain!

### Создание и загрузка пакета
Для создания пакета с библиотекой для последующей загрузки на сервер необходимо создать рецепт **conanfile.py** например такого содержания:

``` python
from conan import ConanFile
from conan.tools.files import copy

class ZlibPrebuiltConan(ConanFile):
    name = "zlib"
    version = "1.3.1"
    settings = "os", "arch", "compiler", "build_type"

    def package(self):
        copy(self, "*.lib", src=self.source_folder + "/lib", dst=self.package_folder + "/lib")
        copy(self, "*.h", src=self.source_folder + "/include", dst=self.package_folder + "/include")

    def package_info(self):
        self.cpp_info.libs = ["zlib"]

```

Для этого рецепта файлы лежат следующим образом:
```
zlib_package/
├── conanfile.py   # Рецепт
├── include/       # Заголовочные файлы (.h)
│   └── zlib.h     # Пример заголовка
└── lib/           # Библиотеки (.lib)
    └── zlib.lib   # Пример библиотеки
```


Из каталога **zlib_package** запускаем следующую команду упаковки пакета:

``` bash
conan create . --user=conan --profile:build=qpos --profile:host=default 
```

Загружаем пакет:
```
CONAN_LOGGING_LEVEL=debug conan upload zlib/1.3.1@conan -r myremote
```

