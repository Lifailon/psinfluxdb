# psinfluxdb

[![GitHub Release](https://img.shields.io/github/v/release/Lifailon/psinfluxdb?display_name=release&logo=GitHub&label=GitHub&link=https%3A%2F%2Fgithub.com%2FLifailon%2Fpsinfluxdb%2F)](https://github.com/Lifailon/psinfluxdb)
[![NuGet Version](https://img.shields.io/nuget/v/psinfluxdb?logo=NuGet&label=NuGet&link=https%3A%2F%2Fwww.nuget.org%2Fpackages%2Fpsinfluxdb)](https://www.nuget.org/packages/psinfluxdb)
[![GitHub top language](https://img.shields.io/github/languages/top/Lifailon/psinfluxdb?logo=PowerShell&link=https%3A%2F%2Fgithub.com%2FPowerShell%2FPowerShell)](https://github.com/PowerShell/PowerShell)
[![GitHub License](https://img.shields.io/github/license/Lifailon/psinfluxdb?link=https%3A%2F%2Fgithub.com%2FLifailon%2Fpsinfluxdb%2Fblob%2Frsa%2FLICENSE)](https://github.com/Lifailon/psinfluxdb/blob/rsa/LICENSE)

**PowerShell module for interaction to InfluxDB 1.x via API**. \
By default GET requests give line-by output. This module is used to automate the query form and output in **object format**. \
Only GET requests.

## 🚀 Install

Install module from [NuGet repository](https://www.nuget.org/packages/psinfluxdb):

```PowerShell
Install-Module psinfluxdb -Repository NuGet
```

Import module:

```PowerShell
PS C:\Users\Lifailon> Import-Module psinfluxdb
PS C:\Users\lifailon> Get-Command -Module psinfluxdb

CommandType     Name                      Version    Source
-----------     ----                      -------    ------
Function        Get-InfluxChart           0.3        psinfluxdb
Function        Get-InfluxData            0.3        psinfluxdb
Function        Get-InfluxDatabases       0.3        psinfluxdb
Function        Get-InfluxPolicy          0.3        psinfluxdb
Function        Get-InfluxTables          0.3        psinfluxdb
Function        Get-InfluxUsers           0.3        psinfluxdb
```

## 📚 Examples

Get user list:

```PowerShell
PS C:\Users\Lifailon> Get-InfluxUsers -server 192.168.3.102

user  admin
----  -----
admin True
root  True
read  False
```

Get database list:

```PowerShell
PS C:\Users\Lifailon> Get-InfluxDatabases -server 192.168.3.102

_internal
PowerShell
```

Creat and delete database:

```PowerShell
PS C:\Users\lifailon> Get-InfluxDatabases -server 192.168.3.102 -creat -database test

_internal
PowerShell
test

PS C:\Users\lifailon> Get-InfluxDatabases -server 192.168.3.102 -delete -database test

_internal
PowerShell
```

Database storage policies (creat and set default):

```PowerShell
PS C:\Users\lifailon> Get-InfluxPolicy -server 192.168.3.102 -database PowerShell

name               : autogen
duration           : 0s
shardGroupDuration : 168h0m0s
replicaN           : 1
default            : True

PS C:\Users\lifailon> Get-InfluxPolicy -server 192.168.3.102 -database PowerShell -creat -policyName del2d -hours 48

name               : autogen
duration           : 0s
shardGroupDuration : 168h0m0s
replicaN           : 1
default            : True

name               : del2d
duration           : 48h0m0s
shardGroupDuration : 24h0m0s
replicaN           : 1
default            : False

PS C:\Users\lifailon> Get-InfluxPolicy -server 192.168.3.102 -database PowerShell -policyName del2d -default

name               : autogen
duration           : 0s
shardGroupDuration : 168h0m0s
replicaN           : 1
default            : False

name               : del2d
duration           : 48h0m0s
shardGroupDuration : 24h0m0s
replicaN           : 1
default            : True
```

Get table (measurement) list:

```PowerShell
PS C:\Users\Lifailon> Get-InfluxTables -server 192.168.3.102 -database PowerShell

performance
ping
speedtest
HardwareMonitor
```

Get data from table (measurement) selected:

```PowerShell
PS C:\Users\Lifailon> Get-InfluxData -server 192.168.3.102 -database PowerShell -table ping | ft

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

![Image alt](https://github.com/Lifailon/psinfluxdb/blob/rsa/image/Example.jpg)

Get data for the last 30 minutes from [HardwareMonitor](https://github.com/Lifailon/PowerShellHardwareMonitor):

```PowerShell
PS C:\Users\lifailon> Get-InfluxData -server 192.168.3.102 -database PowerShell -table HardwareMonitor -minutes 30 | Format-Table

time                HardwareName                  Host        SensorName                     SensorType     Value
----                ------------                  ----        ----------                     ----------     -----
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#1                    Temperature_0  24
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#1_Distance_to_TjMax  Temperature_7  76
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#2                    Temperature_1  24
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#2_Distance_to_TjMax  Temperature_8  76
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#3                    Temperature_2  23
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#3_Distance_to_TjMax  Temperature_9  77
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#4                    Temperature_3  22
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#4_Distance_to_TjMax  Temperature_10 78
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#5                    Temperature_4  23
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#5_Distance_to_TjMax  Temperature_11 77
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#6                    Temperature_5  22
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Core_#6_Distance_to_TjMax  Temperature_12 78
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     CPU_Package                    Temperature_6  24
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     Core_Average                   Temperature_14 23
02/03/2024-22:27:45 Intel_Core_i5-10400           PLEX-01     Core_Max                       Temperature_13 24
02/03/2024-22:27:45 MSI_M390_250GB                PLEX-01     Temperature                    Temperature_0  34
02/03/2024-22:27:45 Nuvoton_NCT6687D              PLEX-01     CPU                            Temperature_0  28
02/03/2024-22:27:45 Nuvoton_NCT6687D              PLEX-01     CPU_Socket                     Temperature_4  27
02/03/2024-22:27:45 Nuvoton_NCT6687D              PLEX-01     M2_1                           Temperature_6  23
02/03/2024-22:27:45 Nuvoton_NCT6687D              PLEX-01     PCH                            Temperature_3  36
02/03/2024-22:27:45 Nuvoton_NCT6687D              PLEX-01     PCIe_x1                        Temperature_5  29
02/03/2024-22:27:45 Nuvoton_NCT6687D              PLEX-01     System                         Temperature_1  30
02/03/2024-22:27:45 Nuvoton_NCT6687D              PLEX-01     VRM_MOS                        Temperature_2  36
02/03/2024-22:27:45 Radeon_RX_570_Series          PLEX-01     GPU_Core                       Temperature_0  34
02/03/2024-22:27:45 ST1000DM003-1CH162            PLEX-01     Temperature                    Temperature_0  31
02/03/2024-22:27:45 WDC_WD2005FBYZ-01YCBB2        PLEX-01     Temperature                    Temperature_0  33
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#1                    Temperature_0  47
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#10                   Temperature_9  45
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#10_Distance_to_TjMax Temperature_22 55
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#11                   Temperature_10 45
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#11_Distance_to_TjMax Temperature_23 55
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#12                   Temperature_11 45
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#12_Distance_to_TjMax Temperature_24 55
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#1_Distance_to_TjMax  Temperature_13 53
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#2                    Temperature_1  48
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#2_Distance_to_TjMax  Temperature_14 52
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#3                    Temperature_2  47
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#3_Distance_to_TjMax  Temperature_15 53
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#4                    Temperature_3  45
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#4_Distance_to_TjMax  Temperature_16 55
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#5                    Temperature_4  50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#5_Distance_to_TjMax  Temperature_17 50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#6                    Temperature_5  50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#6_Distance_to_TjMax  Temperature_18 50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#7                    Temperature_6  50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#7_Distance_to_TjMax  Temperature_19 50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#8                    Temperature_7  50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#8_Distance_to_TjMax  Temperature_20 50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#9                    Temperature_8  45
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Core_#9_Distance_to_TjMax  Temperature_21 55
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK CPU_Package                    Temperature_12 50
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK Core_Average                   Temperature_26 47
02/03/2024-22:27:50 12th_Gen_Intel_Core_i7-1260P  HUAWEI-BOOK Core_Max                       Temperature_25 50
...
```

## 📈 Charts

The Grafana alternative (used **WinForms**) to create graphs from data obtained with the [Ookla-SpeedTest](https://github.com/Lifailon/Ookla-SpeedTest-API) module.

`$influx = Get-InfluxData -server 192.168.3.104 -database PowerShell -table speedtest` \
`Get-InfluxChart -time ($influx.time) -data ($influx.download) -title "SpeedTest Download" -path "C:\Users\Lifailon\Desktop"`

![Image alt](https://github.com/Lifailon/psinfluxdb/blob/rsa/image/Chart-Download.jpeg)

`Get-InfluxChart -time ($influx.time) -data ($influx.upload) -title "SpeedTest Upload" -path "C:\Users\Lifailon\Desktop"`

![Image alt](https://github.com/Lifailon/psinfluxdb/blob/rsa/image/Chart-Upload.jpeg)
