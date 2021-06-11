
命名空间: System.Reflection
程序集:mscorlib (在 mscorlib.dll 中)


1. 反射类中所有字段，属性，方法
    a. 先看看类的结构
    public class People //类名
    {
        public static string name; //字段(Field)

        string sex; //字段(Field)

        public string Sex //属性 (Property)
        {
            get { return sex; } // (Method)
            set { sex = value; } // (Method)
        }

        private static string Name //属性 (Property)
        {
            get { return People.name; } // (Method)
            set { People.name = value; } // (Method)
        }

        public People(){} //构造函数(Constructor)
        public People(string name, string sex) //构造函数(Constructor)
        {
            People.name = name;
            this.sex = sex;
        }

        public string GetMyName(string defaultName) // 函数(Method)
        {
            if (string.IsNullOrEmpty(name))
            {
                name = defaultName;
            }
            return name;
        }
        private static string GetMyName2<T, U>() // 函数(Method, Member)
        {
            return "my name";
        }
    }

    // 测试类
    using System;
    using System.Reflection;

    public class ProgramTest
    {
        static void Main(string[] args)
        {
            Type t = typeof(People);
            ShowClass(t);

            Console.WriteLine("运行完毕！");
            Console.ReadLine();
        }

        /// <summary>
        /// 反射出一个类的内容
        /// </summary>
        /// <param name="ClassFullName">要反射的类型的全名(包括命名空间)</param>
        public static void ShowClass(string ClassFullName)
        {
            if (string.IsNullOrEmpty(ClassFullName)) return;
            Type t = Type.GetType(ClassFullName);
            ShowClass(t);
        }

        /// <summary>
        /// 反射出一个类的内容
        /// </summary>
        /// <param name="t">要反射的类型</param>
        public static void ShowClass(Type t)
        {
            // 查询标志
            BindingFlags flags = BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance | BindingFlags.Static | BindingFlags.DeclaredOnly;

            // 函数(Method)
            Console.WriteLine("---------------- Method ------------------");
            MethodInfo[] methods = t.GetMethods(flags);
            foreach (MethodInfo method in methods)
            {
                string des = method.IsPublic ? "Public " : (method.IsPrivate ? "Private " : ""); // 可见性
                des += method.IsStatic ? "Static " : ""; // 静态
                des += GetTypeName(method.ReturnType); // 返回类型
                des += method.Name; // 函数名
                // 泛型
                if (method.IsGenericMethod)
                {
                    des += "<";
                    Type[] ts = method.GetGenericArguments();
                    for (int i = 0; i < ts.Length; i++)
                    {
                        var o = ts[i];
                        des += o.Name;
                        if (i < ts.Length - 1) des += ", ";
                    }
                    des += ">";
                }
                // 参数列表
                des += "(";
                ParameterInfo[] ps = method.GetParameters();
                for (int i = 0; i < ps.Length; i++)
                {
                    var p = ps[i];
                    des += GetTypeName(p.ParameterType) + " " + p.Name;
                    if (i < ps.Length - 1) des += ", ";
                }
                des += ")";
                Console.WriteLine("Method:" + des);
                //Console.WriteLine("Method:" + method);
            }

            // 字段(Field)
            Console.WriteLine("--------------- Field -------------------");
            FieldInfo[] fields = t.GetFields(flags);
            foreach (FieldInfo field in fields)
            {
                string des = field.IsPublic ? "Public " : (field.IsPrivate ? "Private " : ""); // 可见性
                des += field.IsStatic ? "Static " : ""; // 静态
                des += GetTypeName(field.FieldType) + " "; // 字段类型
                des += field.Name; // 字段名
                Console.WriteLine("Field:" + des);
                //Console.WriteLine("Field:" + field);
            }

            // 属性(Property)
            Console.WriteLine("-------------- Property --------------------");
            PropertyInfo[] properties = t.GetProperties(flags);
            foreach (PropertyInfo property in properties)
            {
                Type ptype = property.PropertyType;
                string des = string.Empty;
                //string des = property.IsPublic ? "Public " : (property.IsPrivate ? "Private " : ""); // 可见性
                //des += property.IsStatic ? "Static " : ""; // 静态
                des += GetTypeName(ptype) + " "; // 字段类型
                des += property.Name; // 字段名
                des += " {";
                des += property.CanRead ? " get; " : "";
                des += property.CanWrite ? " set; " : "";
                des += "}";
                Console.WriteLine("Property:" + des);
                //Console.WriteLine("Property:" + property);
            }

            // 构造函数(Constructor)
            Console.WriteLine("-------------- Constructor --------------------");
            ConstructorInfo[] constructors = t.GetConstructors(flags);
            foreach (ConstructorInfo constructor in constructors)
            {
                string des = constructor.IsPublic ? "Public " : (constructor.IsPrivate ? "Private " : ""); // 可见性
                des += constructor.IsStatic ? "Static " : ""; // 静态
                //des += constructor.Name; // 函数名 都是(.ctor, .cctor),所以没有用,改成显示类名
                des += t.Name; // 类名
                // 泛型
                if (constructor.IsGenericMethod)
                {
                    des += "<";
                    Type[] ts = constructor.GetGenericArguments();
                    for (int i = 0; i < ts.Length; i++)
                    {
                        var o = ts[i];
                        des += o.Name;
                        if (i < ts.Length - 1) des += ", ";
                    }
                    des += ">";
                }
                // 参数列表
                des += "(";
                ParameterInfo[] ps = constructor.GetParameters();
                for (int i = 0; i < ps.Length; i++)
                {
                    var p = ps[i];
                    des += GetTypeName(p.ParameterType) + " " + p.Name;
                    if (i < ps.Length - 1) des += ", ";
                }
                des += ")";
                Console.WriteLine("Constructor:" + des);
                //Console.WriteLine("Constructor:" + constructor);
            }


            // 上面所有的构造函数、事件、字段、方法和属性都叫做成员，即 Member
            Console.WriteLine("-------------- Member --------------------");
            MemberInfo[] members = t.GetMembers(flags);
            foreach (MemberInfo member in members)
            {
                Console.WriteLine("Member:" + member);
            }
        }

        /// <summary>
        /// 获取类型名的字符串
        /// </summary>
        /// <param name="type"></param>
        /// <returns></returns>
        private static string GetTypeName(Type type)
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
                typeStr = head + "<" + body + ">";
            }
            // 空返回类型
            if (typeStr == "System.Void")
            {
                typeStr = "void";
            }
            return typeStr;
        }
    }


