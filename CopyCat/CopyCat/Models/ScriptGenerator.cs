using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CopyCat.Models
{
    // my script generator class for looking at the schema object and creating 
    // a script to create the database
    public class ScriptGenerator
    {
        public string GenerateMasterScript(Schema schema)
        {
            string finalScript = "BEGIN TRANSACTION" + Environment.NewLine;
            foreach(Table t in schema.Tables)
            {
                if (t.IsMissing)
                    finalScript += GenerateCreateTableScript(t) + Environment.NewLine;
            }
            foreach (Table t in schema.Tables)
            {
                finalScript += GenerateRowInserts(t);
            }

            return finalScript;
        }

        private string GenerateCreateTableScript(Table t)
        {
            string createTableScript = "CREATE TABLE " + t.Name + " ( " + Environment.NewLine;

            int count = 0;
            Boolean havePK = false;
            foreach(Column c in t.Columns)
            {
                createTableScript += "["+c.Name+"]" + " " + c.Datatype;
                if(c.Datatype.Contains("char"))
                {
                    createTableScript += "(" + c.Size + ")";
                }
                if (!c.IsNullable)
                    createTableScript += " NOT NULL";
                if (c.IsIdentity && !havePK)
                    createTableScript += " IDENTITY(1,1)";
                if ((c.IsPK) && !havePK)
                {
                    createTableScript += " PRIMARY KEY";
                    havePK = true;
                }
                if (c.IsUnique)
                    createTableScript += " UNIQUE";
                if(count < t.Columns.Count - 1)
                    createTableScript += "," + Environment.NewLine;
                count++;
            }
            createTableScript += Environment.NewLine + ")"; 

            if(!havePK)
            {
                createTableScript += Environment.NewLine;
                createTableScript += "CREATE CLUSTERED INDEX IX_" + t.Name + "_" + t.Columns[0].Name + " ON " + t.Name + " (" + t.Columns[0].Name + ");";
            }

            return createTableScript;
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