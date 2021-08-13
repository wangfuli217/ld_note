
一、LINQ的概念：
    LINQ是Language Integrated Query（语言集成查询）的简称，它是集成在.NET编程语言中的一种特性,这使得查询表达式可以得到很好的编译时语法检查。
    传统上，针对数据的查询都是以简单的字符串表示，而没有编译时类型检查或 IntelliSense 支持。此外，您还必须针对以下各种数据源学习不同的查询语言：SQL 数据库、XML 文档、各种 Web 服务等。
    LINQ 使查询成为 C# 和 Visual Basic 中的一等语言构造。您可以使用语言关键字和熟悉的运算符针对强类型化对象集合编写查询。


二、LINQ 的使用
    一. LINQ to Objects
        只要实现了IEnumerable或IEnumerable接口，就都支持。

    二. LINQ to SQL(ADO.NET)
        ◆LINQ to DataSet、LINQ to SQL 和 LINQ to Entities。
        ◆LINQ to DataSet 提供对 DataSet 的更为丰富的优化查询。
        ◆LINQ to SQL 可以直接查询 SQL Server 数据库架构。
        ◆LINQ to Entities 可以查询实体数据模型。

    三. LINQ to XML
        LINQ可以看作对foreach循环的改进：
        1.它们更简明、更易读，尤其在筛选多个条件时。
        2.它们使用最少的应用程序代码提供强大的筛选、排序和分组功能。
        3.无需修改或只需做很小的修改即可将它们移植到其他数据源。通常，您要对数据执行的操作越复杂，您体会到的使用 LINQ 代替传统迭代技术的好处就越多。

    四.LINQ to SQL:
        1. LINQ要求数据库表必须有主键。
        2. 做update操作时，生成的sql语句中where条件中不仅包括主键id=？，而且包括表中各列 and column2=? and   column3=?。。。
           这是LINQ自动生成SQL语句的严谨所在，这是为了防止并发情况下，多个事务针对同一条记录更新时发生错误，假如A事务更新了该记录，则B事务更新会失败。
        3. update不能更新主键。
        4. skip().take()生成的sql实际就是: select count(*) from,    以及 row_num()来实现分页。
        5. 效率没有直接使用T-SQL高，感觉适合于中小规模的，数据量不是特别大的开发中。而且其与asp.net中的一些控件的结合使用可能不是很方便。
        6. 不如使用T-SQL灵活，尤其是查询比较复杂，多表联接，使用case函数等。


