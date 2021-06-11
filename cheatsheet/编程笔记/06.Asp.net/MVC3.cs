
来源： http://www.cnblogs.com/lukun/archive/2011/07/19/2110728.html

MVC 3.0 的新特性
  新特性分为以下部分：
    Razor 视图引擎
    支持多视图引擎
    Controller 改进
    JavaScript 和 Ajax
    Model 验证的改进
    依赖注入 Dependency Injection 的改进
    其他新特性


MVC的概念及MVC 3.0开发环境
  MVC即： Model(模型), View(视图), Controller(控制器)

    Model：模型对象是实现应用程序数据域逻辑的应用程序部件。 通常，模型对象会检索模型状态并将其存储在数据库中。
    例如，Product 对象可能会从数据库中检索信息，操作该信息，然后将更新的信息写回到 SQL Server 数据库内的 Products 表中。

    在小型应用程序中，模型通常是概念上的分离，而不是实际分离。
    例如，如果应用程序仅读取数据集并将其发送到视图，则该应用程序没有物理模型层和关联的类。 在这种情况下，数据集担当模型对象的作用。

    Controller：控制器是处理用户交互、使用模型并最终选择要呈现的视图来显示 UI 的组件。 在 MVC 应用程序中，视图仅显示信息；控制器则用于处理和响应用户输入和交互。
    例如，控制器处理查询字符串值，并将这些值传递给模型，而模型可能会使用这些值来查询数据库。
    就是程序通过Controller从浏览器中接受命令，决定用它做什么，并返反馈给用户。即获取数据,然后将数据绑定到页面控件的这个业务逻辑。

    View：视图是显示应用程序用户界面 (UI) 的组件。 通常，此 UI 是用模型数据创建的。
    Products 表的编辑视图便是一个视图示例，该视图基于 Product 对象的当前状态显示文本框、下拉列表和复选框。
    就是我们的aspx页面,注意这是一个不包含后台代码文件的aspx页面。在MVC3.0 View可以支持多视图引擎。即aspx和cshtml

    MVC(Model-View-Controller)在软件工程中的一种设计模式.(他不仅仅是Asp.net Mvc,这只是他的一种实现)他的主要设计目标是把用户接口和逻辑层进行分离(低耦合)，这样开发人员可以更好的关注逻辑层的设计和测试，使得整个程序有个清晰的架构。


  默认情况下，MVC 项目包括以下文件夹：
    App_Data:       这是数据的物理存储区。此文件夹的作用与它在使用 Web 窗体页面的 ASP.NET 网站中的作用相同。
    Content:        建议在此位置添加内容文件，如级联样式表文件、图像等。通常，Content 文件夹用于存储静态文件。
    Controllers:    建议在此位置存储控制器。MVC 框架要求所有控制器的名称均以“Controller”结尾，如 HomeController、LoginController 或 ProductController。
    Models:         这是为表示 MVC Web 应用程序的应用程序模型的类提供的文件夹。此文件夹通常包括定义对象以及定义与数据存储交互所用的逻辑的代码。
                    通常，实际模型对象将位于单独的类库中。但是，在创建新应用程序时，您可以将类放在此处，然后在开发周期中稍后的某个时刻将其移动到单独的类库中。
    Scripts:        建议在此位置存储支持应用程序的脚本文件。默认情况下，此文件夹包含 ASP.NET AJAX 基础文件和 jQuery 库。
    Views:          建议在此位置存储视图。视图使用 ViewPage (.aspx)、ViewUserControl (.ascx) 和 ViewMasterPage (.master) 文件，以及与呈现视图相关的任何其他文件。
                    在 Views 文件夹中，每个控制器都具有一个文件夹；该文件夹以控制器名称前缀命名。例如，如果控制器名为 HomeController，则 Views 文件夹包含名为 Home 的文件夹。
                    默认情况下，当 ASP.NET MVC 框架加载视图时，它将在 Views\控制器名称 文件夹中寻找具有请求的视图名称的 ViewPage (.aspx) 文件。
                    默认情况下，Views 文件夹中也有一个名为 Shared 的文件夹，但该文件夹不与任何控制器相对应。Shared 文件夹用于存储在多个控制器之间共享的视图。例如，您可以将 Web 应用程序的母版页放在 Shared 文件夹中。

    除了使用前面列出的文件夹之外，MVC Web 应用程序还使用 Global.asax 文件中的代码来设置全局 URL 路由默认值，并且使用 Web.config 文件来配置应用程序。


  Controllers 控制展示:
    一般返回的是一个 ActionResult 类型的 View, 但是我们还需要建立与其对应的视图。
    不过, 可以直接返回一个字符串来展示, 就不需要视图页面了(页面上可以直接看到输出的字符串):
    将代码
        public ActionResult Index()
        {
            return View();
        }

    修改为
        public string Index()
        {
            var city = City(null); // 调用时,没有这参数也需要一个占位符
            return "Hello World";
        }

        // 获取参数
        public string City(long? ProvinceId)
        {
            // 没有这参数时,值为 null
            if (ProvinceId == null)
                return "";

            // 没有这参数时,设默认值为 0
            var pageIndex = ProvinceId ?? 0;
            // ...
        }


