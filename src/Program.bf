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

		static void write_color(ref System.Collections.List<String> imageData, Color pixel_color, int samples_per_pixel)
		{
			var r = pixel_color.x;
			var g = pixel_color.y;
			var b = pixel_color.z;

			// Divide the color by the number of samples
			let scale = 1.0/ samples_per_pixel;
			r *= scale;
			g *= scale;
			b *= scale;

			imageData.Add(new String()..AppendF("{} {} {}",
				(int)(256 * Math.Clamp(r, 0.0, 0.999)),
				(int)(256 * Math.Clamp(g, 0.0, 0.999)),
				(int)(256 * Math.Clamp(b, 0.0, 0.999))
				));
		}

		static void Main()
		{
			// Image
			let aspect_ratio = 16.0 / 9.0;
			let image_width = 340;
			let image_height = (int)(image_width / aspect_ratio);
			let samples_per_pixel = 5;

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

			// Render
			var imageData = new System.Collections.List<String>();
			defer delete imageData;
			var ErrStream = System.Console.Error;
			// var OutStream = System.Console.Out;
			imageData.Add(scope String()..AppendF("P3\n{} {}\n255\n", image_width, image_height));

			// Camera
			let cam = scope Camera();

			var rand = new Random();
			defer delete rand;

			for (int j = image_height-1; j >= 0; --j)
			{
				ErrStream.Write("\rScanlines remaining: {}", j);
				for (int i < image_width)
				{
					var pixel_color = scope Color(0.0, 0.0, 0.0);
					for (int s < samples_per_pixel)
					{
						let u = (i + rand.NextDouble())/(image_width-1);
						let v = (j + rand.NextDouble())/(image_height-1);
						let r = cam.get_ray(u, v);
						defer delete r;
						*pixel_color += ray_color(r, world);
					}
					write_color(ref imageData, *pixel_color, samples_per_pixel);
				}
			}
			ErrStream.Write("\nDone.\n");
			let fileName = "image.ppm";
			System.IO.File.WriteAllLines(fileName, imageData.GetEnumerator());
			delete imageData;
		}
	}
}
