
// 此工具类, 通过创建隐藏的iframe, 在iframe里提交 form 来实现伪ajax, 依赖 jQuery 核心库
// 此工具类, 在网上原版本的基础上做少量改良,参数提供 data 来额外传参(之前只能在 url 上额外传参,现在是以隐藏域post传参),添加多个文件同时上传功能
(function () {
    /**
     * 文件上传主函数
     * @param {Object} s 参数类,其中包括:
     * @return {Object} 关于说明
     *
     * jQuery.ajaxFileUpload({
     *     url: 'fileUploadAction.action',       // 用于文件上传的服务器端请求地址
     *     secureuri: false,                     // 一般设置为false
     *     fileElementId: 'file1',               // 文件上传元素的id, 单个文件则为字符串, 需多个文件同时上传时可以用字符串数组(如:['fileid1','fileid2'])
     *     data: { a: 22, b: '看看' },           // 额外传输的参数,可以是json类型(将会创建隐藏域来保存),也可以是字符串类型("a=11&b=22" 格式)
     *     dataType: 'json',                     // 返回值类型,可选值: html、script、json、xml、text, 默认:xml
     *     beforeSend:function() {},             // 提交之前的动作
     *     success: function (data, status) {},  // 服务器成功响应处理函数
     *     error: function (data, status, e) {}, // 服务器响应失败处理函数
     *     complete:function() {}                // 数据返回后，不管执行成功还是失败，都执行的动作,后于 success 和 error
     * })
     */
    jQuery.ajaxFileUpload = function (s) {
            // TODO introduce global settings, allowing the client to modify them for all requests, not only timeout
            s = jQuery.extend({}, jQuery.ajaxSettings, s);
            var id = new Date().getTime();
            var form = createUploadForm(id, s.fileElementId);
            var io = createUploadIframe(id, s.secureuri);
            var frameId = 'jUploadFrame' + id;
            var formId = 'jUploadForm' + id;
            // Watch for a new set of requests
            if (s.global && !jQuery.active++) {
                jQuery.event.trigger("ajaxStart");
            }
            var requestDone = false;
            // Create the request object
            var xml = {}
            if (s.global) {
                jQuery.event.trigger("ajaxSend", [xml, s]);
            }
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
                if (xml || isTimeout == "timeout") {
                    requestDone = true;
                    var status;
                    try {
                        status = isTimeout != "timeout" ? "success" : "error";
                        // Make sure that the request was successful or notmodified
                        if (status != "error") {
                            // process the data (runs the xml through httpData regardless of callback)
                            var data = uploadHttpData(xml, s.dataType);
                            // If a local callback was specified, fire it and pass it the data
                            if (s.success) {
                                s.success(data, status);
                            }

                            // Fire the global callback
                            if (s.global) {
                                jQuery.event.trigger("ajaxSuccess", [xml, s]);
                            }
                        } else {
                            jQuery.handleError(s, xml, status);
                        }
                    } catch (e) {
                        status = "error";
                        jQuery.handleError(s, xml, status, e);
                    }

                    // The request was completed
                    if (s.global) {
                        jQuery.event.trigger("ajaxComplete", [xml, s]);
                    }

                    // Handle the global AJAX counter
                    if (s.global && ! --jQuery.active) {
                        jQuery.event.trigger("ajaxStop");
                    }

                    // Process result
                    if (s.complete) {
                        s.complete(xml, status);
                    }

                    // 销毁 iframe 和 form
                    jQuery(io).unbind();
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
                    if (!requestDone) uploadCallback("timeout");
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
                            var input = jQuery('<input type="hidden" name="' + name + '"/>');
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
                (s.context ? jQuery(s.context) : jQuery.event).trigger("ajaxError", [xhr, s, e]);
            }
        };
    }

    /**
     * 创建 iframe,用于保存需要提交的 form
     */
    function createUploadIframe(id, uri) {
        // iframe 的id
        var frameId = 'jUploadFrame' + id;
        var io = null;

        if (window.ActiveXObject) {
            io = document.createElement('<iframe id="' + frameId + '" name="' + frameId + '" />');
            if (typeof uri == 'boolean') {
                io.src = 'javascript:false';
            }
            else if (typeof uri == 'string') {
                io.src = uri;
            }
        }
        else {
            io = document.createElement('iframe');
            io.id = frameId;
            io.name = frameId;
        }
        // style 的属性为了实现此 iframe 的隐藏 (不明白为什么不直接写 style="display:none")
        io.style.position = 'absolute';
        io.style.top = '-1000px';
        io.style.left = '-1000px';

        document.body.appendChild(io);
        return io;
    }

    /**
     * 创建 form, 用来保存需要提交的 file 和其它参数
     */
     function createUploadForm(id, fileElementId) {
        var formId = 'jUploadForm' + id;
        var fileId = 'jUploadFile' + id;
        var form = jQuery('<form  action="" method="POST" name="' + formId + '" id="' + formId + '" enctype="multipart/form-data"></form>');
        if (typeof fileElementId == 'string') {
            fileElementId = [fileElementId];
        }
        // 多个 file 输入框,数组
        if (typeof fileElementId == 'object' && fileElementId.constructor === Array) {
            for (var i = 0, len = fileElementId.length; i < len; i++) {
                var oldElement = jQuery('#' + fileElementId[i]); // 要上传的 file 输入框
                var newElement = oldElement.clone(); // 复制一份,放入到新建的 form 里面
                oldElement.attr('id', fileId + i);
                oldElement.before(newElement);
                oldElement.appendTo(form); // 这里应该是 newElement.appendTo(form); 总感觉作者写错了这里
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
        data = type == "xml" || data ? r.responseXML : r.responseText;

        // If the type is "script", eval it in global context
        if (type == "script") {
            jQuery.globalEval(data);
        }
        // Get the JavaScript object, if JSON is used.
        if (type == "json") {
            eval("data = " + data);
        }
        // evaluate scripts within html
        if (type == "html") {
            jQuery("<div>").html(data).evalScripts();
        }
        return data;
    }

})();