using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CopyCat.Models
{
    // a class to represent a table in a database
    [Serializable]
    public class Table
    {
        String _name;

        public String Name
        {
            get { return _name; }
            set { _name = value; }
        }

        List<Column> _columns;

        public List<Column> Columns
        {
            get { return _columns; }
            set { _columns = value; }
        }

        List<String> _rows;

        public List<String> Rows
        {
            get { return _rows; }
            set { _rows = value; }
        }

        private Boolean _isMissing;

        public Boolean IsMissing
        {
            get { return _isMissing; }
            set { _isMissing = value; }
        }

        public Table()
        {
            Columns = new List<Column>();
            Name = null;
            Rows = new List<String>();
        }
    }
}