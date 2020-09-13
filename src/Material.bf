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
		public double fuzz;

		public this(Color a, double f)
		{
			albedo = a;
			fuzz = f;
		}

		public override bool scatter(ref Ray r_in, hit_record rec, ref Color attenuation, ref Ray scattered)
		{
			let reflected = Vec3.reflect(Vec3.unit_vector(r_in.direction), rec.normal);
			scattered = Ray(rec.p, reflected + fuzz*Vec3.random_in_unit_sphere());
			attenuation = albedo;
			return true;
		}
	}

	class Dielectric : Material
	{
		public double ref_idx;

		public this(double i)
		{
			ref_idx = i;
		}

		public override bool scatter(ref Ray r_in, hit_record rec, ref Color attenuation, ref Ray scattered)
		{
			attenuation = Color(1.0, 1.0, 1.0);
			let etai_over_etat = rec.front_face ? (1.0 / ref_idx) : ref_idx;

			let unit_direction = Vec3.unit_vector(r_in.direction);
			let refracted = Vec3.refract(unit_direction, rec.normal, etai_over_etat);
			scattered = Ray(rec.p, refracted);
			return true;
		}
	}
}
