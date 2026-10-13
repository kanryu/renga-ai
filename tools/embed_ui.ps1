param(
    [string]$InputPath = "pkg/ui_code/appbundle.slint",
    [string]$OutputPath = "pkg/ui_code.hike"
)

$root = Get-Location
$uiFiles = @(
    "ui/renga/router.slint",
    "ui/views/home_page.slint",
    "ui/views/workflow_page.slint",
    "ui/views/node_pages.slint",
    "ui/views/models_page.slint",
    "ui/views/settings_page.slint",
    "ui/router_view.slint",
    "ui/app_window.slint"
)

$parts = @('import { Button, TextEdit, VerticalBox, ListView } from "std-widgets.slint";', "")
foreach ($file in $uiFiles) {
    $text = [System.IO.File]::ReadAllText((Join-Path $root $file), [System.Text.Encoding]::UTF8)
    $text = [regex]::Replace($text, '(?m)^\s*import\s+.*?;\s*$', '')
    if ($file -eq "ui/views/workflow_page.slint") {
        $gridTilePath = ((Join-Path $root "pkg/ui_code/grid_tile.png") -replace '\\', '/')
        $text = $text.Replace('__RENGA_GRID_TILE__', $gridTilePath)
    }
    $parts += "// --- $file ---"
    $parts += $text.Trim()
    $parts += ""
}
$source = ($parts -join "`n")

$bundlePath = Join-Path $root $InputPath
[System.IO.File]::WriteAllText($bundlePath, $source, [System.Text.Encoding]::UTF8)
$escaped = $source.Replace('\', '\\').Replace('"', '\"').Replace("`r`n", '\n').Replace("`n", '\n')
$output = @"
package pkg

// Generated from ui_code/appbundle.slint by tools/embed_ui.ps1.
const Source string = "$escaped"
"@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $OutputPath), $output, [System.Text.Encoding]::UTF8)