初识MVC的Url映射潜规则Routing
    在 ASP.NET 网站中，URL 通常映射到存储在磁盘上的文件(通常为 .aspx 文件)。 这些 .aspx 文件包括经过处理以响应请求的标记和代码。

    ASP.NET MVC 框架将 URL 映射到不同于 ASP.NET Web 窗体页面的服务器代码。
    该框架会将 URL 映射到 controller 类，而不是将 URL 映射到 ASP.NET 页面或处理程序。
    Controller 类将处理传入的请求，如用户输入和交互，并根据用户输入执行相应的应用程序和数据逻辑。
    Controller 类通常会调用一个生成 HTML 输出作为响应的单独视图组件。

    ASP.NET MVC 框架会将模型、视图和控制器组件分开。
    模型表示应用程序的业务/域逻辑，通常具有数据库支持的数据。
    视图由控制器进行选择，并呈现相应的 UI。 默认情况下，ASP.NET MVC 框架使用现有的 ASP.NET 页面 (.aspx)、母版页 (.master) 和用户控件 (.ascx) 类型呈现到浏览器。 控制器将在自身中查找相应的操作方法，获取要用作操作方法参数的值，并处理可能会在运行操作方法时发生的任何错误。 然后，它将呈现请求的视图。 默认情况下，每组组件都位于 MVC Web 应用程序项目的单独文件夹中。


下表列出了 MVC Web 项目的执行阶段。
        阶段                            详细信息
    接收对应用程序的第一个请求      在 Global.asax 文件中，Route 对象将添加到 RouteTable 对象中。
    执行路由                        UrlRoutingModule 模块使用 RouteTable 集合中第一个匹配的 Route 对象来创建 RouteData 对象，然后使用所创建的对象创建 RequestContext 对象。
    创建 MVC 请求处理程序           MvcRouteHandler 对象将创建 MvcHandler 类的实例，并将 RequestContext 实例传递给处理程序。
    创建控制器                      MvcHandler 对象使用 RequestContext 实例标识用于创建控制器实例的 IControllerFactory 对象(通常是 DefaultControllerFactory 类的实例)。
    执行控制器                      MvcHandler 实例调用控制器的 Execute 方法。
    调用操作                        对于从 ControllerBase 类继承的控制器，与该控制器关联的 ControllerActionInvoker 对象将调用 controller 类对应的操作方法。
    执行结果                        操作方法将接收用户输入，准备合适的响应数据，然后通过返回结果类型来执行结果。
                                    可执行的内置结果类型包括：ViewResult、RedirectToRouteResult、RedirectResult、ContentResult、JsonResult、FileResult 和 EmptyResult。



