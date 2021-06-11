
1. 控件不能遗漏 runat="server" 字样，而且所有的WEB控件都要包含在<form runat="server"></form>中间
    下面看一个完整的例子，在程序里面修改Label的Text属性，以此改变网页的显示。
    <%@ Page Language="C#" AutoEventWireup="true"%>
    <%@ Import Namespace="System.Collections.Generic"%>
    <%@ Import Namespace="Com.Everunion.Sysmgr"%>
    <%@ Import Namespace="Com.Everunion.Sysmgr.Dao"%>
    <%@ Import Namespace="Com.Everunion.Util"%>
    <%@ Import Namespace="NHibernate"%>
    <script runat="server" language="c#">
      // <asp:Button> 控件的onclick事件
      void Counter(object sender, EventArgs e)
      {
          if ( "Clicked" == Button1.Text )
            Button1.Text = "UnClicked";
          else
            Button1.Text = "Clicked";
      }

      void Page_Load()
      {
          // 给 ID="Label1" 的控件赋值
          Label1.Text = "Label1 Message";
          // 给 ID="TextBox1" 的控件赋值。在 html 上生成“value="hello"”
          TextBox1.Text = "hello";
          // 文本框可以添加的最多的字符数（多行文本框无效）；在 htnl 上生成“maxlength="6"”
          TextBox1.MaxLength = 6;
          // 设置只读属性，在 html 上生成“readonly="readonly"”
          TextBox1.ReadOnly = true;
      }
    </script>
    <html xmlns="http://www.w3.org/1999/xhtml">
    <head><title>Label.aspx</title></head>
    <body>
      <form id="Form1" runat="server">
            <!-- 生成：<span id="Label1">Label1 Message</span> -->
          <asp:Label ID="Label1" runat="server"/><br />
            <!-- 生成：<input name="TextBox1" type="text" id="TextBox1" /> -->
          <asp:TextBox ID="TextBox1" runat="server"/><br />
            <!-- 生成：<input type="submit" name="Button1" value="UnClicked" id="Button1" /> -->
          <asp:Button ID="Button1" Text="UnClicked" runat="server" OnClick="Counter"/><br />
            <!-- 生成：<input type="image" name="ImageButton1" id="ImageButton1" src="" /> -->
          <asp:ImageButton ID="ImageButton1" runat="server" /><br />
            <!-- 生成：<a id="LinkButton1" href="javascript:__doPostBack('LinkButton1','')">LinkButton</a> -->
          <asp:LinkButton ID="LinkButton1" runat="server">LinkButton</asp:LinkButton><br />
      </form>
    </body>
    </html>


2. WEB控件 验证
    <asp:textbox id="username" runat="server" cssclass="textbox"/>
    <asp:requiredfieldvalidator ID="reg" controltovalidate="username"
     display="dynamic" forecolor="#ff0000" font-name="宋体" font-size="9pt" text="请填写" runat="server"/>

    这是检验表单控件，验证有没有填写。
    controltovalidate就是你想检验的控件的ID；
    默认情况下不显示错误消息，地方也会被保留，如果使用了display="dynamic" 那么不显示错误消息的地方不会被空出；
    forecolor="#ff0000" font-name="宋体" font-size="9pt" 就是设定错误消息字体的颜色，字体，大小的；
    text="请填写" 就是当没有填写内容时候显示的错误消息；别忘记最后的runat="server"。
    现在这个检验控件是放在了textbox的后面，那么错误消息也在textbox后面显示，也可以放在其他地方。
    生成的 html 如下：
    <span id="reg" style="color:Red;font-family:宋体;font-size:9pt;display:none;">请填写</span>

    // 下面是 没填写验证 + 比较验证
    <asp:textbox id="password1" runat="server" textmode="password" cssclass="textbox"/>
    <asp:requiredfieldvalidator controltovalidate="password1" text="请填写" runat="server"/>
    <asp:textbox id="password2" runat="server" textmode="password" cssclass="textbox"/>
    <asp:requiredfieldvalidator controltovalidate="password2" text="请填写" runat="server"/>
    <asp:comparevalidator controltovalidate="password2" controltocompare="password1" operator="equal" text="确认失败" runat="server"/>

    在<asp:comparevalidator>中的 controltocompare="password1" 就是需要比较的控件；
    operator="equal" 就是设定比较操作是：是否相等（还有NotEqual：不相等,LessThan：少于,GreaterThan：大于，当不符合这个比较操作的时候显示错误消息）。

