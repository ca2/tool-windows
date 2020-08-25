

if "%1" == "macos" (set drive=M) else ( if "%1" == "opensuse" (set drive=M) else (set drive=C) )

vmware-vdiskmanager -d %drive%:\computer\build\%1\%1.vmdk
vmware-vdiskmanager -k %drive%:\computer\build\%1\%1.vmdk

if "%1" NEQ "macos" (
vmware-vdiskmanager -d M:\computer\storage\xcore_linux.vmdk
vmware-vdiskmanager -k M:\computer\storage\xcore_linux.vmdk
)