Razor 语法：
      语法                    Razor                               Web Forms对应写法或说明
    服务器端注释            @* 和 *@ 括起来                     <%-- 和 --%> 括起来
    代码块                  @{ int x=123; string y="b"; }       <%  int x = 123; string y = "because."; %>
    输出变量值              @x 和 @y                            <%= x %> 和 <%= y %>  输出前面定义的变量
    表达式(Html Encoded)    <span>@model.Message</span>         <span><%: model.Message %></span>
    表达式(Unencoded)       <p>@Html.Raw(model.Message)</p>     <p><%= model.Message %></p>
    电子邮件地址            Hi philha@example.com               说明： Razor 能认出基本的电子邮件格式，不会把 @ 当作代码分界符
    显式表达式              <span>@(a >= 0)</span>              说明： 这种情况下，需要对表达式使用圆括号
    取消转义 @ 符号         <span>the @@ display</span>         说明： @@ 表示 @
    混合表达式和文本        Hello @title. @name.                Hello <%: title %>. <%: name %>.
    切换成客户端代码        @:这一行，后面的都将直接输出


  混合代码、文本 和标签:
    foreach 语法：
    在 Web Forms 的语法写：
        <ul id='product'>
            <% foreach(var p in products) { %>
                <li>名称：<%= p.name %>&nbsp;&nbsp;价格：<%= p.price %></li>
            <% } %>
        </ul>
    在 Razor 的语法写：
        <ul id='product'>
            @foreach(var p in products) {
                <li>名称：@p.name &nbsp;&nbsp;价格：@p.price</li>
            }
        </ul>

    if 语句:
        @if(products.Count == 0) {
            <p>Sorry, no products</p>
        } else {
            <p>we have products for you!</p>
        }

    多行语句：
        @{
            int i = 0;
            string a = "aa";
        }

    @( ) 也有多行作用，但里面只能写表达式,不能有复杂的语句
    @Recall() 调用函数


