using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;



namespace Barfoo.Library.Text
{
    public static class StringUtility
    {
        /// <summary>
        /// 将字节数组转换为十六进制字符串
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static string ToHexString(this byte[] data)
        {
            var sb = new StringBuilder();
            for (int i = 0; i < data.Length; i++)
            {
                sb.Append(data[i].ToString("X2"));
            }

            return sb.ToString();
        }

        public static string RandomString(int size)
        {
            int number;
            char code;
            string randomStr = String.Empty;

            System.Random random = new Random();

            for (int i = 0; i < size; i++)
            {
                number = random.Next();

                if (number % 2 == 0)
                    code = (char)('0' + (char)(number % 10));
                else
                    code = (char)('A' + (char)(number % 26));

                randomStr += code.ToString();
            }
            return randomStr;
        }

        #region 将HTML标签转换
        /// <summary>
        /// 将HTML标签转换
        /// </summary>
        /// <param name="html"></param>
        public static string EscapeHtml(string html)
        {
            html = html.Replace("&amp;", "&");
            html = html.Replace("\\\\", "\\");
            html = html.Replace("\"", "\\\"");
            html = html.Replace("&lt;", "<");
            html = html.Replace("&gt;", ">");
            return html;
        }
        #endregion

        

    }
}
