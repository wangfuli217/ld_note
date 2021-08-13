using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Barfoo.Library.Text
{
    public class Explanation
    {
        /// <summary>
        /// 处理反序列化的实例
        /// </summary>
        /// <param name="obj"></param>
        public static void ExplanationData(object obj)
        {
            // var entity = obj.GetType();
            var properties = obj.GetType().GetProperties();
            foreach (var p in properties)
            {
                if (p.PropertyType.FullName.IndexOf("System.DateTime") > -1)
                {
                    object o = p.GetValue(obj, null);
                    if (o != null)
                    {
                        try
                        {
                            // 时间需要设成本地时间，否则会有8小时误差(因为中国是东8区)
                            p.SetValue(obj, System.Convert.ToDateTime(o).ToLocalTime(), null);
                        }
                        catch
                        { }
                    }
                }
                else if (p.PropertyType.FullName == "System.String")
                {
                    foreach (Attribute attr in p.GetCustomAttributes(true))
                    {
                        // 标识有去掉html的
                        if (attr is Barfoo.Library.Attributes.ClearHtmlAttribute)
                        {
                            var o = p.GetValue(obj, null) as string;
                            if (o != null)
                            {
                                try
                                {
                                    // 去掉html的内容
                                    p.SetValue(obj, Barfoo.Library.Text.StringExtensions.ClearAllHtmlTag(o), null);
                                }
                                catch
                                { }
                            }
                            break;
                        }
                    }
                }
            }
        }

    }
}
