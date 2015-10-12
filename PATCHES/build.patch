From 2e1d60dda14144ecfa2b265a1a235927cb96d9d3 Mon Sep 17 00:00:00 2001
From: Koushik Dutta <koushd@gmail.com>
Date: Sat, 26 Jun 2010 22:53:55 -0700
Subject: [PATCH 01/16] add support for overriding build.prop settings.

Change-Id: Ie4224d608b7bcb0c2087bd77bc954f8f5f9b6495
---
 core/Makefile          | 1 +
 core/product.mk        | 1 +
 core/product_config.mk | 3 +++
 3 files changed, 5 insertions(+)

diff --git a/core/Makefile b/core/Makefile
index 22dcee1..0b69c90 100644
--- a/core/Makefile
+++ b/core/Makefile
@@ -221,6 +221,7 @@ endif
 			TARGET_CPU_ABI="$(TARGET_CPU_ABI)" \
 			TARGET_CPU_ABI2="$(TARGET_CPU_ABI2)" \
 			TARGET_AAPT_CHARACTERISTICS="$(TARGET_AAPT_CHARACTERISTICS)" \
+			$(PRODUCT_BUILD_PROP_OVERRIDES) \
 	        bash $(BUILDINFO_SH) >> $@
 	$(hide) $(foreach file,$(system_prop_file), \
 		if [ -f "$(file)" ]; then \
diff --git a/core/product.mk b/core/product.mk
index 4e8bff1..83e64be 100644
--- a/core/product.mk
+++ b/core/product.mk
@@ -65,6 +65,7 @@ endef
 #
 
 _product_var_list := \
+    PRODUCT_BUILD_PROP_OVERRIDES \
     PRODUCT_NAME \
     PRODUCT_MODEL \
     PRODUCT_LOCALES \
diff --git a/core/product_config.mk b/core/product_config.mk
index 5240ae7..a87d0c6 100644
--- a/core/product_config.mk
+++ b/core/product_config.mk
@@ -343,6 +343,9 @@ PRODUCT_PROPERTY_OVERRIDES := \
 PRODUCT_DEFAULT_PROPERTY_OVERRIDES := \
     $(strip $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_DEFAULT_PROPERTY_OVERRIDES))
 
+PRODUCT_BUILD_PROP_OVERRIDES := \
+	$(strip $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_BUILD_PROP_OVERRIDES))
+
 # Should we use the default resources or add any product specific overlays
 PRODUCT_PACKAGE_OVERLAYS := \
     $(strip $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_PACKAGE_OVERLAYS))
-- 
2.3.8 (Apple Git-58)


From c80c7c3841226050f3be0ab340eb467047484bcd Mon Sep 17 00:00:00 2001
From: Ricardo Cerqueira <github@cerqueira.org>
Date: Wed, 11 Apr 2012 11:21:23 +0100
Subject: [PATCH 02/16] build: Inline kernel building as a buildtime task

Kernel image integration is now done in the build system. The
"one true way" of doing this is to download the kernel source
into kernel/TARGET_BOOTLOADER_NAME (by usage of the cm.dependencies
mechanism or otherwise), and defining the TARGET_KERNEL_CONFIG
variable in the device's BoardConfig makefile

If the kernel's location doesn't match the automagic location
(multi-device kernel source, for instance), TARGET_KERNEL_SOURCE
can be used to specify a kernel path (i.e.,
"TARGET_KERNEL_SOURCE := kernel/shared-whatever")

If the device requires out-of-kernel-tree modules to be built,
the TARGET_KERNEL_MODULES variable can be used, pointing to a
_make target_ that will build and install such modules. Definition
of such a target is the device author's responsibility, the only
restriction is that it is a normal makefile recipe (example
below)

Optionally (or as an alternative), a prebuilt binary can also be
defined at BoardConfig, by usage of the TARGET_PREBUILT_KERNEL
variable. This binary will be used if the kernel source is absent
(or undefined).

A minimal BoardConfig.mk should look something like this:

TARGET_KERNEL_CONFIG := cyanogenmod_<device>_defconfig
TARGET_PREBUILT_KERNEL := device/<vendor>/<device>/kernel

To include, for example, the TI WLAN modules, this can be used:

-----------------------------
TIWLAN_MODULES:
       make -C hardware/ti/wlan/wl1283/platforms/os/linux/ KERNEL_DIR=$(KERNEL_OUT) ARCH="arm" CROSS_COMPILE="arm-eabi-" TNETW=1273 RANDOM_MAC=n REPORT_LOG=n
       mv hardware/ti/wlan/wl1283/platforms/os/linux/tiwlan_drv.ko $(KERNEL_MODULES_OUT)
       make -C hardware/ti/wlan/wl1283_softAP/platforms/os/linux/ KERNEL_DIR=$(KERNEL_OUT) ARCH="arm" CROSS_COMPILE="arm-eabi-" TNETW=1273 REPORT_LOG=n
       mv hardware/ti/wlan/wl1283_softAP/platforms/os/linux/tiap_drv.ko $(KERNEL_MODULES_OUT)

TARGET_KERNEL_MODULES := TIWLAN_MODULES
---------------------------

Change-Id: I8634fa4c788a42dc6f62e62ca170825b66db126a

build: Fix kernel module building on Darwin/OSX

Darwin/OSX build host does not have module-init-tools which is
required to generated modules.dep file. Switch to modules.order
file marker which is always generated instead.

Change-Id: I20c0fccd905fa668202c3e7284a8778db3728a65

kernel: Change path to kernel/<vendor>/<device>

Derive the kernel path from the device's own path (just replace "device"
with "kernel")

Change-Id: Idd44a0489e1ce280adf5ec4d9cfe2385c75dd115

kernel: Improve support for non-arm architectures

Remove hardwired references to the ARM arch and toolchains, and replace
them with the respective android build variables

Change-Id: Iae3eb548ca1d58ac808b5fa430d415283a809106

kernel: Fix ARM building

The default android ARM compiler, arm-androideabi-, does NOT work
for the Linux kernel. Special-case the ARM architecture to target
the ARM_EABI_TOOLCHAIN path directly

Change-Id: Ib672c99f114cb89d5fda3343d4dc68810d042d35

kernel: allow TARGET_KERNEL_MODULES to overwrite kernel modules

This is necessary to use compat-wireless since it needs to build a newer
version of cfg80211 (and sometimes mac80211) than the kernel sources version.
There are probably other instances of this type of need.

Change-Id: Ib5bf818286bc20987d8b9f9480a43f3e7690e239

kernel.mk: make use of ccache when requested

Change-Id: I9b6e28711bd5f590a76ac2b62a50b1d2de014e3e

kernel: Fix ccache inclusion logic

Builds were broken when CCACHE was missing from the environment
Change-Id: Ie8d6048f4600f1dc9c298593a50e37af04b96438

build: show accurate information on inline kernel warnings/errors

Having the variables on AndroidBoard as suggested causes errors
with mm/mmm, whereas having them on BoardConfig doesn't. Adjust
the warnings to reflect this.

Change-Id: I554c1f1073df678d36521f73bc236a1f4b02212e

This is causing generic_armv5-userdebug builds to fail. Commenting out for now to fix recovery build servers. Will fix properly later.

Change-Id: Ibe1cda8cd2b4c1914dfa3b8a29724c9069e047a6

kernel.mk: Also search PRODUCT_COPY_FILES for the kernel copy, as that is how AOSP does it now.

