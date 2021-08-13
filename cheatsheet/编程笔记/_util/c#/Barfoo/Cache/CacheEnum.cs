/*
版权所有：  邦富软件版权所有(C)
系统名称：  舆情系统
模块名称：  缓存管理类
创建日期：  2012-2-8
作者：      刘付春彬
内容摘要： 
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Barfoo.Library.Cache
{
    public enum CacheType
    {
        /// <summary>
        /// 不用缓存
        /// </summary>
        None,
        /// <summary>
        /// 
        /// </summary>
        Session,

        /// <summary>
        /// 
        /// </summary>
        Cache,

        /// <summary>
        /// 
        /// </summary>
        Memcached,

        /// <summary>
        /// 
        /// </summary>
        File,

        /// <summary>
        /// 
        /// </summary>
        Redis
    }

    public enum TimeOutType
    {
        /// <summary>
        /// 绝对过期
        /// </summary>
        Sliding,
        /// <summary>
       /// 相对过期
        /// </summary>
        Absolute
    }
}
