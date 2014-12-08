using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using Owin;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using CopyCat.Models;
using System.IO;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Web.Services;
using System.Web.Script.Services;

namespace CopyCat
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            System.Diagnostics.Trace.WriteLine("Program started!", "DeveloperLog");
            gen = new ScriptGenerator();
            try
            {
                fillInStateDropdown();
            }
            catch
            {

            }
            
        }
        static string conString2 = "Data Source=tcp:edhvxycn0p.database.windows.net,1433;Initial Catalog=WeatherDB;User Id=kylfowler@edhvxycn0p;Password=Myadmin123";
        private Schema sourceSchema;
        List<string[]> data = new List<string[]>();

        private ScriptGenerator gen;


        // read a database
        private void ReadCSV()
        {
            sourceSchema = new Schema();
            sourceSchema.Name = "WeatherData";

            if (FileUploadControl.HasFile)
            {
                try
                {
                    string filename = Path.GetFileName(FileUploadControl.FileName);
                    FileUploadControl.SaveAs(Server.MapPath("~/") + filename);
                    string fileContents = GetFileContents(FileUploadControl.PostedFile);
                    string[] importData = fileContents.Split(',');
                    ConvertDataToList(importData);
                    StatusLabel.Text = "Upload status: File uploaded!";
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("Data not valid! " + ex.Message);
                    StatusLabel.Text = "Upload status: The file could not be uploaded. The following error occured: " + ex.Message;
                }
            }
        }

        private void ConvertDataToList(string[] importData)
        {
            string[] strings = new string[20];
            int count = 0;
            foreach (string col in importData)
            {
                strings[count] = col;
                count++;
                if (count == 20)
                {
                    data.Add(strings);
                    strings = new string[20];
                    count = 0;
                }
            }
        }

        private string GetFileContents(HttpPostedFile file)
        {
            System.IO.Stream myStream;
            Int32 fileLen;
            StringBuilder displayString = new StringBuilder();

            // Get the length of the file.
            fileLen = FileUploadControl.PostedFile.ContentLength;

            // Create a byte array to hold the contents of the file.
            Byte[] Input = new Byte[fileLen];

            // Initialize the stream to read the uploaded file.
            myStream = FileUploadControl.FileContent;

            // Read the file into the byte array.
            myStream.Read(Input, 0, fileLen);

            return System.Text.Encoding.Default.GetString(Input).Replace('\n', ' ').Replace(" ", "");
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            spinner.Attributes.Remove("hidden");
            UploadButton.Enabled = false;
            ReadCSV();
            BuildSchema();
            ReadDataToSchema();
            string conString = "Data Source=tcp:edhvxycn0p.database.windows.net,1433;Initial Catalog=master;User Id=kylfowler@edhvxycn0p;Password=Myadmin123";
            string createscript = gen.ReadDbaseScript("SqlScripts.dbasesetup.createdatabase.sql");
            string dropscript = gen.ReadDbaseScript("SqlScripts.dbasesetup.dropdatabase.sql");
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                try
                {
                    NonQueryExec(conn, dropscript);
                }
                catch(Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("Data not valid! " + ex.Message);
                }
                NonQueryExec(conn, createscript);
            }

            string script = gen.GenerateMasterScript(sourceSchema);
            
            using (SqlConnection conn = new SqlConnection(conString2))
            {
                conn.Open();
                NonQueryExec(conn, script);

                string procsscript;
                for (int x = 1; x < 4; x++)
                {
                    procsscript = gen.ReadDbaseScript("SqlScripts.views.view" + x + ".sql");
                    NonQueryExec(conn, procsscript);
                    procsscript = gen.ReadDbaseScript("SqlScripts.procedures.procedure" + x + ".sql");
                    NonQueryExec(conn,procsscript);
                }
            }
            spinner.Attributes.Add("hidden","hidden");
            UploadButton.Enabled = true;
        }

        private static void NonQueryExec(SqlConnection conn, string script, int timeout=0)
        {
            SqlCommand cmd = new SqlCommand(script, conn);
            cmd.CommandType = CommandType.Text;
            cmd.CommandTimeout = 0;
            cmd.ExecuteNonQuery();
        }

        private void ReadDataToSchema()
        {
            CopyCat.Models.Table Weather = sourceSchema.Tables.Where(t => t.Name == "Weather").SingleOrDefault();
            string tmin="", tmax="", tavg= "", pcp = "";
            int count = 1;
            foreach (string[] row in data)
            {
                try
                {
                    tmin = GetTemp(count, row[18], "temp min");
                    tmax = GetTemp(count, row[19], "temp max");
                    tavg = GetTemp(count, row[4], "temp average");
                }
                catch
                {
                    continue;
                }
                try
                {
                    pcp = MathFunctions.InchesToMillimetres(row[3]);
                }
                catch
                {
                    System.Diagnostics.Trace.WriteLine("Value: '" + row[3] + "' for pcp was invalid for row " + count + ".");
                    continue;
                }
                Weather.Rows.Add("(SELECT ID FROM YEAR WHERE yearname = " + row[2].Substring(0, 4) + ")," +
                                 "(SELECT ID FROM MONTH WHERE monthname = " + row[2].Substring(4, 2) + ")," +
                                 " (SELECT ID FROM STATE WHERE statecode = " + row[0] + ")," +
                                 tmin + "," +
                                 tmax + "," + 
                                 tavg + "," + 
                                 pcp + "," + 
                                 row[9] + "," + // CDD
                                 row[10]); //HDD
                count++;
            }
        }

        private static string GetTemp(int count, string valueToConvert, string element)
        {
            string value ="";
            try
            {
                value = MathFunctions.FahrenheitToCelcius(valueToConvert);
            }
            catch
            {
                System.Diagnostics.Trace.WriteLine("Value: '" + valueToConvert + "' for " + element + " was invalid for row " + count + ".");
                throw;
            }
            return value;
        }



        private void BuildSchema()
        {
            //Weather Table
            CopyCat.Models.Table t = new CopyCat.Models.Table();

            t.Name = "Weather";
            // cols
            Column c = new Column();
            c.Name = "ID";
            c.Datatype = "int";
            c.IsPK = true;
            c.IsNullable = false;
            c.IsIdentity = true;
            t.Columns.Add(c);

            c = new Column();
            c.Name = "YID";
            c.Datatype = "int";
            c.IsFK = true;
            t.Columns.Add(c);

            c = new Column();
            c.Name = "MID";
            c.Datatype = "varchar";
            c.Size = "50";
            c.IsFK = true;
            t.Columns.Add(c);

            c = new Column();
            c.Name = "SID";
            c.Datatype = "int";
            c.IsFK = true;
            t.Columns.Add(c);

            c = new Column();
            c.Name = "Tmin";
            c.Datatype = "float";
            t.Columns.Add(c);

            c = new Column();
            c.Name = "Tmax";
            c.Datatype = "float";
            t.Columns.Add(c);

            c = new Column();
            c.Name = "Tavg";
            c.Datatype = "float";
            t.Columns.Add(c);

            c = new Column();
            c.Name = "Pcp";
            c.Datatype = "float";
            t.Columns.Add(c);


            c = new Column();
            c.Name = "CDD";
            c.Datatype = "int";
            t.Columns.Add(c);

            c = new Column();
            c.Name = "HDD";
            c.Datatype = "int";
            t.Columns.Add(c);

            sourceSchema.Tables.Add(t);
        }

        private static List<List<string>> QueryExec(SqlConnection conn, string script,int numFields, int timeout = 0)
        {
            SqlCommand cmd = new SqlCommand(script, conn);
            cmd.CommandType = CommandType.Text;
            cmd.CommandTimeout = 0;
            SqlDataReader reader = cmd.ExecuteReader();
            List<List<string>> rows = new List<List<string>>();
            if (reader.HasRows)
            {
                while (reader.Read())
                {
                    List<string> row = new List<string>();
                    for (int x = 0; x < numFields; x++ )
                    {
                        row.Add(String.Format("{0}", reader[x]));
                    }
                    rows.Add(row);
                }
            }
            reader.Close();
            return rows;
        }

        [WebMethod]
        public static string GetPrecipitationData(string StateCode)
        {
            List<List<string>> rows = new List<List<string>>();
            using (SqlConnection conn = new SqlConnection(conString2))
            {
                conn.Open();
                rows = QueryExec(conn, "EXEC getPrecipitationForArea " + StateCode, 3);
            }
            List<string> headers = new List<string>();
            headers.Add("month");
            headers.Add("year");
            headers.Add("pcp");


            return GetJsonOutput(rows, headers);
        }

        // "{ \"Years\": [1990, 1990, 1990, 1990, 1991, 1991, 1992, 1993], \"Months\": [1, 2, 4, 5, 5,6,7,8], \"Precipitation\": [1, 2, 4, 5, 1, 2, 3,4] }"
        static private string GetJsonOutput(List<List<string>> rows, List<string> headers)
        {
            string final = "";
            int numColumns = headers.Count;

            for (int x = 0; x < headers.Count; x++ )
            {
                headers[x] = "\"" + headers[x] + "\": [";
            }

            for (int x = 0; x < rows.Count; x++ )
            {
                for (int y = 0; y < headers.Count; y++ )
                {
                    if (x > 0)
                        headers[y] += ",";
                    headers[y] += "\"" + rows[x][y] + "\"";

                }
            }
            final = "{ ";
            for (int x = 0; x < headers.Count; x++)
            {
                if(x > 0)
                    final += ",";
                final += headers[x] + "]";
            }
            final += "}";

            return final;
        }

        [WebMethod]
        public static string GetCoolingHeatingDaysData(string StateCode)
        {
            List<List<string>> rows = new List<List<string>>();
            using (SqlConnection conn = new SqlConnection(conString2))
            {
                conn.Open();
                rows = QueryExec(conn, "EXEC getCoolAndHeatForArea " + StateCode, 4);
            }
            List<string> headers = new List<string>();
            headers.Add("month");
            headers.Add("year");
            headers.Add("cdd");
            headers.Add("hdd");

            return GetJsonOutput(rows, headers);
        }

        [WebMethod]
        public static string GetTemperatureData(string StateCode)
        {
            List<List<string>> rows = new List<List<string>>();
            using (SqlConnection conn = new SqlConnection(conString2))
            {
                conn.Open();
                rows = QueryExec(conn, "EXEC getTemperatureForArea " + StateCode, 5);
            }
            List<string> headers = new List<string>();
            headers.Add("month");
            headers.Add("year");
            headers.Add("tmin");
            headers.Add("tmax");
            headers.Add("tavg");

            return GetJsonOutput(rows, headers);
        }

        private void fillInStateDropdown()
        {
            List<List<string>> rows = new List<List<string>>();
            using (SqlConnection conn = new SqlConnection(conString2))
            {
                conn.Open();
                rows = QueryExec(conn, "SELECT statecode,statename FROM [State]", 2);
            }
            foreach(List<string> row in rows)
            {
                stateDropDown.InnerHtml += "<li role=\"presentation\"><a role=\"menuitem\" tabindex=\"-1\" href=\"#\" onclick=\"StateSelection='" + row[0] + "'\">" + row[1] + "</a></li>";
            }

        }
    }
}