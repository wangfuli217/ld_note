using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;
using System.Runtime.InteropServices;
using Microsoft.VisualBasic.CompilerServices;
using AlgoXTEA;
using Microsoft.VisualBasic;

namespace Barfoo.Library.Cryptography
{
    public class XTea
    { 
        [DllImport("algoXtea.dll", CharSet = CharSet.Unicode, SetLastError = true, ExactSpelling = true)]
        public static extern void code(ref uint[] v, uint[] k);
        [DllImport("algoXtea.dll", CharSet = CharSet.Unicode, SetLastError = true, ExactSpelling = true)]
        public static extern void decode(ref uint[] v, uint[] k);
        /// <summary>
        ///解密
        /// </summary>
        /// <param name="Data">要解密的字符串</param>
        /// <param name="key">Key密钥</param>
        /// <returns></returns>
        public string decrypt(string Data, string key)
        {
            try
            {
                uint[] k = FormatKey(key);
                int index = 0;
                uint[] v = new uint[3];
                byte[] bytes = new byte[(Data.Length / 2) + 1];
                algo algo = new algo();
                int num6 = Data.Length - 1;
                for (int i = 0; i <= num6; i += 0x10)
                {
                    v[0] = Util.ConvertHexStringToUint(Data.Substring(i, 8));
                    v[1] = Util.ConvertHexStringToUint(Data.Substring(i + 8, 8));
                    algo.decode(v, k);
                    int num4 = 0;
                    do
                    {
                        bytes[index] = BitConverter.GetBytes(v[0])[num4];
                        index++;
                        num4++;
                    }
                    while (num4 <= 3);
                    int num5 = 0;
                    do
                    {
                        bytes[index] = BitConverter.GetBytes(v[1])[num5];
                        index++;
                        num5++;
                    }
                    while (num5 <= 3);
                }
                string str = Encoding.Unicode.GetString(bytes, 0, bytes.Length);
                int num = str.Length - 1;
                char[] chArray = str.ToCharArray();
                while (chArray[num] == '\0')
                {
                    num--;
                }
                return str.Substring(0, num + 1);
            }
            catch (Exception ex)
            {
                return "解密失败:"+ex.Message;
            }


        }
        /// <summary>
        /// 要加密
        /// </summary>
        /// <param name="Data">要加密的字符串</param>
        /// <param name="key">密钥</param>
        /// <returns></returns>
        public string encrypt(string Data, string key)
        {
            try
            {
                if (Data.Length == 0)
                {
                    throw new ArgumentException("Data must be at least 1 characater in length.");
                }
                uint[] k = FormatKey(key);
                if ((Data.Length % 8) != 0)
                {
                    int num6 = (8 - (Data.Length % 8)) - 1;
                    for (int j = 0; j <= num6; j++)
                    {
                        Data = Data + "\0";
                    }
                }
                //增加的
                else
                {
                    for (int j = 0; j <= 7; j++)
                    {
                        Data = Data + "\0";
                    }
                }
                ArrayList list = new ArrayList(Data.Length);
                list.AddRange(Encoding.Unicode.GetBytes(Data));
                string str = "";
                uint[] v = new uint[3];
                byte[] buffer = new byte[5];
                int num5 = list.Count - 1;
                for (int i = 0; i <= num5; i += 8)
                {
                    int index = 0;
                    do
                    {
                        buffer[index] = ByteType.FromObject(list[i + index]);
                        index++;
                    }
                    while (index <= 3);
                    v[0] = BitConverter.ToUInt32(buffer, 0);
                    int num4 = 0;
                    do
                    {
                        buffer[num4] = ByteType.FromObject(list[(i + 4) + num4]);
                        num4++;
                    }
                    while (num4 <= 3);
                    v[1] = BitConverter.ToUInt32(buffer, 0);
                    algo algo = new algo();
                    algo.code(v, k);
                    str = str + Util.ConvertUintToHexString(v[0]) + Util.ConvertUintToHexString(v[1]);
                }
                return str.ToString();
            }
            catch (Exception ex)
            { 
                return "加密失败："+ex.Message;
            }

        }

        public static uint[] FormatKey(string key)
        {
            try
            {
                if ((key.Length <= 0) | (key.Length > 0x10))
                {
                    throw new ArgumentException("Key must be between 1 and 16 characters in length.");
                }
                key = key.PadRight(0x10, '\0').Substring(0, 0x10);
                uint[] numArray2 = new uint[5];
                int index = 0;
                int num3 = key.Length - 1;
                for (int i = 0; i <= num3; i += 4)
                {
                    numArray2[index] = Util.ConvertStringToUint(key.Substring(i, 4));
                    index++;
                }
                return numArray2;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

    }

    public class Util
    {
        public static uint ConvertHexStringToUint(string input)
        {
            try
            {
                byte[] buffer = new byte[5];
                if (input.Length != 8)
                {
                    throw new ArgumentException("Input hexadecimal number must be 8 in length.");
                }
                int startIndex = 0;
                do
                {
                    buffer[startIndex / 2] = Convert.ToByte(input.Substring(startIndex, 2), 0x10);
                    startIndex += 2;
                }
                while (startIndex <= 7);
                return BitConverter.ToUInt32(buffer, 0);
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static uint ConvertStringToUint(string input)
        {
            try
            {
                if (input.Length != 4)
                {
                    throw new Exception("String length must be 4 in order to be converted!");
                }
                byte[] buffer = new byte[5];
                char[] chArray = new char[5];
                chArray = input.ToCharArray();
                int index = 0;
                do
                {
                    buffer[index] = Convert.ToByte(chArray[index]);
                    index++;
                }
                while (index <= 3);
                return BitConverter.ToUInt32(buffer, 0);
            }
            catch (Exception ex)
            {
                throw ex;
            }
             
        }

        public static string ConvertUintToHexString(uint input)
        {
            try
            {
                string str2 = "";
                byte[] bytes = new byte[5];
                bytes = BitConverter.GetBytes(input);
                int index = 0;
                do
                {
                    if (bytes[index] < 0x10)
                    {
                        str2 = str2 + "0";
                    }
                    str2 = str2 + Conversion.Hex(bytes[index]);
                    index++;
                }
                while (index <= 3);
                return str2;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static string ConvertUintToString(uint input)
        {
            try
            {
                byte[] bytes = new byte[5];
                bytes = BitConverter.GetBytes(input);
                StringBuilder builder = new StringBuilder();
                int index = 0;
                do
                {
                    builder.Append(Convert.ToChar(bytes[index]));
                    index++;
                }
                while (index <= 3);
                return builder.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}
