ARCHS = armv7 arm64 arm64e
include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NotRecording
$(TWEAK_NAME)_FILES = NotRecording.xm
$(TWEAK_NAME)_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/var/mobile/Documents/ch.marcoroth.notrecording$(ECHO_END)
	$(ECHO_NOTHING)cp icon.png $(THEOS_STAGING_DIR)/var/mobile/Documents/ch.marcoroth.notrecording/icon.png$(ECHO_END)

after-install::
	install.exec "killall -9 backboardd"

SUBPROJECTS += NotRecording
include $(THEOS_MAKE_PATH)/aggregate.mk
