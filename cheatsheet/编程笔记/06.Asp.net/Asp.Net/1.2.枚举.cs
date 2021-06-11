
1. 枚举类的定义:
    public enum LogActionEnum
    {
        /// <summary>
        /// 不限
        /// </summary>
        None=0,
        /// <summary>
        /// 添加
        /// </summary>
        Add = 1,
        /// <summary>
        /// 修改
        /// </summary>
        Update = 2,
        /// <summary>
        /// 删除
        /// </summary>
        Delete = 3,
        /// <summary>
        /// 查看
        /// </summary>
        View = 4,
        /// <summary>
        /// 其他
        /// </summary>
        Other = 5
    }


2. 枚举 和 int 之间的相互转换
    1) 把 枚举 转换成 int, 枚举可以默认转换为int，或者来一个Int强制转换就OK了，比如 (int)MyEnum
    2) 把 int 转成 枚举,如下写法，注意 int 值要用字符串类型，而不是直接 int, 像下面的"2"
       (LogActionEnum) Enum.Parse(typeof(LogActionEnum),"2")
       (LogActionEnum) Enum.Parse(typeof(LogActionEnum),"name") // 这里写枚举的值的字符串也可以
    3) 获取 枚举 的值的字符串
       Enum.GetName(typeof(LogActionEnum),2); // 2 是对应这枚举的值，返回对应枚举值的字符串

