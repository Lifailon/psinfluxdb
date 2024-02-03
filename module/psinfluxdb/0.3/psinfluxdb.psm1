function Get-InfluxUsers {
	<#
    .SYNOPSIS
    PowerShell module for interaction to InfluxDB 1.x via api
	Only GET requests and data output to chart (use WinForms)
    .DESCRIPTION
    Example:
    Get-InfluxUsers -server 192.168.3.102
    Get-InfluxUsers -server 192.168.3.102 -port 8086
    Get-InfluxUsers -server 192.168.3.102 -port 8086 -user admin -password password
    .LINK
    https://github.com/Lifailon/psinfluxdb
    https://www.nuget.org/packages/psinfluxdb
    #>
	param (
	    $server = "localhost",
	    $port   = 8086,
	    $user,
	    $password
	)
	$query = "SHOW USERS"
	$url   = "http://$($server):$($port)/query?q=$query"
	if (($null -ne $user) -and ($null -ne $password)) {
		$pass = $password | ConvertTo-SecureString -AsPlainText -Force
		$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
		$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
	}
	else {
		$data = Invoke-RestMethod -Method GET -Uri $url
	}
	$col = $data.results.series.columns
	$val = $data.results.series.value
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
	<#
    .SYNOPSIS
    PowerShell module for interaction to InfluxDB 1.x via api
	Only GET requests and data output to chart (use WinForms)
    .DESCRIPTION
    Example:
	Get-InfluxDatabases -server 192.168.3.102
	Get-InfluxDatabases -server 192.168.3.102 -port 8086
	Get-InfluxDatabases -server 192.168.3.102 -port 8086 -user admin -password password
	Get-InfluxDatabases -server 192.168.3.102 -creat -database test
	Get-InfluxDatabases -server 192.168.3.102 -delete -database test
	.LINK
    https://github.com/Lifailon/psinfluxdb
    https://www.nuget.org/packages/psinfluxdb
    #>
	param (
	    $server = "localhost",
	    $port   = 8086,
	    $user,
	    $password,
		[switch]$creat,
		$database,
		[switch]$delete
	)
	if (($creat -eq $true) -and ($null -ne $database) -and ($delete -eq $false)) {
		$query = "CREATE DATABASE $database"
		$url   = "http://$($server):$($port)/query?q=$query"
		if (($null -ne $user) -and ($null -ne $password)) {
			$pass = $password | ConvertTo-SecureString -AsPlainText -Force
			$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
			Invoke-RestMethod -Method GET -Uri $url -Credential $cred | Out-Null
		}
		else {
			Invoke-RestMethod -Method GET -Uri $url | Out-Null
		}
	}
	if (($delete -eq $true) -and ($null -ne $database) -and ($creat -eq $false)) {
		$query = "DROP DATABASE $database"
		$url   = "http://$($server):$($port)/query?q=$query"
		if (($null -ne $user) -and ($null -ne $password)) {
			$pass = $password | ConvertTo-SecureString -AsPlainText -Force
			$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
			Invoke-RestMethod -Method GET -Uri $url -Credential $cred | Out-Null
		}
		else {
			Invoke-RestMethod -Method GET -Uri $url | Out-Null
		}
	}
	$query = "SHOW DATABASES"
	$url   = "http://$($server):$($port)/query?q=$query"
	if (($null -ne $user) -and ($null -ne $password)) {
		$pass = $password | ConvertTo-SecureString -AsPlainText -Force
		$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
		$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
	}
	else {
		$data = Invoke-RestMethod -Method GET -Uri $url
	}
	$data.results.series.values
}

