using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MongoDB.Attributes;
namespace Barfoo.Library.Data
{
    /// <summary>
    /// MongoID自动递增特性，增加了该特性的属性在添加到数据库的时候将被赋予自动递增的值，只允许在int long decimal中使用
    /// </summary>
    [AttributeUsage(AttributeTargets.Property)]
    public class MongoIdAutoIncrAttribute : Attribute
    {
        public MongoIdAutoIncrAttribute()
        { }
    }
}
