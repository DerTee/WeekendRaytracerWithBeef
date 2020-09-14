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

		static Color ray_color(ref Ray r, Hittable world, int depth)
		{
			var rec = hit_record();

			// If we've exceeded the ray bounce limit, no more light is gathered.
			if (depth <= 0)
			    return Color(0,0,0);

			if (world.hit(r, 0.0001, Double.MaxValue, ref rec)) {
				var scattered = Ray();
				var attenuation = Color();
				if(rec.mat_ptr.scatter(ref r, rec, ref attenuation, ref scattered))
					return attenuation * ray_color(ref scattered, world, depth-1);
				return Color(0,0,0);
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
			let max_depth = 5;

			// World
			var world = new HittableList();
			defer delete world;

			var material_ground = scope Lambertian(Color(0.8, 0.8, 0.0));
			//var material_center = new Lambertian(Color(0.7, 0.3, 0.3));
			var material_center = scope Dielectric(1.5);
			//var material_left = scope Metal(Color(0.8, 0.8, 0.8), 0.3);
			var material_left = scope Dielectric(1.5);
			var material_right = scope Metal(Color(0.8, 0.6, 0.2), 1.0);

			world.add(scope Sphere(Point3( 0,   0,   -1),   0.5, material_center));
			world.add(scope Sphere(Point3( 0,-100.5, -1), 100,   material_ground));
			world.add(scope Sphere(Point3(-1,   0,   -1),   0.5, material_left));
			world.add(scope Sphere(Point3(-1,   0,   -1),  -0.4, material_left));
			world.add(scope Sphere(Point3(1,    0,   -1),   0.5, material_right));

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
						var r = cam.get_ray(u, v);
						// defer delete r;
						*pixel_color += ray_color(ref r, world, max_depth);
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
