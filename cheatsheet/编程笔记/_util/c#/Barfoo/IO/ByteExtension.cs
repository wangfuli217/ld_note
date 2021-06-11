/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  ByteExtension 字节数组扩展类
创建日期：  2010-2-1
作者：      谭恒亮
内容摘要： 
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Barfoo.Library.IO
{
    public static class ByteExtension
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
    }
}
