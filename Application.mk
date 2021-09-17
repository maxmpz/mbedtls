# This doesn't properly work due to FFMPEG config variables conflicts. Use separate "ndk-build APP_ABI=armeabi" and "ndk-build APP_ABI=armeabi-v7a".
#APP_ABI := armeabi-v7a armeabi

APP_OPTIM := release
APP_DEBUGGABLE := false
# r20
APP_DEBUG := false

APP_PLATFORM := android-21

# Disable cleaning everything in /libs as we need previous/other lib
NDK_APP.local.cleaned_binaries := true

ifeq (,$(PA_NDK_VERSION_MAJOR))
$(error "Please define PA_NDK_VERSION_MAJOR")
endif

ifeq ($(APP_ABI),arm64-v8a)
    NDK_TOOLCHAIN_VERSION := clang

else
    ifneq (,$(call gte,$(PA_NDK_VERSION_MAJOR),20))
        # >= ndk-r20
        NDK_TOOLCHAIN_VERSION := clang
    else
        NDK_TOOLCHAIN_VERSION := 4.9
    endif
endif

ifneq (,$(ASAN)) # ASAN build
$(info APP ASAN build)
    # Old ndks
    APP_DEBUGGABLE := true
    # r20
    APP_DEBUG := true
endif

