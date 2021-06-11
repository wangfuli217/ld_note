/*
版权所有：  邦富软件版权所有(C)
系统名称：  工作平台
模块名称：  获取路径
创建日期：  2012-9-21
作者：      唐珊珊
内容摘要：  
*/
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace Barfoo.Library
{
    public class PathManage
    {

        #region 01.获取物理驱动路径公用方法
        /// <summary>
        /// 站点的物理路径
        /// </summary>
        public static string GetRootMapPath
        {
            get { return HttpContext.Current.Server.MapPath("~"); }
        }

        /// <summary>
        /// 根据虚似路径获取绝对路径
        /// </summary>
        /// <param name="path">虚似路径如："~/Content/BasicConfigFiles/SerializeFile/"</param>
        /// <returns></returns>
        public static string GetMapPath(string path)
        {
            return HttpContext.Current.Server.MapPath(path);
        }
        /// <summary>
        /// 获取文件的绝对路径
        /// </summary>
        /// <param name="path"></param>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static string GetMapPath(string path, string filename)
        {
            return string.Format("{0}{1}", GetMapPath(path), filename);
        }
        #endregion

        #region 02.获取物理驱动路径公用方法
        /// <summary>
        /// 获取物理驱动器路径
        /// </summary>
        /// <returns></returns>
        public static string GetAppDomainAppPath()
        {
            return System.Web.HttpRuntime.AppDomainAppPath;
        }
        public static string GetAppPath(string path)
        {
            return string.Format("{0}{1}", GetAppDomainAppPath(), path);
        }
        #endregion

    }
}
