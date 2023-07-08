# psinflux

**PowerShell module for interaction to InfluxDB v1 (using REST API)**. \
By default GET requests give line-by output. This module is used to automate the query form and output in **object format**. \
Only GET requests.

## Import
```
PS C:\Users\Lifailon> import-Module psinfluxdb
PS C:\Users\Lifailon> Get-Command -Module psinfluxdb

CommandType     Name                  Version    Source
-----------     ----                  -------    ------
Function        Get-InfluxChart       0.2        psinfluxdb
Function        Get-InfluxData        0.2        psinfluxdb
Function        Get-InfluxDatabases   0.2        psinfluxdb
Function        Get-InfluxTables      0.2        psinfluxdb
Function        Get-InfluxUsers       0.2        psinfluxdb
```

## Examples:
```
PS C:\Users\Lifailon> Get-InfluxUsers -ip 192.168.3.104

user  admin
----  -----
admin True
root  True
read  False
```

```
PS C:\Users\Lifailon> Get-InfluxDatabases -ip 192.168.3.104

_internal
powershell
```

```
PS C:\Users\Lifailon> Get-InfluxTables -ip 192.168.3.104 -database powershell

performance
ping
speedtest
```
```
PS C:\Users\Lifailon> Get-InfluxData -ip 192.168.3.104 -database powershell -table ping | ft

time                host            rtime status
----                ----            ----- ------
07/08/2023-15:16:24 HUAWEI-MB-X-Pro 22    True
07/08/2023-15:16:29 HUAWEI-MB-X-Pro 20    True
07/08/2023-15:16:35 HUAWEI-MB-X-Pro 20    True
07/08/2023-15:16:41 HUAWEI-MB-X-Pro 20    True
07/08/2023-15:16:51 HUAWEI-MB-X-Pro 0     False
07/08/2023-15:17:06 HUAWEI-MB-X-Pro 32    True
07/08/2023-15:17:16 HUAWEI-MB-X-Pro 22    True
07/08/2023-15:17:27 HUAWEI-MB-X-Pro 20    True
07/08/2023-15:17:37 HUAWEI-MB-X-Pro 20    True
07/08/2023-15:17:47 HUAWEI-MB-X-Pro 21    True
...
```

![Image alt](https://github.com/Lifailon/psinfluxdb/blob/rsa/Screen/Example.jpg)

### Chart (version 0.2)

**Source:** https://webnote.satin-pl.com/2019/04/03/posh_influxdb_query/

```
$influx = Get-InfluxData -ip 192.168.3.104 -database powershell -table speedtest
Get-InfluxChart -time ($influx.time) -data ($influx.download) -title "SpeedTest Download" -path "C:\Users\Lifailon\Desktop"
```

![Image alt](https://github.com/Lifailon/psinfluxdb/blob/rsa/Screen/Chart.jpg)
