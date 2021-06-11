using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data.Objects;

namespace Barfoo.Library.Linq
{
    public class LinqUtility
    {
        /// <summary>
        /// 获取 T-SQL
        /// </summary>
        /// <param name="o"></param>
        /// <returns></returns>
        public static  string ToSQL(object o)
        {
            var q = o as ObjectQuery;
            return q != null ? q.ToTraceString() : string.Empty;
        }
    }
}
