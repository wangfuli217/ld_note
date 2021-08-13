/**
 * <P> Title: 工具类                        </P>
 * <P> Description: 工具类                  </P>
 * <P> Copyright: Copyright (c) 2010-07-13  </P>
 * <P> Company:Everunion Tech. Ltd.         </P>
 * @author <A href="daillow@gmail.com">Holer</A>
 */
using System;
using System.Collections;
using System.Configuration;
using System.IO;
using System.Text;

namespace Com.Util
{
    public class FileUtil
    {

        /// <summary>
        /// 创建文件
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <param name="strMsg">文件里需要写入的数据</param>
        /// <param name="overwritten">如果文件已经存在,是否覆盖;true则覆盖旧档,false则保留旧文件而追加数据到文件后面</param>
        public static void WriteFile(string fileName, string strMsg, bool overwritten)
        {
            FileInfo file = new FileInfo(fileName);
            //如果文件路径不存在,先创建文件夹
            if ( !file.Directory.Exists )
            {
                file.Directory.Create();
            }
            //如果文件已经存在;overwritten 为true则覆盖旧档,false则保留旧文件而追加数据到文件后面
            FileMode fileMode = overwritten ? FileMode.Create : FileMode.Append;
            FileStream fs = new FileStream(fileName, fileMode);
            StreamWriter sw = new StreamWriter(fs, Encoding.UTF8);
            //写入资料
            sw.WriteLine(strMsg);
            sw.Flush();
            //关闭流
            sw.Close();
            fs.Close();
            //销毁对象
            sw.Dispose();
            fs.Dispose();
        }


        /// <summary>
        /// 创建文件; 如果文件已经存在,则覆盖旧档
        /// </summary>
        /// <param name="fileName">文件名</param>
        /// <param name="strMsg">文件里需要写入的数据</param>
        public static void WriteFile(string fileName, string strMsg)
        {
            WriteFile( fileName, strMsg, true );
        }


        /// <summary>
        /// 删除目录下的所有文件
        /// </summary>
        /// <param name="Dir">文件目录(不存在时创建)</param>
        public static void DeleteDirFiles(string Dir)
        {
            //目录不存在
            if (!System.IO.Directory.Exists(Dir))
            {
                System.IO.Directory.CreateDirectory(Dir);
            }
            //目录存在
            else
            {
                //文件数组
                string[] Files = System.IO.Directory.GetFiles(Dir);
                foreach (string file in Files)
                {
                    //删除
                    System.IO.File.Delete(file);
                }
            }
        }


        /// <summary>
        /// 删除目录下的所有文件
        /// </summary>
        /// <param name="Dir">文件目录(不存在时创建)</param>
        public static void DeleteFile(string fileName)
        {
            try
            {
                System.IO.File.Delete(fileName);
            }
            catch
            {
            }
        }


        /// <summary> (此函数直接复制过来，未测试)
        /// 获取图片，并保存到本地
        /// </summary>
        /// <param name="imgUrl">图片地址</param>
        /// <param name="path">保存路径</param>
        /// <param name="fileName">图片名</param>
        /// <returns>图片保存成功返回true，否则返回false</returns>
        public static bool SaveImageFromWeb(string imgUrl, string path, string fileName)
        {
            // 未指定保存文件的路径
            if (string.IsNullOrEmpty(path))
                throw new Exception("未指定保存文件的路径");
            // 未指定图片的地址
            if (string.IsNullOrEmpty(imgUrl))
                throw new Exception("未指定保存文件的路径");

            string imgName = imgUrl.Substring(imgUrl.LastIndexOf("/") + 1);

            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(imgUrl);
            request.UserAgent = "Mozilla/6.0 (MSIE 6.0; Windows NT 5.1; Natas.Robot)";
            request.Timeout = 3000;

            WebResponse response = request.GetResponse();
            Stream stream = response.GetResponseStream();

            if (response.ContentType.ToLower().StartsWith("image/"))
            {
                byte[] arrayByte = new byte[1024];
                int imgLong = (int)response.ContentLength;
                int l = 0;

                // 图片类型
                string defaultType = "." + response.ContentType.Split('/')[1];
                string[] imgTypes = new string[] { ".jpg", ".jpeg", ".png", ".gif", ".bmp" };
                string imgType = imgUrl.Substring(imgUrl.LastIndexOf("."));
                foreach (string it in imgTypes)
                {
                    if (imgType.ToLower().Equals(it))
                        break;
                    // 如果不属于上诉的类型，使用默认的
                    if (it.Equals(".bmp"))
                        imgType = defaultType;
                }

                //如果文件名没有传进来，使用图片的
                if (string.IsNullOrEmpty(fileName))
                    fileName = imgName;

                FileStream fso = new FileStream(path + fileName + imgType, FileMode.Create);
                while (l < imgLong)
                {
                    int i = stream.Read(arrayByte, 0, 1024);
                    fso.Write(arrayByte, 0, i);
                    l += i;
                }

                fso.Close();
                stream.Close();
                response.Close();

                return true;
            }
            else
            {
                return false;
            }
        }



    }
}
