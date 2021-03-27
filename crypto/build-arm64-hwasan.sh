#!/bin/bash

export ANDROID_NDK=/opt/android-ndk-r21e
ABI=arm64-v8a
MINSDKVERSION=21
OTHER_ARGS=

# Fails with
# /opt/android-ndk-r21e/toolchains/llvm/prebuilt/darwin-x86_64/lib/gcc/aarch64-linux-android/4.9.x/../../../../aarch64-linux-android/bin/ld: 
# warning: liblog.so, needed by /opt/android-ndk-r21e/toolchains/llvm/prebuilt/darwin-x86_64/lib64/clang/9.0.9/lib/linux/libclang_rt.asan-aarch64-android.so, 
# not found (try using -rpath or -rpath-link)


echo Using ANDROID_NDK=$ANDROID_NDK

# NOTE: needed to force cmake to regenerate build scripts
rm -f CMakeCache.txt
rm -fR build/$ABI
mkdir -p build/$ABI

cmake \
    -DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake \
    -DANDROID_ABI=$ABI \
    -DANDROID_NATIVE_API_LEVEL=$MINSDKVERSION \
    -DENABLE_TESTING=Off \
    -DENABLE_PROGRAMS=Off \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS="-Og -g -fsanitize=address -fno-omit-frame-pointer" \
    
cmake --build . -j8 $*                          

if [ $? -ne 0 ]; then
    exit $?
fi    

mv -v library/*.a build/$ABI/