TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := USBFast17

USBFast17_FILES := Tweak.xm
USBFast17_CFLAGS := -fobjc-arc -fno-modules
USBFast17_CCFLAGS := -std=c++17 -fno-modules
USBFast17_FRAMEWORKS := IOKit
USBFast17_PRIVATE_FRAMEWORKS :=

BUNDLE_NAME := USBFast17Prefs

USBFast17Prefs_FILES := USBFast17Prefs/USBFast17Prefs.m
USBFast17Prefs_INSTALL_PATH := /Library/PreferenceBundles
USBFast17Prefs_FRAMEWORKS := UIKit
USBFast17Prefs_PRIVATE_FRAMEWORKS := Preferences UIUtilities

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
