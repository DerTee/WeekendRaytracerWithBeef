namespace RayTracingWeekend
{
	class Camera
	{
		Point3 origin;
		Point3 lower_left_corner;
		Vec3 horizontal;
		Vec3 vertical;

		public this()
		{
			let aspect_ratio = 16.0 / 9.0;
			let viewport_height = 2.0;
			let viewport_width = aspect_ratio * viewport_height;
			let focal_length = 1.0;

			origin = Point3(0, 0, 0);
			horizontal = Vec3(viewport_width, 0, 0);
			vertical = Vec3(0, viewport_height, 0);
			lower_left_corner = origin - horizontal/2 - vertical/2 - Vec3(0, 0, focal_length);
		}

		public Ray get_ray(double u, double v)
		{
			return new Ray(origin, lower_left_corner + u*horizontal + v*vertical - origin);
		}
	}
}
