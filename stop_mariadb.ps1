$MariaAdmin = "C:\Program Files\MariaDB 12.3\bin\mysqladmin.exe"

& $MariaAdmin -h 127.0.0.1 -P 3306 -u root -proot shutdown

if ($LASTEXITCODE -eq 0) {
    Write-Host "MariaDB stopped."
} else {
    Write-Host "MariaDB stop command failed. It may already be stopped."
}
