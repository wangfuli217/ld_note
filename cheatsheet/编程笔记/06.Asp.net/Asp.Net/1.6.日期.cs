
1. 日期格式化
    string date = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff");
    DateTime date1 = DateTime.Parse("2012-02-01"); // 直接将字符串反序列化成时间,但需要用标准格式
    DateTime date2 = DateTime.ParseExact("20120201", "yyyyMMdd", null); // 遇到不是标准格式的字符串,需要自己指定格式再转成时间


2. 时间运算
    DateTime d1 = DateTime.Now.AddDays(1); // 一天后
    DateTime d2 = DateTime.Now.AddDays(-1); // 一天前
    double days = d1.Subtract(d2).TotalDays; // 返回日期差

