
1. 格式化字符串输出
     string.Format("log: {0} = {1}", Name, Value);
     其中 {0} 将替换成后面的第一个参数,{1}是第二个,以此类推
     需要输出大括号的时候，有3种方式：
     1. 使用双大括号代替一个大括号,如: string a = string.Format("{{hello}} {0},{1}", "nbwl", "wgzy2011"); //输出: {hello} nbwl,wgzy2011
     2. 以传参来做,如: string a = string.Format("{2}hello{3} {0},{1}", "nbwl", "wgzy2011", "{", "}"); //输出同上

2. 字符串拼接
     大量字符串拼接时,使用简单字符串的“+”运算,效率会非常低下,解决方案：
     1)  用 StringBuilder, 注意的是 StringBuilder 初始化(实例对象创建花费时间较长)较费资源, 一旦启动后效率很高,适合大数据量
         用例：
         using System.Text;
         StringBuilder sb = new StringBuilder();
         sb.Append("内容1");
         sb.Append("内容2");
         return sb.ToString();
     2) string[] arr = new string[n]; 将所有的字符串置入一个数组,这样可以减少内存分配的次数,适合大数据量
     3) 使用 字符串的 “+”或者“+=”运算,(使用“+=”会效率更高一些)
        这种在小数据量时效率较高,不适合大数据量,因为该操作必须分配很多的内存,然后复制,内存分配和复制是非常耗费资源和时间的,如:
        string s;
        s="aaa";
        s+="bbb";
        s+="ccc";
     4) 将多次重复不变的数据定义为常量,然后然后根据字符串的连接数据量来决定使用那种连接方法, 这种是最佳的字符串连接方案
        const string CONSTSTRING1 = "<TABLE>";
        StringBuilder sb = new StringBuilder();
        sb.Append(CONSTSTRING1);
        sb.Append("内容1");
        sb.Append("内容2");
        ...

        或者
        string str = CONSTSTRING1
        str += "内容1";
        str += "内容2";

3. 字符串截取
     String.Substring (int start)   // 从指定的字符位置开始截取,直到最后。(字符位置从0算始,包括起始字符)
     String.Substring (int start, int length)   // 从指定的字符位置开始截取,取到指定的长度。
     如:
        string s = "Hello C# World!";
        string s0 = s.Substring(0); // 不变
        string s1 = s.Substring(3); // 结果为: lo C# World!
        string s2 = s.Substring(6, 2); // 结果为: C#

    字符串比较
        string strA = "Hello";
        string strB = string.Copy(strA);    // 创建两个不同的实例,但他们的值相等
        Console.WriteLine(strA == strB);    //True, 双等号跟 Equals 功能一样了
        Console.WriteLine(strA.Equals(strB));   //True
        Console.WriteLine(object.Equals(strA, strB));   //True
        Console.WriteLine(object.ReferenceEquals(strA, strB));  //False, 他们是不同实例

4. 转码/解码
     string str = System.Web.HttpUtility.UrlEncode("<div>哈哈</div>"); // 结果: %3cdiv%3e%e5%93%88%e5%93%88%3c%2fdiv%3e
     string url = System.Web.HttpUtility.UrlDecode(str); // 解码回正常字符串
     //由于web端有安全验证，所有输入的特殊符号会报错，转码和解码就很有必要了(页面上用js的 encodeURIComponent 转码,服务器端用 HttpUtility.UrlDecode 解码)

4.1.UrlEncode
      Response.Redirect("/user/login.aspx?burl=" + Server.UrlEncode(Request.Url.ToString()));

5. “@”字符串
      @"字符串"  这种格式的字符串，斜杠没有转义符功能，编写正则表达式时非常方便。还可以多行编写。
      如果这种字符串中需要用到双引号，则这样写: @"string1""string2"  //字符串中两个双引号表示一个双引号

6. 判断 Unicode 编码
    /// <summary>
    /// 判断字符串里面是否有 Unicode 编码
    /// </summary>
    /// <param name="str"></param>
    /// <returns>有 Unicode 则返回 true, 否则返回 false</returns>
    public bool HasUnicode(string str)
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

7. 判断 中文 编码
    /// <summary>
    /// 判断字符串里面是否有中文(不包括中文符号)
    /// </summary>
    /// <param name="input"></param>
    /// <returns>字符串中包含中文则为 true, 否则为 false</returns>
    private bool HasChinese(string input)
    {
        int code = 0;
        int chfrom = Convert.ToInt32("4e00", 16);    //范围（0x4e00～0x9fff）转换成int（chfrom～chend）
        int chend = Convert.ToInt32("9fff", 16);
        if (!string.IsNullOrEmpty(input))
        {
            for (int i = 0; i < input.Length; i++)
            {
                code = Char.ConvertToUtf32(input, i);    //获得字符串input中指定索引index处字符unicode编码
                if (code >= chfrom && code <= chend)
                {
                    return true;     //当code在中文范围内返回true
                }
            }
        }
        // 整个字符串都不包含中文
        return false;
    }

