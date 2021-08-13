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
using System.IO;
using System.Globalization;

namespace Barfoo.Library
{
    public class PathConfig : PathManage
    {
        #region 01.物理路径
        /// <summary>
        /// 获取Word下某个文件的绝对路径
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static string GetWordFilePath(string filename)
        {
            return GetMapPath("~/Content/Word/", filename);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetWordTempletPath()
        {
            return GetMapPath("~/Content/Word/", "WordTemplet.doc");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetOutPutWordPath()
        {
            return GetMapPath("~/Content/Word/", DateTime.Now.ToString("yyyyMMddHHmmss") + ".doc");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetOutExcelPath()
        {
            return GetMapPath("~/Content/Excel/", "Templet.xls");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetXMLPath()
        {
            return GetMapPath("~/XMLFiles/", "WebConfig.xml");
        }
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetXMLPath(string filename)
        {
            return GetMapPath("~/Content/XMLFiles/", filename);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GetUploadFile()
        {
            string path = GetMapPath("~/Content/UploadFile");
            return path;
        }

        /// <summary>
        /// 生成年月日时分秒文件名
        /// </summary>
        /// <returns></returns>
        public static string GetFileName(string fileExt)
        {
            Random ran = new Random();
            string strRan = Convert.ToString(ran.Next(100, 999));//生成三位随机数 
            return string.Format("{0}{1}.{2}", DateTime.Now.ToString("yyyyMMddHHmmssffff", DateTimeFormatInfo.InvariantInfo), strRan, fileExt);
        }

        /// <summary>
        /// 创建目录
        /// </summary>
        /// <param name="path"></param>
        public static void CreateDirectory(string path)
        {
            if (!Directory.Exists(path))
                Directory.CreateDirectory(path);
        }
        #endregion
    }
}