3. 下拉菜单
    1.有： ListBox 控件 和 DropDownList 控件。功能几乎是一样，只是 ListBox 控件是一次将所有的选项都显示出来。
      SelectionMode属性可以设置是单选还是多选，默认是Single。
      ListBox 控件中的可选项目是通过 ListItem 元素定义的。
    2.语法：
      <ASP:ListBox Id="控件名称" Runat="Server" AutoPostBack="True | False" DataSource="<%数据源%>"
          DataTextField="数据源的字段" DataValueField="数据源的字段" Rows="一次要显示的列数"
          SelectionMode="Single | Multiple" OnSelectedIndexChanged="事件程序名称" >
          <ASP:ListItem Value="1" Enabled="True | False" Selected="True | False">text内容</ASP:ListItem>
      </ASP:ListBox>
      注：在 ListItem 里面还有一个 Text 属性，可指定显示的内容；同时使用 Text 属性和写“text内容”，显示“text内容”。
      同时不写 Text 属性和“text内容”，显示 Value 属性值；如果连 Value 也没有，则显示空白选项。


4. 补充说明的地方
    1.每一个可以显示的控件都有是否显示的属性，比如username.Visible=false;就是隐藏了前面的username控件；
    2.如果要对控件应用CSS的话就这么写：cssclass=""，而不是 HTML 中的class=""。


使用摘录:
    1.修改 <asp:TextBox>标签 的值
      由于 <asp:TextBox>标签 里面无法用 <% %> ，所以不能像下面这样：
      <asp:TextBox ID="PartnerName" runat="server" checkType="R" mess="请选择<%= ParamType == 1 ? "客戶" : "廠商" %>" >
      而可以这样：
      <asp:TextBox ID="PartnerName" runat="server" checkType="R" >
      然后在 Page_Load 方法里面写：
      PartnerName.Attributes.Add("mess", "请选择" + (ParamType == 1 ? "客戶" : "供货厂商"));

    2.页面
        Default.aspx 相当于 index.jsp
            在 aspx 的页面上写代码，如：
            <% Response.Write("Hello World!"); %>
            <%= "Hello World!" %> 则直接在页面上打印出内容

        Default.aspx.cs 相当于 **.java 供页面调用

        Default.aspx.cs 里面的 “Page_Load”方法
            protected void Page_Load(object sender, EventArgs e)
            {
              // 页面上打印内容
                Response.Write("5566655");
            }
        在“Default.aspx”加载时先运行，然后再运行“Default.aspx”
        在“Default.aspx”里面的 <%@ Page Language="C#" CodeFile="Default.aspx.cs" %>
        CodeFile 属性指明 cs 加载文件



    3. 控件 RichTextBox :
        使 RichTextBox 的垂直滚动条一直位于底部
        方法一：
            (没有获得焦点时屏幕照样会滚。这是做聊天软件的最佳方案)
            richTextBox1.HideSelection = false;
            再用 richTextBox1.AppendText(string message) 方法增加内容
            如果用 richTextBox1.Text += string; 方法增加内容,则没有一直位于底部的效果
        方法二：
            this.richTextBox1.Focus();
            this.richTextBox1.Select(historyRichTextBox.TextLength,0);
            this.richTextBox1.ScrollToCaret();
        方法三：
            (该方法比较简单，但是有个问题，就是会让当前焦点处于richTextBox中，这在很多情况下是我们不愿意看到的)
            private void richTextBox1_TextChanged(object sender, EventArgs e)
            {
                richTextBox1.SelectionStart = richTextBox1.Text.Length;
                richTextBox1.Focus();
            }


    4. 控件定位:
        控件的位置默认与上、左对齐
        以浏览器为例,即: webBrowser1.Anchor = AnchorStyles.Top | AnchorStyles.Left;
        若要浏览器的大小随上下左右变化，可: webBrowser1.Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right;
        同时设置 Top 和 Bottom, 或者同时设置 Left 和 Right, 则会让大小也变化
        若只需控制位置,  Top 和 Bottom 只能选一个, 同理 Left 和 Right 只能选一个
        如,某按钮的位置始终保持在右下角: button1.Anchor = AnchorStyles.Bottom | AnchorStyles.Right;


    5. 设置下拉选单只读
        要令下拉选单只读,即只可以选取原本下拉选单里的内容,不可以编辑(原本是可以编辑的)
        comboBox1.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;

    6. 设置控件颜色:
        背景颜色:
        richTextBox1.BackColor = System.Drawing.Color.White;
        richTextBox1.BackColor = System.Drawing.Color.FromRGB(100,100,100);


    7. 菜单栏控件, 快捷方式
        菜单的Text属性改成:“菜单名称(&A)”这样“A”就成为快捷方式了, 显示成:“菜单名称(A)”,
        使用快捷方式: 按下“Alt” + 快捷方式的字母


    8. 打开窗口,控制窗口的大小
       在加载完网页后的事件里面写代码,获得网页宽高同时调整Form窗体大小:
       void wb_DocumentCompleted(object sender, WebBrowserDocumentCompletedEventArgs e)
       {
           int width=wb.Document.ScrollWidth;
           int height=wb.Document.ScrollHeight;
           this.Form1.Size=new Size(width,height);
       }

