<%@ Page Language="C#" AutoEventWireup="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>文件操作</title>
    <meta http-equiv="content-type" content="text/html; charset=utf-8"/>
    <script runat="server">
        // 当前路径
        protected string oPath = string.Empty;
        // 后台信息记录
        protected string str_Status = string.Empty;

        /// <summary>
        /// 页面加载函数
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            string tPath = Request["oPath"];
            this.oPath = string.IsNullOrEmpty(tPath) ? AppDomain.CurrentDomain.SetupInformation.ApplicationBase : tPath;

            if (this.IsPostBack)
            {
                this.SetPath();
                this.SaveFiles();
                this.DeleteFiles();
            }
            else
            {
                // 文件下载，另开新页来做
                this.DownloadFile();
            }
        }

        // 路径处理
        private void SetPath()
        {
            try
            {
                string path = Request.Form["path"];
                if (!string.IsNullOrEmpty(path))
                {
                    if (path.StartsWith("~"))
                    {
                        path = path.Substring(1, path.Length - 1);
                    }
                    if (path.StartsWith("/") || path.StartsWith("\\"))
                    {
                        path = path.Substring(1, path.Length - 1);
                    }
                    if (!path.EndsWith("/") && !path.EndsWith("\\"))
                    {
                        path += "/";
                    }
                    this.oPath += path;
                }

                // 创建目录
                System.IO.DirectoryInfo file = new System.IO.DirectoryInfo(this.oPath);
                this.oPath = file.FullName;
                //如果文件路径不存在,先创建文件夹
                if (!file.Exists)
                {
                    file.Create();
                }
            }
            catch (Exception Ex)
            {
                this.str_Status += "<br/><br/>\r\n\r\n" + Ex.Message;
            }
        }

        // 保存文件(文件太大时会出错,5M就挂掉了)
        private void SaveFiles()
        {
            // 遍历File表单元素
            HttpFileCollection files = Request.Files;
            if (files == null || files.Count == 0) return;

            // 状态信息
            StringBuilder strMsg = new StringBuilder();
            strMsg.Append("上传的文件分别是：<hr color=red/>");
            try
            {
                for (int iFile = 0; iFile < files.Count; iFile++)
                {
                    HttpPostedFile postedFile = files[iFile];
                    string fileName = System.IO.Path.GetFileName(postedFile.FileName);
                    if (!string.IsNullOrEmpty(fileName))
                    {
                        // 检查文件扩展名字
                        string fileExtension = System.IO.Path.GetExtension(fileName);
                        strMsg.Append("上传的文件类型：" + postedFile.ContentType.ToString() + "<br/>");
                        strMsg.Append("客户端文件地址：" + postedFile.FileName + "<br/>");
                        strMsg.Append("上传文件的文件名：" + fileName + "<br/>");
                        strMsg.Append("上传文件的扩展名：" + fileExtension + "<br/><hr/>");
                        //可根据扩展名字的不同保存到不同的文件夹
                        //注意：可能要修改你的文件夹的匿名写入权限。
                        postedFile.SaveAs(oPath + fileName);
                    }
                }
                this.str_Status = strMsg.ToString();
            }
            catch (Exception Ex)
            {
                this.str_Status += "<br/><br/>\r\n\r\n" + Ex.Message;
            }
        }

        // 删除文件或者目录
        private void DeleteFiles()
        {
            string fileName = Request["delName"];
            if (string.IsNullOrEmpty(fileName)) return;
            string filePath = this.oPath + fileName;

            try
            {
                // 目录
                if (fileName.EndsWith("/"))
                {
                    System.IO.DirectoryInfo dir = new System.IO.DirectoryInfo(filePath);
                    dir.Delete(true);
                    // 状态信息
                    this.str_Status = "删除目录(会递归删除其子目录及文件)： &nbsp;&nbsp;" + filePath;
                }
                // 文件
                else
                {
                    System.IO.FileInfo file = new System.IO.FileInfo(filePath);
                    file.Delete();
                    // 状态信息
                    this.str_Status = "删除文件： &nbsp;&nbsp;" + filePath;
                }
            }
            catch (Exception Ex)
            {
                this.str_Status += "<br/><br/>\r\n\r\n" + Ex.Message;
            }
        }

        // 文件下载(流方式下载)
        public void DownloadFile()
        {
            string fileName = Request["downPath"];
            if (string.IsNullOrEmpty(fileName)) return;
            string filePath = this.oPath + fileName;

            //以字符流的形式下载文件
            System.IO.FileStream fs = new System.IO.FileStream(filePath, System.IO.FileMode.Open);
            byte[] bytes = new byte[(int)fs.Length];
            fs.Read(bytes, 0, bytes.Length);
            fs.Close();
            Response.ContentType = "application/octet-stream";
            //通知浏览器下载文件而不是打开
            Response.AddHeader("Content-Disposition", "attachment;  filename=" + HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8));
            Response.BinaryWrite(bytes);
            Response.Flush();
            Response.End();
        }

        /// <summary>
        /// 返回文件大小
        /// </summary>
        /// <param name="length">文件大小(字节)</param>
        /// <returns>返回文件大小(动态转成B、K、M)</returns>
        protected string GetSize(long length)
        {
            if (length > 1024 * 1024 * 1024)
            {
                decimal d = new Decimal(length / (1024 * 1024 * 1024.0));
                return d.ToString("f2") + " G";
            }
            if (length > 1024 * 1024)
            {
                decimal d = new Decimal(length / (1024 * 1024.0));
                return d.ToString("f2") + " M";
            }
            if (length > 1024)
            {
                decimal d = new Decimal(length / 1024.0);
                return d.ToString("f2") + " K";
            }
            return length + " B";
        }
    </script>