Razor语法总结
    关于客户端代码和服务器端代码的灵活切换。

    0. 基本原则
        Razor模板默认是客户端代码(与php、aspx相同)
        任何客户端代码都可以内嵌服务器端代码
        行内服务器端代码不可内嵌客户端代码，多行服务器端代码可内嵌任何客户端代码
        @符号是关键符号，使用@从客户端代码向服务器端代码切换
        使用标签从服务器端代码向多行客户端代码切换，使用@:从服务器端代码向行内客户端代码切换

    1. 行内服务器端代码的几种形式
        @变量  例如：@User.Name，变量或属性结束后自动变回客户端代码，如遇结束判断有歧义，请加括号如下
        @( 表达式 )  例如：@(i + 1) 或 @(User.Name)
        @方法调用  例如：@Html.TextBox("username").ToString()

    2. 多行服务器端代码的几种形式
        @{ 代码块 }
        @if (条件) { 代码块 } else { 代码块 }
        @switch (条件) { 分支匹配代码块 }
        @for (循环控制) { 代码块 }
        @foreach (循环控制) { 代码块 }
        @while (循环控制) { 代码块 }
        @do { 代码块 } while (循环控制)

    3. 行内客户端代码的形式
        @:行内文字，对后面的整行都作为客户端代码处理，换行自动变回服务器端代码
        如：
        @{
            string name = "dd";
            @:打开主页 (这内容会直接输出到页面)
            name += "kkk";
            @name  // 这样可以直接输出这变量
            Response.Write(555); // 这样的输出会比整个页面还要前,而不是输出到当前位置
        }

    4. 多行客户端代码的几种形式
        任何标签对  例如：<div>多行文字</div>
        任何自闭合标签  例如：<img 多行属性 />
        纯文字使用伪标签<text>  例如：<text>多行文字，两侧标签不会被输出</text>

    5. 冲突解决
        电子邮箱可自动识别并输出  例如：hello@hotmail.com 会以文字形式正确输出
        误判的解决  例如：hello@User.Name 会误判为电子邮箱，应加括号解决，即：hello@(User.Name)
        非电子邮箱，则使用@@转义输出单个@
        如果内容文字中要输出，反斜杠“\”，可以在文字前放一个“@”，类似C#一样处理；如： @{ string a = @"dd\ff";}
        如果内容文字中要输出，双引号““””，可以将内容文字中的双引号重复一次。如： @{ string a = "dd""f";} 输出为： dd"f

    6. 预设指令符
        @model 指定视图使用的模型
        @section 指示开始一个节的定义
        @helper 定义一个HtmlHelper扩展

    7. 在@{...}内部使用注释
        @{
            //单行注释
            var i = 10;

            /*
             多行注释
             */

            @*
            多行注释 (这样内嵌是可以的)
            *@
            var j = 10; @* 注释 *@
        }

        @*
         多行注释 (在 @{} 的外部写,也是服务器端注释,不会输出到页面)
        *@

        若在 @{ 代码块 } 内部使用 <!-- --> 注释,则会输出到页面之中,如果在 <!-- --> 内部使用@变量,则会被处理
        @{
            <!-- time now: @DateTime.Now.ToString() -->
        }
        输出: <!-- time now: 4/9/2011 12:01 -->


    8. Classes
        参考： http://www.asp.net/webmatrix/tutorials/asp-net-web-pages-api-reference

       1) 类型转换
        AsBool(),AsBool(true | false)   // 将字符串转换成 布尔值, 如果该字符串不是 布尔值 则返回 false 或者指定的值
        AsInt(), AsInt(value)           // 将字符串转换成 整数, 如果该字符串不是 整形 则返回 0 或者指定的值
        AsFloat(),AsFloat(value)        // 将字符串转换成 浮点型, 如果该字符串不是 浮点型 则返回 0.0 或者指定的值
        AsDecimal(), AsDecimal(value)   // 将字符串转换成 十进制值, 如果该字符串不是 十进制值 则返回 0.0 或者指定的值
        AsDateTime(), AsDateTime(value) // 将字符串转换成 日期/时间类型, 如果该字符串不是 日期/时间类型 则返回 DateTime.MinValue 或者指定的值
        IsInt(), IsBool(), IsFloat(), IsDecimal(), IsDateTime()  // 如果该字符串可以转换成指定的类型则返回true
        ToString()

        例:
            @{ var i = "1999/03/07 12:30"; }
            <p> @i.AsDateTime() </p> <!-- 输出: 1999-03-07 12:30:00 -->

            @{ string a = "1999"; var b = "kk"; }
            <p> @a.AsInt(55) </p> <!-- 输出: 1999 -->
            <p> @b.AsInt(55) </p> <!-- 输出: 55 -->
            <p> @b.AsInt() </p> <!-- 输出: 0 -->

            @{ var boo = "false"; }
            <p> @boo.IsBool() </p> <!-- 输出: True -->

       2) URL 处理
        @Url.Content(), @Href()  // 输出匹配的 url, “~”是指虚拟目录, @Url.Content() 输出绝对路径, @Href() 输出相对路径
            <link href='@Url.Content("~/Content/Site.css")' rel="stylesheet" type="text/css" />
            <a href='@Href("~/Folder/File")'>Link to My File</a>
            <a href='@Href("~/Folder", "File")'>Link to My File</a> 与上句结果一样

       3) 转码
        Html.Raw(value)  // 将 html 编码原样输出,而不转码
        例:
            @{ var name = "<div>"; }
            <p> @name </p> <!-- 输出: &lt;div&gt; -->
            <p> @Html.Raw(name) </p> <!-- 输出: <div> -->

       4) 判断是否为空
        IsEmpty()  // 如果没有值,则返回true
        例: @if (Request["companyname"].IsEmpty()) {
               @:Company name is required.<br />
            }

       5) 判断是否 Post 请求
        IsPost 变量,如果是 post 请求则返回 true, 否则返回 false 。默认请求是 GET
        例: @if (IsPost) { Response.Redirect("Posted"); } else { Response.Redirect("Geted"); } // 这里如果是 post 请求则页面跳转

       6) 母板 与 子板
        Layout 变量指定母板(用于子板, 不写则使用默认的)。
        RenderBody()  显示子板的内容(用于母板)

        如：
            @{
                Layout = "~/Views/Shared/_Layout.cshtml";
            }

       7) 页面变量
        PageData[key], PageData[index], Page
        例：
            @{
                PageData["FavoriteColor"] = "red";
                PageData[1] = "apples";
                Page.MyGreeting = "Good morning";
            }
            @Page[1]        <!-- 显示 PageData[1] -->
            @PageData[1]    <!-- 显示 PageData[1] -->
            @Page["FavoriteColor"]      <!-- 显示 PageData["FavoriteColor"] -->
            @PageData["FavoriteColor"]  <!-- 显示 PageData["FavoriteColor"] -->
            @Page.MyGreeting  <!-- 显示 Page.MyGreeting -->

       8) 包括另一页面
        RenderPage(path, values)
        RenderPage(path[, param1 [, param2]])
        Html.Partial(path)

        例：
            @RenderPage("about.cshtml", "red", 123, "apples")
            @RenderPage("about.cshtml", new { color = "red", number = 123, food = "apples" })
            @Html.Partial("../Home/About")  // 包含某页面,参数是页面路径


    10.常用变量
        @Html.ActionLink("关于", "About", "Home")  // 生成一个 A 标签,如: <a href="/Home/About">关于</a>


    11.@model 用来指定传到视图的 Model 类型
        在 Controllers 里面的代码：
            public class HomeController : Controller
            {
                public ActionResult Index()
                {
                    var cars = new Car().ToList();
                    return View(car);
                }
            }

        在页面上的代码：
            @model IList<Sample.Models.Car>

            <ul>
                @foreach(var car in Model) {
                    <li>@car.name</li>
                }
            </ul>


    11.@helper 自定义一段被页面调用的代码
        在页面上的代码：
            <!-- 自定义一个页面函数 -->
            @helper ShowPost(WarningResult item)
            {
                <div class="yuqing_c_box">
                    <div class="yuqing_c_box_t">
                        <span class="yuqing_c_c">@item.Summary</span>
                        <div class="yuqing_c_bottom">
                            @{
                                bool hasImg = !item.Equals("javascript:void(0);");
                                if (hasImg || !("网友".Equals(item.Author)))
                                {
                                    if (hasImg)
                                    {
                                <img src="@Url.Content(item.ImageUrl)" alt="" />
                                    }
                                <span>@string.Format("{0}从{1}发表", item.Author, item.Source)</span>
                                }
                                else
                                {
                                <span>来源：<label>@item.Source</label></span>
                                }
                            }
                            <span>@item.PublishOn.ToString("yyyy-MM-dd HH:mm")</span>
                        </div>
                        <div class="clear">
                        </div>
                    </div>
                </div>
            }

            <!-- 调用自定义的函数 -->
            <div class="yuqing_c">
                @if (items != null && items.Count > 0)
                {
                    for (int i = 0; i < items.Count; i++)
                    {
                        @ShowPost(items[i])
                    }
                }
            </div>
            <div class="yuqing_c yuqing_c_mar">
                @if (items != null && items.Count > 0)
                {
                    for (int i = 0; i < items.Count; i++)
                    {
                        @ShowPost(items[i])
                    }
                }
            </div>



    对于整个站点可以一次性设定默认项目，例如布局。
    Html.Raw 方法提供了没有进行 HTML 编码的输出
    支持在多个视图之间共享代码 ( _viewstart.cshtml 或者 _viewstart.vbhtml )

    Razor 还包含新的  HTML Helper，例如：
    Chart. 生成图表
    WebGrid, 生成数据表格，支持完整的分页和排序
    Crypto，使用 Hash 算法来创建 Hash 和加盐的口令
    WebImage, 生成图片
    WebMail, 发送电子邮件


