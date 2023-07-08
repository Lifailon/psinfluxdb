# Version 0.1
# Only GET requests
# Examples:
# Get-InfluxUsers -ip 192.168.3.104
# Get-InfluxDatabases -ip 192.168.3.104
# Get-InfluxTables -ip 192.168.3.104 -database powershell
# Get-InfluxData -ip 192.168.3.104 -database powershell -table speedtest | ft
# Get-InfluxData -ip 192.168.3.104 -database powershell -table performance -user root -password root

function Get-InfluxUsers {
param (
    $ip     = "localhost",
    $port   = 8086,
    $user,
    $password
)
$ipp   = $ip+":"+$port
$query = "SHOW USERS"
$url   = "http://$ipp/query?q=$query"

if (($user -ne $null) -and ($password -ne $null)) {
	$pass = $password | ConvertTo-SecureString -AsPlainText -Force
	$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
	$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
} else {
	$data = Invoke-RestMethod -Method GET -Uri $url
}

$col = $data.results.series.columns
$val = $data.results.series.values

$mass    = @()
$mass   += [string]$col
foreach ($v in $val) {
	$mass += [string]$v
}
$mass = $mass -replace '^','"'
$mass = $mass -replace '$','"'
$mass = $mass -replace '\s','","'
$mass | ConvertFrom-Csv
}

function Get-InfluxDatabases {
param (
    $ip     = "localhost",
    $port   = 8086,
    $user,
    $password
)
$ipp   = $ip+":"+$port
$query = "SHOW DATABASES"
$url   = "http://$ipp/query?q=$query"

if (($user -ne $null) -and ($password -ne $null)) {
	$pass = $password | ConvertTo-SecureString -AsPlainText -Force
	$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
	$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
} else {
	$data = Invoke-RestMethod -Method GET -Uri $url
}

$data.results.series.values
}

function Get-InfluxTables {
param (
    $ip       = "localhost",
    $port     = 8086,
    $database = "main",
    $user,
    $password
)
$ipp   = $ip+":"+$port
$query = "SHOW measurements"
$url   = "http://$ipp/query?db=$database&q=$query"

if (($user -ne $null) -and ($password -ne $null)) {
	$pass = $password | ConvertTo-SecureString -AsPlainText -Force
	$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
	$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
} else {
	$data = Invoke-RestMethod -Method GET -Uri $url
}

$data.results.series.values
}

function Get-InfluxData {
param (
    $ip       = "localhost",
    $port     = 8086,
    $database = "main",
    $table,
    $user,
    $password
)
$ipp   = $ip+":"+$port
$query = "SELECT * FROM $Table"
$url   = "http://$ipp/query?db=$database&q=$query"

if (($user -ne $null) -and ($password -ne $null)) {
	$pass = $password | ConvertTo-SecureString -AsPlainText -Force
	$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
	$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
} else {
	$data = Invoke-RestMethod -Method GET -Uri $url
}

$col = $data.results.series.columns
$val = $data.results.series.values

$mass    = @()
$mass   += [string]$col
foreach ($v in $val) {
    $v2 = $v -replace "\s{1,100}","-"
	$mass += [string]$v2
}
$mass = $mass -replace '^','"'
$mass = $mass -replace '$','"'
$mass = $mass -replace '\s','","'
$mass | ConvertFrom-Csv
}