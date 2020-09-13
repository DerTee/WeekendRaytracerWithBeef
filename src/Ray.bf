namespace RayTracingWeekend
{
	struct Ray
	{
		public Point3 orig;
		public Vec3 dir;

		public this()
		{
			orig = Point3();
			dir = Vec3();
		}

		public this(Point3 origin, Vec3 direction)
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

		public Point3 at(double t)
		{
			return orig + t*dir;
		}
	}
}
