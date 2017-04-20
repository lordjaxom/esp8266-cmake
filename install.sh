if [ "$1" = "-r" ]
then
    rm -rf build
    shift
fi
if [ "$1" = "" ]
then
    echo ERROR: Install location not given
    exit 1
fi
mkdir -p build
cd build
cmake -G"MinGW Makefiles" -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain.ESP8266.cmake -DCMAKE_INSTALL_PREFIX="$1" ..
mingw32-make install
