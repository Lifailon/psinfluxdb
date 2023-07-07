# psinflux

**PowerShell module for interaction to InfluxDB v1 (using REST API)** \
By default GET requests give line-by output. This module for output in object format. \
Version 0.1: only GET requests.

Get-InfluxUsers -ip 192.168.3.104

Get-InfluxDatabases -ip 192.168.3.104

Get-InfluxTables -ip 192.168.3.104 -database powershell

Get-InfluxData -ip 192.168.3.104 -database powershell -table speedtest | ft

Get-InfluxData -ip 192.168.3.104 -database powershell -table speedtest -user root -password root
