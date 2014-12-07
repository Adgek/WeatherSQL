using System;
using System.Collections.Generic;
using System.Linq;

namespace MathFunctions
{
	class MathFunctions
	{
		public static void Main(string[] args)
		{
			string temp = "45";
			string inches = "5";
			Console.WriteLine("Value Temp is: " + temp);
			Console.WriteLine(FahrenheitToCelcius(temp));
			Console.WriteLine("Value inches is: " + inches);
			Console.WriteLine(InchesToMillimetres(inches));
		}


		public static string FahrenheitToCelcius(string temp)
		{
			double FahrenheitValue = 0;
			try
			{
				FahrenheitValue = Convert.ToDouble(temp);
			}
			catch
			{
				//Value cannot be converted to double
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
			catch
			{
				//Value cannot be converted to double
			}
			double MillimetreValue = 0;

			MillimetreValue = InchesValue * 25.4;
			MillimetreValue = Math.Round(MillimetreValue, 2);

			return MillimetreValue.ToString();
		}
	}
}