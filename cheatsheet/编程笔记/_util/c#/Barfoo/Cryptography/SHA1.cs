/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  SHA1 
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/


using System;
using System.IO;
using System.Text;
using System.Security.Cryptography;

namespace Barfoo.Library.Cryptography
{
    /// <summary>
    /// SHA1 哈希辅助类
    /// </summary>
    public static class SHA1Heper
    {

        //static HashAlgorithm algorithm = SHA1.Create();
        //static Encoding encoder = Encoding.UTF8;
        //static bool toLowerReturn = false;
        static HashHelper helper = new HashHelper(SHA1.Create());

        /// <summary>
        /// 获取哈希码
        /// </summary>
        public static string Hash(byte[] data)
        {
            return helper.HashByteArrayToString(data);
        }

        /// <summary>
        /// 获取哈希码
        /// </summary>
        public static string Hash(string s)
        {
            return helper.Hash(s);
        }

        /// <summary>
        /// 获取文件哈希码
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static string HashFile(string filename)
        {
            return helper.HashFile(filename);
        }

        /// <summary>
        /// 校验哈希码
        /// </summary>
        public static bool Verify(string s, string hash)
        {
            return helper.Verify(s, hash);
        }

    }
}
