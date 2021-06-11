/*
版权所有：  邦富软件版权所有(C)
系统名称：  舆情系统
模块名称：  文件扩展类 
创建日期：  2011-1-25
作者：      barefoot
内容摘要： 
       -   李旭日 2011/9/6 移除一些类库中本来就可以方便调用  但是自己实现的方法
       *   李旭日 2011/9/6 修改了一些涉及资源释放的调用为using 并重新调整了下代码格式等
       +   李旭日 2011/9/6 增加带lazyload功能的 ReadLines 方法，在大文件时能有效提高效率，避免内存溢出
*/

using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using ICSharpCode.SharpZipLib.Zip;

namespace Barfoo.Library.IO
{
    public class FileUtility
    {
        /// <summary>
        /// 相比File.ReadAllLines有延迟加载的作用
        ///  author: 李旭日
        /// </summary>
        /// <param name="fileName"></param>
        /// <param name="encode"></param>
        /// <returns></returns>
        public static IEnumerable<string> ReadLines(string fileName, Encoding encode)
        {
            using (var sr = new StreamReader(fileName, encode))
            {
                while (!sr.EndOfStream)
                {
                    yield return sr.ReadLine();
                }
            }
        }

        /// <summary>
        /// 相比File.ReadAllLines有延迟加载的作用
        /// author: 李旭日
        /// </summary>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static IEnumerable<string> ReadLines(string fileName)
        {
            return ReadLines(fileName, Encoding.Default);
        }

        /// <summary>
        /// 获取某目录下的所有文件(包括子目录下文件)的数量
        /// </summary>
        /// <param name="Path">目录名</param>
        /// <returns></returns>
        public static int GetFileNum(string Path)
        {
            int fileNum = 0;
            string[] fileList = Directory.GetFileSystemEntries(Path);

            // 遍历所有的文件和目录
            foreach (string file in fileList)
            {
                if (System.IO.Directory.Exists(file))
                    GetFileNum(file);
                else
                    fileNum++;
            }
            return fileNum;
        }

        /// <summary>
        /// 获取某目录下的所有文件(包括子目录下文件)的大小
        /// </summary>
        /// <param name="dirPath">目录名</param>
        /// <returns></returns>
        public static long GetDirectoryLength(string dirPath)
        {
            if (!Directory.Exists(dirPath))
                return 0;

            long len = 0;
            DirectoryInfo di = new DirectoryInfo(dirPath);
            foreach (FileInfo fi in di.GetFiles())
            {
                len += fi.Length;
            }

            DirectoryInfo[] dis = di.GetDirectories();
            if (dis.Length > 0)
            {
                for (int i = 0; i < dis.Length; i++)
                {
                    len += GetDirectoryLength(dis[i].FullName);
                }
            }
            return len;
        }

        /// <summary>
        /// 打包压缩整个目录中的文件
        /// </summary>
        /// <param name="directory">压缩目录</param>
        /// <param name="zipfile">压缩后文件名</param>
        public static void PacketFiles(string directory, string zipfile)
        {
            FastZip fz = new FastZip();

            fz.CreateEmptyDirectories = true;
            fz.CreateZip(zipfile, directory, true, "");
        }

        /// <summary>
        /// 解包所有文件到一个目录中
        /// </summary>
        /// <param name="zipfile">解压文件</param>
        /// <param name="directory">解压后目录</param>
        /// <returns></returns>
        public static bool UnpacketFiles(string zipfile, string directory)
        {
            if (!Directory.Exists(directory))
            {
                Directory.CreateDirectory(directory);
            }

            using (ZipInputStream zis = new ZipInputStream(File.OpenRead(zipfile)))
            {
                ZipEntry entry;

                while ((entry = zis.GetNextEntry()) != null)
                {
                    string directoryName = Path.GetDirectoryName(entry.Name);
                    string fileName = Path.GetFileName(entry.Name);

                    if (directoryName != String.Empty)
                    {
                        Directory.CreateDirectory(directory + directoryName);
                    }

                    if (fileName != String.Empty)
                    {
                        using (FileStream streamWriter = File.Create(Path.Combine(directory, entry.Name)))
                        {
                            int size = 1024;
                            byte[] data = new byte[size];
                            while (size > 0)
                            {
                                size = zis.Read(data, 0, data.Length);
                                if (size > 0)
                                {
                                    streamWriter.Write(data, 0, size);
                                }
                            }
                        }
                    }
                }
            }

            return true;
        }

