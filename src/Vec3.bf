namespace RayTracingInOneWeekendWithBeef
{
	class Vec3
	{
		public double[3] e;

		public double x {
			get { return e[0]; }
			set mut { e[0] = value; }
		}
		public double y {
			get { return e[1]; }
			set mut { e[1] = value; }
		}
		public double z {
			get { return e[2]; }
			set mut { e[2] = value; }
		}

		public this()
		{
			for(int i = 0; i < e.Count; i++) {
				e[i] = 0.0;
			}
		}
	}

	typealias Color = Vec3;
	typealias Point3 = Vec3;
}
