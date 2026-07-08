#requires -RunAsAdministrator

$Host.UI.RawUI.WindowTitle = "IDM Trial Reset Tool"
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "White"
Clear-Host

function Show-Banner {
    param([string]$Text, [string]$Color = "Cyan")

    $banner = @"

    ╔══════════════════════════════════════════════╗
    ║                                              ║
    ║            IDM TRIAL RESET TOOL              ║
    ║         Internet Download Manager            ║
    ║            Registry Cleaner v1.0              ║
    ║                                              ║
    ╚══════════════════════════════════════════════╝

"@
    Write-Host $banner -ForegroundColor $Color
}

function Write-Step {
    param([string]$Message, [string]$Status = "pending")

    switch ($Status) {
        "running"  { $icon = "[>]"; $color = "Yellow"  }
        "done"     { $icon = "[v]"; $color = "Green"   }
        "fail"     { $icon = "[x]"; $color = "Red"     }
        "info"     { $icon = "[i]"; $color = "Cyan"    }
        "warn"     { $icon = "[!]"; $color = "Magenta" }
        default    { $icon = "[ ]"; $color = "Gray"    }
    }

    Write-Host "  $icon " -NoNewline -ForegroundColor $color
    Write-Host $Message
}

function Show-Spinner {
    param([int]$DurationMs = 1500, [string]$Label = "Processing")

    $spin = @('|', '/', '-', '\')
    $end = (Get-Date).AddMilliseconds($DurationMs)

    while ((Get-Date) -lt $end) {
        foreach ($s in $spin) {
            Write-Host "`r  [$s] $Label... " -NoNewline -ForegroundColor Yellow
            Start-Sleep -Milliseconds 80
        }
    }
    Write-Host "`r  [v] $Label... Done!" -ForegroundColor Green
}

function Show-ProgressBar {
    param([int]$Total, [string]$Label = "Scanning")

    for ($i = 1; $i -le $Total; $i++) {
        $pct = [math]::Round(($i / $Total) * 100)
        $barLen = 30
        $filled = [math]::Round(($i / $Total) * $barLen)
        $empty = $barLen - $filled
        $bar = ("#" * $filled) + ("-" * $empty)
        Write-Host "`r  [$bar] $pct%  $Label ($i/$Total)" -NoNewline -ForegroundColor Cyan
        Start-Sleep -Milliseconds 50
    }
    Write-Host "`r  [$("#" * $barLen)] 100%  $Label ($Total/$Total)" -ForegroundColor Green
}

# ───────────────────────────────────────────────
# MAIN
# ───────────────────────────────────────────────

Show-Banner

# Cek Admin
Write-Step "Memeriksa hak akses Administrator..." "running"
Show-Spinner -DurationMs 800 -Label "Checking privilege"
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Step "Script harus dijalankan sebagai Administrator!" "fail"
    Write-Host "`n  Klik kanan pada file ini -> Run with PowerShell" -ForegroundColor Yellow
    Write-Host "  Atau jalankan:  powershell -Command `"Start-Process '$_' -Verb RunAs`"" -ForegroundColor Yellow
    Write-Host "`n"
    Read-Host "  Tekan Enter untuk keluar"
    exit 1
}
Write-Step "Hak akses Administrator terverifikasi" "done"
Start-Sleep -Milliseconds 300

Write-Host ""

# Persiapan
$targetKey = "{07999AC3-058B-40BF-984F-69EB1E554CA7}"
$found = $false
$deleted = 0

Write-Step "Mencari registry key IDM trial..." "running"
Write-Host ""

# Dapatkan semua user hives
$hives = Get-ChildItem "Registry::HKEY_USERS" -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -like "*_Classes" }
$hiveCount = @($hives).Count

if ($hiveCount -eq 0) {
    Write-Step "Tidak ditemukan registry hive dengan akhiran _Classes" "warn"
} else {
    Write-Step "Ditemukan $hiveCount user registry hive, mulai pencarian..." "info"
    Write-Host ""

    Show-ProgressBar -Total $hiveCount -Label "Scanning hives"

    Write-Host ""
    Write-Host ""

    $index = 0
    foreach ($hive in $hives) {
        $index++
        $path = "Registry::$($hive.PSPath)\$targetKey"

        if (Test-Path $path) {
            $found = $true
            Write-Step "[$index/$hiveCount] Menemukan key di: $($hive.PSChildName)" "running"
            Start-Sleep -Milliseconds 300
            Write-Step "[$index/$hiveCount] Menghapus registry key..." "running"
            Show-Spinner -DurationMs 600 -Label "Deleting"

            try {
                Remove-Item -Path $path -Recurse -Force -ErrorAction Stop
                Write-Step "[$index/$hiveCount] Berhasil dihapus!" "done"
                $deleted++
            } catch {
                Write-Step "[$index/$hiveCount] Gagal menghapus: $_" "fail"
            }
        } else {
            Write-Step "[$index/$hiveCount] Tidak ditemukan di: $($hive.PSChildName)" "info"
        }
    }
}

Write-Host ""
Write-Host "  ═══════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host ""

# Summary
if ($found) {
    Write-Step "REGISTRY KEY BERHASIL DIHAPUS!" "done"
    Write-Step "Total key dihapus: $deleted" "done"
    Write-Step "Silahkan jalankan IDM kembali, trial sudah di-reset." "info"
} else {
    Write-Step "Tidak ditemukan registry key IDM trial." "warn"
    Write-Step "Kemungkinan IDM sudah dalam keadaan fresh/trial aktif." "info"
}

Write-Host ""
Write-Host "  ═══════════════════════════════════════════" -ForegroundColor DarkGray
Write-Host @"

     ██████╗  ██████╗ ███╗   ██╗███████╗
    ██╔════╝ ██╔═══██╗████╗  ██║██╔════╝
    ██║  ███╗██║   ██║██╔██╗ ██║█████╗
    ██║   ██║██║   ██║██║╚██╗██║██╔══╝
    ╚██████╔╝╚██████╔╝██║ ╚████║███████╗
     ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝

"@ -ForegroundColor Cyan

Write-Host "  Terima kasih telah menggunakan tools ini!" -ForegroundColor Green
Write-Host "  Created by: IDM Reset Tool`n" -ForegroundColor DarkGray

Read-Host "  Tekan Enter untuk keluar"
