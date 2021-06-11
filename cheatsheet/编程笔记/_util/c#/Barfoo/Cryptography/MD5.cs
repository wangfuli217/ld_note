/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  MD5 
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
    /// MD5 哈希辅助类
    /// </summary>
    public static class MD5Helper
    {
        static HashAlgorithm algorithm = MD5.Create();


        /// <summary>
        /// 获取哈希码
        /// </summary>
        public static string Md5Hash(this string s)
        {
            HashHelper helper = new HashHelper(algorithm);
            return helper.Hash(s);
        }

        /// <summary>
        /// 获取哈希码
        /// </summary>
        public static string Md5Hash(this string s, bool toLowerReturn)
        {
            HashHelper helper = new HashHelper(algorithm, Encoding.UTF8, toLowerReturn);
            return helper.Hash(s);
        }

        /// <summary>
        /// 获取哈希码
        /// </summary>
        public static string Md5HashToLower(this string s)
        {
            HashHelper helper = new HashHelper(algorithm, Encoding.UTF8, true);
            return helper.Hash(s);
        }

        /// <summary>
        /// 获取文件哈希码
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="toLowerReturn"></param>
        /// <returns></returns>
        public static string HashFile(string filename)
        {
            HashHelper helper = new HashHelper(algorithm);
            return helper.HashFile(filename);
        }

        /// <summary>
        /// 校验哈希码
        /// </summary>
        /// <param name="s"></param>
        /// <param name="hash"></param>
        /// <param name="toLowerReturn"></param>
        /// <returns></returns>
        public static bool Verify(this string s, string hash, bool toLowerReturn)
        {
            HashHelper helper = new HashHelper(algorithm);
            string hashOfInput = helper.Hash(s);
            return StringComparer.OrdinalIgnoreCase.Compare(hashOfInput, hash) == 0;
        }

        /// <summary>
        /// 利用MD5算法生成字符串的散列值(compute hash value from text with MD5 algorithm)
        /// </summary>
        /// <param name="text"></param>
        /// <param name="encode">默认gb2312</param>
        /// <returns></returns>
        public static Guid ConvertToGuid(string text, Encoding encode)
        {
            Guid md5Hash = Guid.Empty;
            try
            {
                HashHelper helper = new HashHelper(algorithm, encode, false);
                byte[] md5Bytes = helper.StringToByteArray(text);
                md5Hash = new Guid(md5Bytes);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return md5Hash;
        }

        /// <summary>
        /// 利用MD5算法生成字符串的散列值(compute hash value from text with MD5 algorithm)
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static Guid ConvertToGuid(string text)
        {
            return ConvertToGuid(text, Encoding.GetEncoding("gb2312"));
        }

        /// <summary>
        /// 利用MD5算法生成字符串的散列值(compute hash value from text with MD5 algorithm)
        /// </summary>
        /// <param name="text"></param>
        /// <param name="encoding"></param>
        /// <returns></returns>
        public static Guid Convert(string text, Encoding encoding)
        {
            MD5CryptoServiceProvider md5 = new MD5CryptoServiceProvider();
            try
            {
                byte[] bytes = md5.ComputeHash(encoding.GetBytes(text));
                //string md5Str = BitConverter.ToString(bytes).Replace("-", "");
                return new Guid(bytes);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
            return Guid.Empty;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static string Convert(string text)
        {
            Guid guid = Convert(text, Encoding.UTF8);
            return guid.ToString().Replace("-", "");
        }
    }
}