        /// <summary>
        /// 创建zip文件
        /// </summary>
        /// <param name="textfile">原文件名</param>
        /// <param name="zipfile">zip文件名</param>
        /// <param name="cpRatio">压缩比率</param>
        public static void Save2Zip(string textfile, string zipfile, int? cpRatio)
        {
            int ratio = 6;
            if (cpRatio != null && cpRatio > 0)
            {
                ratio = cpRatio.Value;
            }

            using (FileStream zipfs = new FileStream(zipfile, FileMode.Append, FileAccess.Write))
            {
                using (ZipOutputStream zos = new ZipOutputStream(zipfs))
                {
                    zos.SetLevel(ratio); // 0: store only ～ 9: means best compression

                    using (FileStream txtfs = File.OpenRead(textfile))
                    {
                        byte[] buffer = new byte[txtfs.Length];
                        txtfs.Read(buffer, 0, buffer.Length);

                        string name = textfile.Substring(textfile.LastIndexOf('\\') + 1);
                        ZipEntry entry = new ZipEntry(name);

                        zos.PutNextEntry(entry);
                        zos.Write(buffer, 0, buffer.Length);
                    }
                }
            }
        }

        /// <summary>
        /// 读取zip文件
        /// </summary>
        /// <param name="filename">zip文件名</param>
        /// <returns></returns>
        public static string OpenReadZip(string filename)
        {
            return OpenReadZip(filename, Encoding.UTF8);
        }

        /// <summary>
        /// 读取zip文件
        /// </summary>
        /// <param name="filename">zip文件名</param>
        /// <returns></returns>
        public static string OpenReadZip(string filename, Encoding code)
        {
            StringBuilder text = new StringBuilder();

            using (ZipInputStream zis = new ZipInputStream(File.OpenRead(filename)))
            {

                ZipEntry entry;
                while ((entry = zis.GetNextEntry()) != null)
                {
                    int size = 1024;
                    byte[] buffer = new byte[size];

                    while (true)
                    {
                        size = zis.Read(buffer, 0, buffer.Length);
                        if (size > 0)
                        {
                            text.Append(code.GetString(buffer, 0, size));
                        }
                        else
                        {
                            break;
                        }
                    }
                    buffer = null;
                }
            }

            return text.ToString();
        }

        /// <summary>
        ///  路径分割符
        /// </summary>
        private const string PATH_SPLIT_CHAR = "\\";

        /// <summary>
        /// 重命名
        /// </summary>
        /// <param name="sourceFileName">新文件名</param>
        /// <param name="destFileName">旧文件名</param>
        public static void Rename(string sourceFileName, string destFileName)
        {
            if (File.Exists(destFileName))
                File.Delete(destFileName);

            File.Move(sourceFileName, destFileName);
        }


        /// <summary>
        /// 复制指定目录的所有文件,不包含子目录及子目录中的文件
        /// </summary>
        /// <param name="sourceDir">原始目录</param>
        /// <param name="targetDir">目标目录</param>
        /// <param name="overWrite">如果为true,表示覆盖同名文件,否则不覆盖</param>
        public static void CopyFiles(string sourceDir, string targetDir, bool overWrite)
        {
            CopyFiles(sourceDir, targetDir, overWrite, false);
        }

        /// <summary>
        /// 复制指定目录的所有文件
        /// </summary>
        /// <param name="sourceDir">原始目录</param>
        /// <param name="targetDir">目标目录</param>
        /// <param name="overWrite">如果为true,覆盖同名文件,否则不覆盖</param>
        /// <param name="copySubDir">如果为true,包含目录,否则不包含</param>
        public static void CopyFiles(string sourceDir, string targetDir, bool overWrite, bool copySubDir)
        {
            //复制当前目录文件
            foreach (string sourceFileName in Directory.GetFiles(sourceDir))
            {
                string targetFileName = Path.Combine(targetDir, sourceFileName.Substring(sourceFileName.LastIndexOf(PATH_SPLIT_CHAR) + 1));
                if (File.Exists(targetFileName))
                {
                    if (overWrite == true)
                    {
                        File.SetAttributes(targetFileName, FileAttributes.Normal);
                        File.Copy(sourceFileName, targetFileName, overWrite);
                    }
                }
                else
                {
                    File.Copy(sourceFileName, targetFileName, overWrite);
                }
            }
            //复制子目录
            if (copySubDir)
            {
                foreach (string sourceSubDir in Directory.GetDirectories(sourceDir))
                {
                    string targetSubDir = Path.Combine(targetDir, sourceSubDir.Substring(sourceSubDir.LastIndexOf(PATH_SPLIT_CHAR) + 1));
                    if (!Directory.Exists(targetSubDir))
                        Directory.CreateDirectory(targetSubDir);
                    CopyFiles(sourceSubDir, targetSubDir, overWrite, true);
                }
            }
        }

