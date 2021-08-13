using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NLog;

namespace Barfoo.Library.IO
{
    enum LogType { Info, Warn, Trace, Error, Debug, Fatal };

    /// <summary>
    /// NLog封装类。
    /// 专门用于写文件日志，自带日志分组、限制日志大小等功能，使用时需带上Nlog.config文件
    /// </summary>
    public static class NlogHelper
    {


        private static readonly Logger log = LogManager.GetLogger("BarfooLogger");

        public static void Info(string Message, params object[] objs)
        {
            WriteLog(LogType.Info, Message, objs);
        }

        public static void Warn(string Message, params object[] objs)
        {
            WriteLog(LogType.Warn, Message, objs);
        }

        public static void Trace(string Message, params object[] objs)
        {
            WriteLog(LogType.Trace, Message, objs);
        }

        public static void Error(string Message, params object[] objs)
        {
            WriteLog(LogType.Error, Message, objs);
        }

        public static void Debug(string Message, params object[] objs)
        {
            WriteLog(LogType.Debug, Message, objs);
        }

        public static void Fatal(string Message, params object[] objs)
        {
            WriteLog(LogType.Fatal, Message, objs);
        }

        static void WriteLog(LogType ltype, string Message, params object[] objs)
        {
            var msg = (objs != null && objs.Length != 0) ? string.Format(Message, objs) : Message;
            switch (ltype)
            {
                case LogType.Info:
                    log.Info(msg);
                    break;
                case LogType.Warn:
                    log.Warn(msg);
                    break;
                case LogType.Trace:
                    log.Trace(msg);
                    break;
                case LogType.Error:
                    log.Error(msg);
                    break;
                case LogType.Debug:
                    log.Debug(msg);
                    break;
                case LogType.Fatal:
                    log.Fatal(msg);
                    break;
                default:
                    break;
            }
        }
    }
}
