param(
    [string]$InputPath = "pkg/ui_code/appbundle.slint",
    [string]$OutputPath = "pkg/ui_code.hike"
)

$root = Get-Location
$bundlePath = Join-Path $root $InputPath
$source = [System.IO.File]::ReadAllText($bundlePath, [System.Text.Encoding]::UTF8)
$gridTilePath = ((Join-Path $root "pkg/ui_code/grid_tile.png") -replace '\\', '/')
$source = $source.Replace('__RENGA_GRID_TILE__', $gridTilePath)
$source = (($source -split "`r?`n") | ForEach-Object { $_.TrimEnd() }) -join "`n"
[System.IO.File]::WriteAllText($bundlePath, $source, [System.Text.Encoding]::UTF8)

$escaped = $source.Replace('\', '\\').Replace('"', '\"').Replace("`r`n", '\n').Replace("`n", '\n')
$output = @"
package pkg

// Generated from ui_code/appbundle.slint by hikec tool bds and tools/embed_ui.ps1.
const Source string = "$escaped"
"@
[System.IO.File]::WriteAllText((Join-Path $root $OutputPath), $output, [System.Text.Encoding]::UTF8)
