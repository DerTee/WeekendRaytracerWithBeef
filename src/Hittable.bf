using System;

namespace RayTracingWeekend
{
	struct hit_record {
		public Point3 p;
		public Vec3 normal;
		public double t;
		public bool front_face;

		[Inline]
		public void set_face_normal(Ray r, Vec3 outward_normal) mut
		{
			front_face = Vec3.dot(r.direction, outward_normal) < 0;
			normal = front_face ? outward_normal : outward_normal*(-1);
		}
	}

	abstract class Hittable
	{
		public abstract bool hit(Ray r, double t_min, double t_max, ref hit_record rec);
	}
}
