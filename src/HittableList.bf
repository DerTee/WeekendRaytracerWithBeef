using System.Collections;

namespace RayTracingWeekend
{
	class HittableList : Hittable
	{
		public var objects = new List<Hittable>();

		public this() {}
		public this(Hittable object) { add(object); }
		public ~this() { delete objects; }

		public void clear() { objects.Clear(); }
		public void add(Hittable object) { objects.Add(object); }

		public bool hit(Ray r, double t_min, double t_max, ref hit_record rec)
		{
			var temp_rec = hit_record();
			var hit_anything = false;
			var closest_so_far = t_max;

			for (var object in objects) {
				if (object.hit(r, t_min, t_max, ref temp_rec)) {
					hit_anything = true;
					closest_so_far = temp_rec.t;
					rec = temp_rec;
				}
			}

			return hit_anything;
		}
	}
}
