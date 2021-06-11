/*
版权所有：  邦富软件版权所有(C)
系统名称：  基础类库
模块名称：  RegexUtility正则表达式资源类
创建日期：  2007-2-1
作者：      李旭日
内容摘要： 
*/

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text.RegularExpressions;

namespace Barfoo.Library.Text
{
    public static class RegexUtility
    {
        /// <summary>
        /// 正则表达式缓存
        /// </summary>
        private static Dictionary<string, Regex> regexCache = new Dictionary<string, Regex>();

        /// <summary>
        /// 正则表达式选项：编译，忽略大小写，忽略无命名组。
        /// </summary>
        public static RegexOptions CompiledIgnoreCaseExplicitCapture = RegexOptions.Compiled | RegexOptions.IgnoreCase | RegexOptions.ExplicitCapture;

        /// <summary>
        /// 构建编译，忽略大小写，忽略无组名的正则表达式，如果已经存在则直接返回缓存的
        /// </summary>
        /// <param name="pattern"></param>
        /// <returns></returns>
        [MethodImpl(MethodImplOptions.Synchronized)]
        public static Regex CreateRegex(string pattern)
        {
            Regex reg;
            if (!regexCache.TryGetValue(pattern, out reg))
            {
                reg = new Regex(pattern, CompiledIgnoreCaseExplicitCapture);
                regexCache.Add(pattern, reg);
            }
            return reg;
        }

        /// <summary>
        /// 获取匹配的第一个组名里的所有匹配项
        /// </summary>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <param name="ms"></param>
        public static void GetFirstGroups(this Regex reg, string content, IList<string> ms)
        {
            var mc = reg.Matches(content);
            var groupName = GetFirstGroupName(reg);
            foreach (Match m in mc)
            {
                var cs = m.Groups[groupName].Captures;
                foreach (var c in cs)
                {
                    ms.Add(c.ToString());
                }
            }
        }

        /// <summary>
        /// 获取匹配的第一个组名里的所有匹配项
        /// </summary>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <returns></returns>
        public static IList<string> GetFirstGroups(this Regex reg, string content)
        {
            var list = new List<string>();
            GetFirstGroups(reg, content, list);
            return list;
        }

        /// <summary>
        /// 获取第一个组名里的第一个匹配项
        /// </summary>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <returns></returns>
        public static string GetFirstMatch(this Regex reg, string content)
        {
            var mc = reg.Matches(content);
            if (mc.Count == 0) return string.Empty;

            var groupName = GetFirstGroupName(reg);
            return String.IsNullOrEmpty(groupName) ? mc[0].Value : mc[0].Groups[groupName].Value.Trim();
        }

        /// <summary>
        /// 获取匹配到的第一个组
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <returns></returns>
        public static T GetFirstMatch<T>(this Regex reg, string content)
        {
            content = GetFirstMatch(reg, content);
            return String.IsNullOrEmpty(content) ? default(T) : (T)Convert.ChangeType(content, typeof(T));
        }

        /// <summary>
        /// 获取第一个组名
        /// </summary>
        /// <param name="reg"></param>
        /// <returns></returns>
        public static string GetFirstGroupName(this Regex reg)
        {
            return reg.GetGroupNames().Length >= 2 ? reg.GetGroupNames()[1] : string.Empty;
        }

        /// <summary>
        /// 利用正则匹配文本，同时装配到传进来的对象中
        /// </summary>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <param name="obj"></param>
        /// <![CDATA[
        ///    var content = "名字=李明 年龄=25";
        ///    var reg = new Regex(@"名字=(?<Name>[^ ]+)\s*年龄=(?<Age>\d+)");
        ///    var p = new People();
        ///    RegexUtility.Assemble(reg, content, p);
        ///    Console.WriteLine("{0}：{1}", p.Name, p.Age);
        /// ]]>
        public static void Assemble(this Regex reg, string content, object obj)
        {
            if (reg == null || String.IsNullOrEmpty(content)) return;

            var mc = reg.Matches(content);
            if (mc.Count == 0) return;

            var groupNames = reg.GetGroupNames();
            Assemble(mc[0], groupNames, obj);
        }

        /// <summary>
        /// 利用正则匹配文本，同时装配到传进来的对象中
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <returns></returns>
        public static T Assemble<T>(this Regex reg, string content) where T : new()
        {
            if (reg == null || String.IsNullOrEmpty(content)) return default(T);

            var mc = reg.Matches(content);
            if (mc.Count == 0) return default(T);

            var groupNames = reg.GetGroupNames();

            var obj = new T();
            Assemble(mc[0], groupNames, obj);

            return obj;
        }

        /// <summary>
        /// 利用正则匹配文本，同时装配到传进来的对象中
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="reg"></param>
        /// <param name="content"></param>
        /// <returns></returns>
        public static T[] AssembleList<T>(this Regex reg, string content) where T : new()
        {
            if (reg == null || String.IsNullOrEmpty(content)) return new T[0];

            var mc = reg.Matches(content);
            if (mc.Count == 0) return new T[0];

            var groupNames = reg.GetGroupNames();
            var objs = new T[mc.Count];

            for (int i = 0; i < mc.Count; i++)
            {
                objs[i] = new T();
                Assemble(mc[i], groupNames, objs[i]);
            }

            return objs;
        }

        /// <summary>
        /// 将匹配到的Match中的各个组填充到对象中去
        /// </summary>
        /// <param name="m"></param>
        /// <param name="groupNames"></param>
        /// <param name="obj"></param>
        public static void Assemble(this Match m, string[] groupNames, object obj)
        {
            var properties = obj.GetProperties();

            foreach (var p in properties)
            {
                if (groupNames.Contains(p.Name))
                {
                    if (m.Groups[p.Name].Success)
                    {
                        try
                        {
                            var capture = m.Groups[p.Name].Value;
                            object value;

                            if (p.PropertyType == typeof(String))
                                value = capture;
                            else
                                value = Convert.ChangeType(capture, p.PropertyType);

                            p.SetValue(obj, value, null);
                        }
                        catch
                        { }
                    }
                }
            }
        }
    }
}
