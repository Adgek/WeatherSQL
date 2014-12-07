using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace CopyCat
{
	public static class MathFunctions
	{


		public static string FahrenheitToCelcius(string temp)
		{
			double FahrenheitValue = 0;
			try
			{
				FahrenheitValue = Convert.ToDouble(temp);
			}
			catch(Exception ex)
			{
                Trace.WriteLine("Data not valid! " + ex.Message);
                throw ex;
			}
			double CelciusValue = 0;

			CelciusValue = 5f/9f*(FahrenheitValue - 32);
			CelciusValue = Math.Round(CelciusValue, 2);

			return CelciusValue.ToString();
		}

		public static string InchesToMillimetres(string amount)
		{
			double InchesValue = 0;
			try
			{
				InchesValue = Convert.ToDouble(amount);
			}
            catch (Exception ex)
            {
                Trace.WriteLine("Data not valid! " + ex.Message);
                throw ex;
			}
			double MillimetreValue = 0;

			MillimetreValue = InchesValue * 25.4;
			MillimetreValue = Math.Round(MillimetreValue, 2);

			return MillimetreValue.ToString();
		}
	}
}