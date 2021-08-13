using System;
using System.IO;
using System.Web;
using System.Text;
using System.Linq;
using System.Web.Mvc;
using System.Reflection;
using System.Data.Common;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Text.RegularExpressions;

using Barfoo.Strategy.Database;

namespace Barfoo.Opinion.Service.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            ViewBag.Message = "欢迎使用 ASP.NET MVC!";
            return Content(ViewBag.Message);
        }

        /// <summary>
        /// 数据库测试
        /// </summary>
        /// <param name="SQL"></param>
        /// <param name="ConnStr"></param>
        /// <param name="DbType"></param>
        /// <param name="Method"></param>
        /// <returns></returns>
        public string Database(string SQL, string ConnStr, string DbType, string Method)
        {
            // 页面显示的内容
            var result = new System.Text.StringBuilder();

            #region 页面提交内容
            result.Append("<form name='pageForm' id='pageForm' method='post' action='#'>\r\n");

            // 选择数据库操作类型
            result.Append("操作类型：<select name='Method'>\r\n");
            result.Append("<option value='Select'" + ("Select".Equals(Method) ? " selected " : "") + ">查询</option>\r\n");
            result.Append("<option value='Execute'" + ("Execute".Equals(Method) ? " selected " : "") + ">执行</option>\r\n");
            result.Append("</select>&nbsp;&nbsp;&nbsp;&nbsp;\r\n\r\n");

            // 选择数据库类型
            result.Append("数据库类型：<select name='DbType'>\r\n");
            result.Append("<option value='MySQL'" + ("MySQL".Equals(DbType) ? " selected " : "") + ">MySQL</option>\r\n");
            result.Append("<option value='SQL Server'" + ("SQL Server".Equals(DbType) ? " selected " : "") + ">SQL Server</option>\r\n");
            result.Append("</select><br/>\r\n\r\n");

            // 数据库连接
            if (!string.IsNullOrEmpty(ConnStr))
            {
                ConnStr = HttpUtility.UrlDecode(ConnStr);
            }
            // 遍历所有的数据库连接
            var connStrs = System.Configuration.ConfigurationManager.ConnectionStrings;
            result.Append("数据库连接： <select onchange='this.form.tc.value=this.value'>\r\n");
            foreach (var conn in connStrs)
            {
                var str = conn.ToString();
                if (string.IsNullOrEmpty(str)) continue; // 空字符串的过滤掉
                // 截取出database的部分
                var database = str.Replace(" ", "").ToLower();
                if (database.IndexOf("database=") < 0) continue; // 没包含数据库连接信息的，过滤掉
                database = database.Substring(database.IndexOf("database=") + 9);
                database = database.Substring(0, database.IndexOf(";"));
                result.Append("<option value='" + str + "'" + (str.Equals(ConnStr) ? " selected " : "") + ">" + database + "</option>\r\n");
            }
            result.Append("</select>\r\n");
            result.Append("<input type='hidden' name='ConnStr' value=''/>\r\n");
            result.Append("<input type='text' name='tc' value='" + ConnStr + "' style='width:70%'/><br/>\r\n\r\n");

            // SQL 语句输入框
            if (!string.IsNullOrEmpty(SQL))
            {
                SQL = HttpUtility.UrlDecode(SQL);
            }
            result.Append("<textArea name='ts' id='ts' rows='5' style='width:98%'>" + ToTextarea(SQL) + "</textArea><br />\r\n");
            result.Append("<input type='hidden' name='SQL' value=''/>\r\n");

            // 提交按钮(SQL输入的内容转码一下，以免被系统安全验证时屏蔽掉)
            result.Append("<input type='submit' value='提交' onclick='this.form.SQL.value = encodeURIComponent(this.form.ts.value);this.form.ConnStr.value = encodeURIComponent(this.form.tc.value);'/>\r\n");
            result.Append("</form><br/><br/>\r\n\r\n\r\n");
            #endregion

            #region 执行SQL
            // 显示出查询的内容(执行SQL之后)
            if ("GET".Equals(Request.HttpMethod) || string.IsNullOrEmpty(SQL)
                || string.IsNullOrEmpty(ConnStr) || string.IsNullOrEmpty(DbType) || string.IsNullOrEmpty(Method))
            {
                return result.ToString();
            }
            int rows = 0;
            SqlDataReader dataReader = null;
            IEnumerable<DbDataReader> list = null;
            try
            {
                if ("SQL Server".Equals(DbType))
                {
                    // SQL SERVER的连接数据库并打开；
                    var myConnection = new SqlConnection(ConnStr);
                    SqlCommand objCommand = new SqlCommand(SQL, myConnection);
                    myConnection.Open();
                    if ("Execute".Equals(Method))
                    {
                        rows = objCommand.ExecuteNonQuery();
                    }
                    else if ("Select".Equals(Method))
                    {
                        dataReader = objCommand.ExecuteReader();
                    }
                }
                else if ("MySQL".Equals(DbType))
                {
                    if ("Execute".Equals(Method))
                    {
                        rows = DbUtility.ExecuteNonQuery(ConnStr, SQL);
                    }
                    else if ("Select".Equals(Method))
                    {
                        list = DbUtility.ExecuteReader(ConnStr, SQL);
                    }
                }
            }
            catch (Exception ex)
            {
                result.AppendFormat("<div style='color:red'>操作异常, 错误源:" + ex.Source + "<br/>\r\n");
                if (!string.IsNullOrEmpty(ex.Message))
                {
                    result.AppendFormat("错误信息:" + ex.Message + "<br/>\r\n");
                }
                else
                {
                    try
                    {
                        result.AppendFormat("错误信息:" + ex.InnerException + "<br/>\r\n");
                    }
                    catch { }
                }
                result.Append("堆信息：" + ex.StackTrace + "</div><br/>\r\n\r\n\r\n");
            }
            #endregion

            #region 显示操作结果
            // 处理操作结果
            if (rows > 0)
            {
                result.Append("操作影响 " + rows + " 行<br/>\r\n");
            }
            if (list != null && list.Count() > 0)
            {
                result.Append("<table border='1' align='center'><tbody>\r\n");
                bool hasTitle = false; // 标识是否已经输出过标题
                int index = 0; // 序号记录
                foreach (var item in list)
                {
                    try
                    {
                        // 标题栏
                        if (hasTitle == false)
                        {
                            result.Append("<tr>\r\n");
                            result.Append("<th title='序号'>序号</th>\r\n");
                            for (int i = 0; i < item.FieldCount; i++)
                            {
                                var key = item.GetName(i);
                                result.Append("<th title='" + ToHtml(key) + "'>" + ToHtml(key) + "</th>\r\n");
                            }
                            result.Append("</tr>\r\n\r\n");
                            hasTitle = true;
                        }

                        // 内容栏
                        result.Append("<tr>\r\n");
                        result.Append("<td title='" + (++index) + "'>" + index + "</td>\r\n");
                        // 各字段的内容
                        for (int i = 0; i < item.FieldCount; i++)
                        {
                            var value = item[i];
                            var str = value == null ? string.Empty : value.ToString();
                            //为""时,显示空格; 为null时,红色显示
                            string showValue = (value == null ? "<font color='red'>null</font>" : ("".Equals(str) ? "&nbsp;" : ToHtml(str)));
                            result.Append("<td title='" + ToHtml(str) + "'>" + showValue + "</td>\r\n");
                        }
                        result.Append("</tr>\r\n\r\n");
                    }
                    catch { }
                }
                result.Append("</tbody></table><br />\r\n\r\n\r\n");
            }
            if (dataReader != null && dataReader.HasRows)
            {
                result.Append("<table border='1' align='center'><tbody>\r\n");
                bool hasTitle = false; // 标识是否已经输出过标题
                int index = 0; // 序号记录
                //读取所有行
                while (dataReader.Read())
                {
                    try
                    {
                        // 标题栏
                        if (hasTitle == false)
                        {
                            result.Append("<tr>\r\n");
                            result.Append("<th title='序号'>序号</th>\r\n");
                            for (int i = 0; i < dataReader.FieldCount; i++)
                            {
                                var key = dataReader.GetName(i);
                                result.Append("<th title='" + ToHtml(key) + "'>" + ToHtml(key) + "</th>\r\n");
                            }
                            result.Append("</tr>\r\n\r\n");
                            hasTitle = true;
                        }

                        // 内容栏
                        result.Append("<tr>\r\n");
                        result.Append("<td title='" + (++index) + "'>" + index + "</td>\r\n");
                        // 各字段的内容
                        for (int i = 0; i < dataReader.FieldCount; i++)
                        {
                            var value = dataReader[i];
                            var str = value == null ? string.Empty : value.ToString();
                            //为""时,显示空格; 为null时,红色显示
                            string showValue = (value == null ? "<font color='red'>null</font>" : ("".Equals(str) ? "&nbsp;" : ToHtml(str)));
                            result.Append("<td title='" + ToHtml(str) + "'>" + showValue + "</td>\r\n");
                        }
                        result.Append("</tr>\r\n\r\n");
                    }
                    catch { }
                }

                result.Append("</tbody></table><br />\r\n\r\n\r\n");
            }
            #endregion

            return result.ToString();
        }

        #region 文件浏览
        /// <summary>
        /// 文件浏览+上传页面
        /// </summary>
        /// <returns></returns>
        public ActionResult FilesIndex()
        {
            // 页面内容
            string html = @"<!DOCTYPE html>
<html>
<head>
    <title>文件浏览</title>
    <meta http-equiv='content-type' content='text/html; charset=utf-8'/>
    <script src='http://code.jquery.com/jquery-1.7.1.min.js' type='text/javascript'></script>
</head>
<body>
<fieldset id='addField'>
    <legend>添加文件</legend>

	上传路径:
    <input type='text' name='addPath' id='addPath' style='width:80%;'/>
    <br />

    <!-- 操作按钮 -->
    <input type='radio' id='pathType1' name='pathType' value='Relatively' checked='checked'/><label for='pathType1'>相对路径</label>
    <input type='radio' id='pathType2' name='pathType' value='Absolute'/><label for='pathType2'>绝对路径</label>
    &nbsp;&nbsp;&nbsp;&nbsp;
    <input type='button' value='添加' onclick='addFileInput()'/>
	<input type='button' value='上传' onclick='addFileSubmit()'/>

    <!-- 路径说明 -->
    <br /><span style='font-size:9pt;font-weight:bold;'>路径允许使用“..”来表示上一层目录，没有的目录会在后台自动创建</span>

    <!-- 文件选择按钮保存区 -->
    <br /><div id='myFiles'></div>
</fieldset>

<br />
<fieldset>
    <legend>目录浏览</legend>
    <div id='showFilesPage'></div>
</fieldset>
</body>
</html>

<script language='JavaScript' type='text/javascript'>

    var index = 0; // 记录着共多少个文件
    // 添加上传的文件输入框
    function addFileInput() {
        ++index;
        $('#myFiles').append('<INPUT type=""file"" NAME=""file' + index + '"" id=""file' + index + '""/>');
    }
    // 提交上传
    function addFileSubmit() {
        // 如果选绝对路径,则必须填写路径
        if ($('#pathType2').is(':checked') && $('#path').val() == '') {
            alert('你选择了绝对路径，则路径不能为空！');
            return;
        }

        var files = $('#myFiles :file');
        // 检查有没有文件输入框
        if (files.length <= 0) {
            alert('请先添加要上传的文件再提交！');
            return;
        }
        var fileElementIds = [];
        // 检查有没有选择文件
        var hasFiles = false;
        for (var i = 0, len = files.length; i < len; i++) {
            var file = files[i];
            hasFiles = hasFiles || (file.value.length > 0);
            fileElementIds.push(file.id);
        }
        if (!hasFiles) {
            alert('请选择要上传的文件再提交！');
            return;
        }

        // 路径处理
        var path;
        // 绝对路径时,直接用输入的
        if ($('#pathType2').is(':checked')) {
            path = $('#addPath').val();
        }
        // 相对路径时,路径拼接
        else {
            path = $('#oPath').val() + $('#addPath').val();
        }

        // 提交上传
        jQuery.ajaxFileUpload({
            url: 'SaveFiles', // 用于文件上传的服务器端请求地址
            fileElementId: fileElementIds, // 文件上传元素的id, 单个文件则为字符串, 多个文件同时上传时可以用字符串数组(如:['fileid1','fileid2'])
            data: { filePath: path }, // 额外传输的参数,可以是json类型(将会创建隐藏域来保存),也可以是字符串类型('a=11&b=22' 格式)
            dataType: 'text', // 返回值类型,可选值: html、script、json、xml、text, 默认:xml
            //服务器响应失败处理函数
            error: function (data, status, e) {
                alert('文件上传出错！');
            },
            //服务器成功响应处理函数
            success: function (data, status) {
                alert(data);
                $('#myFiles').html(''); // 清空文件
            },
            // 数据返回后，不管执行成功还是失败，都执行的动作,后于 success 和 error
            complete: reloadPage
        });
    }

    // 跳转到某目录
    function goTo(path) {
        path = path || '';
        // 路径:基础路径 + 目录名 + 避免缓存的随机数
        path = encodeURIComponent($('#oPath').val() + path) + '/&' + Math.random();
        $('#showFilesPage').load('ShowFiles?BasePath=' + path);
    }

    // 下载文件
    function downloadFile(path) {
        // 路径:基础路径 + 文件名
        path = encodeURIComponent($('#oPath').val() + path);
        window.open('DownloadFile?filePath=' + path);
    }

    // 删除
    function delFile(path) {
        if (!confirm('确认要删除“' + path + '”吗？')) return;
        // 路径:基础路径 + 文件名
        path = $('#oPath').val() + path;
        jQuery.ajax({
            type: 'POST', // 避免缓存
            url: 'DeleteFile',
            data: { filePath: path }, //发送的数据,用json就不用转码了
            dataType: 'text', // 返回值类型,可选值: html、script、json、xml、text
            error: function (XMLHttpRequest, textStatus, errorThrown) { alert('删除出错'); },
            //成功时,即回调函数
            success: function (data, textStatus, xhr) {
                alert(data); // 提示后台返回的反馈信息
            },
            //完成时,执行 success 或者 error 之后的回调函数
            complete: reloadPage
        });
    }

    // 重新加载页面
    function reloadPage() {
        $('#showFilesPage').load('ShowFiles?BasePath=' + $('#oPath').val());
    }

    // 加载文件列表
    reloadPage();

// 文件上传控件
// 此工具类, 通过创建隐藏的iframe, 在iframe里提交 form 来实现伪ajax
// 此工具类, 在网上原版本的基础上做少量改良,参数提供 data 来额外传参(之前只能在 url 上额外传参,现在是以隐藏域post传参),添加多个文件同时上传功能
(function () {
    // jQuery.handleError 只在jquery-1.4.2之前的版本中存在，jquery-1.6 和1.7中都没有这个函数了，因此需加上此函数来解决
    if (!jQuery.handleError) {
        jQuery.handleError = function (s, xhr, status, e) {
            // 如果自定义了出错处理函数,调用它
            // If a local callback was specified, fire it
            if (s.error) {
                s.error.call(s.context || s, xhr, status, e);
            }
            // 调用全局的出错处理函数
            // Fire the global callback
            if (s.global) {
                (s.context ? jQuery(s.context) : jQuery.event).trigger('ajaxError', [xhr, s, e]);
            }
        };
    }

    /**
     * 文件上传主函数
     * @param {Object} s 参数类,其中包括:
     * @return {Object} 关于说明
     *
     * jQuery.ajaxFileUpload({
     *     url: 'fileUploadAction.action',       // 用于文件上传的服务器端请求地址
     *     secureuri: false,                     // 一般设置为false
     *     fileElementId: 'file',                // 文件上传元素的id, 单个文件则为字符串, 需多个文件同时上传时可以用字符串数组(如:['fileid1','fileid2'])
     *     data: { a: 22, b: '看看' },           // 额外传输的参数,可以是json类型(将会创建隐藏域来保存),也可以是字符串类型('a=11&b=22' 格式)
     *     dataType: 'json',                     // 返回值类型,可选值: html、script、json、xml、text, 默认:xml
     *     beforeSend:function() {},             // 提交之前的动作
     *     success: function (data, status) {},  //服务器成功响应处理函数
     *     error: function (data, status, e) {}, //服务器响应失败处理函数
     *     complete:function() {}                // 数据返回后，不管执行成功还是失败，都执行的动作,后于 success 和 error
     * })
     */
    jQuery.ajaxFileUpload = function (s) {
            // TODO introduce global settings, allowing the client to modify them for all requests, not only timeout
            s = jQuery.extend({}, jQuery.ajaxSettings, s);
            var id = new Date().getTime()
            var form = createUploadForm(id, s.fileElementId);
            var io = createUploadIframe(id, s.secureuri);
            var frameId = 'jUploadFrame' + id;
            var formId = 'jUploadForm' + id;
            // Watch for a new set of requests
            if (s.global && !jQuery.active++) {
                jQuery.event.trigger('ajaxStart');
            }
            var requestDone = false;
            // Create the request object
            var xml = {}
            if (s.global)
                jQuery.event.trigger('ajaxSend', [xml, s]);
            // Wait for a response to come back
            var uploadCallback = function (isTimeout) {
                var io = document.getElementById(frameId);
                try {
                    if (io.contentWindow && io.contentWindow.document) {
                        xml.responseText = io.contentWindow.document.body ? io.contentWindow.document.body.innerHTML : null;
                        xml.responseXML = io.contentWindow.document.XMLDocument || io.contentWindow.document;
                    } else if (io.contentDocument && io.contentDocument.document) {
                        xml.responseText = io.contentDocument.document.body ? io.contentDocument.document.body.innerHTML : null;
                        xml.responseXML = io.contentDocument.document.XMLDocument || io.contentDocument.document;
                    }
                } catch (e) {
                    jQuery.handleError(s, xml, null, e);
                }
                if (xml || isTimeout == 'timeout') {
                    requestDone = true;
                    var status;
                    try {
                        status = isTimeout != 'timeout' ? 'success' : 'error';
                        // Make sure that the request was successful or notmodified
                        if (status != 'error') {
                            // process the data (runs the xml through httpData regardless of callback)
                            var data = uploadHttpData(xml, s.dataType);
                            // If a local callback was specified, fire it and pass it the data
                            if (s.success)
                                s.success(data, status);

                            // Fire the global callback
                            if (s.global)
                                jQuery.event.trigger('ajaxSuccess', [xml, s]);
                        } else
                            jQuery.handleError(s, xml, status);
                    } catch (e) {
                        status = 'error';
                        jQuery.handleError(s, xml, status, e);
                    }

                    // The request was completed
                    if (s.global)
                        jQuery.event.trigger('ajaxComplete', [xml, s]);

                    // Handle the global AJAX counter
                    if (s.global && ! --jQuery.active)
                        jQuery.event.trigger('ajaxStop');

                    // Process result
                    if (s.complete)
                        s.complete(xml, status);

                    // 销毁 iframe 和 form
                    jQuery(io).unbind()
                    setTimeout(function () {
                        try {
                            $(io).remove();
                            form.remove();
                        } catch (e) {
                            jQuery.handleError(s, xml, null, e);
                        }
                    }, 100);

                    xml = null;
                }
            }
            // Timeout checker
            if (s.timeout > 0) {
                setTimeout(function () {
                    // Check to see if the request is still happening
                    if (!requestDone) uploadCallback('timeout');
                }, s.timeout);
            }
            try {
                // var io = $('#' + frameId);
                var form = $('#' + formId);
                // 添加要附加提交的参数
                if (s.data) {
                    var data = s.data;
                    // 如果附加提交的参数是 string 类型,解析成 json, 下面再处理
                    if (typeof data == 'string') {
                        var regex = /(\w+)=([^&]+)/gi;
                        var ms = data.match(regex);
                        if (ms != null) {
                            var data = {}; // 保存 json 参数
                            for (var i = 0, length = ms.length; i < length; i++) {
                                var ns = ms[i].match(regex);
                                try { data[RegExp.$1] = decodeURI(RegExp.$2); } catch (e) { }
                            }
                        }
                    }
                    // 使用 input 来保存需要提交的附加参数
                    if (typeof data == 'object') {
                        for (var name in data) {
                            var input = jQuery('<input type=""hidden"" name=""' + name + '""/>');
                            input.val(data[name]).appendTo(form);
                        }
                    }
                }
                // 设置 form 的其他参数
                form.attr('action', s.url);
                form.attr('method', 'POST');
                form.attr('target', frameId);
                if (form.attr('encoding')) {
                    form.attr('encoding', 'multipart/form-data');
                }
                else {
                    form.attr('enctype', 'multipart/form-data');
                }
                form.submit();
            } catch (e) {
                jQuery.handleError(s, xml, null, e);
            }
            jQuery('#' + frameId).load(uploadCallback);
            return { abort: function () { } };
    };

    /**
     * 创建 iframe,用于保存需要提交的 form
     */
    function createUploadIframe(id, uri) {
        // iframe 的id
        var frameId = 'jUploadFrame' + id;

        if (window.ActiveXObject) {
            var io = document.createElement('<iframe id=""' + frameId + '"" name=""' + frameId + '"" />');
            if (typeof uri == 'boolean') {
                io.src = 'javascript:false';
            }
            else if (typeof uri == 'string') {
                io.src = uri;
            }
        }
        else {
            var io = document.createElement('iframe');
            io.id = frameId;
            io.name = frameId;
        }
        // style 的属性为了实现此 iframe 的隐藏 (不明白为什么不直接写 style='display:none')
        io.style.position = 'absolute';
        io.style.top = '-1000px';
        io.style.left = '-1000px';

        document.body.appendChild(io);

        return io
    }

    /**
     * 创建 form, 用来保存需要提交的 file 和其它参数
     */
     function createUploadForm(id, fileElementId) {
        var formId = 'jUploadForm' + id;
        var fileId = 'jUploadFile' + id;
        var form = jQuery('<form  action="""" method=""POST"" name=""' + formId + '"" id=""' + formId + '"" enctype=""multipart/form-data""></form>');
        if (typeof fileElementId == 'string') {
            fileElementId = [fileElementId];
        }
        // 多个 file 输入框,数组
        if (typeof fileElementId == 'object' && fileElementId.constructor === Array) {
            for (var i = 0, len = fileElementId.length; i < len; i++) {
                var oldElement = jQuery('#' + fileElementId[i]); // 要上传的 file 输入框
                var newElement = oldElement.clone(); // 复制一份,放入到新建的 form 里面
                oldElement.attr('id', fileId);
                oldElement.before(newElement);
                oldElement.appendTo(form);
            }
        }
        // 设置 form 的参数
        //set attributes
        form.css('position', 'absolute');
        form.css('top', '-1200px');
        form.css('left', '-1200px');
        form.appendTo('body');
        return form;
    }

    /**
     * 处理返回的结果
     */
    function uploadHttpData(r, type) {
        var data = !type;
        data = type == 'xml' || data ? r.responseXML : r.responseText;

        // If the type is 'script', eval it in global context
        if (type == 'script')
            jQuery.globalEval(data);
        // Get the JavaScript object, if JSON is used.
        if (type == 'json')
            eval('data = ' + data);
        // evaluate scripts within html
        if (type == 'html')
            jQuery('<div>').html(data).evalScripts();
        //alert($('param', data).each(function(){alert($(this).attr('value'));}));
        return data;
    }

})();
</script>";
            return Content(html);
        }

        /// <summary>
        /// 文件浏览
        /// </summary>
        /// <param name="BasePath">浏览的起始位置</param>
        /// <returns></returns>
        public string ShowFiles(string BasePath)
        {
            // 如果没有起始位置，则以本站点的首目录为起始位置
            BasePath = string.IsNullOrEmpty(BasePath) ? AppDomain.CurrentDomain.SetupInformation.ApplicationBase : BasePath;
            System.IO.DirectoryInfo BaseFile = new System.IO.DirectoryInfo(BasePath);
            // 真实路径
            BasePath = BaseFile.FullName;
            //如果文件路径不存在,先创建文件夹
            if (!BaseFile.Exists)
            {
                BaseFile.Create();
            }

            // 出错信息
            string errorMsg = string.Empty;
            // 页面内容
            string html = @"
            <a href='javascript:;' title='去到上一层目录' onclick='goTo("".."");return false;'>上一层目录</a><br />
            当前目录：" + BasePath + @"<br />
            <input type='hidden' name='oPath' id='oPath' value='" + BasePath + @"'/>

            <table border='1'>
            <tbody>
                <tr>
                    <th title='序号'>序号</th>
                    <th title='名称'>名称</th>
                    <th title='大小'>大小</th>
                    <th title='更新日期'>更新日期</th>
                    <th title='操作'>操作</th>
                </tr>";

            try
            {
                int index = 0;
                // 当前目录
                var parentdi = new System.IO.DirectoryInfo(BasePath);

                // 遍历直属子目录
                var dirs = parentdi.GetDirectories();
                for (int i = 0; i < dirs.Length; i++)
                {
                    System.IO.DirectoryInfo dir = dirs[i];
                    html += "<tr>\r\n<td>" + (++index) + "</td>\r\n";
                    html += "<td><a href='javascript:;' title='进入此目录' onclick='goTo(\"" + dir.Name + "\");return false;'>" + dir.Name + "</a></td>\r\n";
                    html += "<td>&nbsp;</td>\r\n";
                    html += "<td>" + dir.LastWriteTime + "</td>\r\n";
                    html += "<td><input type='button' value='删除' title='删除此目录' onclick='delFile(\"" + dir.Name + "/\")'/></td>\r\n";
                    html += "</tr>";
                }

                // 遍历直属文件
                var files = parentdi.GetFiles();
                for (int i = 0; i < files.Length; i++)
                {
                    System.IO.FileInfo file = files[i];
                    html += "<tr>\r\n<td>" + (++index) + "</td>\r\n";
                    html += "<td><a href='javascript:;' title='下载此文件' onclick='downloadFile(\"" + file.Name + "\")'>" + file.Name + "</a></td>\r\n";
                    html += "<td>" + GetSize(file.Length) + "</td>\r\n";
                    html += "<td>" + file.LastWriteTime + "</td>\r\n";
                    html += "<td><input type='button' value='删除' title='删除此文件' onclick='delFile(\"" + file.Name + "\")'/></td>\r\n";
                    html += "</tr>\r\n";
                }
            }
            catch (Exception Ex)
            {
                errorMsg += "<br/><br/>出错信息：" + Ex.Message;
            }

            html += "\r\n</tbody>\r\n</table>\r\n";
            html += errorMsg;
            return html;
        }

        /// <summary>
        /// 返回文件大小
        /// </summary>
        /// <param name="length">文件大小(字节)</param>
        /// <returns>返回文件大小(转成B、K、M 等文字缩写)</returns>
        private string GetSize(long length)
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

        /// <summary>
        /// 文件下载(流方式下载)
        /// </summary>
        /// <param name="filePath">要下载的文件路径(硬盘路径)</param>
        public void DownloadFile(string filePath)
        {
            if (string.IsNullOrEmpty(filePath)) return;
            // 获取文件名
            string fileName = System.IO.Path.GetFileName(filePath);

            //以字符流的形式下载文件
            var fs = new System.IO.FileStream(filePath, System.IO.FileMode.Open);
            byte[] bytes = new byte[(int)fs.Length];
            fs.Read(bytes, 0, bytes.Length);
            fs.Close();
            //通知浏览器下载文件而不是打开
            Response.ContentType = "application/octet-stream";
            //浏览器判断(火狐浏览器应该直接写中文名字，IE却要求转码)
            var browserName = Request.Browser.Browser;
            // 浏览器名称，可能的值为: ie, firefox, opera, chrome, safari
            browserName = browserName == null ? null : browserName.Trim().ToLower();
            if (!"firefox".Equals(browserName))
            {
                fileName = HttpUtility.UrlEncode(fileName, System.Text.Encoding.UTF8);
            }
            Response.AddHeader("Content-Disposition", "attachment;  filename=" + fileName);
            Response.BinaryWrite(bytes);
            Response.Flush();
            Response.End();
        }

        /// <summary>
        /// 删除文件或者目录
        /// </summary>
        /// <param name="filePath">要下载的目录或者文件路径(硬盘路径,目录需要以斜杠"/"结尾)</param>
        /// <returns>反馈信息</returns>
        public string DeleteFile(string filePath)
        {
            if (string.IsNullOrEmpty(filePath)) return "缺少要删除的文件名称！";

            try
            {
                // 目录
                if (filePath.EndsWith("/"))
                {
                    System.IO.DirectoryInfo dir = new System.IO.DirectoryInfo(filePath);
                    dir.Delete(true);
                    return "成功删除目录(会递归删除其子目录及文件)：\n" + filePath;
                }
                // 文件
                else
                {
                    System.IO.FileInfo file = new System.IO.FileInfo(filePath);
                    file.Delete();
                    return "删除文件：\n" + filePath;
                }
            }
            catch (Exception Ex)
            {
                return "出错信息：\n" + Ex.Message;
            }
        }

        /// <summary>
        /// 保存文件(文件太大时会出错,5M就挂掉了)
        /// </summary>
        /// <param name="oPath">要保存的文件目录路径(硬盘路径,没有这目录则新增)</param>
        /// <returns>反馈信息</returns>
        public string SaveFiles(string filePath)
        {
            // 基础检查
            if (string.IsNullOrEmpty(filePath)) return "缺少要上传的路径！";
            var files = Request.Files;
            if (files == null || files.Count == 0) return "没有要上传的文件！";

            // 状态信息
            var strMsg = new System.Text.StringBuilder();
            strMsg.Append("上传的文件分别是：\n");
            try
            {
                // 检查目录
                var dir = new System.IO.DirectoryInfo(filePath);
                filePath = dir.FullName;
                //如果文件路径不存在,先创建文件夹
                if (!dir.Exists)
                {
                    dir.Create();
                }
                // 路径正确性处理
                if (!filePath.EndsWith("/") && !filePath.EndsWith("\\"))
                {
                    filePath += "/";
                }

                // 遍历File表单元素
                for (int iFile = 0, len = files.Count; iFile < len; iFile++)
                {
                    var postedFile = files[iFile];
                    string fileName = System.IO.Path.GetFileName(postedFile.FileName);
                    if (!string.IsNullOrEmpty(fileName))
                    {
                        // 检查文件扩展名字
                        string fileExtension = System.IO.Path.GetExtension(fileName);
                        strMsg.Append("文件：" + fileName + "\n");
                        //注意：可能要修改你的文件夹的匿名写入权限。
                        postedFile.SaveAs(filePath + fileName);
                    }
                }
            }
            catch (Exception Ex)
            {
                strMsg.Append("出错信息：\n" + Ex.Message);
            }
            return strMsg.ToString();
        }
        #endregion


        #region 符号转换
        /// <summary>
        /// 将需要显示的字符串转换成 HTML 格式的
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public string ToHtml(string sour)
        {
            if (string.IsNullOrEmpty(sour)) return "";

            // 以下逐一转换
            sour = sour.Replace("&", "&amp;"); // & 符號,最先转换
            sour = sour.Replace(" ", "&nbsp;");
            sour = sour.Replace("%", "&#37;");
            sour = sour.Replace("<", "&lt;");
            sour = sour.Replace(">", "&gt;");
            sour = sour.Replace("\n", "\n<br/>");
            sour = sour.Replace("\"", "&quot;");
            sour = sour.Replace("'", "&#39;");
            sour = sour.Replace("+", "&#43;");
            return sour;
        }

        /// <summary>
        /// 将需要显示的字符串转换成 textarea 显示的字符串
        /// </summary>
        /// <param name="sour">被转换的字符串</param>
        /// <returns>转换后的字符串</returns>
        public string ToTextarea(string sour)
        {
            if (string.IsNullOrEmpty(sour)) return "";

            // 以下逐一转换
            sour = sour.Replace("&", "&amp;");
            sour = sour.Replace("<", "&lt;");
            sour = sour.Replace(">", "&gt;");
            return sour;
        }
        #endregion

        #region 显示代码
        // 所有的命名空间的集合(缓存)
        private static HashSet<string> NameSpaceList = new HashSet<string>();
        // 所有的类的集合(缓存)
        private static HashSet<Type> AllClassList = new HashSet<Type>();

        /// <summary>
        /// 反射出一个类的所有字段，属性，方法
        /// </summary>
        /// <returns></returns>
        public string ShowAllClass()
        {
            if (NameSpaceList == null) NameSpaceList = new HashSet<string>();
            if (AllClassList == null) AllClassList = new HashSet<Type>();
            if (NameSpaceList.Count == 0 || AllClassList.Count == 0)
            {
                GetExecutingClasses(NameSpaceList, AllClassList); // 加载能访问到的
                GetAllClasses(NameSpaceList, AllClassList); // 加载运行目录下的所有
            }

            // 页面显示的内容
            var result = new StringBuilder();
            result.Append(@"<!DOCTYPE html>
<html>
<head>
    <title>程序浏览</title>
    <meta http-equiv='content-type' content='text/html; charset=utf-8'/>
    <script src='http://code.jquery.com/jquery-1.7.1.min.js' type='text/javascript'></script>
    <style type='text/css'>span.Namespace, span.Object { cursor: pointer; }</style>
</head>
<body>");

            // 所有命名空间
            List<string> nList = NameSpaceList.ToList();
            nList.Sort();
            foreach (string Namespace in nList)
            {
                result.Append("\r\n<br/><span class='Namespace' ctrlId='" + Namespace + "'>+</span>&nbsp;\r\n<span>");
                result.Append(Namespace);
                result.Append("</span>\r\n<div id='" + Namespace + "' style='display:none;'>\r\n");
                // 命名空间下的所有类
                List<Type> thisClassList = AllClassList.Where(o => o.Namespace == Namespace).ToList();
                thisClassList = thisClassList.OrderBy(o => o.Name).ToList(); // 排序
                foreach (Type type in thisClassList)
                {
                    result.Append(addSpace(1));
                    result.Append("<span class='Object' ctrlId='" + type.FullName + "'>+</span>&nbsp;\r\n<span>");
                    result.Append(type.Name);
                    // 类里面的内容, Ajax加载
                    result.Append("</span><div id='" + type.FullName + "'></div>\r\n");
                }
                result.Append("</div>\r\n");
            }

            // 没有命名空间的类
            List<Type> noNamespaceClassList = AllClassList.Where(o => string.IsNullOrEmpty(o.Namespace)).ToList();
            if (noNamespaceClassList != null && noNamespaceClassList.Count > 0)
            {
                result.Append("\r\n<br/><span class='Namespace' ctrlId='0'>+</span>&nbsp;\r\n<span>没有命名空间的类</span>\r\n");
                result.Append("<div id='0' style='display:none;'>\r\n");
                // 没有命名空间的所有类
                foreach (Type type in noNamespaceClassList)
                {
                    result.Append(addSpace(1));
                    result.Append("<span class='Object' ctrlId='" + type.FullName + "'>+</span>&nbsp;\r\n<span>");
                    result.Append(type.Name);
                    // 类里面的内容, Ajax加载
                    result.Append("</span><div id='" + type.FullName + "'></div>\r\n");
                }
                result.Append("</div>\r\n");
            }

            result.Append("</body>\r\n</html>\r\n\r\n");
            result.Append(@"
<script language='JavaScript' type='text/javascript'>
(function(){
    // 给有“+”的A标签添加事件
    window.document.onclick = function(e) {
        e = e || window.event;
        var x = e.target || e.srcElement; // 获取事件源(被点击的元素对象)
        if (x.tagName == 'SPAN') {
            if (x.innerHTML == '+') {
                // 命名空间
                if (x.className == 'Namespace') {
                    window.document.getElementById(x.getAttribute('ctrlId')).style.display = ''; // 显示命名空间下的所有类
                    x.innerHTML = '-';
                }
                // 类
                else if (x.className == 'Object') {
                    var id = x.getAttribute('ctrlId');
                    var child = window.document.getElementById(id);
                    child.style.display = ''; // 显示类下的所有成员
                    x.innerHTML = '-';
                    // 类里面如果还没有内容, Ajax加载
                    if(child.innerHTML == ''){
                        $(child).load('ShowClass?ClassFullName=' + id);
                    }
                }
            }
            else if (x.innerHTML == '-') {
                window.document.getElementById(x.getAttribute('ctrlId')).style.display = 'none'; // 折叠子层
                x.innerHTML = '+';
            }
        }
    }
})();
</script>");
            return result.ToString();
        }

        /// <summary>
        /// 增加空白区域，以表明层次感
        /// </summary>
        /// <param name="number">第几层子元素</param>
        /// <returns></returns>
        private string addSpace(int number)
        {
            return "&nbsp;&nbsp;&nbsp;&nbsp;";
        }

        /// <summary>
        /// 当前程序所能访问到的所有命名空间及类的集合
        /// 使用 HashSet 是为了去重
        /// </summary>
        /// <param name="namespaceList">所有命名空间的集合(用来保存命名空间的集合)</param>
        /// <param name="classList">当前能访问到的所有类的集合(用来保存类的集合)</param>
        private void GetExecutingClasses(HashSet<string> namespaceList, HashSet<Type> classList)
        {
            // 本程序可以访问到的所有命名空间
            Assembly asm = Assembly.GetExecutingAssembly();
            foreach (Type type in asm.GetTypes())
            {
                // 有些没有命名空间的,以及空间名为乱码的
                string Namespace = type.Namespace;
                if (!string.IsNullOrEmpty(Namespace) && !HasUnicode(Namespace))
                {
                    namespaceList.Add(Namespace); // 保存命名空间
                }
                // 有些类名为乱码的
                string className = type.Name;
                if (!string.IsNullOrEmpty(className) && !HasUnicode(className))
                {
                    // 一些特殊的类名，没什么意义
                    if (!className.StartsWith("<") && !className.StartsWith("__"))
                    {
                        classList.Add(type); // 保存类
                    }
                }
            }
        }

        /// <summary>
        /// 获取的所有命名空间及类的集合
        /// 使用 HashSet 是为了去重
        /// </summary>
        /// <param name="namespaceList">所有命名空间的集合(用来保存命名空间的集合)</param>
        /// <param name="classList">所有类的集合(用来保存类的集合)</param>
        private void GetAllClasses(HashSet<string> namespaceList, HashSet<Type> classList)
        {
            // 用io流递归遍历运行目录下的所有dll或者exe等文件,力求获取所有能取到的命名空间
            string domain = System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase; // 站点的硬盘地址,结果如: "D:\\wwwfiles\\myApp\\"
            AddDir(new DirectoryInfo(domain), namespaceList, classList);
        }

        /// <summary>
        /// 获取指定目录下的所有命名空间及类的集合
        /// 使用 HashSet 是为了去重
        /// </summary>
        /// <param name="runDir">要加载的目录路径</param>
        /// <param name="namespaceList">所有命名空间的集合(用来保存命名空间的集合)</param>
        /// <param name="classList">所有类的集合(用来保存类的集合)</param>
        /// <returns></returns>
        private void AddDir(DirectoryInfo runDir, HashSet<string> namespaceList, HashSet<Type> classList)
        {
            if (runDir == null || !runDir.Exists) return; // 目录不存在时不加载
            // 遍历直属文件
            foreach (FileInfo file in runDir.GetFiles())
            {
                Assembly a;
                try { a = Assembly.LoadFrom(file.FullName ?? file.Name); }
                // 加载不成功，则跳过
                catch { continue; }
                Type[] mytypes = a.GetTypes();
                foreach (Type type in mytypes)
                {
                    // 有些没有命名空间的,以及空间名为乱码的
                    string Namespace = type.Namespace;
                    if (!string.IsNullOrEmpty(Namespace) && !HasUnicode(Namespace))
                    {
                        namespaceList.Add(Namespace); // 保存命名空间
                    }
                    // 有些类名为乱码的
                    string className = type.Name;
                    if (!string.IsNullOrEmpty(className) && !HasUnicode(className))
                    {
                        // 一些特殊的类名，没什么意义
                        if (!className.StartsWith("<") && !className.StartsWith("__"))
                        {
                            classList.Add(type); // 保存类
                        }
                    }
                }
            }

            // 递归遍历子目录
            foreach (DirectoryInfo dir in runDir.GetDirectories())
            {
                AddDir(dir, namespaceList, classList);
            }
        }

        /// <summary>
        /// 判断字符串里面是否有 Unicode 编码
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        private bool HasUnicode(string str)
        {
            for (int i = 0; i < str.Length; i++)
            {
                if (Convert.ToInt32(Convert.ToChar(str.Substring(i, 1))) > Convert.ToInt32(Convert.ToChar(128)))
                {
                    return true;
                }
            }
            return false;
        }

        /// <summary>
        /// 反射出一个类的内容
        /// </summary>
        /// <param name="ClassFullName">要反射的类型的全名(包括命名空间)</param>
        public string ShowClass(string ClassFullName)
        {
            if (string.IsNullOrEmpty(ClassFullName)) return string.Empty;
            Type t = Type.GetType(ClassFullName);
            // 如果这类不在本程序的访问范围内,会反射不出来,去读取全局的
            if (t == null)
            {
                if (AllClassList == null) AllClassList = new HashSet<Type>();
                if (AllClassList.Count == 0)
                {
                    if (NameSpaceList == null) NameSpaceList = new HashSet<string>();
                    GetAllClasses(NameSpaceList, AllClassList); // 加载运行目录下的所有
                }
                t = AllClassList.FirstOrDefault(o => o.FullName == ClassFullName);
                if (t == null) return string.Empty; // 还找不到就没办法了
            }

            int number = 3; // 起始层级
            // 查询标志
            BindingFlags flags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;

            // 页面显示的内容
            var result = new StringBuilder();

            // 构造函数(Constructor)
            result.Append(addSpace(number));
            result.Append("构造函数(Constructor):<br/>\r\n");
            ConstructorInfo[] constructors = t.GetConstructors(flags);
            foreach (ConstructorInfo constructor in constructors)
            {
                result.Append(addSpace(number + 2));
                result.Append(constructor.IsPublic ? "Public " : (constructor.IsPrivate ? "Private " : "")); // 可见性
                result.Append(constructor.IsStatic ? "Static " : ""); // 静态
                // constructor.Name; // 函数名 都是(.ctor, .cctor),所以没有用,改成显示类名
                result.Append(t.Name); // 类名
                // 泛型
                if (constructor.IsGenericMethod)
                {
                    result.Append("&lt;"); // “<”小于号
                    Type[] ts = constructor.GetGenericArguments();
                    for (int i = 0; i < ts.Length; i++)
                    {
                        var o = ts[i];
                        result.Append(o.Name);
                        if (i < ts.Length - 1) result.Append(", ");
                    }
                    result.Append("&gt;"); // “>”大于号
                }
                // 参数列表
                result.Append("(");
                ParameterInfo[] ps = constructor.GetParameters();
                for (int i = 0; i < ps.Length; i++)
                {
                    var p = ps[i];
                    result.Append(GetTypeName(p.ParameterType) + " " + p.Name); // 参数类型及参数名
                    if (i < ps.Length - 1) result.Append(", ");
                }
                result.Append(")");
                result.Append("<br/>\r\n");
            }

            // 字段(Field)
            result.Append(addSpace(number));
            result.Append("字段(Field):<br/>\r\n");
            FieldInfo[] fields = t.GetFields(flags);
            foreach (FieldInfo field in fields)
            {
                result.Append(addSpace(number + 2));
                result.Append(field.IsPublic ? "Public " : (field.IsPrivate ? "Private " : "")); // 可见性
                result.Append(field.IsStatic ? "Static " : ""); // 静态
                result.Append(GetTypeName(field.FieldType) + " "); // 字段类型
                result.Append(field.Name); // 字段名
                result.Append("<br/>\r\n");
            }

            // 属性(Property)
            result.Append(addSpace(number));
            result.Append("属性(Property):<br/>\r\n");
            PropertyInfo[] properties = t.GetProperties(flags);
            foreach (PropertyInfo property in properties)
            {
                Type ptype = property.PropertyType;
                result.Append(addSpace(number + 2));
                //result.Append(property.IsPublic ? "Public " : (property.IsPrivate ? "Private " : "")); // 可见性
                //result.Append(property.IsStatic ? "Static " : ""); // 静态
                result.Append(GetTypeName(ptype)); // 字段类型
                result.Append(property.Name); // 字段名
                result.Append(" {");
                result.Append(property.CanRead ? " get; " : "");
                result.Append(property.CanWrite ? " set; " : "");
                result.Append("}");
                result.Append("<br/>\r\n");
            }

            // 函数(Method)
            result.Append(addSpace(number));
            result.Append("函数(Method):<br/>\r\n");
            MethodInfo[] methods = t.GetMethods(flags);
            foreach (MethodInfo method in methods)
            {
                result.Append(addSpace(number + 2));
                result.Append(method.IsPublic ? "Public " : (method.IsPrivate ? "Private " : "")); // 可见性
                result.Append(method.IsStatic ? "Static " : ""); // 静态
                result.Append(GetTypeName(method.ReturnType) + " "); // 返回类型
                result.Append(method.Name); // 函数名
                // 泛型
                if (method.IsGenericMethod)
                {
                    result.Append("&lt;"); // “<”小于号
                    Type[] ts = method.GetGenericArguments();
                    for (int i = 0; i < ts.Length; i++)
                    {
                        var o = ts[i];
                        result.Append(o.Name);
                        if (i < ts.Length - 1) result.Append(", ");
                    }
                    result.Append("&gt;"); // “>”大于号
                }
                // 参数列表
                result.Append("(");
                ParameterInfo[] ps = method.GetParameters();
                for (int i = 0; i < ps.Length; i++)
                {
                    var p = ps[i];
                    result.Append(GetTypeName(p.ParameterType) + " " + p.Name); // 参数类型及参数名
                    if (i < ps.Length - 1) result.Append(", ");
                }
                result.Append(")");
                result.Append("<br/>\r\n");
            }
            return result.ToString();
        }

        /// <summary>
        /// 获取类型名的字符串
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        private string GetTypeName(Type type)
        {
            // 泛型时 FullName 为null,而可以读取 Name
            string typeStr = type.FullName ?? type.Name ?? type.ToString();
            // 处理为空的类型,如 int? 类型； 还有泛型类型,如 List<T>
            if (typeStr.Contains("`") && typeStr.Contains("["))
            {
                string head = typeStr.Substring(0, typeStr.IndexOf("`"));
                string body = string.Empty;
                if (typeStr.Contains("[[")) // 有两个“[”
                {
                    body = typeStr.Substring(typeStr.IndexOf("[") + 2);
                    body = body.Substring(0, body.Length - 2);
                }
                else // 只有一个“[”
                {
                    body = typeStr.Substring(typeStr.IndexOf("[") + 1);
                    body = body.Substring(0, body.Length - 1);
                }
                if (body.Contains(","))
                {
                    body = body.Split(',')[0];
                }
                typeStr = head + "&lt;" + body + "&gt;";
            }
            // 空返回类型
            if (typeStr == "System.Void")
            {
                typeStr = "void";
            }
            return typeStr;
        }
        #endregion
    }
}