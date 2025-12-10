# scripts/start.ps1
# Entry point for the WinUtil application.

# Define the project root globally for consistent path resolution across all scripts.
# This ensures that all components can reliably find project-relative resources (e.g., config files, other scripts).
# $PSScriptRoot here refers to the 'scripts' directory, so we take its parent to get the repository root.
$global:WinUtilProjectRoot = Split-Path -Parent $PSScriptRoot

# Dot-source the main script which initializes the UI and core logic.
. (Join-Path $global:WinUtilProjectRoot "scripts/main.ps1")
