HIKEC ?=hikec
TARGET ?= windows

# Renga AI is a Windows GUI application. Use cmd.exe so make does not route
# lifecycle commands through an MSYS shell on Windows.
SHELL := cmd.exe

APP_DIR := cmd/renga-ai
APP := $(APP_DIR)/renga-ai.exe
RUNTIME_DLL := $(APP_DIR)/slint_cflat.dll
UI_BUNDLE := pkg/ui_code/appbundle.slint
UI_EMBED := pkg/ui_code.hike
UI_EMBED_SCRIPT := tools/embed_ui.ps1

.PHONY: all build run clean FORCE

all: build

build: $(APP)

$(APP): $(APP_DIR)/main.hike $(UI_EMBED) hike.mod
	$(HIKEC) build -target $(TARGET) $(APP_DIR)/main.hike -o $(APP)

$(UI_EMBED): FORCE $(UI_BUNDLE) $(UI_EMBED_SCRIPT)
	powershell -NoProfile -ExecutionPolicy Bypass -File "$(UI_EMBED_SCRIPT)" -InputPath "$(UI_BUNDLE)" -OutputPath "$(UI_EMBED)"

FORCE:

run: build
ifeq ($(OS),Windows_NT)
	powershell -NoProfile -Command "& './$(APP)'"
else
	./$(APP)
endif

clean:
	rm -f '$(APP)' '$(RUNTIME_DLL)' $(UI_EMBED)
