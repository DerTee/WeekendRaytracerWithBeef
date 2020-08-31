using System;

namespace RayTracingWeekend
{
	class Program
	{
		// Utilities
		//  wrong place, but there is no right place yet
		[Inline]
		public static double degrees_to_radians(double degrees)
		{
			return degrees * Math.PI_d / 180;
		}

		static Color ray_color(Ray r, Hittable world)
		{
			var rec = hit_record();
			if (world.hit(r, 0, Double.MaxValue, ref rec)) {
				return 0.5 * (rec.normal + Color(1,1,1));
			}
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

			// World
			var world = new HittableList();
			var sphere1 = new Sphere(Point3(0,0,-1), 0.5);
			world.add(sphere1);
			var sphere2 = new Sphere(Point3(0,-100.5,-1), 100);
			world.add(sphere2);
			defer
			{
				delete sphere1;
				delete sphere2;
				delete world;
			}

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
				for (int i < image_width)
				{
					let u = double(i)/(image_width-1);
					let v = double(j)/(image_height-1);
					ray.dir = lower_left_corner + u*horizontal + v*vertical - origin;
					let pixel_color = ray_color(ray, world);
					write_color(OutStream, pixel_color);
				}
			}
			ErrStream.Write("\nDone.\n");
		}
	}
}
