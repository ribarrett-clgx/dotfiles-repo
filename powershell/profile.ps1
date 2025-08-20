### ─────────────────────────────────────────────────────────────────
### Google Cloud SDK + PowerShell Module bootstrap
### ─────────────────────────────────────────────────────────────────

# Helper: add a directory to PATH for *this* session if not already present
function Add-ToPathIfMissing([string]$dir) {
    if ([string]::IsNullOrWhiteSpace($dir)) { return }
    if (-not (Test-Path -LiteralPath $dir)) { return }
    $current = ($env:PATH -split ';') | Where-Object { $_ -and $_.Trim() }
    if ($current -notcontains $dir) {
        $env:PATH = ($current + $dir) -join ';'
    }
}

# Ensure `gcloud` on PATH
try {
    if (-not (Get-Command gcloud -ErrorAction SilentlyContinue)) {
        $candidates = @(
            "C:\\Program Files\\Google\\Cloud SDK\\google-cloud-sdk\\bin",
            "C:\\Program Files (x86)\\Google\\Cloud SDK\\google-cloud-sdk\\bin",
            "$env:USERPROFILE\\AppData\\Local\\Google\\Cloud SDK\\google-cloud-sdk\\bin"
        )
        if ($env:CLOUDSDK_HOME) {
            $candidates += (Join-Path $env:CLOUDSDK_HOME "google-cloud-sdk\\bin")
            $candidates += (Join-Path $env:CLOUDSDK_HOME "bin")
        }
        foreach ($dir in $candidates) { Add-ToPathIfMissing $dir }
    }
} catch { Write-Warning "Failed PATH setup for gcloud: $_" }

# Ensure correct Python for gcloud/bq
function Use-GCloudPython {
    Remove-Item Env:PYTHONHOME, Env:PYTHONPATH -ErrorAction Ignore
    $sdk = $env:GCLOUD_SDK
    if (-not $sdk) { try { $sdk = (& gcloud info --format='value(installation.sdk_root)' 2>$null) } catch {} }
    if (-not $sdk) {
        $candidates = @(
            "C:\\Program Files\\Google\\Cloud SDK\\google-cloud-sdk",
            "C:\\Program Files (x86)\\Google\\Cloud SDK\\google-cloud-sdk",
            "$env:USERPROFILE\\AppData\\Local\\Google\\Cloud SDK\\google-cloud-sdk"
        )
        $sdk = ($candidates | Where-Object { Test-Path $_ } | Select-Object -First 1)
    }
    if ($sdk) {
        $bp = Join-Path $sdk 'platform\\bundledpython\\python.exe'
        if (Test-Path $bp) { $env:CLOUDSDK_PYTHON = $bp } else { Remove-Item Env:CLOUDSDK_PYTHON -ErrorAction Ignore }
    }
}

# Wrap gcloud/bq
function bq { Use-GCloudPython; & "$env:ProgramFiles\\Google\\Cloud SDK\\google-cloud-sdk\\bin\\bq.cmd" @args }
function gcloud { Use-GCloudPython; & "$env:ProgramFiles\\Google\\Cloud SDK\\google-cloud-sdk\\bin\\gcloud.cmd" @args }

### ─────────────────────────────────────────────────────────────────
### Linux-like Aliases (for a familiar terminal experience)
### ─────────────────────────────────────────────────────────────────

# Navigation and File Commands
Set-Alias ..  Set-Location                           # Go up one directory
Set-Alias cd.. 'Set-Location ..'                     # Go up one directory (alternative)
Set-Alias ls Get-ChildItem                          # List files (similar to `ls`)
Set-Alias ll "Get-ChildItem -Force"                  # List all files (similar to `ls -la`)
Set-Alias la "Get-ChildItem -Force"                  # List all files (similar to `ls -a`)
Set-Alias pwd Get-Location                          # Print working directory
Set-Alias cat Get-Content                           # Display file content (similar to `cat`)

# Corrected: Function to create a new file (similar to `touch`)
function touch {
    param([string]$path)
    if (-not (Test-Path $path)) { New-Item -ItemType File -Path $path -Force }
}

# Corrected: Function to remove file/folder recursively (similar to `rm -rf`)
function rmrf {
    param([string]$path)
    Remove-Item -Recurse -Force -Path $path
}

# Process and System Monitoring
Set-Alias ps Get-Process                            # List processes (similar to `ps`)
function top { Get-Process | Sort-Object CPU -Descending | Select-Object -First 20 | Format-Table -AutoSize }  # Monitor CPU usage (similar to `top` in Linux)
Set-Alias kill Stop-Process                        # Stop a process (similar to `kill`)

# Misc Utilities
Set-Alias clear Clear-Host                         # Clear the terminal screen (similar to `clear`)
function less { param($path) Get-Content $path | Out-Host -Paging }  # View file content with paging (similar to `less`)
function grep { param([string]$Pattern, [string]$Path = ".") Get-ChildItem -Recurse $Path | Select-String -Pattern $Pattern }  # Search files (similar to `grep`)
function which { param([string]$name) (Get-Command $name).Source }  # Find path to executable (similar to `which`)
function df { Get-PSDrive | Format-Table -AutoSize }  # Disk usage (similar to `df`)
function du { param($path=".") Get-ChildItem $path -Recurse | Measure-Object -Property Length -Sum | ForEach-Object { "{0:N2} MB" -f ($_.Sum / 1MB) } }  # Disk usage for directory (similar to `du`)

# Process Monitoring (requires Sysinternals `procexp` for `htop`)
function htop { Start-Process procexp }             # Open htop (if Sysinternals `procexp` is installed)