2. 获取所有 命名空间 及 类
    using System;
    using System.IO;
    using System.Reflection;
    using System.ComponentModel;
    using System.Collections.Generic;

    public class ProgramTest
    {
        public static void Main(string[] args)
        {
            // 当前程序所能访问到的所有命名空间及类的集合
            HashSet<Type> classList = new HashSet<Type>();
            HashSet<string> namespaceList = GetExecutingClasses(classList);
            Console.WriteLine("------------ 本程序能访问到的所有命名空间 ----------------");
            foreach (string Namespace in namespaceList)
            {
                Console.WriteLine(Namespace);
            }
            Console.WriteLine("----------- 本程序能访问到的所有类 -----------------");
            foreach (Type type in classList)
            {
                Console.WriteLine(type.FullName);
            }

            // 所有的命名空间及类的集合
            classList = new HashSet<Type>();
            namespaceList = GetAllClasses(classList);
            Console.WriteLine("------------ 所有的命名空间 ----------------");
            foreach (string Namespace in namespaceList)
            {
                Console.WriteLine(Namespace);
            }
            Console.WriteLine("----------- 所有的类 -----------------");
            foreach (Type type in classList)
            {
                Console.WriteLine(type.FullName);
            }

            Console.WriteLine("运行完毕！");
            Console.ReadLine();
        }

        /// <summary>
        /// 当前程序所能访问到的所有命名空间及类的集合
        /// 使用 HashSet 是为了去重
        /// </summary>
        /// <param name="classList">当前能访问到的所有类的集合(用来保存类的集合)</param>
        /// <returns></returns>
        public static HashSet<string> GetExecutingClasses(HashSet<Type> classList)
        {
            if (classList == null) classList = new HashSet<Type>();
            // 先保存本程序可以访问到的所有命名空间
            Assembly asm = Assembly.GetExecutingAssembly();
            HashSet<string> namespaceList = new HashSet<string>();
            foreach (Type type in asm.GetTypes())
            {
                namespaceList.Add(type.Namespace); // 保存命名空间
                classList.Add(type); // 保存类
            }
            return namespaceList;
        }

        /// <summary>
        /// 获取的所有命名空间及类的集合
        /// 使用 HashSet 是为了去重
        /// </summary>
        /// <param name="classList">所有类的集合(用来保存类的集合)</param>
        /// <returns></returns>
        public static HashSet<string> GetAllClasses(HashSet<Type> classList)
        {
            if (classList == null) classList = new HashSet<Type>();
            HashSet<string> namespaceList = new HashSet<string>();

            // 用io流递归遍历运行目录下的所有dll或者exe等文件,力求获取所有能取到的命名空间
            string domain = System.AppDomain.CurrentDomain.SetupInformation.ApplicationBase; // 站点的硬盘地址,结果如: "D:\\wwwfiles\\myApp\\"
            AddDir(new DirectoryInfo(domain), namespaceList, classList);

            return namespaceList;
        }

        /// <summary>
        /// 获取指定目录下的所有命名空间及类的集合
        /// 使用 HashSet 是为了去重
        /// </summary>
        /// <param name="runDir">要加载的目录路径</param>
        /// <param name="namespaceList">所有命名空间的集合(用来保存命名空间的集合)</param>
        /// <param name="classList">所有类的集合(用来保存类的集合)</param>
        /// <returns></returns>
        private static void AddDir(DirectoryInfo runDir, HashSet<string> namespaceList, HashSet<Type> classList)
        {
            if (runDir == null || !runDir.Exists) return; // 目录不存在时不加载
            if (classList == null) classList = new HashSet<Type>();
            if (namespaceList == null) namespaceList = new HashSet<string>();
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
                    namespaceList.Add(type.Namespace); // 保存命名空间
                    classList.Add(type); // 保存类
                }
            }
            // 递归遍历子目录
            foreach (DirectoryInfo dir in runDir.GetDirectories())
            {
                AddDir(dir, namespaceList, classList);
            }
        }
    }


4. 获取注释
    // 获取 System.ComponentModel.DescriptionAttribute 形式的注释
    using System;
    using System.Reflection;
    using System.ComponentModel;

    namespace Test
    {
        public class Program
        {
            static void Main(string[] args)
            {
                PropertyInfo[] peroperties = typeof(TEST).GetProperties(BindingFlags.Public | BindingFlags.Instance);
                foreach (PropertyInfo property in peroperties)
                {
                    object[] objs = property.GetCustomAttributes(typeof(DescriptionAttribute), true);
                    if (objs.Length > 0)
                    {
                        Console.WriteLine("{0}: {1}", property.Name, ((DescriptionAttribute)objs[0]).Description);
                    }
                }
                Console.ReadKey();
            }
        }

        class TEST
        {
            [Description("a")] // 这样的注释可以反射获取
            public string X
            {
                get { return null; }
            }
        }
    }


