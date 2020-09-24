using System;

namespace RayTracingWeekend
{
	class Program
	{
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
			return (1.0-t)*(Color(0.9, 0.9, 0.9)) + t*(Color(0.7, 0.8, 0.9));
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

		static HittableList random_scene()
		{
			let world = new HittableList();
			let rand = new Random();
			defer delete rand;

			var material_ground = new Lambertian(Color(0.8, 0.8, 0.0));
			world.add(new Sphere(Point3(0, -1000, 0), 1000, material_ground));

			for (int a = -11; a < 11; a++) {
				for (int b = -11; b < 11; b++) {
					let choose_mat = rand.NextDouble();
					let center = Point3(a + 0.9*rand.NextDouble(), 0.2, b + 0.9*rand.NextDouble());

					if ((center - Point3(4, 0.2, 0)).length() > 0.9)
					{
						if (choose_mat < 0.8) {
							// diffuse
							let albedo = Color.random() * Color.random();
							let sphere_material = new Lambertian(albedo);
							world.add(new Sphere(center, 0.2, sphere_material));
						} else if (choose_mat < 0.95) {
							// metal
							let albedo = Color.random(0.5, 1);
							let fuzz = rand.NextDouble()*0.5;
							let sphere_material = new Metal(albedo, fuzz);
							world.add(new Sphere(center, 0.2, sphere_material));
						} else {
							// glass
							let sphere_material = new Dielectric(1.5);
							world.add(new Sphere(center, 0.2, sphere_material));
						}
					}
				}
			}

			let material1 = new Dielectric(1.5);
			world.add(new Sphere(Point3(0, 1, 0), 1.0, material1));
			let material2 = new Lambertian(Color(0.4, 0.2, 0.1));
			world.add(new Sphere(Point3(-4, 1, 0), 1.0, material2));
			let material3 = new Metal(Color(0.7, 0.6, 0.5), 0.0);
			world.add(new Sphere(Point3(4, 1, 0), 1.0, material3));

			return world;
		}

		static void Main()
		{
			var start_time = DateTime.Now;
			
			// Image
			let aspect_ratio = 3.0 / 2.0;
			let image_width = 1200;
			let image_height = (int)(image_width / aspect_ratio);
			let samples_per_pixel = 50;
			let max_depth = 50;

			// World
			var world = random_scene();
			defer delete world;

			// Render
			var imageData = new String();
			defer delete imageData;

			var Stream = System.Console.Error;
			imageData.AppendF("P3\n{} {}\n255\n", image_width, image_height);

			let lookfrom = Point3(13,2,3);
			let lookat = Point3(0,0,0);
			let vup = Vec3(0,1,0);
			let dist_to_focus = 10;
			let aperture = 0.1;

			// Camera
			var cam = scope Camera(lookfrom, lookat, vup, 20.0, aspect_ratio, aperture, dist_to_focus);

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

			// FIXME there's definitely a better way to deallocate the scene objects
			for (var obj in ref world.objects) {
				var sphere = (Sphere)obj;
				delete sphere.mat_ptr;
				delete sphere;
			}
			world.clear();
			
			Stream.Write(scope String("\nDone.")..AppendF(" Render time: {}\n", DateTime.Now - start_time));

			let fileName = "image.ppm";
			System.IO.File.WriteAllText(fileName, imageData);
		}
	}
}