使用 Controller/Action
  ActionResult 返回类型
    大多数操作方法会返回从 ActionResult 中派生的类的实例。 ActionResult 类是所有操作结果的基础。 不过，也存在不同的操作结果类型，具体取决于操作方法执行的任务。
    例如，最常见的操作是调用 View 方法。 View 方法返回从 ActionResult 中派生的 ViewResult 类的实例。
    您可以创建返回任意类型(如字符串、整数或布尔值)的对象的操作方法。 这些返回类型在呈现到响应流之前包装在合适的 ActionResult 类型中。
    下表显示了内置操作结果类型以及返回这些类型的操作帮助器方法。

    操作结果                帮助器方法          描述
    ViewResult              View                将视图呈现为网页。
    PartialViewResult       PartialView         呈现分部视图，该分部视图定义可呈现在另一视图内的某视图的一部分。
    RedirectResult          Redirect            使用其 URL 重定向到另一操作方法。
    RedirectToRouteResult   RedirectToAction    重定向到另一操作方法。
                            RedirectToRoute
    ContentResult           Content             返回用户定义的内容类型。
    JsonResult              Json                返回序列化的 JSON 对象。
    JavaScriptResult        JavaScript          返回可在客户端上执行的脚本。
    FileResult              File                返回要写入响应中的二进制输出。
    EmptyResult             (无)                表示在操作方法必须返回 null 结果 (void) 的情况下所使用的返回值。





