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

		static Color ray_color(Ray r, Hittable world, int depth)
		{
			var rec = hit_record();

			// If we've exceeded the ray bounce limit, no more light is gathered.
			if (depth <= 0)
			    return Color(0,0,0);

			if (world.hit(r, 0.0001, Double.MaxValue, ref rec)) {
				// let target = rec.p + rec.normal + Vec3.random_in_unit_sphere();
				let target = rec.p + rec.normal + Vec3.random_unit_vector();
				return 0.5 * ray_color(scope Ray(rec.p, target - rec.p), world, depth-1);
			}

			Vec3 unit_direction = Vec3.unit_vector(r.direction);
			let t = 0.5*(unit_direction.y + 1.0);
			return (1.0-t)*(Color(0.8, 0.8, 1.0)) + t*(Color(1.0, 0.7, 0.7));
		}

		static void write_color(ref String imageData, Color pixel_color, int samples_per_pixel)
		{
			var r = pixel_color.x;
			var g = pixel_color.y;
			var b = pixel_color.z;

			// Divide the color by the number of samples
			let scale = 1.0 / samples_per_pixel;
			r = Math.Sqrt(scale * r);
			g = Math.Sqrt(scale * g);
			b = Math.Sqrt(scale * b);

			imageData.AppendF("\n{} {} {}",
				(int)(256 * Math.Clamp(r, 0.0, 0.999)),
				(int)(256 * Math.Clamp(g, 0.0, 0.999)),
				(int)(256 * Math.Clamp(b, 0.0, 0.999))
				);
		}

		static void Main()
		{
			// Image
			let aspect_ratio = 16.0 / 9.0;
			let image_width = 340;
			let image_height = (int)(image_width / aspect_ratio);
			let samples_per_pixel = 10;
			let max_depth = 50;

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
			var imageData = new String();
			defer delete imageData;

			var Stream = System.Console.Error;
			imageData.AppendF("P3\n{} {}\n255\n", image_width, image_height);

			// Camera
			var cam = scope Camera();

			var rand = scope Random();

			for (int j = image_height-1; j >= 0; --j)
			{
				Stream.Write("\rScanlines remaining: {0,5}", j);
				for (int i < image_width)
				{
					var pixel_color = scope Color(0.0, 0.0, 0.0);
					for (int s < samples_per_pixel)
					{
						let u = (i + rand.NextDouble()) / (image_width-1);
						let v = (j + rand.NextDouble()) / (image_height-1);
						let r = cam.get_ray(u, v);
						defer delete r;
						*pixel_color += ray_color(r, world, max_depth);
					}
					write_color(ref imageData, *pixel_color, samples_per_pixel);
				}
			}
			Stream.Write("\nDone.\n");
			let fileName = "image.ppm";
			System.IO.File.WriteAllText(fileName, imageData);
		}
	}
}
