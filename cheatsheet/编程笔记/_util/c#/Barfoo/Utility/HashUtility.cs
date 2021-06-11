using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;
using System.Security.Cryptography;
using Barfoo.Library.Text;
namespace Barfoo.Library.Utility
{
    /// <summary>
    /// 哈希辅助类
    /// </summary>
    public static class HashUtility
    {
        /// <summary>
        /// 获取哈希码
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static byte[] ComputeHash(byte[] data)
        {
            using (var hasher = MD5.Create())
            {
                return hasher.ComputeHash(data);
            }
        }

        /// <summary>
        /// 获取哈希码
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        public static string Hash(byte[] data)
        {
            return ComputeHash(data).ToHexString();
        }

        /// <summary>
        /// 获取哈希码
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string Hash(string s)
        {
            return Hash(Encoding.UTF8.GetBytes(s));
        }
    }
}
