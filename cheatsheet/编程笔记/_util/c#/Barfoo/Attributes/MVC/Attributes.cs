/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  NoClientCacheAttribute 配置文件资源类
创建日期：  2011-9-6
作者：      李旭日
内容摘要： 
*/

using System.Web;
using System.Web.Mvc;
using System.IO.Compression;

namespace Barfoo.Library.Mvc
{
    /// <summary>
    /// 设置资源为非客户端缓存
    /// </summary>
	public class NoClientCacheAttribute : ActionFilterAttribute
	{
		public override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			HttpContext.Current.Response.CacheControl = "No-Cache";
		}
	}

    /// <summary>
    /// 压缩属性
    /// </summary>
    public class CompressAttribute : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            var acceptEncoding = filterContext.HttpContext.Request.Headers["Accept-Encoding"];
            if (!string.IsNullOrEmpty(acceptEncoding))
            {
                acceptEncoding = acceptEncoding.ToLower();
                var response = filterContext.HttpContext.Response;

                if (acceptEncoding.Contains("gzip"))
                {
                    response.AppendHeader("Content-encoding", "gzip");
                    response.Filter = new GZipStream(response.Filter, CompressionMode.Compress);
                }
                else if (acceptEncoding.Contains("deflate"))
                {
                    response.AppendHeader("Content-encoding", "deflate");
                    response.Filter = new DeflateStream(response.Filter, CompressionMode.Compress);
                }
            }
        }
    }
}
