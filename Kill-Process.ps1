<#
.SYNOPSIS
    Terminates a process by name or process ID (PID).
.DESCRIPTION
    This script allows the user to kill a process by providing either the process name or process ID.
    It includes safety checks and confirmation prompts.
.EXAMPLE
    .\Kill-Process.ps1 -Name notepad
.EXAMPLE
    .\Kill-Process.ps1 -Id 1234
#>

param (
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$Name,

    [Parameter(Mandatory = $false, Position = 1)]
    [int]$Id
)

# Ensure at least one input is provided
if (-not $Name -and -not $Id) {
    Write-Host "❌ Please provide either a process name (-Name) or process ID (-Id)." -ForegroundColor Red
    exit
}

try {
    if ($Name) {
        $processes = Get-Process -Name $Name -ErrorAction Stop
    } elseif ($Id) {
        $processes = Get-Process -Id $Id -ErrorAction Stop
    }

    Write-Host "The following process(es) will be terminated:" -ForegroundColor Yellow
    $processes | Select-Object Id, ProcessName | Format-Table -AutoSize

    $confirm = Read-Host "Are you sure you want to kill these process(es)? (Y/N)"
    if ($confirm -match '^[Yy]$') {
        $processes | Stop-Process -Force
        Write-Host "✅ Process(es) terminated successfully." -ForegroundColor Green
    } else {
        Write-Host "⚠️ Operation cancelled." -ForegroundColor Yellow
    }

} catch {
    Write-Host "❗ Error: $($_.Exception.Message)" -ForegroundColor Red
}
