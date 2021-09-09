#!/bin/bash

export ANDROID_NDK=/opt/android-ndk-r20
ABI=arm64-v8a
MINSDKVERSION=21
OTHER_ARGS=

echo Using ANDROID_NDK=$ANDROID_NDK

# NOTE: needed to force cmake to regenerate build scripts
rm -f CMakeCache.txt
rm -fR build/$ABI
mkdir -p build/$ABI

# NOTE: c flags modified in cmakelists.txt as we can't override them here, just prepend

cmake \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=$ABI \
    -DANDROID_NATIVE_API_LEVEL=$MINSDKVERSION \
    -DENABLE_TESTING=Off \
    -DENABLE_PROGRAMS=Off \
    -DCMAKE_BUILD_TYPE=Release \

cmake --build . -j8 $*                          

if [ $? -ne 0 ]; then
    exit $?
fi    

mv -v library/*.a build/$ABI/