TARGET := iphone:clang:latest:15.0
ARCHS := arm64 arm64e

include $(THEOS)/makefiles/common.mk

TWEAK_NAME := USBFast17

USBFAST17_FILES := Tweak.xm
USBFAST17_CFLAGS := -fobjc-arc

BUNDLE_NAME := USBFast17Prefs

USBFAST17PREFS_FILES := USBFast17Prefs/USBFast17Prefs.m
USBFAST17PREFS_INSTALL_PATH := /Library/PreferenceBundles

USBFAST17PREFS_FRAMEWORKS := UIKit
USBFAST17PREFS_PRIVATE_FRAMEWORKS := Preferences

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
