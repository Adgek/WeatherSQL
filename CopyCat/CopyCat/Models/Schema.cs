using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CopyCat.Models
{
    // a class that represents a database schema
    [Serializable]
    public class Schema
    {
        String _name;

        public String Name
        {
            get { return _name; }
            set { _name = value; }
        }

        List<Table> _tables;

        public List<Table> Tables
        {
            get { return _tables; }
            set { _tables = value; }
        }

        public Schema()
        {
            Name = null;
            Tables = new List<Table>();
        }
    }
}