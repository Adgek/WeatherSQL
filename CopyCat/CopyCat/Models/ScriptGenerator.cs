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
        public List<string> GenerateMasterScript(Schema schema)
        {
            List<string> scripts =new List<string>();
            scripts.Add(ReadDbaseScript("SqlScripts.dbasesetup.creationscript.sql"));
            Table weather = schema.Tables.Where(t => t.Name == "Weather").SingleOrDefault();
            scripts.AddRange(GenerateRowInserts(weather));

            return scripts;
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
        

        private List<string> GenerateRowInserts(Table t)
        {
            List<string> rows = new List<string>();
            string rowStart = "INSERT INTO " + t.Name + " (";
            List<string> cols = getColumnList(t);
            int count = 0;
            string rowClump = "";
            foreach(string col in cols)
            {
                rowStart += "["+col+"]";
                if (count < cols.Count - 1)
                    rowStart += ",";
                count++;
            }
            rowStart += ") VALUES (";
            int rowCount = 0;
            foreach(string row in t.Rows)
            {
                rowClump += rowStart + row + ")" + Environment.NewLine;
                rowCount++;
                if (rowCount == 500)
                {
                    rows.Add(rowClump);
                    rowClump = "";
                    rowCount = 0;
                }

            }
            if(rowCount != 0)
                rows.Add(rowClump);
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