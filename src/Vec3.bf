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
			[Inline]
		    get { return e[key]; }
			[Inline]
			set mut { e[key] = value; }
		}

		[Inline]
		public void operator +=(Vec3 rhs)
		{
		    e[0] += rhs.e[0];
			e[1] += rhs.e[1];
			e[2] += rhs.e[2];
		}

		[Inline]
		public void operator -=(Vec3 rhs)
		{
		    e[0] -= rhs.e[0];
			e[1] -= rhs.e[1];
			e[2] -= rhs.e[2];
		}

		[Inline]
		public void operator *=(double t)
		{
		    e[0] *= t;
			e[1] *= t;
			e[2] *= t;
		}

		[Inline]
		public void operator /=(double t)
		{
			// would like to do the following, but it doesn't work
		    // this *= 1/t;
			e[0] /= t;
			e[1] /= t;
			e[2] /= t;
		}

		public double x
		{
			[Inline]
			get { return e[0]; }
			[Inline]
			set mut { e[0] = value; }
		}

		public double y
		{
			[Inline]
			get { return e[1]; }
			[Inline]
			set mut { e[1] = value; }
		}

		public double z
		{
			[Inline]
			get { return e[2]; }
			[Inline]
			set mut { e[2] = value; }
		}

		[Inline]
		public double length()
		{
			return Math.Sqrt(length_squared());
		}	

		[Inline]
		public double length_squared()
		{
			return e[0]*e[0] + e[1]*e[1] + e[2]*e[2];
		}

		[Inline]
		public static Vec3 operator +(Vec3 lhs, Vec3 rhs) {
			return new Vec3(lhs[0] + rhs[0], lhs[1] + rhs[1], lhs[2] + rhs[2]);
		}

		[Inline]
		public static Vec3 operator -(Vec3 lhs, Vec3 rhs) {
			return new Vec3(lhs[0] - rhs[0], lhs[1] - rhs[1], lhs[2] - rhs[2]);
		}

		[Inline]
		public static Vec3 operator *(Vec3 lhs, Vec3 rhs) {
			return new Vec3(lhs[0] * rhs[0], lhs[1] * rhs[1], lhs[2] * rhs[2]);
		}

		[Inline]
		public static Vec3 operator *(double t, Vec3 v) {
			return new Vec3(v[0] * t, v[1] * t, v[2] * t);
		}

		[Inline]
		public static Vec3 operator *(Vec3 v, double t) {
			return new Vec3(v[0] * t, v[1] * t, v[2] * t);
		}

		[Inline]
		public static Vec3 operator /(Vec3 v, double t) {
			return (1/t) * v;
		}
	}

	typealias Color = Vec3;
	typealias Point3 = Vec3;
}
