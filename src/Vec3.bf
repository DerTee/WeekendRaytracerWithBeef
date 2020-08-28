using System;

namespace RayTracingInOneWeekendWithBeef
{
	class Vec3
	{
		public double[3] e;

		public this()
		{
			for(int i = 0; i < e.Count; i++) {
				e[i] = 0.0;
			}
		}

		public this(double e0, double e1, double e2) {
			e[0] = e0;
			e[1] = e1;
			e[2] = e2;
		}

		// override for [] operator seems to work differently than the others
		// found help here: https://www.reddit.com/r/beeflang/comments/ihibt2/how_do_i_overload_the_operator/g30d73b
		public double this[int key]
		{
		    get { return e[key]; }
			set mut { e[key] = value; }
		}

		public void operator+=(Vec3 rhs)
		{
		    e[0] += rhs.e[0];
			e[1] += rhs.e[1];
			e[2] += rhs.e[2];
		}

		public void operator-=(Vec3 rhs)
		{
		    e[0] -= rhs.e[0];
			e[1] -= rhs.e[1];
			e[2] -= rhs.e[2];
		}

		public void operator*=(double t)
		{
		    e[0] *= t;
			e[1] *= t;
			e[2] *= t;
		}

		
		public void operator/=(double t)
		{
			// would like to do the following, but it doesnt work
		    // this *= 1/t;
			e[0] /= t;
			e[1] /= t;
			e[2] /= t;
		}

		public double x
		{
			get { return e[0]; }
			set mut { e[0] = value; }
		}

		public double y
		{
			get { return e[1]; }
			set mut { e[1] = value; }
		}

		public double z
		{
			get { return e[2]; }
			set mut { e[2] = value; }
		}


		public double length()
		{
			return Math.Sqrt(length_squared());
		}	

		public double length_squared()
		{
			return e[0]*e[0] + e[1]*e[1] + e[2]*e[2];
		}

		public String ToString()
		{
			return new String("{} {} {}", e[0], e[1], e[2]);
		}

	}

	typealias Color = Vec3;
	typealias Point3 = Vec3;
}
