### Доступ

Для загрузки пакета на сервер необходимо иметь доступ, который настраивается в файле **server.conf** сервера.

```
[read_permissions]
*/*@*/*: *

[users]
demo: demo
```

Пользователь **demo**, пароль **demo**. Правило `*/*@*/*: *` означает чтение и запись для всех.

### Первичная настройка - профили

Добавьте профиль **QPOS** в файл **~/.conan2/settings.yaml** 
```
os:
	QPOS:
    Windows:
    ....
```


Создайте профиль (если он не создан), например так: **conan profile detect --force**. И отредактируйте файл профиля **~/.conan2/profiles/default** :

[settings]
arch=x86_64
build_type=Release
compiler=Clang
compiler.cppstd=gnu17
compiler.libcxx=libstdc++11
compiler.version=18
os=QPOS

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


Из каталога **zlib_package** запускаем следующую команду упаковки и отправки на сервер:

``` bash
conan create . --user=demo --profile:build=default --profile:host=default 
```

