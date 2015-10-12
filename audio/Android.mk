LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
    CapriAudioPolicyManager.cpp

LOCAL_SHARED_LIBRARIES := \
    libcutils \
    liblog \
    libutils \
    libmedia \
    libbinder \
    libaudiopolicymanagerdefault

LOCAL_C_INCLUDES := \
    external/tinyalsa/include \
    $(TOPDIR)frameworks/av/services/audiopolicy \
    $(TOPDIR)frameworks/av/services/audiopolicy/common/include \
    $(TOPDIR)frameworks/av/services/audiopolicy/common/managerdefinitions/include \
    $(TOPDIR)frameworks/av/services/audiopolicy/engine/interface

LOCAL_MODULE := libaudiopolicymanager
LOCAL_MODULE_TAGS := optional

include $(BUILD_SHARED_LIBRARY)