Change-Id: Id2d1cf079694d1996d4a85d8435c2e4562e5d444

kernel.mk: fix compiled kernel copy

Change-Id: Ifb2a3d4968e56eed236eaa2db9258cd0b8865fda

kernel.mk: workaround to fix kernel builds on darwin until the prebuilts/gcc is checked in by upstream.

Change-Id: I6321fb7f6814b207c821d974766d945351b3f546

build: fix ccache usage when building kernels

Change-Id: Id4edd4d85d9ba3ef42575f5fdebf22ed14957a99

kernel.mk: set KERNEL_OUT properly

It was hardcoded to $(ANDROID_BUILD_TOP)/$(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
which wouldn't exist if OUT_DIR_COMMON_BASE was set to use another dir
(e.g. ramdisk)

Fix it so that it now points to $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
if OUT_DIR is not out

Change-Id: I1bf767d86548e41270d9cbb8f0c00512708501c5

build: add support for uncompressed kernels

build: kernel: remove hard coded darwin toolchain.

* Use latest kernel toolchain from $(ARM_EABI_TOOLCHAIN) variable.

Change-Id: I3b43408937dd5f193fcba19c034f868272de8963

envsetup: set OUT_DIR to an absolute path always

OUT_DIR was set to $(TOPDIR)out previously,
but $(TOPDIR) was null, so it was a relative path.
This broke releasetools, inline kernel building, etc
since they require absolute paths.
Fix it so that it is set to $(shell readlink -f .)/out
if $(TOPDIR) is null.

Also remove hacks which checked if (OUT_DIR) was out
and changed it to $(ANDROID_BUILD_TOP)/out to workaround
the aforementioned problem.

Change-Id: I459a3b1325a1bbea0565cd73f6acf160d4ed9b39

build: add strip on kernel modules

kernel modules are huge for prima wlan and we need to strip them
unstriped size 40mb
striped size 2mb

Change-Id: Iefd572732cad0a6f608439618673068a3586fcd5

kernel: Ignore errors with module building

Let kernel fully disable loadable modules

Change-Id: Ia37ec927b092c041ee4c68bf9fd0f28b7339c8ca

build: Add support for extra kernel build variables

 * This allows specifying a variant defconfig, and an selinux defconfig
   which are simply configuration fragments.

Change-Id: I97882ae3b8c2e16ff6a7dce8dd3a70d70f8aa866

s/cyanogenmod.com/cyanogenmod.org/

* And fixup a wiki link while I'm at it.

Change-Id: I0355b9a47eac1becc07e81659fbb2d11b14ece36

Fixes for Xcode 5 and OSX 10.9.
kernel.mk: Put elf.h into the include path on Darwin builds.

Change-Id: I7069b956965d27caac3b2e4c3cc2e8b4c1da7a82

Make the kernel image format parametric instead of a chain of if/elses

Change-Id: I54bfcdecb8647f7bcf744e72b2de19fcf4e4e7ac

build: Add "dtbs" target when building the kernel

 * This is needed for 3.10

Change-Id: I4044ea9e67017452efc25097a3327141a6627c24
---
 core/tasks/kernel.mk | 188 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 188 insertions(+)
 create mode 100644 core/tasks/kernel.mk

diff --git a/core/tasks/kernel.mk b/core/tasks/kernel.mk
new file mode 100644
index 0000000..4d519a0
--- /dev/null
+++ b/core/tasks/kernel.mk
@@ -0,0 +1,188 @@
+# Copyright (C) 2012 The CyanogenMod Project
+#
+# Licensed under the Apache License, Version 2.0 (the "License");
+# you may not use this file except in compliance with the License.
+# You may obtain a copy of the License at
+#
+#      http://www.apache.org/licenses/LICENSE-2.0
+#
+# Unless required by applicable law or agreed to in writing, software
+# distributed under the License is distributed on an "AS IS" BASIS,
+# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
+# See the License for the specific language governing permissions and
+# limitations under the License.
+
+# Android makefile to build kernel as a part of Android Build
+
+TARGET_AUTO_KDIR := $(shell echo $(TARGET_DEVICE_DIR) | sed -e 's/^device/kernel/g')
+
+## Externally influenced variables
+# kernel location - optional, defaults to kernel/<vendor>/<device>
+TARGET_KERNEL_SOURCE ?= $(TARGET_AUTO_KDIR)
+KERNEL_SRC := $(TARGET_KERNEL_SOURCE)
+# kernel configuration - mandatory
+KERNEL_DEFCONFIG := $(TARGET_KERNEL_CONFIG)
+VARIANT_DEFCONFIG := $(TARGET_KERNEL_VARIANT_CONFIG)
+SELINUX_DEFCONFIG := $(TARGET_KERNEL_SELINUX_CONFIG)
+
+## Internal variables
+KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
+KERNEL_CONFIG := $(KERNEL_OUT)/.config
+
+ifneq ($(BOARD_KERNEL_IMAGE_NAME),)
+	TARGET_PREBUILT_INT_KERNEL_TYPE := $(BOARD_KERNEL_IMAGE_NAME)
+	TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(TARGET_ARCH)/boot/$(TARGET_PREBUILT_INT_KERNEL_TYPE)
+else
+	TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(TARGET_ARCH)/boot/zImage
+	TARGET_PREBUILT_INT_KERNEL_TYPE := zImage
+endif
+
+## Do be discontinued in a future version. Notify builder about target
+## kernel format requirement
+ifeq ($(BOARD_KERNEL_IMAGE_NAME),)
+ifeq ($(BOARD_USES_UBOOT),true)
+        $(error "Please set BOARD_KERNEL_IMAGE_NAME to uImage")
+else ifeq ($(BOARD_USES_UNCOMPRESSED_BOOT),true)
+        $(error "Please set BOARD_KERNEL_IMAGE_NAME to Image")
+endif
+endif
+
+ifeq "$(wildcard $(KERNEL_SRC) )" ""
+    ifneq ($(TARGET_PREBUILT_KERNEL),)
+        HAS_PREBUILT_KERNEL := true
+        NEEDS_KERNEL_COPY := true
+    else
+        $(foreach cf,$(PRODUCT_COPY_FILES), \
+            $(eval _src := $(call word-colon,1,$(cf))) \
+            $(eval _dest := $(call word-colon,2,$(cf))) \
+            $(ifeq kernel,$(_dest), \
+                $(eval HAS_PREBUILT_KERNEL := true)))
+    endif
+
+    ifneq ($(HAS_PREBUILT_KERNEL),)
+        $(warning ***************************************************************)
+        $(warning * Using prebuilt kernel binary instead of source              *)
+        $(warning * THIS IS DEPRECATED, AND WILL BE DISCONTINUED                *)
+        $(warning * Please configure your device to download the kernel         *)
+        $(warning * source repository to $(KERNEL_SRC))
+        $(warning * See http://wiki.cyanogenmod.org/w/Doc:_integrated_kernel_building)
+        $(warning * for more information                                        *)
+        $(warning ***************************************************************)
+        FULL_KERNEL_BUILD := false
+        KERNEL_BIN := $(TARGET_PREBUILT_KERNEL)
+    else
+        $(warning ***************************************************************)
+        $(warning *                                                             *)
+        $(warning * No kernel source found, and no fallback prebuilt defined.   *)
+        $(warning * Please make sure your device is properly configured to      *)
+        $(warning * download the kernel repository to $(KERNEL_SRC))
+        $(warning * and add the TARGET_KERNEL_CONFIG variable to BoardConfig.mk *)
+        $(warning *                                                             *)
+        $(warning * As an alternative, define the TARGET_PREBUILT_KERNEL        *)
+        $(warning * variable with the path to the prebuilt binary kernel image  *)
+        $(warning * in your BoardConfig.mk file                                 *)
+        $(warning *                                                             *)
+        $(warning ***************************************************************)
+        $(error "NO KERNEL")
+    endif
+else
+    NEEDS_KERNEL_COPY := true
+    ifeq ($(TARGET_KERNEL_CONFIG),)
+        $(warning **********************************************************)
+        $(warning * Kernel source found, but no configuration was defined  *)
+        $(warning * Please add the TARGET_KERNEL_CONFIG variable to your   *)
+        $(warning * BoardConfig.mk file                                    *)
+        $(warning **********************************************************)
+        # $(error "NO KERNEL CONFIG")
+    else
+        #$(info Kernel source found, building it)
+        FULL_KERNEL_BUILD := true
+        ifeq ($(TARGET_USES_UNCOMPRESSED_KERNEL),true)
+        $(info Using uncompressed kernel)
+            KERNEL_BIN := $(KERNEL_OUT)/piggy
+        else
+            KERNEL_BIN := $(TARGET_PREBUILT_INT_KERNEL)
+        endif
+    endif
+endif
+
+ifeq ($(FULL_KERNEL_BUILD),true)
+
+KERNEL_HEADERS_INSTALL := $(KERNEL_OUT)/usr
+KERNEL_MODULES_INSTALL := system
+KERNEL_MODULES_OUT := $(TARGET_OUT)/lib/modules
+
+define mv-modules
+    mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.order`;\
+    if [ "$$mdpath" != "" ];then\
+        mpath=`dirname $$mdpath`;\
+        ko=`find $$mpath/kernel -type f -name *.ko`;\
+        for i in $$ko; do $(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $$i;\
+        mv $$i $(KERNEL_MODULES_OUT)/; done;\
+    fi
+endef
+
+define clean-module-folder
+    mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.order`;\
+    if [ "$$mdpath" != "" ];then\
+        mpath=`dirname $$mdpath`; rm -rf $$mpath;\
+    fi
+endef
+
+ifeq ($(TARGET_ARCH),arm)
+    ifneq ($(USE_CCACHE),)
+      ccache := $(ANDROID_BUILD_TOP)/prebuilts/misc/$(HOST_PREBUILT_TAG)/ccache/ccache
+      # Check that the executable is here.
+      ccache := $(strip $(wildcard $(ccache)))
+    endif
+    ARM_CROSS_COMPILE:=CROSS_COMPILE="$(ccache) $(ARM_EABI_TOOLCHAIN)/arm-eabi-"
+    ccache = 
+endif
+
+ifeq ($(HOST_OS),darwin)
+  MAKE_FLAGS := C_INCLUDE_PATH=$(ANDROID_BUILD_TOP)/external/elfutils/libelf
+endif
+
+ifeq ($(TARGET_KERNEL_MODULES),)
+    TARGET_KERNEL_MODULES := no-external-modules
+endif
+
+$(KERNEL_OUT):
+	mkdir -p $(KERNEL_OUT)
+	mkdir -p $(KERNEL_MODULES_OUT)
+
+$(KERNEL_CONFIG): $(KERNEL_OUT)
+	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) VARIANT_DEFCONFIG=$(VARIANT_DEFCONFIG) SELINUX_DEFCONFIG=$(SELINUX_DEFCONFIG) $(KERNEL_DEFCONFIG)
+
+$(KERNEL_OUT)/piggy : $(TARGET_PREBUILT_INT_KERNEL)
+	$(hide) gunzip -c $(KERNEL_OUT)/arch/$(TARGET_ARCH)/boot/compressed/piggy.gzip > $(KERNEL_OUT)/piggy
+
+TARGET_KERNEL_BINARIES: $(KERNEL_OUT) $(KERNEL_CONFIG) $(KERNEL_HEADERS_INSTALL)
+	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) $(TARGET_PREBUILT_INT_KERNEL_TYPE)
+	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) dtbs
+	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) modules
+	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) INSTALL_MOD_PATH=../../$(KERNEL_MODULES_INSTALL) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) modules_install
+	$(mv-modules)
+	$(clean-module-folder)
+
+$(TARGET_KERNEL_MODULES): TARGET_KERNEL_BINARIES
+
+$(TARGET_PREBUILT_INT_KERNEL): $(TARGET_KERNEL_MODULES)
+	$(mv-modules)
+	$(clean-module-folder)
+
+$(KERNEL_HEADERS_INSTALL): $(KERNEL_OUT) $(KERNEL_CONFIG)
+	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) headers_install
+
+endif # FULL_KERNEL_BUILD
+
+## Install it
+
+ifeq ($(NEEDS_KERNEL_COPY),true)
+file := $(INSTALLED_KERNEL_TARGET)
+ALL_PREBUILT += $(file)
+$(file) : $(KERNEL_BIN) | $(ACP)
+	$(transform-prebuilt-to-target)
+
+ALL_PREBUILT += $(INSTALLED_KERNEL_TARGET)
+endif
-- 
2.3.8 (Apple Git-58)


