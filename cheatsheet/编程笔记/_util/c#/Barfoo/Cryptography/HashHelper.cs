/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  HashHelper 哈希帮助类
创建日期：  2012-4-29
作者：      王波
内容摘要： 
*/


using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using System.IO;

namespace Barfoo.Library.Cryptography
{
    public class HashHelper
    {
        #region Constructor
        //使用的哈希算法
        HashAlgorithm hasher;
        //ToString格式
        string toStringFormat = "X2";
        //编码格式
        Encoding encoder = Encoding.UTF8;
        //true转换为小写字符串返回
        bool toLowerReturn = false;
        #endregion

        #region Constructor

        public HashHelper(HashAlgorithm hasher)
            : this(hasher, Encoding.UTF8, true)
        {

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="hasher"></param>
        /// <param name="encoder"></param>
        /// <param name="toLowerReturn">true转化为小写Hash输出</param>
        public HashHelper(HashAlgorithm hasher, Encoding encoder, bool toLowerReturn)
        {
            this.hasher = hasher;
            this.encoder = encoder;
            this.toLowerReturn = toLowerReturn;
        }
        #endregion

        #region Private Method

        #endregion

        #region Public Method

        public string HashByteArrayToString(byte[] data)
        {
            var sb = new StringBuilder();
            try
            {
                var hash = this.hasher.ComputeHash(data); // 高并发时会抛异常(System.ObjectDisposedException: 已关闭 Safe handle)
                for (int i = 0; i < hash.Length; i++)
                {
                    sb.Append(hash[i].ToString(toStringFormat));
                }
            }
            catch { }
            return sb.ToString();
        }

        public byte[] StringToByteArray(string s)
        {
            var data = encoder.GetBytes(s);
            return data;
        }

        /// <summary>
        /// 获取Hash字符串
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public string Hash(string s)
        {
            var byteArray = StringToByteArray(s);
            string hashCode = HashByteArrayToString(byteArray);
            if (toLowerReturn)
            {
                return hashCode.ToLower();
            }
            return hashCode;
        }





        /// <summary>
        /// 获取文件哈希码
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public string HashFile(string filename)
        {
            return HashByteArrayToString(File.ReadAllBytes(filename));
        }

        /// <summary>
        /// 校验哈希码
        /// </summary>
        public bool Verify(string s, string hash)
        {
            string hashOfInput = Hash(s);
            return StringComparer.OrdinalIgnoreCase.Compare(hashOfInput, hash) == 0;
        }
        #endregion

    }
}
