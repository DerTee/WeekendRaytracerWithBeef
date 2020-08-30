namespace RayTracingWeekend
{
	struct hit_record {
		Point3 p;
		Vec3 normal;
		double t;
	}

	abstract class Hittable
	{
		public abstract bool hit(Ray r, double t_min, double t_max, hit_record rec);
	}
}
