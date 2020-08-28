namespace RayTracingInOneWeekendWithBeef
{
	class Ray
	{
		public Point3 orig;
		public Vec3 dir;

		this()
		{
		}

		this(Point3 origin, Vec3 direction)
		{
			orig = origin;
			dir = direction;
		}

		public Point3 origin
		{
			get { return orig; }
		}

		public Vec3 direction
		{
			get { return dir; }
		}

		Point3 at(double t)
		{
			return orig + t*dir;
		}
	}
}
