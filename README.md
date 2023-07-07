# psinflux

**PowerShell module for interaction to InfluxDB v1 (using REST API)** \
By default GET requests give line-by output. This module for creat and output in **object format**. \
Version 0.1: only GET requests.

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
speedtest
```
```
PS C:\Users\Lifailon> Get-InfluxData -ip 192.168.3.104 -database powershell -table speedtest | ft
time                download host            ping upload
----                -------- ----            ---- ------
07/06/2023-20:00:11 291172   HUAWEI-MB-X-PRO 3    280829
07/06/2023-20:12:15 308885   HUAWEI-MB-X-PRO 3    307078
07/06/2023-20:46:29 311197   HUAWEI-MB-X-PRO 3    284526
07/06/2023-20:48:44 312540   HUAWEI-MB-X-PRO 3    284669
07/06/2023-20:51:00 312861   HUAWEI-MB-X-PRO 3    279900
07/06/2023-20:53:17 313120   HUAWEI-MB-X-PRO 3    282298
07/06/2023-20:55:33 312638   HUAWEI-MB-X-PRO 3    237256
07/06/2023-20:57:50 311915   HUAWEI-MB-X-PRO 3    280594
07/06/2023-21:00:07 295804   HUAWEI-MB-X-PRO 3    219438
07/06/2023-21:02:23 307016   HUAWEI-MB-X-PRO 3    249504
07/06/2023-21:04:39 267358   HUAWEI-MB-X-PRO 4    212225
07/06/2023-21:06:55 309878   HUAWEI-MB-X-PRO 3    228684
07/06/2023-21:09:10 308277   HUAWEI-MB-X-PRO 3    256097
07/06/2023-21:11:26 312194   HUAWEI-MB-X-PRO 2    253876
07/06/2023-21:13:42 292125   HUAWEI-MB-X-PRO 3    143308
07/06/2023-21:15:57 307825   HUAWEI-MB-X-PRO 3    235829
07/06/2023-21:18:13 311578   HUAWEI-MB-X-PRO 3    225315
07/06/2023-21:20:29 311019   HUAWEI-MB-X-PRO 4    242643
07/06/2023-21:22:44 308873   HUAWEI-MB-X-PRO 3    243114
07/06/2023-21:24:59 306217   HUAWEI-MB-X-PRO 3    211599
...
```

![Image alt](https://github.com/Lifailon/psinfluxdb/blob/rsa/Example.jpg)
