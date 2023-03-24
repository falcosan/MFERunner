$win_path = Split-Path -Parent $MyInvocation.MyCommand.Definition
$folder_items = Get-ChildItem -Path $win_path | Where-Object { $_.Name -like "pt*" -or $_.Name -like "orchestrator*" -and $_.PSIsContainer }
if ($folder_items.Count -gt 0) {
    $command = Read-Host -Prompt "Command (default: npm run dev)"
    if ([string]::IsNullOrEmpty($command)) {
        $command = "npm run dev"
    }
    foreach ($app_item in $folder_items) {
        $app_path = Join-Path $win_path $app_item.Name
        Start-Process "powershell" "-NoExit -Command Set-Location '$app_path'; $command"
        Start-Sleep -Milliseconds 500
    }
}
else {
    Write-Host "No apps" -ForegroundColor Yellow
}