USE_CAMERA_STUB := true

# inherit from the proprietary version
-include vendor/samsung/i9082/BoardConfigVendor.mk

TARGET_ARCH := arm
TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := capri
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_CPU_VARIANT := cortex-a9
TARGET_CPU_SMP := true

TARGET_BOOTLOADER_BOARD_NAME := capri

BOARD_KERNEL_CMDLINE := console=ttyS0,115200n8 mem=832M@0xA2000000 androidboot.console=ttyS0 vc-cma-mem=0/176M@0xCB000000
BOARD_KERNEL_BASE := 0xa2000000
BOARD_KERNEL_PAGESIZE := 4096

TARGET_USERIMAGES_USE_EXT4 := true

BOARD_BOOTIMAGE_PARTITION_SIZE := 8388608
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 8388608

# This is actually 1610612736, but reducing to 1049 MB to support users using repartition.
# Feel free to increase when needed
# See: http://forum.xda-developers.com/showpost.php?p=55293011&postcount=1
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1099956224

BOARD_USERDATAIMAGE_PARTITION_SIZE := 4404019200
BOARD_CACHEIMAGE_PARTITION_SIZE := 1073741824
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 131072

# Include an expanded selection of fonts
EXTENDED_FONT_FOOTPRINT := true

# Kernel
TARGET_KERNEL_CONFIG := cyanogenmod_i9082_defconfig

BOARD_HAS_NO_SELECT_BUTTON := true
BOARD_HAS_LARGE_FILESYSTEM := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/samsung/i9082/bluetooth
BOARD_BLUEDROID_VENDOR_CONF := device/samsung/i9082/libbt_vndcfg.txt

# Connectivity - Wi-Fi
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION      := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER        := NL80211
BOARD_HOSTAPD_PRIVATE_LIB   := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE           := bcmdhd
BOARD_WLAN_DEVICE_REV       := bcm4334
WIFI_DRIVER_FW_PATH_PARAM   := "/sys/module/dhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_STA     := "/system/etc/wifi/bcmdhd_sta.bin"
WIFI_DRIVER_FW_PATH_AP      := "/system/etc/wifi/bcmdhd_apsta.bin"
WIFI_DRIVER_MODULE_PATH     := "/system/lib/modules/dhd.ko"
WIFI_DRIVER_MODULE_NAME     := "dhd"
WIFI_DRIVER_MODULE_ARG      := "firmware_path=/system/etc/wifi/bcmdhd_sta.bin nvram_path=/system/etc/wifi/nvram_net.txt"
WIFI_DRIVER_MODULE_AP_ARG   := "firmware_path=/system/etc/wifi/bcmdhd_apsta.bin nvram_path=/system/etc/wifi/nvram_net.txt"
WIFI_BAND                   := 802_11_ABG

# Wi-Fi Tethering
BOARD_HAVE_SAMSUNG_WIFI := true

# SkTextBox for libtvout
BOARD_USES_SKTEXTBOX := true

# Hardware rendering
USE_OPENGL_RENDERER := true
BOARD_EGL_CFG := device/samsung/i9082/egl.cfg
BOARD_USE_MHEAP_SCREENSHOT := true
BOARD_EGL_WORKAROUND_BUG_10194508 := true
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true
COMMON_GLOBAL_CFLAGS += -DNEEDS_VECTORIMPL_SYMBOLS -DCAPRI_HWC -DADD_LEGACY_ACQUIRE_BUFFER_SYMBOL -DREFBASE_JB_MR1_COMPAT_SYMBOLS

# Bootanimation
TARGET_BOOTANIMATION_PRELOAD := true
TARGET_BOOTANIMATION_TEXTURE_CACHE := true

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGING_MODE_BOOTING_LPM := /sys/class/power_supply/battery/batt_lp_charging

# RIL
BOARD_RIL_CLASS := ../../../device/samsung/i9082/ril/

# Recovery
TARGET_RECOVERY_FSTAB := device/samsung/i9082/fstab.capri_ss_baffin
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/class/android_usb/android0/f_mass_storage/lun%d/file"
TARGET_RECOVERY_PIXEL_FORMAT := BGRA_8888

# healthd
BOARD_HAL_STATIC_LIBRARIES := libhealthd.capri

# CMHW
BOARD_HARDWARE_CLASS := hardware/samsung/cmhw/ device/samsung/i9082/cmhw/

# GPS
TARGET_SPECIFIC_HEADER_PATH := device/samsung/i9082/include

# Compat
TARGET_USES_LOGD := false

# jemalloc causes a lot of random crash on free()
MALLOC_IMPL := dlmalloc

# SELinux
BOARD_SEPOLICY_DIRS += \
    device/samsung/i9082/sepolicy

BOARD_SEPOLICY_UNION += \
    file_contexts \
    property_contexts \
    service_contexts \
    bkmgrd.te \
    device.te \
    geomagneticd.te \
    gpsd.te \
    init.te \
    immvibed.te \
    kernel.te \
    macloader.te \
    rild.te \
    shell.te \
    system_app.te \
    system_server.te \
    tvserver.te \
    vclmk.te \
