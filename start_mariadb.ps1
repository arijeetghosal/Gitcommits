$ProjectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$MariaDb = "C:\Program Files\MariaDB 12.3\bin\mariadbd.exe"
$DataDir = Join-Path $ProjectDir "mariadb-data"
$OutLog = Join-Path $ProjectDir "mariadb-server.log"
$ErrLog = Join-Path $ProjectDir "mariadb-server.err.log"

$existing = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort 3306 -State Listen -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "MariaDB/MySQL is already listening on 127.0.0.1:3306."
    return
}

Start-Process `
    -FilePath $MariaDb `
    -ArgumentList "--defaults-file=$DataDir\my.ini", "--datadir=$DataDir", "--port=3306", "--bind-address=127.0.0.1" `
    -WorkingDirectory $ProjectDir `
    -RedirectStandardOutput $OutLog `
    -RedirectStandardError $ErrLog `
    -WindowStyle Hidden

Start-Sleep -Seconds 5
$started = Get-NetTCPConnection -LocalAddress 127.0.0.1 -LocalPort 3306 -State Listen -ErrorAction SilentlyContinue
if ($started) {
    Write-Host "MariaDB started on 127.0.0.1:3306."
} else {
    Write-Host "MariaDB did not start. Check mariadb-server.err.log."
}
