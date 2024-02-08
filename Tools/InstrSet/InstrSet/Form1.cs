using Crc;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.OleDb;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace InstrSet
{

    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnProcess_Click(object sender, EventArgs e)
        {
           
        }

        private void btnProcess_Click_1(object sender, EventArgs e)
        {
          
        }

        private string FormatHandlerData(string s)
        {
            string str = "";
            var split = s.Split(',');
            UInt32 dummy;
            foreach (var item in split)
            {
                if (item.Length > 2 && item.Substring(0, 2).ToLower() == "0x")
                {
                    str += $"{item} ";  //We are using the 0x convention
                } else if ( UInt32.TryParse(item.Substring(0, 1), out dummy))   //If it starts with a number
                {
                    if (item.Substring(item.Length - 1, 1).ToLower() == "h")    //If it starts with a number but ends with h, its hexadecimal
                        str += $"0x{item.Substring(0, item.Length - 1)} ";  //Convert to 0x convention
                    else
                        str += $"{item} ";  //Otherwise store it as it is. Its either a number or something strange :)
                } else
                {
                    str += $"{item} ";  //Probably not a number or it represents a constant, store it as it is
                }
                 
            }

            return str.Trim();
        }

        List<string[]> existingHandlers;

        private string[] GetHandlerData(string instr)
        {
            string[] ret = new string[6] {"","","","","","" };
            for (int i =0;i <existingHandlers.Count; i++)
            {
                var handler = existingHandlers[i];
                if (handler[0].ToLower() == instr.ToLower())
                {
                    ret = handler; 
                    break;
                } else
                {
                   // Console.WriteLine($"Missed:{handler[0]} vs {instr}");
                }
            }
            return ret;
        }


        private void btnGatherInstrHandlers_Click(object sender, EventArgs e)
        {

            string csvFile = "C:\\a16\\ALL.csv";
            List<string> existing = new List<string>();
            int nRecords = 0;
            int stage = 0;
            int curLen = 0;
            char curLetter = (char)96;    //a is 97
            StreamWriter writer = new StreamWriter("C:\\a16\\AllNew.csv");
            StreamReader reader = new StreamReader(csvFile);
            StreamReader instrReader = new StreamReader("C:\\a16\\INSTR16.ASM");

            int MAX_LEN = 20;

            existingHandlers = new List<string[]>();

            var s = new string[4];
            int handlerStage = 0;
            while (!instrReader.EndOfStream)
            {
                string ln = instrReader.ReadLine().Trim();

                var handlerName = "";
                var handlerAddress = "";
                List<string> handlerDataType = new List<string>();
                List<string> handlerData = new List<string>();
                while (ln != "")
                {
                    if (ln.Length > 5 && ln.Trim().Substring(0, 5).ToLower() == "even " || ln.Trim() == "")
                    {
                        ln = "";
                        continue;
                    }

                    if (handlerName != "")
                    {
                        existingHandlers.Add(new string[6] { 
                            handlerName, 
                            handlerAddress,

                            handlerDataType.Count > 0 ? handlerDataType[0] : "", 
                            handlerData.Count > 0  ? handlerData[0] : "",

                            handlerDataType.Count > 1  ? handlerDataType[1] : "",
                            handlerData.Count > 1? handlerDataType[1] : "",
                        });

                        handlerName = "";
                        handlerAddress = "";
                        handlerDataType.Clear();
                        handlerData.Clear();
                    }

                    var spc = ln.IndexOf(' ');
                    var colon = ln.IndexOf(":");

                    if (colon != -1)
                    {
                        handlerName = ln.Substring(0, colon).Trim();
                        ln = ln.Substring(colon + 1);
                        handlerStage=1;
                    }
                    else if (spc != -1)
                    {
                        handlerName = ln.Substring(0, spc).Trim();
                        ln = ln.Substring(spc + 1);
                        handlerStage=1;
                    }
                    else
                    {
                        Console.WriteLine($"Error!!! :: {ln}");
                    }

                    Console.WriteLine(handlerName);

                    ln = ln.Trim();
                    while (handlerStage < 10)
                    {
                        while (ln == "" && !instrReader.EndOfStream)    //if we have reached the end of this line, read the next until we have data
                        {
                            ln = instrReader.ReadLine().Trim();    //Read another one and see if it is part of the handler. 
                            if (ln.Length > 5 && ln.Substring(0, 5).ToLower() == "even ") ln = "";
                        }

                        if (instrReader.EndOfStream) break;

                        var strx = ln.Trim().Substring(0, 3);
                        if (strx == "DW ")
                        {
                            if (handlerAddress != "")
                            {

                                handlerDataType.Add("WORD");
                                handlerData.Add( FormatHandlerData(ln.Trim().Substring(3).Trim()));
                                ln = "";
                                //Console.WriteLine("Error. Unexpected data format");
                            }
                            else if (handlerStage == 1)
                            {
                                handlerAddress = ln.Trim().Substring(3).Trim();
                                ln = "";
                            }
                            handlerStage++;
                        }
                        else if (strx == "DB ")
                        {
                            handlerDataType.Add("BYTE");
                            handlerData.Add(FormatHandlerData(ln.Trim().Substring(3).Trim()));
                            ln = "";
                            handlerStage++;
                        } else
                        {
                            break;
                        }

                    }
                }                    

            }

            while (!reader.EndOfStream)
            {
                string ln = reader.ReadLine();
                var items = ln.Split(',');

                UInt32 crc = Crc32.Calc(items[0]);
                string crc32s = crc.ToString("x").PadLeft(8, '0');
                string lowHalfCrc = crc32s.Substring(4);
                string highHalfCrc = crc32s.Substring(0, 4);
                int len = items[0].Trim().Length;

                ln = "";
                for (int i = 0; i < items.Length; i++)
                {
                    items[i] = items[i].Trim();
                    ln += "," + items[i];
                }
                ln = ln.Substring(1);
                if (items.Length > 2 && items[1].Trim() == "FUNCTION")
                {
                    items[2] = items[2].Trim().Trim(new char[2] { '(', ')' });
                    string[] instr = GetHandlerData(items[2]);

                    instr[1] = instr[1].Trim().Trim(new char[2] { '(', ')' });

                    ln = $"{items[0]},{items[1]},{items[2]},{items[3]},{instr[1]},{instr[2]},{instr[3]},{instr[4]},{instr[5]}";
                }
                else
                {
                }
                writer.WriteLine(ln);
            }
            writer.Close();
            reader.Close();
            instrReader.Close();
        }

        private void btnProcessCsv_Click(object sender, EventArgs e)
        {

            string sourceCsv = "C:\\a16\\Src\\Instructions.csv";

            //Sort everything in alphabetic order
             StreamReader sourceReader = new StreamReader(sourceCsv);
            //            StreamWriter writer = new StreamWriter(csvFile);
            List<string> lines = new List<string>();

            while (!sourceReader.EndOfStream)
            {
                string ln = sourceReader.ReadLine().Trim();
                if (ln == "") continue;
                lines.Add(ln);
            }

            lines.Sort();

            List<string> existing = new List<string>();
            int nRecords = 0;
            int stage = 0;
            int curLen = 0;
//            char curLetter = (char)97;    //a is 97

            StreamWriter writer = new StreamWriter("C:\\a16\\CPU16N.ASM");
            StreamWriter writerInstrFile = new StreamWriter("C:\\a16\\INSTR16N.ASM");

            int MAX_LEN = 20;

            string output1 = "";
            string output2 = "";
            string output3 = "";
            string final = "";

            List<string>[] crcLows = new List<string>[MAX_LEN];
            List<string>[] crcHighs = new List<string>[MAX_LEN];
            List<string>[] keywordDesc = new List<string>[MAX_LEN];
            char []curLetter = new char[MAX_LEN];
            int[,] alphaLengths = new int[MAX_LEN, 27];


            for (int c = 0; c < MAX_LEN; c++)
            {
                crcLows[c] = new List<string>();
                crcHighs[c] = new List<string>();
                keywordDesc[c] = new List<string>();
                curLetter[c] = (char)('a' - 1); //Deliberately start with char 96. It will mismatch in the first iteration causing an a to be registered
                for (int d = 0; d < 27; d++)
                    alphaLengths[c, d] = 0;
            }

            List<string> instrTable = new List<string>();


            writerInstrFile.WriteLine("EVEN 2\r\nInstructionsStart:\r\n");
            foreach (string ln in lines)
            {
                //                string ln = reader.ReadLine();
                var items = ln.Split(',');

                UInt32 crc = Crc32.Calc(items[0]);
                string crc32s = crc.ToString("x").PadLeft(8, '0');
                string lowHalfCrc = "0x" + crc32s.Substring(4);
                string highHalfCrc = "0x" + crc32s.Substring(0, 4);
                int len = items[0].Trim().Length;

                while (curLetter[len] != items[0].Trim().Substring(0, 1).ToCharArray()[0])
                {
                    curLetter[len] = (char)(curLetter[len] + 1);    //Since we started with a - 1.. Add before adding it
                    crcLows[len].Add($"Keyword{len}{curLetter[len]}:\r\n");
                }

                Console.WriteLine($"\tDW\t\t{lowHalfCrc}\t;{items[0]} low\r\n");
                crcLows[len].Add($"\tDW\t\t{lowHalfCrc}\t;{items[0]} low\r\n");
                crcHighs[len].Add($"\tDW\t\t{highHalfCrc}\t;{items[0]} high\r\n");

                int pos = curLetter[len] - 97;
                alphaLengths[len, pos + 1]++;   //Increase the offset of next record by 1

                if (items.Length > 2 && items[1].Trim() == "FUNCTION")
                {

                    items[2] = items[2].Trim();
                    if (items[4] == "")
                        items[4] = "(NotCoded)";

                    keywordDesc[len].Add($"\tDW\t\t({items[2]})\t\r\n");

                    var str = $"\r\nEVEN 2\r\n{items[2]}:\r\n\tDW\t\t{items[4]}\r\n";
//                    writerInstrFile.WriteLine( str );
//                    instrTable.Add($"{items[2]}:\r\n\tDW\t\t({items[4]})\r\n");

                    for (int i = 5; i < 8; i += 2) {
                        items[i] = items[i].Trim();
                        if (items[i] == "") continue;

                        string defStatement = "";
                        if (items[i] == "BYTE")
                            defStatement = "DB";
                        else if (items[i] == "WORD")
                            defStatement = "DW";

                        if (defStatement != "")
                        {

                            var data = items[i + 1].Trim().Replace(' ', ',');                            
//                            instrTable.Add($"\t{defStatement}\t\t{data}\r\n");

                            str += $"\t{defStatement}\t\t{data}\r\n";
                        }
                    }

                    //Console.WriteLine($"Func Stuff:: {items[2]} {items[3]}  {items[4]}  {items[5]}  {items[6]}  {items[7]}  {items[8]}");
                    //Console.WriteLine($"Def::");
                    //                    Console.WriteLine(str);

                    if (instrTable.IndexOf(items[2]) == -1)
                    {
                        instrTable.Add(items[2]);
                        writerInstrFile.WriteLine(str);
                    }
                    else
                        Console.WriteLine(items[2] + " already exists");

                }
                else if (items.Length > 3)
                {
                    keywordDesc[len].Add($"\tDB\t\t{items[2]}, {items[3]}\t\r\n");
                }
            }

            final = "";

            for (int i = 0; i < MAX_LEN; i++)
            {

                string outputPre = $"EVEN 2\r\nKeyword{i}:\r\n\tDW\t";
                int ofs = 0;
                string offsets = "";
                for (int j = 0; j < 27; j++)
                {
                    offsets += $",{(ofs + alphaLengths[i, j]).ToString().PadLeft(3, '0')}";
                    ofs += alphaLengths[i, j];
                }
                outputPre += $"{offsets.Substring(1)}\r\n\tDW\tKeyword{i}High, Keyword{i}Desc\r\n";
                outputPre = outputPre.Substring(0, outputPre.Length - 1);

                string crcLowOut = "";
                string crcHighOut = "";
                string keywordDescOut = "";

                var cll = crcLows[i];
                var chh = crcHighs[i];
                var kdd = keywordDesc[i];
                for (int x = 0, y = 0; x < cll.Count; x++)
                {

                    crcLowOut += cll[x];
                    Console.WriteLine(cll[x] + " ....");

                    if (cll[x].Contains(":")) continue;

                    if (chh.Count > y)
                    {
                        crcHighOut += chh[y];
                        Console.WriteLine(chh[y] + " ... ");
                    }

                    if (kdd.Count > y)
                    {
                        keywordDescOut += kdd[y];
                        Console.WriteLine(kdd[y]);
                    }
                    y++;

                }
                final += outputPre + "\r\n\r\n" + crcLowOut + "\r\n\r\n" + $"Keyword{i}High:\r\n" + crcHighOut.ToString() + "\r\n\r\n" + $"Keyword{i}Desc:\r\n" + keywordDescOut;

            }

            if (final != "")
            {
                writer.WriteLine(final);
            }

            writerInstrFile.WriteLine("\r\nInstructionsEnd:\r\n");

            sourceReader.Close();
            writer.Close();
            writerInstrFile.Close();
            //            reader.Close();
        }

        private void btnConvertToCsv_Click(object sender, EventArgs e)
        {
            string cpuFile = "C:\\a16\\CPU16.RAW";

            StreamWriter writer = new StreamWriter("C:\\a16\\CPU16.csv");
            StreamReader reader = new StreamReader(cpuFile);

            List<string> keywords = new List<string>();
            List<KeywordDescription> description = new List<KeywordDescription>();

            POSITIONS pos = POSITIONS.UNDEFINED;
            while (!reader.EndOfStream)
            {
                string ln = reader.ReadLine().Trim();
                string comment = "";
                int commentPos = ln.IndexOf(";");
                if (commentPos != -1)
                {
                    comment = ln.Substring(commentPos + 1);
                    ln = ln.Substring(0, commentPos);   //remove comments                    
                }

                if (ln == "")
                    continue;
                if (ln.Length >= 4 && ln.Trim().Substring(0, 4).ToLower() == "even") //Ignore where we put the EVEN statement
                    continue;
                else if (ln.Length >= 3 && ln.Substring(0, 3).ToLower() == "db " && ln.Substring(3).Trim() == "0") //If we have DB followed by 0
                    continue;
                else if (ln.Length >= 3 && ln.Substring(0, 3).ToLower() == "db " && ln.Substring(3).Trim().Substring(0, 1) == "\"") //If we have DB followed by a quote
                {
                    string keyw = ln.Substring(3).Trim().Replace("\"", "");
                    keywords.Add(keyw);
                }
                else if (ln.Length > 7 && ln.Substring(0, 7) == "Keyword" && ln.Substring(ln.Length - 1, 1) == ":")
                {
                    if (ln.Substring(ln.Length - 5) == "desc:")
                    {
                        pos = POSITIONS.IN_DESC;
                    }
                    else
                    {
                        pos = POSITIONS.IN_KEYWORD;
                    }
                }
                else if (pos == POSITIONS.IN_DESC && ln.Length >= 3) //If we have DB followed by a quote
                {
                    KeywordDescription kd = new KeywordDescription();

                    string sv = ln.Substring(0, 3);
                    if (sv == "dw ")
                    {
                        string desc = ln.Substring(3).Trim();
                        kd.type = KEYWORDTYPE.FUNCTION;
                        kd.value = desc;
                        kd.value2 = "Function description";
                        kd.comment = comment;
                    }
                    else if (sv == "db ")
                    {
                        var values = ln.Substring(3).Trim().Split(',');
                        if (values.Length == 2)
                        {
                            kd.type = KEYWORDTYPE.KEYWORD;
                            kd.value = values[0].Trim();
                            kd.value2 = values[1].Trim();
                            kd.comment = comment;
                        }
                        else
                        {
                            kd.type = KEYWORDTYPE.OTHER;
                            kd.value = "Error";
                            kd.value2 = "Error";
                            kd.comment = ln;
                        }
                    }
                    else
                    {
                        kd.type = KEYWORDTYPE.OTHER;
                        kd.value = "Error2";
                        kd.value2 = "Error2";
                        kd.comment = ln;

                    }


                    description.Add(kd);
                }
                else
                {
                    Console.WriteLine($"Dont know : ({ln})");
                }

            }


            Console.WriteLine($"NumKw: {keywords.Count} NumDesc:{description.Count}");
            for (int i = 0; i < keywords.Count; i++)
            {
                writer.WriteLine($"{keywords[i].ToString()}, {description[i].ToString()}");
                Console.WriteLine($"{keywords[i].ToString()}, {description[i].ToString()}");
            }

            writer.Close();
            reader.Close();
        }
    }
}
