namespace RayTracingWeekend
{
	abstract class Material
	{
		public abstract bool scatter(ref Ray r_in, hit_record rec, ref Color attenuation, ref Ray scattered);
	}

	class Lambertian : Material
	{
		public Color albedo;

		public this(Color a)
		{
			albedo = a;
		}

		public override bool scatter(ref Ray r_in, hit_record rec, ref Color attenuation, ref Ray scattered)
		{
			// let scatter_direction = rec.normal + Vec3.random_in_unit_sphere();
			// let scatter_direction = Vec3.random_in_hemisphere(rec.normal);
			let scatter_direction = rec.normal + Vec3.random_unit_vector();
			scattered = Ray(rec.p, scatter_direction);
			attenuation = albedo;
			return true;
		}
	}

	class Metal : Material
	{
		public Color albedo;

		public this(Color a)
		{
			albedo = a;
		}

		public override bool scatter(ref Ray r_in, hit_record rec, ref Color attenuation, ref Ray scattered)
		{
			let reflected = Vec3.reflect(Vec3.unit_vector(r_in.direction), rec.normal);
			scattered = Ray(rec.p, reflected);
			attenuation = albedo;
			return true;
		}
	}
}
