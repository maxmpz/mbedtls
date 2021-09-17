#!/bin/bash

export ANDROID_NDK=/opt/android-ndk-r20
#export ANDROID_NDK=/opt/android-ndk-r21d


echo Using ANDROID_NDK=$ANDROID_NDK
# --output-sync=none for r21
# PA_GLOBAL_FLTO=true

# NOTE: as we don't use jni directory, need to setup NDK_PROJECT_PATH/APP_BUILD_SCRIPT
export NDK_PROJECT_PATH=$(pwd)

PARAMS="NDK_APPLICATION_MK=$NDK_PROJECT_PATH/Application.mk APP_BUILD_SCRIPT=$NDK_PROJECT_PATH/Android.mk"
PARAMS+=" PA_NDK_VERSION_MAJOR=20 PA_GLOBAL_FLTO=false APP_ABI=arm64-v8a PA_GLOBAL_ARCH_MODE=arm64"
#$ANDROID_NDK/ndk-build clean $PARAMS
$ANDROID_NDK/ndk-build -j16 $PARAMS $*
