using System;

namespace RayTracingInOneWeekendWithBeef
{
	class Program
	{
		static void Main()
		{
			// Image

			int image_width = 256;
			int image_height = 256;

			// Render

			System.Console.Write("P3\n{} {}\n255\n", image_width, image_height);
			var ErrStream = System.Console.Error;
			var OutStream = System.Console.Out;


			for (int j = 0; j < image_height; ++j) {
				ErrStream.Write("\rScanlines remaining: {}", j);
				for (int i = 0; i < image_width; ++i) {
					let pixel_color = scope Color(
						double(i)/(image_width-1),
						double(j)/(image_height-1),
						0.25);
					pixel_color.write_color(OutStream);
				}	
			}
		}
	}
}
