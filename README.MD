# Windows Powershell issues

PS outputs UT16 with BOM which is invalid for the image format PPM, so you have to use
```
.\Debug_Win64\RayTracingInOneWeekendWithBeef\RayTracingInOneWeekendWithBeef.exe | Out-File -Encoding ASCII image.ppm
```

With timing info:
```
Measure-Command { .\Debug_Win64\RayTracingInOneWeekendWithBeef\RayTracingInOneWeekendWithBeef.exe | Out-File -Encoding ASCII image.ppm }
```