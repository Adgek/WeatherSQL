using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Web;

namespace CopyCat.Models
{
    // my script generator class for looking at the schema object and creating 
    // a script to create the database
    public class ScriptGenerator
    {
        public string GenerateMasterScript(Schema schema)
        {
            string finalScript ="";
            finalScript += ReadDbaseScript("creationscript.sql");
            Table weather = schema.Tables.Where(t => t.Name == "Weather").SingleOrDefault();
            finalScript += Environment.NewLine + GenerateRowInserts(weather);

            return finalScript;
        }

        
        public string ReadDbaseScript(string scriptName)
        {
            string commandText;
            Assembly thisAssembly = Assembly.GetExecutingAssembly();
            using (Stream s = thisAssembly.GetManifestResourceStream(
                  "CopyCat." + scriptName))
            {
                using (StreamReader sr = new StreamReader(s))
                {
                    commandText = sr.ReadToEnd();
                }
            }
            return commandText;
        }

        private string GenerateRowInserts(Table t)
        {
            string rows = "";
            string rowStart = "INSERT INTO " + t.Name + " (";
            List<string> cols = getColumnList(t);
            int count = 0;
            foreach(string col in cols)
            {
                rowStart += "["+col+"]";
                if (count < cols.Count - 1)
                    rowStart += ",";
                count++;
            }
            rowStart += ") VALUES (";

            foreach(string row in t.Rows)
            {
                rows += rowStart + row + ")" + Environment.NewLine;
            }

            return rows;
        }

        private List<string> getColumnList(CopyCat.Models.Table t)
        {
            List<string> ColsToPull = new List<string>();
            foreach (Column c in t.Columns)
            {
                if (c.IsPK && c.IsIdentity)
                {

                }
                else
                {
                    ColsToPull.Add(c.Name);
                }
            }
            return ColsToPull;
        }
    }
}