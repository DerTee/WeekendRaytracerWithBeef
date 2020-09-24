using System;

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
			scattered = Ray(rec.p, reflected + fuzz * Vec3.random_in_unit_sphere());
			attenuation = albedo;
			return true;
		}
	}

	class Dielectric : Material
	{
		public double ref_idx;
		private static Random rand = new Random() ~ delete _;

		public this(double i)
		{
			ref_idx = i;
		}

		public override bool scatter(ref Ray r_in, hit_record rec, ref Color attenuation, ref Ray scattered)
		{
			attenuation = Color(1.0, 1.0, 1.0);
			let etai_over_etat = rec.front_face ? (1.0 / ref_idx) : ref_idx;

			let unit_direction = Vec3.unit_vector(r_in.direction);

			let cos_theta = Math.Min(Vec3.dot(-1 * unit_direction, rec.normal), 1.0);
			let sin_theta = Math.Sqrt(1.0 - cos_theta * cos_theta);
			if (etai_over_etat * sin_theta > 1.0)
			{
				let reflected = Vec3.reflect(unit_direction, rec.normal);
				scattered = Ray(rec.p, reflected);
				return true;
			}
			let reflect_prob = schlick(cos_theta, etai_over_etat);
			if (rand.NextDouble() < reflect_prob)
			{
				let reflected = Vec3.reflect(unit_direction, rec.normal);
				scattered = Ray(rec.p, reflected);
				return true;
			}

			let refracted = Vec3.refract(unit_direction, rec.normal, etai_over_etat);
			scattered = Ray(rec.p, refracted);
			return true;
		}

		public double schlick(double cosine, double ref_idx)
		{
			var r0 = (1 - ref_idx) / (1 + ref_idx);
			r0 = r0 * r0;
			return r0 + (1 - r0) * Math.Pow((1 - cosine), 5);
		}
	}
}
