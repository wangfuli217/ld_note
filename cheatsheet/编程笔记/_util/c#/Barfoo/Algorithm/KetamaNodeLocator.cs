/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  KetamaNodeLocator 一致性哈希类
创建日期：  2012-4-29
作者：      王波
内容摘要： 
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Security.Cryptography;
using Barfoo.Library.Cryptography;

namespace Barfoo.Library.Algorithm
{

    public class KetamaNodeLocator
    {
        private SortedList<long, string> ketamaNodes = new SortedList<long, string>();
        private HashAlgorithm hashAlg = MD5.Create();
        private int numReps = 160;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="digest"></param>
        /// <param name="nTime"></param>
        /// <returns></returns>
        public long ByteArrayToInt64(byte[] digest, int nTime)
        {
            long rv = ((long)(digest[3 + nTime * 4] & 0xFF) << 24)
                   | ((long)(digest[2 + nTime * 4] & 0xFF) << 16)
                       | ((long)(digest[1 + nTime * 4] & 0xFF) << 8)
                       | ((long)digest[0 + nTime * 4] & 0xFF);
            return rv & 0xffffffffL;
        }

        public KetamaNodeLocator(List<string> nodes, int nodeCopies)
        {
            ketamaNodes = new SortedList<long, string>();
            numReps = nodeCopies;
            //为每个节点生成nodeCopies个虚拟节点
            foreach (string node in nodes)
            {
                //每四个虚拟结点为一组
                int numRepTimes = numReps / 4;
                for (int i = 0; i < numRepTimes; i++)
                {
                    byte[] digest = new HashHelper(hashAlg).StringToByteArray(node + i);
                    /** Md5是一个16字节长度的数组，将16字节的数组每四个字节一组，分别对应一个虚拟结点，这就是为什么上面把虚拟结点四个划分一组的原因*/
                    for (int h = 0; h < 4; h++)
                    {
                        long m = ByteArrayToInt64(digest, h);
                        ketamaNodes[m] = node;
                    }
                }
            }
        }

        //
        public string GetPrimary(string k)
        {
            byte[] digest = new HashHelper(hashAlg).StringToByteArray(k);
            string rv = GetNodeForKey(ByteArrayToInt64(digest, 0));
            return rv;
        }

        string GetNodeForKey(long hash)
        {
            string rv;
            long key = hash;
            //如果找到这个节点，直接取节点，返回 
            if (!ketamaNodes.ContainsKey(key))
            {
                //得到大于当前key的那个子Map，然后从中取出第一个key，就是大于且离它最近的那个key
                var tailMap = from coll in ketamaNodes
                              where coll.Key > key
                              select new { coll.Key };
                if (tailMap == null || tailMap.Count() == 0)
                {
                    key = ketamaNodes.FirstOrDefault().Key;
                }
                else
                {
                    key = tailMap.FirstOrDefault().Key;
                }
            }
            rv = ketamaNodes[key];
            return rv;
        }
    }
}
