# Raytracer in a weekend

This is following [_Ray Tracing in One Weekend_](https://raytracing.github.io/books/RayTracingInOneWeekend.html).
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