三、LinQ 是利用泛型对数据进行操作
    实例一:
        int[] number = new int[] { 1, 3, 2, 4, 5, 6, 7 };
        var n = from nb in number where (nb > 3) select nb;
        foreach (var i in n)
        {
            Console.WriteLine(i);
        }
        // 输出的结果是：4567.

    实例二：
        // 模拟的一个实体类person.cs
        public class person
        {
            public string name { get; set; }
            public int age { get; set; }
            public string sex { get; set; }
        }

        // 接下来我们在页面上运行如下代码
        List<person> plist = new List<person>();
        plist.Add(new person { name = "cxx1", age = 24, sex = "男" });
        plist.Add(new person { name = "cxx2", age = 25, sex = "男" });
        plist.Add(new person { name = "cxx3", age = 26, sex = "男" });
        plist.Add(new person { name = "cxx4", age = 21, sex = "女" });

        List<person> plist2 = new List<person>();
        plist2.Add(new person { name = "cxx1", age = 24, sex = "男" });
        plist2.Add(new person { name = "cxx2", age = 28, sex = "男" });
        plist2.Add(new person { name = "cxx4", age = 27, sex = "男" });
        plist2.Add(new person { name = "cxx5", age = 28, sex = "男" });

        // 查询出所有
        var select = from person p in plist select p;
        // LINQ也和SQL类似，提供了where的查询条件。 这里要查询年龄为24的数据：
        var select = from person p in plist where (p.age.Equals(24))  select p;


    只获取一个实体类：
        var select = from person p in plist select p;
        var p = select.FirstOrDefault();


    排序：
        // 1.顺序,直接 orderby
        var select = from person p in plist where (1 == 1) orderby p.age select p;
        // 2.descending是降序
        var select = from person p in plist where (1 == 1) orderby p.age descending select p;
        // 3.thenby 排序，先按照年龄降序，如果相同，就按照名称降序
        select = select.OrderByDescending(p => p.age).ThenByDescending(p => p.name);


    多条件查询:
        // 1. 多个 where (这种方式可以使用if判断, 更加方便)
        var select = from person p in plist select p;
        select = select.Where(p => p.name == "ddd");
        select = select.Where(p => p.age >= 25);

        // 2. 用 && 连接多个条件
        var select = from person p in plist where p.name == "ddd" && p.age >= 25 select p;


    in 查询:
        int[] ages = new int[]{25, 26, 27, 28};
        var select = from person p in plist select p;
        // 使用数组的 Contains 方法, 代替 in 查询
        select = select.Where(p => ages.Contains(p.age));

        // not in 查询: 在 in 的前面加上“非”即可
        select = select.Where(p => !ages.Contains(p.age));


    like 查询:
        string name = "a";
        var select = from person p in plist select p;
        // 使用字符串的 Contains 方法, 代替 like 查询
        // 这里得注意: 不支持字符串的 IndexOf 方法,这写法会出错： select.Where(p => p.name.IndexOf(name) >= 0);
        select = select.Where(p => p.name.Contains(name));


    分页：
        var select = from person p in plist select p;
        // 查询条件
        select = select.Where(p => p.age >= 25);
        // 总条数
        int count = select.Count();
        // 当前页
        int pageIndex = 1;
        // 每页多少
        int pageSize = 10;
        // 共多少页
        int endPage = (count + pageSize -1) / pageSize;
        // 分页查询:  Skip 代表的是从第几条数据开始算起； Take代表的是每页的产生的条数。
        var list = select.Skip((pageIndex - 1) * pageSize).Take(pageSize);


    group by(分组查询)：
        // 单个分组条件
        var query = from person m in plist
            group m by m.sex into g  // 根据 sex 分组
            select new
            {
                g.Key,
                sumAge = g == null ? 0 : g.Sum(a => a.age), // sum
                maxAge = g == null ? 0 : g.Max(a => a.age), // max
                mixAge = g == null ? 0 : g.Min(a => a.age), // min
                avgAge = g == null ? 0 : g.Average(a => Convert.ToInt32(a.age)) // avg
            };
        /* 结果如：
            { Key : "男", sumAge : 75, maxAge : 26, mixAge : 24, avgAge : 25.0 },
            { Key : "女", sumAge : 21, maxAge : 21, mixAge : 21, avgAge : 21.0 }
         */

        // 多个分组条件
        var query = from person m in plist2
            group m by new { m.age, m.sex } into g  // 根据 age, sex 分组
            select new
            {
               age = g.Key.age,
               sex = g.Key.sex,
               name = g == null ? "暂无数据" : g.Max(a => a.name) // 取数据时需要用聚合函数来取
            };
        /* 结果如：
            { age : 24, sex : "男", name : "cxx1" },
            { age : 28, sex : "男", name : "cxx5" },
            { age : 27, sex : "男", name : "cxx4" }
         */


    多表查询：
        var query = from person p in plist
            join person per in plist2 // join两个表
            on p.name equals per.name // join的条件(name相等)
            select new
            {
                名称 = p.name, // 这里可以使用 p 和 per 的值
                性别 = p.sex,
                年龄 = p.age
            };

        /* 结果如：
            { 名称 : "cxx1", 性别 : "男", 年龄 : 24 },
            { 名称 : "cxx2", 性别 : "男", 年龄 : 25 },
            { 名称 : "cxx4", 性别 : "女", 年龄 : 21 }
         */


    多表查询(left jion)：
        var query = from person p in plist
            join person per in plist2
            on p.name equals per.name into joinm
            from j in joinm.DefaultIfEmpty() // plist2 允许没有对应的值,此时 j 为 null
            select new
            {
                名称 = p.name, // 这里可以使用 p 和 j 的值, per 无效(被 j 替代了), 但使用 j 时必须判断是否为空, 因为它是 left join,可以为null值
                性别 = j == null ? "暂无数据" : j.sex,
                年龄 = j == null ? 0 : j.age
            };

        /* 结果如：
            { 名称 : "cxx1", 性别 : "男", 年龄 : 24 },
            { 名称 : "cxx2", 性别 : "男", 年龄 : 28 },
            { 名称 : "cxx3", 性别 : "暂无数据", 年龄 : 0 }, // 此时 plist2 里面没有对应的值
            { 名称 : "cxx4", 性别 : "男", 年龄 : 27 }
         */


http://blog.csdn.net/cxx2325938/article/details/5736726


using System;
using System.Linq;
using System.Linq.Expressions;
using System.Collections.Generic;


public static class PredicateBuilder
{
    public static Expression<Func<T, bool>> True<T>()
    {
        return f => true;
    }

    public static Expression<Func<T, bool>> False<T>()
    {
        return f => false;
    }

    public static Expression<Func<T, bool>> Or<T>(this Expression<Func<T, bool>> expr1, Expression<Func<T, bool>> expr2)
    {
        var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
        return Expression.Lambda<Func<T, bool>>(Expression.Or(expr1.Body, invokedExpr), expr1.Parameters);
    }

    public static Expression<Func<T, bool>> And<T>(this Expression<Func<T, bool>> expr1, Expression<Func<T, bool>> expr2)
    {
        var invokedExpr = Expression.Invoke(expr2, expr1.Parameters.Cast<Expression>());
        return Expression.Lambda<Func<T, bool>>(Expression.And(expr1.Body, invokedExpr), expr1.Parameters);
    }
}




