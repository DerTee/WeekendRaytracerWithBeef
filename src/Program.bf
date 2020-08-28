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


			for (int j = 0; j < image_width; ++j) {
				ErrStream.Write("\rScanlines remaining: {}", j);
				for (int i = 0; i < image_height; ++i) {
					double r = (double)i / (image_width-1);
					double g = (double)j / (image_height-1);
					double b = 0.25;

					int ir = (int)(255.9 * r);
					int ig = (int)(255.9 * g);
					int ib = (int)(255.9 * b);

					System.Console.WriteLine("{} {} {}", ir, ig, ib);
				}	
			}
		}
	}
}
