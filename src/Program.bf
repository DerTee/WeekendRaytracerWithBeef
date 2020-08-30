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

			let aspect_ratio = 16.0 / 9.0;
			let image_width = 340;
			let image_height = (int)(image_width / aspect_ratio);

			// Camera

			let viewport_height = 2.0;
			let viewport_width = aspect_ratio * viewport_height;
			let focal_length = 1.0;

			let origin = Point3(0, 0, 0);
			let horizontal = Vec3(viewport_width, 0, 0);
			let vertical = Vec3(0, viewport_height, 0);
			let lower_left_corner = origin - horizontal/2 - vertical/2 - Vec3(0, 0, focal_length);

			var ray = scope Ray(Point3(0.0, 0.0, 0.0), Vec3(1.0, 1.0, -10.0));


			// Render

			System.Console.Write("P3\n{} {}\n255\n", image_width, image_height);
			var ErrStream = System.Console.Error;
			var OutStream = System.Console.Out;


			for (int j = image_height-1; j >= 0; --j)
			{
				ErrStream.Write("\rScanlines remaining: {}", j);
				for (int i = 0; i < image_width; ++i)
				{
					let u = double(i)/(image_width-1);
					let v = double(j)/(image_height-1);
					ray.dir = lower_left_corner + u*horizontal + v*vertical - origin;
					write_color(OutStream, ray_color(ray));
				}
			}
			ErrStream.Write("\nDone.\n");
		}
	}
}
