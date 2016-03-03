from conans import ConanFile
from conans.tools import download, unzip
import os


class CMakeCallFunctionConan(ConanFile):
    name = "cmake-call-function"
    version = "master"
    generators = "cmake"
    requires = ("cmake-include-guard/master@smspillaz/cmake-include-guard", )
    url = "http://github.com/polysquare/cmake-call-function"
    license = "MIT"
    exports = "*"

    def source(self):
        zip_name = "cmake-call-function-master.zip"
        download("https://github.com/polysquare/" +
                 "cmake-call-function/archive/master.zip", zip_name)
        unzip(zip_name)
        os.unlink(zip_name)

    def package(self):
        self.copy(pattern="*.cmake",
                  dst="cmake/cmake-call-function",
                  src=".",
                  keep_path=True)
