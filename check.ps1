<#
.SYNOPSIS
  FLOP miner readiness check for Windows (unofficial community tool).

.DESCRIPTION
  Checks whether this PC meets the known FLOP miner requirement (an NVIDIA GPU
  with at least 16 GB VRAM) and prints some extra system info.
  It only reads system information. It installs nothing and sends nothing.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\check.ps1
  powershell -ExecutionPolicy Bypass -File .\check.ps1 -Lang tr
#>
param(
    [ValidateSet('en', 'tr')]
    [string]$Lang = 'en'
)

$MinVramGB = 16

$Text = @{
    en = @{
        Title    = 'FLOP miner readiness check (unofficial)'
        Os       = 'Operating system'
        Gpu      = 'GPU'
        Driver   = 'NVIDIA driver'
        Cuda     = 'CUDA (supported by driver)'
        Ram      = 'System RAM'
        Disk     = 'Free disk space'
        Net      = 'flop.finance reachable'
        NoNvidia = 'No NVIDIA GPU found (nvidia-smi missing). Other adapters:'
        Need     = "needs $MinVramGB GB+"
        Yes      = 'yes'
        No       = 'no'
        Ready    = "READY: you have a GPU with $MinVramGB GB+ VRAM."
        NotReady = "NOT READY: FLOP needs a GPU with $MinVramGB GB+ VRAM."
        Note     = "Only the $MinVramGB GB VRAM rule is official. Other lines are info only."
        Client   = 'There is no public miner client yet. Only download it from flop.finance.'
    }
    tr = @{
        Title    = 'FLOP miner hazırlık kontrolü (resmi değil)'
        Os       = 'İşletim sistemi'
        Gpu      = 'Ekran kartı'
        Driver   = 'NVIDIA sürücüsü'
        Cuda     = 'CUDA (sürücünün desteklediği)'
        Ram      = 'Sistem RAM'
        Disk     = 'Boş disk alanı'
        Net      = 'flop.finance erişilebilir'
        NoNvidia = 'NVIDIA ekran kartı bulunamadı (nvidia-smi yok). Diğer kartlar:'
        Need     = "en az $MinVramGB GB gerekli"
        Yes      = 'evet'
        No       = 'hayır'
        Ready    = "HAZIR: $MinVramGB GB+ VRAM'li bir ekran kartın var."
        NotReady = "HAZIR DEĞİL: FLOP için $MinVramGB GB+ VRAM'li ekran kartı gerekli."
        Note     = "Resmi şart sadece $MinVramGB GB VRAM. Diğer satırlar bilgi amaçlı."
        Client   = 'Resmi miner yazılımı henüz yayınlanmadı. Sadece flop.finance üzerinden indirin.'
    }
}
$T = $Text[$Lang]

function Write-Line($Status, $Label, $Value) {
    $colors = @{ PASS = 'Green'; FAIL = 'Red'; WARN = 'Yellow'; INFO = 'Gray' }
    Write-Host ('[{0}] ' -f $Status) -ForegroundColor $colors[$Status] -NoNewline
    Write-Host ('{0}: {1}' -f $Label, $Value)
}

Write-Host ''
Write-Host $T.Title -ForegroundColor Cyan
Write-Host ('-' * $T.Title.Length)

$os = Get-CimInstance Win32_OperatingSystem
Write-Line INFO $T.Os ('{0} ({1})' -f $os.Caption, $os.OSArchitecture)

# GPU: nvidia-smi is the reliable source; Win32_VideoController caps VRAM at 4 GB.
$ready = $false
$smi = Get-Command nvidia-smi -ErrorAction SilentlyContinue
if ($smi) {
    $rows = & nvidia-smi --query-gpu=name,memory.total,driver_version --format=csv,noheader,nounits
    $driver = $null
    foreach ($row in $rows) {
        $name, $mib, $driver = $row.Split(',') | ForEach-Object { $_.Trim() }
        $gb = [math]::Round([double]$mib / 1024, 1)
        if ($gb -ge $MinVramGB - 0.5) {
            $ready = $true
            Write-Line PASS $T.Gpu ('{0}, {1} GB VRAM' -f $name, $gb)
        } else {
            Write-Line FAIL $T.Gpu ('{0}, {1} GB VRAM ({2})' -f $name, $gb, $T.Need)
        }
    }
    Write-Line INFO $T.Driver $driver

    $cuda = (& nvidia-smi | Select-String 'CUDA Version:\s*([\d.]+)').Matches
    if ($cuda) { Write-Line INFO $T.Cuda $cuda[0].Groups[1].Value }
} else {
    Write-Line FAIL $T.Gpu $T.NoNvidia
    Get-CimInstance Win32_VideoController | ForEach-Object { Write-Host "       - $($_.Name)" }
}

$ramGb = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)
Write-Line INFO $T.Ram "$ramGb GB"

$sysDrive = $env:SystemDrive.TrimEnd(':')
$freeGb = [math]::Round((Get-PSDrive $sysDrive).Free / 1GB, 1)
Write-Line INFO $T.Disk "$freeGb GB ($($env:SystemDrive))"

try {
    $null = Invoke-WebRequest 'https://flop.finance' -Method Head -UseBasicParsing -TimeoutSec 10
    Write-Line PASS $T.Net $T.Yes
} catch {
    Write-Line WARN $T.Net $T.No
}

Write-Host ''
if ($ready) {
    Write-Host $T.Ready -ForegroundColor Green
} else {
    Write-Host $T.NotReady -ForegroundColor Red
}
Write-Host $T.Note -ForegroundColor Gray
Write-Host $T.Client -ForegroundColor Gray
Write-Host ''

if ($ready) { exit 0 } else { exit 1 }
