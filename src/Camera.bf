using System;

namespace RayTracingWeekend
{
	class Camera
	{
		Point3 origin;
		Point3 lower_left_corner;
		Vec3 horizontal;
		Vec3 vertical;

		public this(Point3 lookfrom, Point3 lookat, Vec3 vup, double vfov, double aspect_ratio)
		{
			let theta = Program.degrees_to_radians(vfov);
			let h = Math.Tan(theta/2);
			let viewport_height = 2.0 * h;
			let viewport_width = aspect_ratio * viewport_height;

			let w = Vec3.unit_vector(lookfrom -lookat);
			let u = Vec3.unit_vector(Vec3.cross(vup, w));
			let v = Vec3.cross(w, u);

			origin = lookfrom;
			horizontal = viewport_width * u;
			vertical = viewport_height * v;
			lower_left_corner = origin - horizontal/2 - vertical/2 - w;
		}

		public Ray get_ray(double s, double t)
		{
			return Ray(origin, lower_left_corner + s*horizontal + t*vertical - origin);
		}
	}
}
