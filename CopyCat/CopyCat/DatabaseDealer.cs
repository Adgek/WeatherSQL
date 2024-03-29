﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace CopyCat
{
    public static class DatabaseDealer
    {
        private static string conString = "Data Source=r2oqwsh7ne.database.windows.net,1433;Initial Catalog=dbname;User Id=matthew;Password=Anselmo1";

        public static void SetDBName(string oldName, string newName)
        {
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                string script = "DELETE FROM [Dbase] WHERE name='" + oldName + "'";
                NonQueryExec(conn, script);
                script = "INSERT INTO [Dbase] VALUES('"+newName+"')";
                NonQueryExec(conn, script);
            }
        }

        /// <summary>
        /// Used to send a script to the dbase for a non query 
        /// </summary>
        /// <param name="conn">the connection to the dbase</param>
        /// <param name="script">the script to exec</param>
        /// <param name="timeout">how long before we timeout</param>
        private static void NonQueryExec(SqlConnection conn, string script, int timeout = 0)
        {
            SqlCommand cmd = new SqlCommand(script, conn);
            cmd.CommandType = CommandType.Text;
            cmd.CommandTimeout = 120;
            cmd.ExecuteNonQuery();
        }

        public static string GetDBName()
        {
            using (SqlConnection conn = new SqlConnection(conString))
            {
                conn.Open();
                SqlCommand cmd = new SqlCommand("SELECT TOP 1 name FROM [Dbase]", conn);
                cmd.CommandType = CommandType.Text;
                int numFields = 1;
                cmd.CommandTimeout = 0;
                SqlDataReader reader = cmd.ExecuteReader();
                List<List<string>> rows = new List<List<string>>();
                if (reader.HasRows)
                {
                    while (reader.Read())
                    {
                        List<string> row = new List<string>();
                        for (int x = 0; x < numFields; x++)
                        {
                            row.Add(String.Format("{0}", reader[x]));
                        }
                        rows.Add(row);
                    }
                }
                reader.Close();
                return rows[0].FirstOrDefault();
            }            
        }
    }
}