</head>
<body>
    <form id="form1" name='form1' runat="server" method="post" action="#" enctype="multipart/form-data">
		上传路径:
        <input type="hidden" name="oPath" id='oPath' value="<%= oPath %>"/>
        <input type="hidden" name="delName" id='delName'/>
        <input type="text" name="path" id='path'/>
        &nbsp;&nbsp;&nbsp;&nbsp;

        <%-- 操作按钮 --%>
        <input type="button" value="添加文件" onclick="addFile()"/>
		<input type='submit' value="提交" />

        <%-- 路径说明 --%>
        <br /><span style="font-size:9pt;font-weight:bold;">(当前目录指项目的首页路径)支持的路径写法： “~/file/”，“空字符串”，“imgs”，“../imgs/tt/”</span>
        
        <%-- 文件选择按钮 --%>
        <br /><div id='myFiles'></div><br />
    </form>

    <%-- 目录遍历 --%>
    <a href='javascript:;' title='返回上层' onclick='goTo("../")'>../</a><br />
    当前目录：<%= oPath %><br />
    <table border='1'>
    <tbody>
        <tr>
            <th title='序号'>序号</th>
            <th title='名称'>名称</th>
            <th title='大小'>大小</th>
            <th title='更新日期'>更新日期</th>
            <th title='操作'>操作</th>
        </tr>
    <%
    try
    {
        int index = 0;
        // 当前目录
        System.IO.DirectoryInfo parentdi = new System.IO.DirectoryInfo(oPath);
            
        // 遍历直属子目录
        System.IO.DirectoryInfo[] dirs = parentdi.GetDirectories();
        for (int i = 0; i < dirs.Length; i++)
        {
            System.IO.DirectoryInfo dir = dirs[i];
            Response.Write("<tr>\r\n");
            Response.Write("\t<td>" + (++index) + "</td>\r\n");
            Response.Write("\t<td><a href='javascript:;' title='进入此目录' onclick='goTo(\"" + dir.Name + "/\")'>" + dir.Name + "</a></td>\r\n");
            Response.Write("\t<td>&nbsp;</td>\r\n");
            Response.Write("\t<td>" + dir.LastWriteTime + "</td>\r\n");
            Response.Write("\t<td><input type='button' value='删除' title='删除此目录' onclick='delFile(\"" + dir.Name + "/\")'/></td>\r\n");
            Response.Write("</tr>\r\n\r\n");
        }
            
        // 遍历直属文件
        System.IO.FileInfo[] files = parentdi.GetFiles();
        for (int i = 0; i < files.Length; i++)
        {
            System.IO.FileInfo file = files[i];
            Response.Write("<tr>\r\n");
            Response.Write("\t<td>" + (++index) + "</td>\r\n");
            Response.Write("\t<td><a href='javascript:;' title='下载此文件' onclick='downloadFile(\"" + file.Name + "\")'>" + file.Name + "</a></td>\r\n");
            Response.Write("\t<td>" + GetSize(file.Length) + "</td>\r\n");
            Response.Write("\t<td>" + file.LastWriteTime + "</td>\r\n");
            Response.Write("\t<td><input type='button' value='删除' title='删除此文件' onclick='delFile(\"" + file.Name + "\")'/></td>\r\n");
            Response.Write("</tr>\r\n\r\n");
        }
    }
    catch (Exception Ex)
    {
        this.str_Status += "<br/><br/>\r\n\r\n" + Ex.Message;
    }
    %>
    </tbody>
    </table>
    <br />

    <%-- 操作信息 --%>
    <span style="display:inline-block;border-color:White;border-style:None;font-size:9pt;font-weight:bold;width:500px;"><%= str_Status%></span>
</body>
</html>

<script language="JavaScript" type="text/javascript">
    var index = 0; // 记录着共多少个文件

    // 添加上传的文件
    function addFile() {
        var str = '<INPUT type="file" NAME="file' + (++index) + '"/>';
        var conten = document.getElementById('myFiles');
        try {
            conten.insertAdjacentHTML("beforeEnd", str);
        } catch (e) {
            var file = document.createElement('INPUT');
            file.setAttribute('type', "file");
            file.setAttribute('name', "file" + index);
            conten.appendChild(file);
        }
    }

    // 跳转到某目录
    function goTo(path) {
        var form = document.getElementById('form1');
        // 页面跳转时，还原路径栏，也清空文件上传
        form.reset();
        var oPath = document.getElementById('oPath');
        oPath.value = oPath.value + path;
        form.submit();
    }

    // 下载文件
    function downloadFile(path) {
        var url = window.location.protocol + "//" + window.location.host + window.location.pathname;
        url += "?oPath=" + encodeURIComponent(document.getElementById('oPath').value);
        url += "&downPath=" + encodeURIComponent(path);
        window.open(url);
    }

    // 删除
    function delFile(path) {
        var form = document.getElementById('form1');
        // 页面跳转时，还原路径栏，也清空文件上传
        form.reset();
        document.getElementById('delName').value = path;
        form.submit();
    }
</script>