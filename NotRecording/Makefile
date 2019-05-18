ARCHS = armv7 arm64 arm64e
include $(THEOS)/makefiles/common.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp NotRecording.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotRecording.plist$(ECHO_END)
	$(ECHO_NOTHING)cp NotRecording@3x.png $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NotRecording@3x.png$(ECHO_END)