        /// <summary>
        /// 剪切指定目录的所有文件,不包含子目录
        /// </summary>
        /// <param name="sourceDir">原始目录</param>
        /// <param name="targetDir">目标目录</param>
        /// <param name="overWrite">如果为true,覆盖同名文件,否则不覆盖</param>
        public static void MoveFiles(string sourceDir, string targetDir, bool overWrite)
        {
            MoveFiles(sourceDir, targetDir, overWrite, false);
        }

        /// <summary>
        /// 剪切指定目录的所有文件
        /// </summary>
        /// <param name="sourceDir">原始目录</param>
        /// <param name="targetDir">目标目录</param>
        /// <param name="overWrite">如果为true,覆盖同名文件,否则不覆盖</param>
        /// <param name="moveSubDir">如果为true,包含目录,否则不包含</param>
        public static void MoveFiles(string sourceDir, string targetDir, bool overWrite, bool moveSubDir)
        {
            //移动当前目录文件
            foreach (string sourceFileName in Directory.GetFiles(sourceDir))
            {
                string targetFileName = Path.Combine(targetDir, sourceFileName.Substring(sourceFileName.LastIndexOf(PATH_SPLIT_CHAR) + 1));
                if (File.Exists(targetFileName))
                {
                    if (overWrite == true)
                    {
                        File.SetAttributes(targetFileName, FileAttributes.Normal);
                        File.Delete(targetFileName);
                        File.Move(sourceFileName, targetFileName);
                    }
                }
                else
                {
                    File.Move(sourceFileName, targetFileName);
                }
            }
            if (moveSubDir)
            {
                foreach (string sourceSubDir in Directory.GetDirectories(sourceDir))
                {
                    string targetSubDir = Path.Combine(targetDir, sourceSubDir.Substring(sourceSubDir.LastIndexOf(PATH_SPLIT_CHAR) + 1));
                    if (!Directory.Exists(targetSubDir))
                        Directory.CreateDirectory(targetSubDir);

                    MoveFiles(sourceSubDir, targetSubDir, overWrite, true);
                    Directory.Delete(sourceSubDir);
                }
            }
        }


        /// <summary>
        /// 读取文件
        /// </summary>
        /// <param name="filename"></param>
        /// <returns></returns>
        public static string ReadText(string filename)
        {
            return ReadText(filename, Encoding.Default);
        }
        /// <summary>
        ///  读取文件
        /// </summary>
        /// <param name="filename"></param>
        /// <param name="code"></param>
        /// <returns></returns>
        public static string ReadText(string filename, Encoding code)
        {
            string text = "";
            StreamReader sr = null;
            if (!File.Exists(filename))
            {
                return text;
            }
            try
            {
                sr = new StreamReader(filename, code);
                text = sr.ReadToEnd();
            }
            catch
            {
            }
            finally
            {
                if (sr != null)
                {
                    sr.Close();
                    sr.Dispose();
                }
            }
            return text;
        }

        /// <summary>
        /// 写文件
        /// </summary>
        /// <param name="filename">文件的物理路径</param>
        /// <param name="strcontent">文本内容</param>
        public static void WriteFile(string filename, string strcontent)
        {
            WriteFile(filename, strcontent, false);
        }
        /// <summary>
        /// 写文件
        /// </summary>
        /// <param name="filename">文件的物理路径</param>
        /// <param name="strcontent">文本内容</param>
        /// <param name="append">文本是否追加到文件后面</param>
        public static void WriteFile(string filename, string strcontent, bool append)
        {
            WriteFile(filename, strcontent, append, System.Text.Encoding.GetEncoding("GB2312"));
        }
        /// <summary>
        ///  写文件
        /// </summary>
        /// <param name="filename">文件的物理路径</param>
        /// <param name="strcontent">文本内容</param>
        /// <param name="code">字符编码</param>
        public static void WriteFile(string filename, string strcontent, Encoding code)
        {
            WriteFile(filename, strcontent, false, code);
        }
        /// <summary>
        ///  写文件
        /// </summary>
        /// <param name="filename">文件的物理路径</param>
        /// <param name="strcontent">文本内容</param>
        /// <param name="code">字符编码</param>
        /// <param name="append">文本是否追加到文件</param>
        public static void WriteFile(string filename, string strcontent, bool append, Encoding code)
        {
            StreamWriter sw = null;
            try
            {
                FileInfo file = new FileInfo(filename);
                //如果文件路径不存在,先创建文件夹
                if (!file.Directory.Exists)
                {
                    file.Directory.Create();
                }
                //写入文件
                sw = new StreamWriter(filename, append, code);
                sw.Write(strcontent);
                sw.Flush();
            }
            catch
            { }
            finally
            {
                if (sw != null)
                {
                    sw.Close();
                    sw.Dispose();
                }
            }
        }
    }
}