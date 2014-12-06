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

namespace CopyCat
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var manager = Context.GetOwinContext().GetUserManager<ApplicationUserManager>();
            var signInManager = Context.GetOwinContext().Get<ApplicationSignInManager>();
            var user = new ApplicationUser() { UserName = "admin@admin.com", Email = "admin@admin.com" };
            IdentityResult result = manager.Create(user, "Admin123!");
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

            return System.Text.Encoding.Default.GetString(Input);
        }

        protected void UploadButton_Click(object sender, EventArgs e)
        {
            ReadCSV();
            BuildSchema();
            ReadDataToSchema();
        }

        private void ReadDataToSchema()
        {
            //Table state = sourceSchema.Tables.Where(t => t.)
            foreach (string[] row in data)
            {
            }
        }



        private void BuildSchema()
        {
            //State Table
            CopyCat.Models.Table t = new CopyCat.Models.Table();

            t.Name = "State";
            // cols
            Column c = new Column();
            c.Name = "StateCode";
            c.Datatype = "int";
            c.IsPK = true;
            t.Columns.Add(c);

            c = new Column();
            c.Name = "StateName";
            c.Datatype = "varchar";
            c.Size = "50";
            t.Columns.Add(c);
            sourceSchema.Tables.Add(t);

            //Year Table
            t = new CopyCat.Models.Table();

            t.Name = "Year";
            // cols
            c = new Column();
            c.Name = "Year";
            c.Datatype = "int";
            c.IsPK = true;
            t.Columns.Add(c);

            sourceSchema.Tables.Add(t);

            //Month Table
            t = new CopyCat.Models.Table();

            t.Name = "Month";
            // cols
            c = new Column();
            c.Name = "Month";
            c.Datatype = "varchar";
            c.Size = "50";
            c.IsPK = true;
            t.Columns.Add(c);

            sourceSchema.Tables.Add(t);

            //Month Table
            t = new CopyCat.Models.Table();

            t.Name = "Weather";
            // cols
            c = new Column();
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

            sourceSchema.Tables.Add(t);
        }

        
    }
}