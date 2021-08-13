using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Barfoo.Library.Attributes
{
    /// <summary>
    /// URL 编码
    /// </summary>
    public class FieldEncodingAttribute : Attribute
    {
        public FieldEncodingAttribute(string encod)
        {
            this.Encod = encod;
        }
        protected string encod;
        public string Encod
        {
            get { return encod; }
            set { encod = value; }
        }
    }

    /// <summary>
    /// 删除HTML标签
    /// </summary>
    public class ClearHtmlAttribute : Attribute
    {
        public ClearHtmlAttribute()
        {
        }
    }
}