From c7833b2a6588e828a6287e99afb5933b654438ab Mon Sep 17 00:00:00 2001
From: Chirayu Desai <chirayudesai1@gmail.com>
Date: Sun, 9 Nov 2014 17:27:51 +0530
Subject: [PATCH 03/16] Allow specifying kernel toolchain and prefix

Change-Id: Ib75cfe772e073f2196455f3e3dfba247f6b3feff
---
 core/tasks/kernel.mk | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/core/tasks/kernel.mk b/core/tasks/kernel.mk
index 4d519a0..b0ab1de 100644
--- a/core/tasks/kernel.mk
+++ b/core/tasks/kernel.mk
@@ -112,12 +112,19 @@ KERNEL_HEADERS_INSTALL := $(KERNEL_OUT)/usr
 KERNEL_MODULES_INSTALL := system
 KERNEL_MODULES_OUT := $(TARGET_OUT)/lib/modules
 
+ifeq ($(KERNEL_TOOLCHAIN),)
+KERNEL_TOOLCHAIN := $(ARM_EABI_TOOLCHAIN)
+endif
+ifeq ($(KERNEL_TOOLCHAIN_PREFIX),)
+KERNEL_TOOLCHAIN_PREFIX := arm-eabi-
+endif
+
 define mv-modules
     mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.order`;\
     if [ "$$mdpath" != "" ];then\
         mpath=`dirname $$mdpath`;\
         ko=`find $$mpath/kernel -type f -name *.ko`;\
-        for i in $$ko; do $(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $$i;\
+        for i in $$ko; do $(KERNEL_TOOLCHAIN)/$(KERNEL_TOOLCHAIN_PREFIX)strip --strip-unneeded $$i;\
         mv $$i $(KERNEL_MODULES_OUT)/; done;\
     fi
 endef
@@ -135,7 +142,7 @@ ifeq ($(TARGET_ARCH),arm)
       # Check that the executable is here.
       ccache := $(strip $(wildcard $(ccache)))
     endif
-    ARM_CROSS_COMPILE:=CROSS_COMPILE="$(ccache) $(ARM_EABI_TOOLCHAIN)/arm-eabi-"
+    ARM_CROSS_COMPILE:=CROSS_COMPILE="$(ccache) $(KERNEL_TOOLCHAIN)/$(KERNEL_TOOLCHAIN_PREFIX)"
     ccache = 
 endif
 
-- 
2.3.8 (Apple Git-58)


From fc24d384c919346ce9d5cea1ee91e2b44c9b5010 Mon Sep 17 00:00:00 2001
From: Alvin Francis <nivlafx@gmail.com>
Date: Mon, 1 Dec 2014 13:13:40 -0400
Subject: [PATCH 04/16] Fix libelf path

Fixes kernel build

Change-Id: Ic6cdb1734d7b865491e8e61403d32db4acafe514
Signed-off-by: Alvin Francis <nivlafx@gmail.com>
---
 core/tasks/kernel.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/core/tasks/kernel.mk b/core/tasks/kernel.mk
index b0ab1de..e6be63a 100644
--- a/core/tasks/kernel.mk
+++ b/core/tasks/kernel.mk
@@ -147,7 +147,7 @@ ifeq ($(TARGET_ARCH),arm)
 endif
 
 ifeq ($(HOST_OS),darwin)
-  MAKE_FLAGS := C_INCLUDE_PATH=$(ANDROID_BUILD_TOP)/external/elfutils/libelf
+  MAKE_FLAGS := C_INCLUDE_PATH=$(ANDROID_BUILD_TOP)/external/elfutils/0.153/libelf/
 endif
 
 ifeq ($(TARGET_KERNEL_MODULES),)
-- 
2.3.8 (Apple Git-58)


From 1ec979e6477595f8d9517bb2429e674af71dda0a Mon Sep 17 00:00:00 2001
From: Steve Kondik <steve@cyngn.com>
Date: Wed, 24 Dec 2014 03:18:54 -0800
Subject: [PATCH 05/16] core: More flexible kernel configuration

 * Allow various combinations of kernel vs. userspace architectures
 * Get rid of various assumptions about everything being ARM or 32-bit
 * This adds the following target flags:
     TARGET_KERNEL_ARCH
     TARGET_KERNEL_HEADER_ARCH
     KERNEL_HEADER_DEFCONFIG
     TARGET_KERNEL_CROSS_COMPILE_PREFIX

Change-Id: If0bc202abd35c216ba3ea5707ffdb602526d8ed3
---
 core/tasks/kernel.mk | 130 +++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 96 insertions(+), 34 deletions(-)

diff --git a/core/tasks/kernel.mk b/core/tasks/kernel.mk
index e6be63a..9f40eec 100644
--- a/core/tasks/kernel.mk
+++ b/core/tasks/kernel.mk
@@ -29,14 +29,50 @@ SELINUX_DEFCONFIG := $(TARGET_KERNEL_SELINUX_CONFIG)
 KERNEL_OUT := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ
 KERNEL_CONFIG := $(KERNEL_OUT)/.config
 
+TARGET_KERNEL_ARCH := $(strip $(TARGET_KERNEL_ARCH))
+ifeq ($(TARGET_KERNEL_ARCH),)
+KERNEL_ARCH := $(TARGET_ARCH)
+else
+KERNEL_ARCH := $(TARGET_KERNEL_ARCH)
+endif
+
+TARGET_KERNEL_HEADER_ARCH := $(strip $(TARGET_KERNEL_HEADER_ARCH))
+ifeq ($(TARGET_KERNEL_HEADER_ARCH),)
+KERNEL_HEADER_ARCH := $(KERNEL_ARCH)
+else
+KERNEL_HEADER_ARCH := $(TARGET_KERNEL_HEADER_ARCH)
+endif
+
+KERNEL_HEADER_DEFCONFIG := $(strip $(KERNEL_HEADER_DEFCONFIG))
+ifeq ($(KERNEL_HEADER_DEFCONFIG),)
+KERNEL_HEADER_DEFCONFIG := $(KERNEL_DEFCONFIG)
+endif
+
+
 ifneq ($(BOARD_KERNEL_IMAGE_NAME),)
-	TARGET_PREBUILT_INT_KERNEL_TYPE := $(BOARD_KERNEL_IMAGE_NAME)
-	TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(TARGET_ARCH)/boot/$(TARGET_PREBUILT_INT_KERNEL_TYPE)
+  TARGET_PREBUILT_INT_KERNEL_TYPE := $(BOARD_KERNEL_IMAGE_NAME)
 else
-	TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(TARGET_ARCH)/boot/zImage
-	TARGET_PREBUILT_INT_KERNEL_TYPE := zImage
+  ifeq ($(TARGET_USES_UNCOMPRESSED_KERNEL),true)
+    TARGET_PREBUILT_INT_KERNEL_TYPE := Image
+  else
+    TARGET_PREBUILT_INT_KERNEL_TYPE := zImage
+  endif
+endif
+
+TARGET_PREBUILT_INT_KERNEL := $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/$(TARGET_PREBUILT_INT_KERNEL_TYPE)
+
+# Clear this first to prevent accidental poisoning from env
+MAKE_FLAGS :=
+
+ifeq ($(KERNEL_ARCH),arm64)
+  # Avoid "unsupported RELA relocation: 311" errors (R_AARCH64_ADR_GOT_PAGE)
+  MAKE_FLAGS += CFLAGS_MODULE="-fno-pic"
+  ifeq ($(TARGET_ARCH),arm)
+    KERNEL_CONFIG_OVERRIDE := CONFIG_ANDROID_BINDER_IPC_32BIT=y
+  endif
 endif
 
+
 ## Do be discontinued in a future version. Notify builder about target
 ## kernel format requirement
 ifeq ($(BOARD_KERNEL_IMAGE_NAME),)
@@ -97,12 +133,7 @@ else
     else
         #$(info Kernel source found, building it)
         FULL_KERNEL_BUILD := true
-        ifeq ($(TARGET_USES_UNCOMPRESSED_KERNEL),true)
-        $(info Using uncompressed kernel)
-            KERNEL_BIN := $(KERNEL_OUT)/piggy
-        else
-            KERNEL_BIN := $(TARGET_PREBUILT_INT_KERNEL)
-        endif
+        KERNEL_BIN := $(TARGET_PREBUILT_INT_KERNEL)
     endif
 endif
 
@@ -112,19 +143,38 @@ KERNEL_HEADERS_INSTALL := $(KERNEL_OUT)/usr
 KERNEL_MODULES_INSTALL := system
 KERNEL_MODULES_OUT := $(TARGET_OUT)/lib/modules
 
-ifeq ($(KERNEL_TOOLCHAIN),)
-KERNEL_TOOLCHAIN := $(ARM_EABI_TOOLCHAIN)
-endif
+TARGET_KERNEL_CROSS_COMPILE_PREFIX := $(strip $(TARGET_KERNEL_CROSS_COMPILE_PREFIX))
+ifeq ($(TARGET_KERNEL_CROSS_COMPILE_PREFIX),)
 ifeq ($(KERNEL_TOOLCHAIN_PREFIX),)
 KERNEL_TOOLCHAIN_PREFIX := arm-eabi-
 endif
+else
+KERNEL_TOOLCHAIN_PREFIX := $(TARGET_KERNEL_CROSS_COMPILE_PREFIX)
+endif
+
+ifeq ($(KERNEL_TOOLCHAIN),)
+KERNEL_TOOLCHAIN_PATH := $(KERNEL_TOOLCHAIN_PREFIX)
+else
+ifneq ($(KERNEL_TOOLCHAIN_PREFIX),)
+KERNEL_TOOLCHAIN_PATH := $(KERNEL_TOOLCHAIN)/$(KERNEL_TOOLCHAIN_PREFIX)
+endif
+endif
+
+ifneq ($(USE_CCACHE),)
+    ccache := $(ANDROID_BUILD_TOP)/prebuilts/misc/$(HOST_PREBUILT_TAG)/ccache/ccache
+    # Check that the executable is here.
+    ccache := $(strip $(wildcard $(ccache)))
+endif
+
+KERNEL_CROSS_COMPILE := CROSS_COMPILE="$(ccache) $(KERNEL_TOOLCHAIN_PATH)"
+ccache =
 
 define mv-modules
     mdpath=`find $(KERNEL_MODULES_OUT) -type f -name modules.order`;\
     if [ "$$mdpath" != "" ];then\
         mpath=`dirname $$mdpath`;\
         ko=`find $$mpath/kernel -type f -name *.ko`;\
-        for i in $$ko; do $(KERNEL_TOOLCHAIN)/$(KERNEL_TOOLCHAIN_PREFIX)strip --strip-unneeded $$i;\
+        for i in $$ko; do $(KERNEL_TOOLCHAIN_PATH)strip --strip-unneeded $$i;\
         mv $$i $(KERNEL_MODULES_OUT)/; done;\
     fi
 endef
@@ -136,18 +186,8 @@ define clean-module-folder
     fi
 endef
 
-ifeq ($(TARGET_ARCH),arm)
-    ifneq ($(USE_CCACHE),)
-      ccache := $(ANDROID_BUILD_TOP)/prebuilts/misc/$(HOST_PREBUILT_TAG)/ccache/ccache
-      # Check that the executable is here.
-      ccache := $(strip $(wildcard $(ccache)))
-    endif
-    ARM_CROSS_COMPILE:=CROSS_COMPILE="$(ccache) $(KERNEL_TOOLCHAIN)/$(KERNEL_TOOLCHAIN_PREFIX)"
-    ccache = 
-endif
-
 ifeq ($(HOST_OS),darwin)
-  MAKE_FLAGS := C_INCLUDE_PATH=$(ANDROID_BUILD_TOP)/external/elfutils/0.153/libelf/
+  MAKE_FLAGS += C_INCLUDE_PATH=$(ANDROID_BUILD_TOP)/external/elfutils/0.153/libelf/
 endif
 
 ifeq ($(TARGET_KERNEL_MODULES),)
@@ -159,16 +199,17 @@ $(KERNEL_OUT):
 	mkdir -p $(KERNEL_MODULES_OUT)
 
 $(KERNEL_CONFIG): $(KERNEL_OUT)
-	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) VARIANT_DEFCONFIG=$(VARIANT_DEFCONFIG) SELINUX_DEFCONFIG=$(SELINUX_DEFCONFIG) $(KERNEL_DEFCONFIG)
-
-$(KERNEL_OUT)/piggy : $(TARGET_PREBUILT_INT_KERNEL)
-	$(hide) gunzip -c $(KERNEL_OUT)/arch/$(TARGET_ARCH)/boot/compressed/piggy.gzip > $(KERNEL_OUT)/piggy
+	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) VARIANT_DEFCONFIG=$(VARIANT_DEFCONFIG) SELINUX_DEFCONFIG=$(SELINUX_DEFCONFIG) $(KERNEL_DEFCONFIG)
+	$(hide) if [ ! -z "$(KERNEL_CONFIG_OVERRIDE)" ]; then \
+			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
+			echo $(KERNEL_CONFIG_OVERRIDE) >> $(KERNEL_OUT)/.config; \
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) oldconfig; fi
 
 TARGET_KERNEL_BINARIES: $(KERNEL_OUT) $(KERNEL_CONFIG) $(KERNEL_HEADERS_INSTALL)
-	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) $(TARGET_PREBUILT_INT_KERNEL_TYPE)
-	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) dtbs
-	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) modules
-	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) INSTALL_MOD_PATH=../../$(KERNEL_MODULES_INSTALL) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) modules_install
+	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(TARGET_PREBUILT_INT_KERNEL_TYPE)
+	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) dtbs
+	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) modules
+	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) INSTALL_MOD_PATH=../../$(KERNEL_MODULES_INSTALL) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) modules_install
 	$(mv-modules)
 	$(clean-module-folder)
 
@@ -179,7 +220,28 @@ $(TARGET_PREBUILT_INT_KERNEL): $(TARGET_KERNEL_MODULES)
 	$(clean-module-folder)
 
 $(KERNEL_HEADERS_INSTALL): $(KERNEL_OUT) $(KERNEL_CONFIG)
-	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(TARGET_ARCH) $(ARM_CROSS_COMPILE) headers_install
+	$(hide) if [ ! -z "$(KERNEL_HEADER_DEFCONFIG)" ]; then \
+			$(hide) rm -f ../$(KERNEL_CONFIG); \
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_HEADER_ARCH) $(KERNEL_CROSS_COMPILE) $(KERNEL_HEADER_DEFCONFIG); \
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_HEADER_ARCH) $(KERNEL_CROSS_COMPILE) headers_install; fi
+	$(hide) if [ "$(KERNEL_HEADER_DEFCONFIG)" != "$(KERNEL_DEFCONFIG)" ]; then \
+			echo "Used a different defconfig for header generation"; \
+			$(hide) rm -f ../$(KERNEL_CONFIG); \
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(KERNEL_DEFCONFIG); fi
+	$(hide) if [ ! -z "$(KERNEL_CONFIG_OVERRIDE)" ]; then \
+			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
+			echo $(KERNEL_CONFIG_OVERRIDE) >> $(KERNEL_OUT)/.config; \
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) oldconfig; fi
+
+kerneltags: $(KERNEL_OUT) $(KERNEL_CONFIG)
+	$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) tags
+
+kernelconfig: $(KERNEL_OUT) $(KERNEL_CONFIG)
+	env KCONFIG_NOTIMESTAMP=true \
+		 $(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) menuconfig
+	env KCONFIG_NOTIMESTAMP=true \
+		 $(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) savedefconfig
+	cp $(KERNEL_OUT)/defconfig kernel/arch/$(KERNEL_ARCH)/configs/$(KERNEL_DEFCONFIG)
 
 endif # FULL_KERNEL_BUILD
 
-- 
2.3.8 (Apple Git-58)


From 3acaa14dafb0ce2e4743d8c2370f67e5009bc5e3 Mon Sep 17 00:00:00 2001
From: dhacker29 <dhackerdvm@gmail.com>
Date: Sun, 18 Jan 2015 19:34:14 -0500
Subject: [PATCH 06/16] Fix kernel.mk if SELINUX or VARIANT_DEFCONFIG is
 defined

KERNEL_HEADER_DEFCONFIG was ignoring SELINUX_DEFCONFIG thus breaking
all selinux support

Change-Id: Idc3367d6b4b85343078e63e87dca6d6d052e7f53
---
 core/tasks/kernel.mk | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/core/tasks/kernel.mk b/core/tasks/kernel.mk
index 9f40eec..a2eb21e 100644
--- a/core/tasks/kernel.mk
+++ b/core/tasks/kernel.mk
@@ -222,12 +222,12 @@ $(TARGET_PREBUILT_INT_KERNEL): $(TARGET_KERNEL_MODULES)
 $(KERNEL_HEADERS_INSTALL): $(KERNEL_OUT) $(KERNEL_CONFIG)
 	$(hide) if [ ! -z "$(KERNEL_HEADER_DEFCONFIG)" ]; then \
 			$(hide) rm -f ../$(KERNEL_CONFIG); \
-			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_HEADER_ARCH) $(KERNEL_CROSS_COMPILE) $(KERNEL_HEADER_DEFCONFIG); \
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_HEADER_ARCH) $(KERNEL_CROSS_COMPILE) VARIANT_DEFCONFIG=$(VARIANT_DEFCONFIG) SELINUX_DEFCONFIG=$(SELINUX_DEFCONFIG) $(KERNEL_HEADER_DEFCONFIG); \
 			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_HEADER_ARCH) $(KERNEL_CROSS_COMPILE) headers_install; fi
 	$(hide) if [ "$(KERNEL_HEADER_DEFCONFIG)" != "$(KERNEL_DEFCONFIG)" ]; then \
 			echo "Used a different defconfig for header generation"; \
 			$(hide) rm -f ../$(KERNEL_CONFIG); \
-			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(KERNEL_DEFCONFIG); fi
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) VARIANT_DEFCONFIG=$(VARIANT_DEFCONFIG) SELINUX_DEFCONFIG=$(SELINUX_DEFCONFIG) $(KERNEL_DEFCONFIG); fi
 	$(hide) if [ ! -z "$(KERNEL_CONFIG_OVERRIDE)" ]; then \
 			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
 			echo $(KERNEL_CONFIG_OVERRIDE) >> $(KERNEL_OUT)/.config; \
-- 
2.3.8 (Apple Git-58)


From 64b2bbc48971483a02ba106cb280e327205a88b2 Mon Sep 17 00:00:00 2001
From: Ricardo Cerqueira <ricardo@cyngn.com>
Date: Tue, 20 Jan 2015 01:41:19 +0000
Subject: [PATCH 07/16] build: kernel: Fix stray "@"

Nested "$(hide)"s (makefile @) don't work. There was one at the
beginning of the script, remove the inner one to prevent it from
being interpreted as a shell command

Change-Id: I08a829ee56b212366a0f5a3812f7a614667a9c2b
---
 core/tasks/kernel.mk | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/core/tasks/kernel.mk b/core/tasks/kernel.mk
index a2eb21e..2c49271 100644
--- a/core/tasks/kernel.mk
+++ b/core/tasks/kernel.mk
@@ -221,12 +221,12 @@ $(TARGET_PREBUILT_INT_KERNEL): $(TARGET_KERNEL_MODULES)
 
 $(KERNEL_HEADERS_INSTALL): $(KERNEL_OUT) $(KERNEL_CONFIG)
 	$(hide) if [ ! -z "$(KERNEL_HEADER_DEFCONFIG)" ]; then \
-			$(hide) rm -f ../$(KERNEL_CONFIG); \
+			rm -f ../$(KERNEL_CONFIG); \
 			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_HEADER_ARCH) $(KERNEL_CROSS_COMPILE) VARIANT_DEFCONFIG=$(VARIANT_DEFCONFIG) SELINUX_DEFCONFIG=$(SELINUX_DEFCONFIG) $(KERNEL_HEADER_DEFCONFIG); \
 			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_HEADER_ARCH) $(KERNEL_CROSS_COMPILE) headers_install; fi
 	$(hide) if [ "$(KERNEL_HEADER_DEFCONFIG)" != "$(KERNEL_DEFCONFIG)" ]; then \
 			echo "Used a different defconfig for header generation"; \
-			$(hide) rm -f ../$(KERNEL_CONFIG); \
+			rm -f ../$(KERNEL_CONFIG); \
 			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) VARIANT_DEFCONFIG=$(VARIANT_DEFCONFIG) SELINUX_DEFCONFIG=$(SELINUX_DEFCONFIG) $(KERNEL_DEFCONFIG); fi
 	$(hide) if [ ! -z "$(KERNEL_CONFIG_OVERRIDE)" ]; then \
 			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
-- 
2.3.8 (Apple Git-58)


From 3a1aabef3e14125bf1f8acc9145e0d784becfffb Mon Sep 17 00:00:00 2001
From: Steve Kondik <steve@cyngn.com>
Date: Mon, 9 Mar 2015 15:07:08 +0000
Subject: [PATCH 08/16] build: Add support for additional kernel config snippet

 * Add support for TARGET_KERNEL_ADDITIONAL_CONFIG which will append a
   config snippet from arch/$ARCH/configs/ to the main defconfig.
 * This can be used for various things, such as including DIAG support
   into debuggable builds.

Change-Id: Ifa48688a3f951dd8ecc9a13a27de3a476e7bf633
---
 core/tasks/kernel.mk | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/core/tasks/kernel.mk b/core/tasks/kernel.mk
index 2c49271..764532c 100644
--- a/core/tasks/kernel.mk
+++ b/core/tasks/kernel.mk
@@ -72,6 +72,9 @@ ifeq ($(KERNEL_ARCH),arm64)
   endif
 endif
 
+ifneq ($(TARGET_KERNEL_ADDITIONAL_CONFIG),)
+KERNEL_ADDITIONAL_CONFIG := $(TARGET_KERNEL_ADDITIONAL_CONFIG)
+endif
 
 ## Do be discontinued in a future version. Notify builder about target
 ## kernel format requirement
@@ -204,6 +207,10 @@ $(KERNEL_CONFIG): $(KERNEL_OUT)
 			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
 			echo $(KERNEL_CONFIG_OVERRIDE) >> $(KERNEL_OUT)/.config; \
 			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) oldconfig; fi
+	$(hide) if [ ! -z "$(KERNEL_ADDITIONAL_CONFIG)" ]; then \
+			echo "Using additional config '$(KERNEL_ADDITIONAL_CONFIG)'"; \
+			cat $(KERNEL_SRC)/arch/$(KERNEL_ARCH)/configs/$(KERNEL_ADDITIONAL_CONFIG) >> $(KERNEL_OUT)/.config; \
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) oldconfig; fi
 
 TARGET_KERNEL_BINARIES: $(KERNEL_OUT) $(KERNEL_CONFIG) $(KERNEL_HEADERS_INSTALL)
 	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(TARGET_PREBUILT_INT_KERNEL_TYPE)
@@ -232,6 +239,10 @@ $(KERNEL_HEADERS_INSTALL): $(KERNEL_OUT) $(KERNEL_CONFIG)
 			echo "Overriding kernel config with '$(KERNEL_CONFIG_OVERRIDE)'"; \
 			echo $(KERNEL_CONFIG_OVERRIDE) >> $(KERNEL_OUT)/.config; \
 			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) oldconfig; fi
+	$(hide) if [ ! -z "$(KERNEL_ADDITIONAL_CONFIG)" ]; then \
+			echo "Using additional config '$(KERNEL_ADDITIONAL_CONFIG)'"; \
+			cat $(KERNEL_SRC)/arch/$(KERNEL_ARCH)/configs/$(KERNEL_ADDITIONAL_CONFIG) >> $(KERNEL_OUT)/.config; \
+			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) oldconfig; fi
 
 kerneltags: $(KERNEL_OUT) $(KERNEL_CONFIG)
 	$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) tags
-- 
2.3.8 (Apple Git-58)


From 22ab9b2ad5203ce07259d99ca2e5cef0a3b69f26 Mon Sep 17 00:00:00 2001
From: Pawit Pornkitprasan <p.pawit@gmail.com>
Date: Tue, 16 Dec 2014 19:19:52 +0700
Subject: [PATCH 09/16] minigzip dependency for kernel

i9082 kernel uses minigzip

Change-Id: I8c07a76eec568bce641b158d01ef8cd88b9997d4
---
 core/tasks/kernel.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/core/tasks/kernel.mk b/core/tasks/kernel.mk
index 764532c..510047d 100644
--- a/core/tasks/kernel.mk
+++ b/core/tasks/kernel.mk
@@ -212,7 +212,7 @@ $(KERNEL_CONFIG): $(KERNEL_OUT)
 			cat $(KERNEL_SRC)/arch/$(KERNEL_ARCH)/configs/$(KERNEL_ADDITIONAL_CONFIG) >> $(KERNEL_OUT)/.config; \
 			$(MAKE) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) oldconfig; fi
 
-TARGET_KERNEL_BINARIES: $(KERNEL_OUT) $(KERNEL_CONFIG) $(KERNEL_HEADERS_INSTALL)
+TARGET_KERNEL_BINARIES: $(KERNEL_OUT) $(KERNEL_CONFIG) $(KERNEL_HEADERS_INSTALL) $(MINIGZIP)
 	$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) $(TARGET_PREBUILT_INT_KERNEL_TYPE)
 	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) dtbs
 	-$(MAKE) $(MAKE_FLAGS) -C $(KERNEL_SRC) O=$(KERNEL_OUT) ARCH=$(KERNEL_ARCH) $(KERNEL_CROSS_COMPILE) modules
-- 
2.3.8 (Apple Git-58)


From 2b7772cb0e76e29bb3b4a040cc99d1c24bfcb0a5 Mon Sep 17 00:00:00 2001
From: Cristoforo Cataldo <cristoforo.cataldo@gmail.com>
Date: Sun, 30 Nov 2014 06:12:35 +0100
Subject: [PATCH 10/16] core: Enable -mcpu=cortex-a9 flag for Cortex-A9 cpu
 variant

Change-Id: I9294a518bcdc21ccbae72eadd9f3c1a12982d028

Conflicts:
	core/combo/arch/arm/armv7-a-neon.mk
---
 core/combo/arch/arm/armv7-a-neon.mk | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/core/combo/arch/arm/armv7-a-neon.mk b/core/combo/arch/arm/armv7-a-neon.mk
index 99f17aa..164dc2a 100644
--- a/core/combo/arch/arm/armv7-a-neon.mk
+++ b/core/combo/arch/arm/armv7-a-neon.mk
@@ -19,6 +19,9 @@ ifneq (,$(filter cortex-a15 krait denver,$(TARGET_$(combo_2nd_arch_prefix)CPU_VA
 	arch_variant_ldflags := \
 		-Wl,--no-fix-cortex-a8
 else
+ifeq ($(strip $(TARGET_$(combo_2nd_arch_prefix)CPU_VARIANT)),cortex-a9)
+	arch_variant_cflags := -mcpu=cortex-a9
+else
 ifeq ($(strip $(TARGET_$(combo_2nd_arch_prefix)CPU_VARIANT)),cortex-a8)
 	arch_variant_cflags := -mcpu=cortex-a8
 	arch_variant_ldflags := \
@@ -36,6 +39,7 @@ else
 endif
 endif
 endif
+endif
 
 arch_variant_cflags += \
     -mfloat-abi=softfp \
-- 
2.3.8 (Apple Git-58)


From caa2b003400306aeda2abb26433cf19145980203 Mon Sep 17 00:00:00 2001
From: Ricardo Cerqueira <github@cerqueira.org>
Date: Wed, 16 Nov 2011 23:14:27 +0000
Subject: [PATCH 11/16] ota: Remove cruft we don't care about

Skip the date check (downgrade to your content), and don't include
recovery in otapackages.
5.0.0 update: We want the recovery patchstuff back
---
 tools/releasetools/ota_from_target_files.py | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/releasetools/ota_from_target_files.py b/tools/releasetools/ota_from_target_files.py
index 9951b39..3587b35 100755
--- a/tools/releasetools/ota_from_target_files.py
+++ b/tools/releasetools/ota_from_target_files.py
@@ -521,10 +521,10 @@ def WriteFullOTAPackage(input_zip, output_zip):
   has_recovery_patch = HasRecoveryPatch(input_zip)
   block_based = OPTIONS.block_based and has_recovery_patch
 
-  if not OPTIONS.omit_prereq:
-    ts = GetBuildProp("ro.build.date.utc", OPTIONS.info_dict)
-    ts_text = GetBuildProp("ro.build.date", OPTIONS.info_dict)
-    script.AssertOlderBuild(ts, ts_text)
+  #if not OPTIONS.omit_prereq:
+  #  ts = GetBuildProp("ro.build.date.utc", OPTIONS.info_dict)
+  #  ts_text = GetBuildProp("ro.build.date", OPTIONS.info_dict)
+  #  script.AssertOlderBuild(ts, ts_text)
 
   AppendAssertions(script, OPTIONS.info_dict, oem_dict)
   device_specific.FullOTA_Assertions()
-- 
2.3.8 (Apple Git-58)


From 8f626b77ec758fe04eafea23a8586e1628f149b4 Mon Sep 17 00:00:00 2001
From: Chirayu Desai <chirayudesai1@gmail.com>
Date: Thu, 27 Sep 2012 18:11:25 +0530
Subject: [PATCH 12/16] envsetup: set OUT_DIR to an absolute path always

OUT_DIR was set to $(TOPDIR)out previously,
but $(TOPDIR) was null, so it was a relative path.
This broke releasetools, inline kernel building, etc
since they require absolute paths.
Fix it so that it is set to $(shell readlink -f .)/out
if $(TOPDIR) is null.

Also remove hacks which checked if (OUT_DIR) was out
and changed it to $(ANDROID_BUILD_TOP)/out to workaround
the aforementioned problem.

Change-Id: I459a3b1325a1bbea0565cd73f6acf160d4ed9b39
---
 core/envsetup.mk | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/core/envsetup.mk b/core/envsetup.mk
index bf04455..5f43cf9 100644
--- a/core/envsetup.mk
+++ b/core/envsetup.mk
@@ -207,8 +207,12 @@ endif
 
 ifeq (,$(strip $(OUT_DIR)))
 ifeq (,$(strip $(OUT_DIR_COMMON_BASE)))
+ifneq ($(TOPDIR),)
 OUT_DIR := $(TOPDIR)out
 else
+OUT_DIR := $(shell readlink -f .)/out
+endif
+else
 OUT_DIR := $(OUT_DIR_COMMON_BASE)/$(notdir $(PWD))
 endif
 endif
-- 
2.3.8 (Apple Git-58)


From 743f70fabea6ad0468690f5d278ce5b47563057c Mon Sep 17 00:00:00 2001
From: David Ferguson <ferguson.david@gmail.com>
Date: Thu, 4 Oct 2012 10:15:58 -0400
Subject: [PATCH 13/16] build: work around missing readlink -f on Mac

Change-Id: I5d56366cf33a2b02f1886c87815d00cff279779d
---
 core/envsetup.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/core/envsetup.mk b/core/envsetup.mk
index 5f43cf9..eb19f4f 100644
--- a/core/envsetup.mk
+++ b/core/envsetup.mk
@@ -210,7 +210,7 @@ ifeq (,$(strip $(OUT_DIR_COMMON_BASE)))
 ifneq ($(TOPDIR),)
 OUT_DIR := $(TOPDIR)out
 else
-OUT_DIR := $(shell readlink -f .)/out
+OUT_DIR := $(shell python -c 'import os,sys; print os.path.realpath(sys.argv[1])' .)/out
 endif
 else
 OUT_DIR := $(OUT_DIR_COMMON_BASE)/$(notdir $(PWD))
-- 
2.3.8 (Apple Git-58)


From 103cd37440f5b2397a9936d89cda932de24485c7 Mon Sep 17 00:00:00 2001
From: Chirayu Desai <cdesai@cyanogenmod.org>
Date: Wed, 1 May 2013 15:48:08 +0530
Subject: [PATCH 14/16] envsetup: use $(CURDIR) for getting current directory

Change-Id: I5f00faf64ec31d86dd2e48ec038748ce8499380b
---
 core/envsetup.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/core/envsetup.mk b/core/envsetup.mk
index eb19f4f..08524b3 100644
--- a/core/envsetup.mk
+++ b/core/envsetup.mk
@@ -210,7 +210,7 @@ ifeq (,$(strip $(OUT_DIR_COMMON_BASE)))
 ifneq ($(TOPDIR),)
 OUT_DIR := $(TOPDIR)out
 else
-OUT_DIR := $(shell python -c 'import os,sys; print os.path.realpath(sys.argv[1])' .)/out
+OUT_DIR := $(CURDIR)/out
 endif
 else
 OUT_DIR := $(OUT_DIR_COMMON_BASE)/$(notdir $(PWD))
-- 
2.3.8 (Apple Git-58)


From 5ac43bf0e26525a014fc73d4d794d9fb4be08c4c Mon Sep 17 00:00:00 2001
From: Ricardo Cerqueira <cyanogenmod@cerqueira.org>
Date: Tue, 12 Apr 2011 10:57:22 +0100
Subject: [PATCH 15/16] Allow a device to generically define its own headers

We have a few cases of devices including specific versions of projects
just because of modified headers (msm_mdp.h comes to mind), and I just
had enough of ifdeffing header files for specific cases (the P990 needs
a lot of these).
Now... if a target defines a TARGET_SPECIFIC_HEADER_PATH, any headers in
there will take precedence over the standard ones; for example, on the
p990, I have

TARGET_SPECIFIC_HEADER_PATH := device/lge/p990/include

which makes, for example, the
device/lge/p990/include/hardware_legacy/AudioHardwareInterface.h be
used instead of
hardware/libhardware_legacy/include/hardware_legacy/AudioHardwareInterface.h
whenever a source file uses <hardware_legacy/AudioHardwareInterface.h>

Change-Id: I41b62668b60e3f62a6ebd3738d8d2675103a81e6a

build: fix target header overlay

LOCAL_C_INCLUDES as defined by the makefile should be put AFTER
the overlay includes so the overlay always takes precedence.

Change-Id: I489b2aab6dbacd9122d834f85e07b63ed1271f07
---
 core/binary.mk | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/core/binary.mk b/core/binary.mk
index b8003d7..dfc53c7 100644
--- a/core/binary.mk
+++ b/core/binary.mk
@@ -956,6 +956,11 @@ normal_objects := \
 
 all_objects := $(normal_objects) $(gen_o_objects)
 
+## Allow a device's own headers to take precedence over global ones
+ifneq ($(TARGET_SPECIFIC_HEADER_PATH),)
+my_c_includes := $(TOPDIR)$(TARGET_SPECIFIC_HEADER_PATH) $(my_c_includes)
+endif
+
 my_c_includes += $(TOPDIR)$(LOCAL_PATH) $(intermediates) $(generated_sources_dir)
 
 ifndef LOCAL_SDK_VERSION
-- 
2.3.8 (Apple Git-58)


From bb3841f0f4f0274da731a1543f7debbe69d636a8 Mon Sep 17 00:00:00 2001
From: Brandon McAnsh <brandon.mcansh@gmail.com>
Date: Sat, 10 Oct 2015 10:20:38 -0400
Subject: [PATCH 16/16] Set kernel gcc version to 4.8 for ARM targets

* This causes the check during path setup for an arm-eabi-4.9 toolchain to fail,
      thus only leaving the arm-linux-androideabi- to exist.
* This is only temporary as Google is building with 4.9 and 4.8 gcc's
       have been removed in their next release

Was updated to 4.9 here: https://github.com/CyanogenMod/android_build/commit/bf8346e90c5a6d5d809fa7166d50714b2b6bc30d
Toolchain check here: https://github.com/CyanogenMod/android_build/blob/cm-13.0/envsetup.sh#L189

Change-Id: I24bff10e392a6cdced1797870e523144e83d611d
Signed-off-by: Brandon McAnsh <brandon.mcansh@gmail.com>
---
 core/combo/TARGET_linux-arm.mk | 1 +
 envsetup.sh                    | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/core/combo/TARGET_linux-arm.mk b/core/combo/TARGET_linux-arm.mk
index 3651c39..5020865 100644
--- a/core/combo/TARGET_linux-arm.mk
+++ b/core/combo/TARGET_linux-arm.mk
@@ -39,6 +39,7 @@ $(combo_2nd_arch_prefix)TARGET_NDK_GCC_VERSION := 4.9
 
 ifeq ($(strip $(TARGET_GCC_VERSION_EXP)),)
 $(combo_2nd_arch_prefix)TARGET_GCC_VERSION := 4.9
+$(combo_2nd_arch_prefix)TARGET_LEGACY_GCC_VERSION := 4.8
 else
 $(combo_2nd_arch_prefix)TARGET_GCC_VERSION := $(TARGET_GCC_VERSION_EXP)
 endif
diff --git a/envsetup.sh b/envsetup.sh
index dba64ee..5d0696d 100644
--- a/envsetup.sh
+++ b/envsetup.sh
@@ -129,6 +129,7 @@ function setpaths()
     # defined in core/config.mk
     targetgccversion=$(get_build_var TARGET_GCC_VERSION)
     targetgccversion2=$(get_build_var 2ND_TARGET_GCC_VERSION)
+    targetlegacygccversion=$(get_build_var TARGET_LEGACY_GCC_VERSION)
     export TARGET_GCC_VERSION=$targetgccversion
 
     # The gcc toolchain does not exists for windows/cygwin. In this case, do not reference it.
@@ -164,7 +165,7 @@ function setpaths()
     case $ARCH in
         arm)
             # Legacy toolchain configuration used for ARM kernel compilation
-            toolchaindir=arm/arm-eabi-$targetgccversion/bin
+            toolchaindir=arm/arm-eabi-$targetlegacygccversion/bin
             if [ -d "$gccprebuiltdir/$toolchaindir" ]; then
                  export ARM_EABI_TOOLCHAIN="$gccprebuiltdir/$toolchaindir"
                  ANDROID_KERNEL_TOOLCHAIN_PATH="$ARM_EABI_TOOLCHAIN":
-- 
2.3.8 (Apple Git-58)

