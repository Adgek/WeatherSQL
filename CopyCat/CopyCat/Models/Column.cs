using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CopyCat.Models
{
    // a class that represents a column in a database
    [Serializable]
    public class Column
    {
        private String _name;

        public String Name
        {
            get { return _name; }
            set { _name = value; }
        }

        private String _datatype;

        public String Datatype
        {
            get { return _datatype; }
            set { _datatype = value; }
        }

        private String _size;

        public String Size
        {
            get { return _size; }
            set { _size = value; }
        }

        private Boolean _isNullable;

        public Boolean IsNullable
        {
            get { return _isNullable; }
            set { _isNullable = value; }
        }

        private Boolean _isPK;

        public Boolean IsPK
        {
            get { return _isPK; }
            set { _isPK = value; }
        }

        private Boolean _isUnique;

        public Boolean IsUnique
        {
            get { return _isUnique; }
            set { _isUnique = value; }
        }

        private Boolean _isIdentity;

        public Boolean IsIdentity
        {
            get { return _isIdentity; }
            set { _isIdentity = value; }
        }

        private Boolean _isFK;

        public Boolean IsFK
        {
            get { return _isFK; }
            set { _isFK = value; }
        }

        private String _fktref;

        public String Fktref
        {
            get { return _fktref; }
            set { _fktref = value; }
        }

        private String _fkcref;

        public String Fkcref
        {
            get { return _fkcref; }
            set { _fkcref = value; }
        }

        public Column()
        {
            Name = null;
            Datatype = null;
        }
    }
}