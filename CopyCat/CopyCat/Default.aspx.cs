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
using System.Threading;

namespace CopyCat
{
    public partial class _Default : Page
    {
        static string conString2 = "Data Source=tcp:edhvxycn0p.database.windows.net,1433;Initial Catalog=WeatherDB;User Id=kylfowler@edhvxycn0p;Password=Myadmin123";
        private Schema sourceSchema;
        List<string[]> data = new List<string[]>();
        private ScriptGenerator gen;

        protected void Page_Load(object sender, EventArgs e)
        {
            conString2 = "Data Source=tcp:edhvxycn0p.database.windows.net,1433;Initial Catalog=" + DatabaseDealer.GetDBName() + ";User Id=kylfowler@edhvxycn0p;Password=Myadmin123";
            gen = new ScriptGenerator();
            try
            {
                fillInStateDropdown();
            }
            catch
            {
                System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "No data to populate the area selector box with.", "DeveloperLog");
            }            
        }

        // read a database
        private void ReadCSV()
        {
            sourceSchema = new Schema();
            sourceSchema.Name = "WeatherData";

            if (FileUploadControl.HasFile)
            {
                try
                {
                    System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Starting to read in the CSV file.", "DeveloperLog");
                    string filename = Path.GetFileName(FileUploadControl.FileName);
                    FileUploadControl.SaveAs(Server.MapPath("~/") + filename);
                    string fileContents = GetFileContents(FileUploadControl.PostedFile);
                    string[] importData = fileContents.Split(',');
                    if(importData.Count() < 40)
                    {
                        throw new Exception("Not enough data was supplied to parse a valid row of weather data.");
                    }
                    ConvertDataToList(importData);
                    System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Finished reading in the CSV file.", "DeveloperLog");
                    StatusLabel.Text = "Upload status: File uploaded!";
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Data not valid! " + ex.Message);
                    StatusLabel.Text = "Upload status: The file could not be uploaded. The following error occured: " + ex.Message;
                    throw ex;
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

        [WebMethod]
        public void UploadButton_Click(object sender, EventArgs e)
        {
            try
            {
                ReadCSV();
            }
            catch
            {
                StatusLabel.Text = "Error: No valid rows were found to parse in the file.";
                return;
            }
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
                    NonQueryExec(conn, dropscript + " " + DatabaseDealer.GetDBName());

                    DatabaseDealer.SetDBName(DatabaseDealer.GetDBName(), "WeatherDB" + DateTime.Now.Ticks);
                }
                catch (Exception ex)
                {
                    DatabaseDealer.SetDBName(DatabaseDealer.GetDBName(), "WeatherDB" + DateTime.Now.Ticks);
                    System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Failed to drop the database.", "DeveloperLog");
                    System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Data not valid! " + ex.Message);
                }
                System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Creating the database.", "DeveloperLog");
                NonQueryExec(conn, createscript + DatabaseDealer.GetDBName());
                System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Successfully Created the database.", "DeveloperLog");
            }

            List<string> scripts = gen.GenerateMasterScript(sourceSchema);
            conString2 = "Data Source=tcp:edhvxycn0p.database.windows.net,1433;Initial Catalog=" + DatabaseDealer.GetDBName() + ";User Id=kylfowler@edhvxycn0p;Password=Myadmin123";
            using (SqlConnection conn = new SqlConnection(conString2))
            {
                conn.Open();
                foreach (string script in scripts)
                {
                    try
                    {
                        NonQueryExec(conn, script);
                    }
                    catch(Exception ex)
                    {
                        System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Encountered an error doing an insert of weather data: " + ex.Message, "DeveloperLog");
                    }
                }

                string procsscript;
                for (int x = 1; x < 4; x++)
                {
                    procsscript = gen.ReadDbaseScript("SqlScripts.views.view" + x + ".sql");
                    NonQueryExec(conn, procsscript);
                    procsscript = gen.ReadDbaseScript("SqlScripts.procedures.procedure" + x + ".sql");
                    NonQueryExec(conn, procsscript);
                }
            }
            System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")"+ " The database have been successfully created and populated. " + data.Count + " rows were added to the new database.", "DeveloperLog");
            fillInStateDropdown();
        }

        private static void NonQueryExec(SqlConnection conn, string script, int timeout=0)
        {
            SqlCommand cmd = new SqlCommand(script, conn);
            cmd.CommandType = CommandType.Text;
            cmd.CommandTimeout = 120;
            cmd.ExecuteNonQuery();
        }

        private void ReadDataToSchema()
        {
            CopyCat.Models.Table Weather = sourceSchema.Tables.Where(t => t.Name == "Weather").SingleOrDefault();
            string tmin="", tmax="", tavg= "", pcp = "";
            int count = 1;
            int Errcount = 0;
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
                    Errcount++;
                    continue;
                }
                try
                {
                    pcp = MathFunctions.InchesToMillimetres(row[3]);
                }
                catch
                {
                    System.Diagnostics.Trace.WriteLine("(User:" + User.Identity.Name + ")" + "Value: '" + row[3] + "' for pcp was invalid for row " + count + ".");
                    Errcount++;
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
            if(Errcount == data.Count)            
                StatusLabel.Text += " The file was invalid, no rows could be added to the database.";            
            else if(Errcount > 0)
                StatusLabel.Text += " There were " + Errcount + " rows in the file that could be not parsed into a valid database row of weather data.";
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
                System.Diagnostics.Trace.WriteLine( "Value: '" + valueToConvert + "' for " + element + " was invalid for row " + count + ".");
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
                rows = QueryExec(conn, "SELECT DISTINCT statecode,statename FROM [State] INNER JOIN Weather ON Weather.SID = state.id", 2);
            }
            try
            {
                AreaDropdown.InnerHtml = "<button class=\"btn btn-default  AreaSelection dropdown-toggle\" type=\"button\" id=\"AreaSelection\" runat=\"Server\" data-toggle=\"dropdown\" aria-expanded=\"true\">" +
                    rows[0][1] +
                    "<span class=\"caret\"></span>" +
                    "</button>" +
                    "<ul class=\"dropdown-menu areaSelection scrollable-menu\" role\"menu\" runat=\"server\" id=\"stateDropDown\">";
            }
            catch
            {
                AreaDropdown.InnerHtml = "<button class=\"btn btn-default  AreaSelection dropdown-toggle\" type=\"button\" id=\"AreaSelection\" runat=\"Server\" data-toggle=\"dropdown\" aria-expanded=\"true\">" +
                    "No Data"+
                    "<span class=\"caret\"></span>" +
                    "</button>" +
                    "<ul class=\"dropdown-menu areaSelection scrollable-menu\" role\"menu\" runat=\"server\" id=\"stateDropDown\">";
            }
            foreach(List<string> row in rows)
            {
                AreaDropdown.InnerHtml += "<li role=\"presentation\"><a role=\"menuitem\" tabindex=\"-1\" href=\"#\" onclick=\"StateSelection='" + row[0] + "';DrawSelectedGraph();\">" + row[1] + "</a></li>";
            }
            AreaDropdown.InnerHtml += "</ul>";
            Page.ClientScript.RegisterStartupScript(this.GetType(), "someID", "SetStateCode(" + rows[0][0] + ")", true);
        }
    }
}