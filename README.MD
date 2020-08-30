# Raytracer in a weekend

This is following a [book about raytracing](https://raytracing.github.io/books/RayTracingInOneWeekend.html#overview).
The language used is [Beef](https://github.com/beefytech/Beef).


# Windows Powershell issues

PS outputs UTF16 with BOM which is invalid for the image format PPM, so you have to use
```
.\Debug_Win64\RayTracingInOneWeekendWithBeef\RayTracingInOneWeekendWithBeef.exe | Out-File -Encoding ASCII image.ppm
```

With timing info:
```
Measure-Command { .\Debug_Win64\RayTracingInOneWeekendWithBeef\RayTracingInOneWeekendWithBeef.exe | Out-File -Encoding ASCII image.ppm }
```