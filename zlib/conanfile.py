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
