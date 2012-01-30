include framework/makefiles/common.mk

TWEAK_NAME = GTranslate
GTranslate_FILES = GTranslate.m
GTranslate_FRAMEWORKS = UIKit QuartzCore
GTranslate_PRIVATE_FRAMEWORKS = WebKit WebCore
GTranslate_INSTALL_PATH = /Library/ActionMenu/Plugins

include framework/makefiles/tweak.mk
