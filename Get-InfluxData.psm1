function Get-InfluxData {
param (
    [string]$ip    = "localhost",
    [string]$port  = 8086,
    [string]$db    = "main",
    [string]$Table
    #$cred   = Get-Credential
    #$user   = "admin"
    #$pass   = "password" | ConvertTo-SecureString -AsPlainText -Force
    #$cred   = [System.Management.Automation.PSCredential]::new($user,$pass)
)
$ip_port = $ip+":"+$port
$query   = "SELECT * FROM $Table"
$url     = "http://$ip_port/query?db=$db&q=$query"
$data    = Invoke-RestMethod -Method GET -Uri $url  # -Credential $cred 
$col     = $data.results.series.columns
$val     = $data.results.series.values

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

# Get-InfluxData -ip 192.168.3.104 -db win_performance -Table counters