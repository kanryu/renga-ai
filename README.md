# Renga AI

Renga AI is a highly customizable Windows-native AI authoring and
orchestration tool. It lets users combine AI-based data generation and data
processing as reusable nodes in a visual workflow, making it possible to
construct detailed multimodal pipelines from small, composable operations.

The project is being developed with Hike and Slint. Hike provides the
application and controller layer, while Slint provides a lightweight native
GUI. The long-term goal is an extensible authoring environment in which models,
prompts, image generation, transformation, analysis, and other AI operations
can be connected and rearranged to match each user's workflow.

The project is currently under active development. The workflow editor,
editable node positions, pin connections, node parameter editors, and JSON
persistence are being implemented incrementally.

## Layout

```text
renga-ai/
  cmd/renga/          Command-line companion
  cmd/renga-ai/       Windows GUI application entry point
  pkg/controller/     Hike controllers and workflow state management
  pkg/ui_code/        Bundled Slint source and UI assets
  ui/                 Slint components, split by responsibility
  tools/              Build helpers for embedding the Slint bundle
```

## GUI

The GUI follows the same separation as the Knuckle example:

* `ui/renga/router.slint` owns the route state and navigation callback.
* `ui/router_view.slint` mounts one page according to `AppRouter.current_page`.
* `ui/views/` contains the Home, Workflow, Models, and Settings pages.
* `ui/app_window.slint` is the single exported application root.

The corresponding Hike MVC layer is in `pkg/controller/`. It contains one
controller per page plus a router that owns the controllers and performs the
`OnMount`/`OnUnmount` lifecycle transition. `cmd/renga-ai/main.hike` creates
the router before creating the Slint application. The C-flat callback polling
API is exposed through `hike-gui-slint/slint.Context.PollCallback`; the GUI
event loop consumes the `navigate` callback and delegates it to this Hike
router. The resulting route is written back through
`Context.SetProperty("current_page", ...)`, so page state is owned by the
Hike router.

The Slint root exposes `AppWindow.current_page`, which is bound into
`RouterView` and updated by the Hike event loop.

Build the native GUI with:

```powershell
make build
```

The generated executable is kept out of source control. The Slint runtime DLL
is copied beside it by the `hike-gui-slint/shared` native package.

Before compiling, the CUN Slint package should concatenate every `.slint` file
below `ui/` into `pkg/ui_code/appbundle.slint`, then regenerate the embedded
`Source` declaration in `pkg/ui_code.hike`. The GUI entry point in
`cmd/renga-ai/main.hike` imports that package, and the resulting Hike source is
then compiled normally by `hikec`.

The Makefile enforces the second step: it regenerates `pkg/ui_code.hike` from
`pkg/ui_code/appbundle.slint` before invoking `hikec`. The Hike compiler does
not read `appbundle.slint` directly.

The application Makefile provides the basic lifecycle commands:

```powershell
make build   # Build cmd/renga-ai/renga-ai.exe
make run     # Build and launch the Windows GUI
make clean   # Remove the executable and copied runtime DLL
```

## CLI

The command-line companion is intentionally separate from the GUI. It will
host project initialization, workflow validation, execution, and packaging
commands without making the GUI responsible for project automation.

```powershell
go run ./cmd/renga help
```

## Dependencies

The application currently uses:

- `hike-rdb-sqlite`
- `hike-ai-stable-diffusion`
- `hike-images-vips`
- `hike-gui-slint`

The module file currently contains local development replacements for the
Hike GUI and JSON packages. These references will be adjusted as the related
Hike packages are published independently.
