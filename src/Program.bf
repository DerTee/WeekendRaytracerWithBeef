using System;

namespace RayTracingInOneWeekendWithBeef
{
	class Program
	{
		static Color ray_color(Ray r)
		{
			Vec3 unit_direction = Vec3.unit_vector(r.direction);
			let t = 0.5*(unit_direction.y + 1.0);
			return (1.0-t)*(Color(1.0, 1.0, 1.0)) + t*(Color(0.5, 0.7, 1.0));
		}

		static void write_color(System.IO.StreamWriter outstream, Color c)
		{
			outstream.WriteLine("{} {} {}",
				(int)(255.9*c.x),
				(int)(255.9*c.y),
				(int)(255.9*c.z)
				);
		}

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
					write_color(OutStream, pixel_color);
				}	
			}
		}
	}
}
