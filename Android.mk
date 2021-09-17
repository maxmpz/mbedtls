# mbedtls
LOCAL_PATH := $(abspath $(call my-dir))

PA_GLOBAL_CFLAGS ?=

# libcrypto =============================
include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_MODULE := mbedtls-all

# IMPORTANT: ensure we have mbedtls includes before crypto's
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_C_INCLUDES += $(LOCAL_PATH)/crypto/include


LOCAL_SRC_FILES := $(wildcard $(LOCAL_PATH)/crypto/library/*.c)
# Use some mbedtls files, not crypto's
EXCLUDE_CRYPTO_FILES := $(LOCAL_PATH)/crypto/library/error.c \
    $(LOCAL_PATH)/crypto/library/version.c \
    $(LOCAL_PATH)/crypto/library/version_features.c \

LOCAL_SRC_FILES := $(filter-out $(EXCLUDE_CRYPTO_FILES),$(LOCAL_SRC_FILES))
LOCAL_SRC_FILES += $(wildcard $(LOCAL_PATH)/library/*.c)

LOCAL_CFLAGS := $(PA_GLOBAL_CFLAGS)

# Override default optimization, force opt. for a size here
ifneq (,$(findstring clang,$(NDK_TOOLCHAIN_VERSION))) # clang
    LOCAL_CFLAGS := -Oz
else # gcc
    LOCAL_CFLAGS := -Os
endif
# NOTE: can't use visibility=hidden here as we need some functions to be exported for libpowerampcore
LOCAL_CFLAGS += -std=c99 -ffunction-sections -fdata-sections
LOCAL_CONLYFLAGS := $(PA_GLOBAL_CONLYFLAGS)

ifneq (false,$(PA_GLOBAL_FLTO)) # NOTE: PA_GLOBAL_FLTO can be false,full,thin
ifneq (,$(findstring clang,$(NDK_TOOLCHAIN_VERSION))) # clang
    LOCAL_CFLAGS += -flto=$(PA_GLOBAL_FLTO)
else
    LOCAL_CFLAGS += -flto -falign-functions=16
endif

else
endif # PA_GLOBAL_FLTO

ifeq (,$(findstring -O, $(LOCAL_CFLAGS))) # Check for optimization flag
$(error No -Ox in LOCAL_CFLAGS=$(LOCAL_CFLAGS))
endif
ifneq (false,$(PA_GLOBAL_FLTO)) # NOTE: PA_GLOBAL_FLTO can be false,full,thin
ifeq (,$(findstring -flto, $(LOCAL_CFLAGS)))
$(error No -flto in LOCAL_CFLAGS=$(LOCAL_CFLAGS))
endif
endif

include $(BUILD_STATIC_LIBRARY)


