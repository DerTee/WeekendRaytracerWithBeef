using System;

namespace RayTracingWeekend
{
	class Camera
	{
		Point3 origin;
		Point3 lower_left_corner;
		Vec3 horizontal;
		Vec3 vertical;

		public this(double vfov, double aspect_ratio)
		{
			let theta = Program.degrees_to_radians(vfov);
			let h = Math.Tan(theta/2);
			let viewport_height = 2.0 * h;
			let viewport_width = aspect_ratio * viewport_height;

			let focal_length = 1.0;

			origin = Point3(0, 0, 0);
			horizontal = Vec3(viewport_width, 0, 0);
			vertical = Vec3(0, viewport_height, 0);
			lower_left_corner = origin - horizontal/2 - vertical/2 - Vec3(0, 0, focal_length);
		}

		public Ray get_ray(double u, double v)
		{
			return Ray(origin, lower_left_corner + u*horizontal + v*vertical - origin);
		}
	}
}
