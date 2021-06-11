/**
 * <P> Title: 工具类                        </P>
 * <P> Description: 工具类                  </P>
 * <P> Copyright: Copyright (c) 2011-05-14  </P>
 * <P> Company:ZhongKu Tech. Ltd.           </P>
 * @author <A href="daillow@gmail.com">Holer</A>
 */
using System;
using System.Collections;
using System.Configuration;
using System.IO;
using System.Text;

namespace Com.Util
{
    public class LogUtil
    {
        // 是否第一次启动项目
        private static bool isFirst = true;
        // log 路径(前面会加上项目的绝对路径，路径写法如：<add key="log_file" value="log"/>，首目录可写 value=".")
        private static string logPath = HttpContext.Current.Request.PhysicalApplicationPath + "/" + ConfigurationManager.AppSettings["log_file"];

        /// <summary>
        /// 创建文件; 如果文件已经存在,则覆盖旧档
        /// </summary>
        /// <param name="strMsg">需要写入的数据</param>
        public static void log(string strMsg)
        {
            // 时间
            string now = "[" + DateTime.Now.ToString(@"HH:mm:ss") + "]: ";
            // log 记录
            string logFile = logPath + "/" + DateTime.Now.ToString(@"yyyy_MM_dd") + ".log";
            FileUtil.WriteFile(logFile, now + strMsg, isFirst);
            isFirst = false;
        }

    }
}
