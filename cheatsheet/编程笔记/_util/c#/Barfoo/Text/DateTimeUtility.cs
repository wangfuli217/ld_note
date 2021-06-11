using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Barfoo.Library.Text
{
    public static class DateTimeUtility
    {
        /// <summary>
        /// 格林威治时间时当前时区的时间(1970-01-01 08:00:00)
        /// </summary>
        private static readonly DateTime STARTTIME = TimeZone.CurrentTimeZone.ToLocalTime(new DateTime(1970, 1, 1, 8, 0, 0));

        /// <summary>
        /// 将当前时区的时间转换成Unix时间戳
        /// </summary>
        /// <param name="date">当前时区的时间</param>
        /// <returns>Unix时间戳</returns>
        public static long ToUnixStamp(DateTime date)
        {
            return Convert.ToInt64((date - STARTTIME).TotalSeconds);
        }

        /// <summary>
        /// 将时间戳转换成当前时区的时间
        /// </summary>
        /// <param name="stamp">时间戳</param>
        /// <returns>当前时区的时间</returns>
        public static DateTime UnixStampToDate(long stamp)
        {
            return STARTTIME.AddSeconds(Convert.ToDouble(stamp));
        }

        /// <summary>
        /// 将毫秒的时间值转为DateTime类型(值为0时表示时间： 1970-01-01 08:00:00)
        /// </summary>
        /// <param name="stamp">时间值(单位为毫秒)</param>
        /// <returns>当前时区的时间</returns>
        public static DateTime MilliSecond(long stamp)
        {
            return UnixStampToDate(stamp / 1000 - 8 * 60 * 60);
        }

        /// <summary>
        /// 获取当前时间的Unix时间戳
        /// </summary>
        /// <returns>当前时间的Unix时间戳</returns>
        public static long NowUnixStamp()
        {
            return ToUnixStamp(DateTime.Now);
        }

        /// <summary>
        /// 是否已经赋值的时间
        /// </summary>
        /// <param name="date">需判断的时间</param>
        /// <returns>是否已经赋值</returns>
        public static bool IsCorrect(this DateTime date)
        {
            return date != default(DateTime) && date > DateTime.MinValue;
        }

        /// <summary>
        /// C#中使用TimeSpan计算两个时间的差值
        /// 可以反加两个日期之间任何一个时间单位
        /// </summary>
        /// <param name="DateTime1"></param>
        /// <param name="DateTime2"></param>
        /// <returns></returns>
        public static int DateDiff(DateTime DateTime1, DateTime DateTime2)
        {
            //string dateDiff = null;
            TimeSpan ts1 = new TimeSpan(DateTime1.Ticks);
            TimeSpan ts2 = new TimeSpan(DateTime2.Ticks);
            TimeSpan ts = ts1.Subtract(ts2).Duration();
            //dateDiff = ts.Days.ToString() + "天" + ts.Hours.ToString() + "小时" + ts.Minutes.ToString() + "分钟" + ts.Seconds.ToString() + "秒";
            return ts.Days;
        }
    }
}
