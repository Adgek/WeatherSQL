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
            
            gen = new ScriptGenerator();
        }

        private Schema sourceSchema;
        private Schema destSchema;

        private string[] importData;
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

            return System.Text.Encoding.Default.GetString(Input).Replace('\n',' ').Replace(" ","");
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            ReadCSV();
            BuildSchema();
            ReadDataToSchema();
            string conString = "Data Source=tcp:edhvxycn0p.database.windows.net,1433;Initial Catalog=master;User Id=kylfowler@edhvxycn0p;Password=Myadmin123";
            string createscript = gen.ReadDbaseScript("createdatabase.sql");
            string dropscript = gen.ReadDbaseScript("dropdatabase.sql");
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                SqlCommand cmd;
                try
                {
                    cmd = new SqlCommand(dropscript, conn);
                    cmd.CommandType = CommandType.Text;
                    cmd.ExecuteNonQuery();
                }
                catch
                {
                    //log
                }

                cmd = new SqlCommand(createscript, conn);
                cmd.CommandType = CommandType.Text;
                cmd.ExecuteNonQuery();
            }

            string script = gen.GenerateMasterScript(sourceSchema);
            string conString2 = "Data Source=tcp:edhvxycn0p.database.windows.net,1433;Initial Catalog=WeatherDB;User Id=kylfowler@edhvxycn0p;Password=Myadmin123";
            using (SqlConnection conn = new SqlConnection(conString2))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand(script, conn);
                cmd.CommandType = CommandType.Text;
                cmd.CommandTimeout = 0;
                cmd.ExecuteNonQuery();
            }
        }

        private void ReadDataToSchema()
        {
            CopyCat.Models.Table Weather = sourceSchema.Tables.Where(t => t.Name == "Weather").SingleOrDefault();
            foreach (string[] row in data)
            {
                Weather.Rows.Add("(SELECT ID FROM YEAR WHERE yearname = " + row[2].Substring(0, 4) + ")," +
                                 "(SELECT ID FROM MONTH WHERE monthname = " + row[2].Substring(4, 2) + ")," +
                                 " (SELECT ID FROM STATE WHERE statecode = " + row[0] +")," +
                                 row[18] + "," +
                                 row[19] + "," +
                                 row[4]+ "," +
                                 row[3]+ "," +
                                 row[1]+ "," +
                                 row[9]+ "," +
                                 row[10]);
            }
            Weather.Rows.RemoveAt(0);
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
            c.Name = "Division";
            c.Datatype = "varchar";
            c.Size = "3";
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

        [System.Web.Services.WebMethod()]
        public static string MyMethod(string name)
        {
            return "Hello " ;
        }
  
    }
}