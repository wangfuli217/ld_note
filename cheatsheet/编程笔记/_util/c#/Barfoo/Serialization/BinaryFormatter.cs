/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  SoapFormatter
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/
using System.Runtime.Serialization;

namespace Barfoo.Library.Serialization
{
    /// <summary>
    /// 二进制序列化
    /// </summary>
    public class BinaryFormatter : FormatterBase
    {
        private static BinaryFormatter instance = new BinaryFormatter();

        public static BinaryFormatter Instance { get { return instance; } }

        public override IFormatter Formatter
        {
            get { return new System.Runtime.Serialization.Formatters.Binary.BinaryFormatter(); }
        }
    }
}
