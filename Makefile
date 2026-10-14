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
BDS_TOOL := github.com/kanryu/hike-gui-slint/cmd/bds
BDS := .hike/bin/bds.exe
BDS_MODULE := ../hikec-go/hike-gui-slint/hike.mod
UI_SOURCES := \
	ui/renga/router.slint \
	ui/views/home_page.slint \
	ui/views/node_windows/node_panel.slint \
	ui/views/node_windows/workflow_nodes.slint \
	ui/views/workflow_page.slint \
	ui/views/node_pages.slint \
	ui/views/models_page.slint \
	ui/views/settings_page.slint \
	ui/router_view.slint \
	ui/app_window.slint

.PHONY: all build ui run clean FORCE

all: build

build: $(APP)

$(APP): $(APP_DIR)/main.hike $(UI_EMBED) hike.mod
	$(HIKEC) build -target $(TARGET) $(APP_DIR)/main.hike -o $(APP)

ui: $(UI_EMBED)

# Slint sources are compiled as one UI package. The source files may import
# one another, so compiling them independently produces false diagnostics.

# The tool is owned by the locally replaced GUI Slint module. Re-resolve it
# automatically when either module manifest changes.
$(BDS): hike.mod $(BDS_MODULE)
	$(HIKEC) get -tool $(BDS_TOOL)

$(UI_BUNDLE): FORCE $(UI_SOURCES) $(BDS)
	$(BDS) ui -o "$(UI_BUNDLE)"

$(UI_EMBED): $(UI_BUNDLE) $(UI_EMBED_SCRIPT)
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
