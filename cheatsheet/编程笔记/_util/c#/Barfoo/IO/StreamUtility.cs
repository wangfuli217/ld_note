/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  StreamExtension流处理扩展类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System.Drawing;
using System.IO;
using System.Text;

namespace Barfoo.Library.IO
{
    public static class StreamExtension
    {
        /// <summary>
        /// 根据指定编码将流解读为字符串
        /// </summary>
        /// <param name="stream">待解析的流</param>
        /// <param name="encode">流的编码</param>
        /// <returns>字符串</returns>
        public static string ToString(this Stream stream, Encoding encode)
        {
            using (StreamReader myStreamReader = new StreamReader(stream, encode))
            {
                return myStreamReader.ReadToEnd();
            }
        }

        /// <summary>
        /// 将流转换为Image对象
        /// </summary>
        /// <param name="stream">待转换的流</param>
        /// <returns>转换得到的位图对象</returns>
        public static Image ToBitmap(this Stream stream)
        {
            return new Bitmap(stream);
        }

        /// <summary>
        /// 将普通流转换成内存流
        /// </summary>
        /// <param name="normalStream">普通流</param>
        /// <returns>内存流</returns>
        public static MemoryStream ToMemoryStream(this Stream stream)
        {
            if (stream is MemoryStream) return stream as MemoryStream;

            using (stream)
            {
                byte[] buffer = new byte[1024];
                var memoryStream = new MemoryStream();
                int i = 1;
                while (i > 0)
                {
                    i = stream.Read(buffer, 0, buffer.Length);
                    memoryStream.Write(buffer, 0, i);
                }
                memoryStream.Seek(0, SeekOrigin.Begin);
                return memoryStream;
            }
        }

        /// <summary>
        /// 将流写入文件
        /// </summary>
        /// <param name="stream">待写入流</param>
        /// <param name="path">目标文件路径</param>
        public static void Save(this Stream stream, string path)
        {
            FileInfo file = new FileInfo(path);
            //如果文件路径不存在,先创建文件夹
            if (!file.Directory.Exists)
            {
                file.Directory.Create();
            }
            using (var fs = File.Open(path, FileMode.OpenOrCreate, FileAccess.Write))
            {
                byte[] buffer = new byte[1024];
                int length = int.MaxValue;
                while (length > 0)
                {
                    length = stream.Read(buffer, 0, buffer.Length);
                    fs.Write(buffer, 0, length);
                }
            }
        }
    }
}
