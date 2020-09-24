using System;
using RayTracingWeekend.Utils;

namespace RayTracingWeekend
{
	class Camera
	{
		Point3 origin;
		Point3 lower_left_corner;
		Vec3 horizontal;
		Vec3 vertical;
		Vec3 u, v, w;
		double lens_radius;

		public this(Point3 lookfrom, Point3 lookat, Vec3 vup, double vfov, double aspect_ratio, double aperture, double focus_dist)
		{
			let theta = degrees_to_radians(vfov);
			let h = Math.Tan(theta/2);
			let viewport_height = 2.0 * h;
			let viewport_width = aspect_ratio * viewport_height;

			w = Vec3.unit_vector(lookfrom -lookat);
			u = Vec3.unit_vector(Vec3.cross(vup, w));
			v = Vec3.cross(w, u);

			origin = lookfrom;
			horizontal = focus_dist * viewport_width * u;
			vertical = focus_dist * viewport_height * v;
			lower_left_corner = origin - horizontal/2 - vertical/2 - focus_dist*w;

			lens_radius = aperture / 2;
		}

		public Ray get_ray(double s, double t)
		{
			Vec3 rd = lens_radius * Vec3.random_in_unit_disk();
			Vec3 offset = u * rd.x + v * rd.y;
			return Ray(
				origin + offset,
				lower_left_corner + s*horizontal + t*vertical - origin - offset
			);
		}
	}
}
