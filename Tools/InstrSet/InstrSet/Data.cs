using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace InstrSet
{
    enum POSITIONS
    {
        UNDEFINED = 0,
        IN_KEYWORD = 1,
        IN_DESC,
    }

    public enum KEYWORDTYPE
    {
        FUNCTION = 1,
        KEYWORD = 2,
        OTHER = 3
    }
    public class KeywordDescription
    {
        public KEYWORDTYPE type;    //function, keyword
        public string value; //e.g MoveInstrProcedure or TestReg
        public string value2;  //e.g 1
        public string comment;

        public string ToString()
        {
            return $"{this.type}, {this.value}, {this.value2}, {this.comment}";
        }
    }
}
