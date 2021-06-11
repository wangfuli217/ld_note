using System;
//using System.Text;
//using System.Runtime.InteropServices;

using Microsoft.VisualBasic;

namespace Barfoo.Library.Text
{

    #region Win32 API method(commented)
    /*
    public enum ConvertType { Simplified, Traditional }

    public class Converter
    {
        private static readonly int LCMAP_SIMPLIFIED_CHINESE = 0x02000000;
        private static readonly int LCMAP_TRADITIONAL_CHINESE = 0x04000000;

        [DllImport("kernel32.dll", EntryPoint = "LCMapStringA")]
        public static extern int LCMapString(int Locale, int dwMapFlags, byte[] lpSrcStr, int cchSrc, byte[] lpDestStr, int cchDest);

        private static readonly Encoding encode = Encoding.GetEncoding("gb2312");

        /// <summary>
        /// 简/繁体转换
        /// </summary>
        /// <param name="text"></param>
        /// <param name="type"></param>
        /// <returns></returns>
        public static string Convert(string text, ConvertType type)
        {
            byte[] buffer = encode.GetBytes(text);
            byte[] bufSize = new byte[buffer.Length];
            switch (type)
            {
                case ConvertType.Simplified: LCMapString(0x0804, LCMAP_SIMPLIFIED_CHINESE, buffer, -1, bufSize, buffer.Length); break;
                case ConvertType.Traditional: LCMapString(0x0804, LCMAP_TRADITIONAL_CHINESE, buffer, -1, bufSize, buffer.Length); break;
            }
            return encode.GetString(bufSize);
        }
    }
    */
    #endregion

    /// <summary>
    /// 简体/繁体转换类(simplified/traditional converter)
    /// </summary>
    public static class ChineseConverter
    {
        /// <summary>
        /// 简体 -> 繁体
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string Simp2Trad(string text)
        {
            return Strings.StrConv(text, VbStrConv.TraditionalChinese, 0);
        }

        /// <summary>
        /// 繁体 -> 简体
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string Trad2Simp(string text)
        {
            return Strings.StrConv(text, VbStrConv.SimplifiedChinese, 0);
        }
    }
}