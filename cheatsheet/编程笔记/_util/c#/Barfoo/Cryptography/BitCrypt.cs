/*
版权所有：邦富软件版权所有(C)
系统名称：加密
模块名称：
创建日期：2012-9-25
作　　者：王波
内容摘要：蕾舟的临时加密解密方法
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Barfoo.Library.Cryptography
{
    public class BitCrypt
    {
        //加密
        public static string StringToDataString(string source)
        {
            var data = Encoding.UTF8.GetBytes(source);
            var cp = BitConverter.ToString(data).Replace("-", "");
            return cp;
        }

        //解密
        public static string DataStringToString(string source)
        {
            List<byte> bs = new List<byte>();
            for (int i = 0; i < source.Length; i += 2)
            {
                string part = source.Substring(i, 2);
                bs.Add(byte.Parse(part, System.Globalization.NumberStyles.HexNumber));
            }
            var target = Encoding.UTF8.GetString(bs.ToArray());
            return target;
        }
    }
}
