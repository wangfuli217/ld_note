/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  FormatterBase
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/
using System.IO;
using System.Runtime.Serialization;

namespace Barfoo.Library.Serialization
{
    /// <summary>
    /// 序列化基类
    /// </summary>
    public abstract class FormatterBase
    {
        public abstract IFormatter Formatter { get; }

        public T DeSerialize<T>(string path)
        {
            using (var stream = new FileStream(path, FileMode.Open))
            {
                return (T)Formatter.Deserialize(stream);
            }
        }

        public void Serialize(object obj, string path)
        {
            using (var stream = new FileStream(path, FileMode.OpenOrCreate))
            {
                Formatter.Serialize(stream, obj);
            }
        }
    }
}