function Get-InfluxPolicy {
	<#
    .SYNOPSIS
    PowerShell module for interaction to InfluxDB 1.x via api
	Only GET requests and data output to chart (use WinForms)
    .DESCRIPTION
    Example:
    Get-InfluxPolicy -server 192.168.3.102 -database PowerShell
    Get-InfluxPolicy -server 192.168.3.102 -database PowerShell -port 8086
    Get-InfluxPolicy -server 192.168.3.102 -database PowerShell -port 8086 -user admin -password password
    Get-InfluxPolicy -server 192.168.3.102 -database PowerShell -creat -policyName del2d -hours 48
    Get-InfluxPolicy -server 192.168.3.102 -database PowerShell -policyName del2d -default
	.LINK
    https://github.com/Lifailon/psinfluxdb
    https://www.nuget.org/packages/psinfluxdb
    #>
	param (
	    $server = "localhost",
	    $port   = 8086,
	    $database,
		[switch]$creat,
		[switch]$default,
		$policyName,
		$hours,
		$replication = 1,
		$user,
	    $password
	)
	if (($creat -eq $true) -and ($null -ne $policyName) -and ($null -ne $hours) -and ($default -eq $false)) {
		$query = "CREATE RETENTION POLICY $policyName ON $database DURATION $($hours)h REPLICATION $replication"
		$url   = "http://$($server):$($port)/query?q=$query"
		if (($null -ne $user) -and ($null -ne $password)) {
			$pass = $password | ConvertTo-SecureString -AsPlainText -Force
			$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
			$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
		}
		else {
			$data = Invoke-RestMethod -Method GET -Uri $url
		}
	}
	if (($default -eq $true) -and ($null -ne $policyName) -and ($creat -eq $false)) {
		$query = "ALTER RETENTION POLICY $policyName ON $database DEFAULT"
		$url   = "http://$($server):$($port)/query?q=$query"
		if (($null -ne $user) -and ($null -ne $password)) {
			$pass = $password | ConvertTo-SecureString -AsPlainText -Force
			$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
			$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
		}
		else {
			$data = Invoke-RestMethod -Method GET -Uri $url
		}
	}
	$query = "SHOW RETENTION POLICIES ON $database"
	$url   = "http://$($server):$($port)/query?q=$query"
	if (($null -ne $user) -and ($null -ne $password)) {
		$pass = $password | ConvertTo-SecureString -AsPlainText -Force
		$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
		$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
	}
	else {
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

function Get-InfluxTables {
	<#
    .SYNOPSIS
    PowerShell module for interaction to InfluxDB 1.x via api
	Only GET requests and data output to chart (use WinForms)
    .DESCRIPTION
    Example:
	Get-InfluxTables -server 192.168.3.102 -database PowerShell
	Get-InfluxTables -server 192.168.3.102 -database PowerShell -port 8086
	Get-InfluxTables -server 192.168.3.102 -database PowerShell -port 8086 -user admin -password password
    .LINK
    https://github.com/Lifailon/psinfluxdb
    https://www.nuget.org/packages/psinfluxdb
    #>
	param (
	    $server   = "localhost",
	    $port     = 8086,
	    $database = "main",
	    $user,
	    $password
	)
	$query = "SHOW measurements"
	$url   = "http://$($server):$($port)/query?db=$database&q=$query"
	if (($null -ne $user) -and ($null -ne $password)) {
		$pass = $password | ConvertTo-SecureString -AsPlainText -Force
		$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
		$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
	}
	else {
		$data = Invoke-RestMethod -Method GET -Uri $url
	}
	$data.results.series.values
}

function Get-InfluxData {
	<#
    .SYNOPSIS
    PowerShell module for interaction to InfluxDB 1.x via api
	Only GET requests and data output to chart (use WinForms)
    .DESCRIPTION
    Example:
	Get-InfluxData -server 192.168.3.102 -database PowerShell -table HardwareMonitor | Format-Table
	Get-InfluxData -server 192.168.3.102 -database PowerShell -table HardwareMonitor -minutes 60 | Format-Table
    .LINK
    https://github.com/Lifailon/psinfluxdb
    https://www.nuget.org/packages/psinfluxdb
    #>
	param (
	    $server   = "localhost",
	    $port     = 8086,
	    $database = "PowerShell",
	    $table,
		$minutes = "10",
		$user,
	    $password
	)
	$query = "SELECT * FROM $Table WHERE time > now() - $($minutes)m"
	$url   = "http://$($server):$($port)/query?db=$database&q=$query"
	if (($null -ne $user) -and ($null -ne $password)) {
		$pass = $password | ConvertTo-SecureString -AsPlainText -Force
		$cred = [System.Management.Automation.PSCredential]::new($user,$pass)
		$data = Invoke-RestMethod -Method GET -Uri $url -Credential $cred 
	}
	else {
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
	<#
    .SYNOPSIS
    PowerShell module for interaction to InfluxDB 1.x via api
	Only GET requests and data output to chart (use WinForms)
    .DESCRIPTION
    Example:
	$influx = Get-InfluxData -server 192.168.3.102 -database PowerShell -table speedtest
	Get-InfluxChart -time ($influx.time) -data ($influx.download) -title "SpeedTest Download" -path "$home\Desktop"
    .LINK
    https://github.com/Lifailon/psinfluxdb
    https://www.nuget.org/packages/psinfluxdb
	https://webnote.satin-pl.com/2019/04/03/posh_influxdb_query
    #>
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