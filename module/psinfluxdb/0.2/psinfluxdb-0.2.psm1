# Version 0.2
# Only GET requests and data output to chart (use WinForms)
# Examples:
# Get-InfluxUsers -ip 192.168.3.104
# Get-InfluxDatabases -ip 192.168.3.104
# Get-InfluxTables -ip 192.168.3.104 -database powershell
# Get-InfluxData -ip 192.168.3.104 -database powershell -table ping | ft
# Get-InfluxData -ip 192.168.3.104 -database powershell -table performance -user root -password root
# $influx = Get-InfluxData -ip 192.168.3.104 -database powershell -table speedtest
# Get-InfluxChart -time ($influx.time) -data ($influx.download) -title "SpeedTest Download" -path "C:\Users\Lifailon\Desktop"

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

function Get-InfluxChart {
param (
	$time,
	$data,
	$title,
	$path
)
Add-Type -AssemblyName System.Windows.Forms.DataVisualization
$Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
$ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
$Series = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.Series
$Series.ChartType = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Line
$Chart.Series.Add($Series)
$Chart.ChartAreas.Add($ChartArea)
$Chart.Series["Series1"].Points.DataBindXY($time, $data)

$Chart.Width = 800
$Chart.Height = 400
$Chart.Left = 10
$Chart.Top = 10
$Chart.BackColor = [System.Drawing.Color]::White
$Chart.BorderColor = "Black"
$Chart.BorderDashStyle = "Solid"

$ChartTitle = New-Object System.Windows.Forms.DataVisualization.Charting.Title
$ChartTitle.Text = $title
$Font = New-Object System.Drawing.Font @("Microsoft Sans Serif",12,[System.Drawing.FontStyle]::Bold)
$ChartTitle.Font =$Font
$Chart.Titles.Add($ChartTitle)
$AnchorAll = [System.Windows.Forms.AnchorStyles]::Bottom -bor [System.Windows.Forms.AnchorStyles]::Right -bor
[System.Windows.Forms.AnchorStyles]::Top -bor [System.Windows.Forms.AnchorStyles]::Left

if ($path) {
	$Chart.SaveImage("$path\Chart.jpeg", "jpeg")
}

$main_form = New-Object Windows.Forms.Form
$main_form.Width = 840
$main_form.Height = 470
$main_form.controls.add($Chart)
$Chart.Anchor = $AnchorAll
$main_form.Add_Shown({$main_form.Activate()})
$main_form.ShowDialog()
}