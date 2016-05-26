from conans import ConanFile
from conans.tools import download, unzip
import os

VERSION = "0.0.4"


class CMakeCallFunction(ConanFile):
    name = "cmake-call-function"
    version = os.environ.get("CONAN_VERSION_OVERRIDE", VERSION)
    requires = ("cmake-include-guard/master@smspillaz/cmake-include-guard", )
    generators = "cmake"
    url = "http://github.com/polysquare/cmake-call-function"
    licence = "MIT"
    options = {
        "dev": [True, False]
    }
    default_options = "dev=False"

    def requirements(self):
        if self.options.dev:
            self.requires("cmake-module-common/master@smspillaz/cmake-module-common")

    def source(self):
        zip_name = "cmake-call-function.zip"
        download("https://github.com/polysquare/"
                 "cmake-call-function/archive/{version}.zip"
                 "".format(version="v" + VERSION),
                 zip_name)
        unzip(zip_name)
        os.unlink(zip_name)

    def package(self):
        self.copy(pattern="*.cmake",
                  dst="cmake/cmake-call-function",
                  src="cmake-call-function-" + VERSION,
                  keep_path=True)
