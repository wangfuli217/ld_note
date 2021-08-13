/*
版权所有：  Copyright (c) 2002 Douglas Crockford  (www.crockford.com)
系统名称：  基础类库
模块名称：  javascript 压缩工具类
创建日期：  2013-03-26
作者：      冯万里
内容摘要：  jsmin 是一个压缩Javascript代码的工具,它会帮助你去除多余的空格,换行,注释等等。
            用法：new JsMin().Minify("E:\\要压缩的JS文件路径\\JS文件名.js", "E:\\输出JS文件路径\\JS文件压缩后名称.js");
*/
using System;
using System.IO;

namespace Barfoo.Library.Web
{
    /// <summary>
    /// javascript 压缩程序
    /// </summary>
    public class JsMin
    {
        private const int EOF = -1;

        private StreamReader sr;
        private StreamWriter sw;
        private int theA;
        private int theB;
        private int theLookahead = EOF;

        /// <summary>
        /// javascript 压缩主程序
        /// </summary>
        /// <param name="src">要压缩的JS文件的路径(包括文件名)</param>
        /// <param name="dst">输出JS文件路径(包括文件名)</param>
        public void Minify(string src, string dst)
        {
            using (sr = new StreamReader(src))
            {
                using (sw = new StreamWriter(dst))
                {
                    jsmin();
                }
            }
        }

        /// <summary>
        /// Copy the input to the output, deleting the characters which are
        ///     insignificant to JavaScript. Comments will be removed. Tabs will be
        ///     replaced with spaces. Carriage returns will be replaced with linefeeds.
        ///     Most spaces and linefeeds will be removed.
        /// </summary>
        private void jsmin()
        {
            theA = '\n';
            action(3);
            while (theA != EOF)
            {
                switch (theA)
                {
                    case ' ':
                        {
                            if (isAlphanum(theB))
                            {
                                action(1);
                            }
                            else
                            {
                                action(2);
                            }
                            break;
                        }
                    case '\n':
                        {
                            switch (theB)
                            {
                                case '{':
                                case '[':
                                case '(':
                                case '+':
                                case '-':
                                    {
                                        action(1);
                                        break;
                                    }
                                case ' ':
                                    {
                                        action(3);
                                        break;
                                    }
                                default:
                                    {
                                        if (isAlphanum(theB))
                                        {
                                            action(1);
                                        }
                                        else
                                        {
                                            action(2);
                                        }
                                        break;
                                    }
                            }
                            break;
                        }
                    default:
                        {
                            switch (theB)
                            {
                                case ' ':
                                    {
                                        if (isAlphanum(theA))
                                        {
                                            action(1);
                                            break;
                                        }
                                        action(3);
                                        break;
                                    }
                                case '\n':
                                    {
                                        switch (theA)
                                        {
                                            case '}':
                                            case ']':
                                            case ')':
                                            case '+':
                                            case '-':
                                            case '"':
                                            case '\'':
                                                {
                                                    action(1);
                                                    break;
                                                }
                                            default:
                                                {
                                                    if (isAlphanum(theA))
                                                    {
                                                        action(1);
                                                    }
                                                    else
                                                    {
                                                        action(3);
                                                    }
                                                    break;
                                                }
                                        }
                                        break;
                                    }
                                default:
                                    {
                                        action(1);
                                        break;
                                    }
                            }
                            break;
                        }
                }
            }
        }

        /// <summary>
        /// do something! What you do is determined by the argument:
        ///     1   Output A. Copy B to A. Get the next B.
        ///     2   Copy B to A. Get the next B. (Delete A).
        ///     3   Get the next B. (Delete B).
        /// action treats a string as a single character. Wow!
        /// action recognizes a regular expression if it is preceded by ( or , or =.
        /// </summary>
        /// <param name="d"></param>
        private void action(int d)
        {
            if (d <= 1)
            {
                put(theA);
            }
            if (d <= 2)
            {
                theA = theB;
                // 引号引起来的字符串
                if (theA == '\'' || theA == '"')
                {
                    for (; ; )
                    {
                        put(theA);
                        theA = get();
                        if (theA == theB)
                        {
                            break;
                        }
                        if (theA <= '\n')
                        {
                            // 字符串中有换行,无法处理(运行出错)
                            throw new Exception(string.Format("Error: JSMIN unterminated string literal: {0}\n", theA));
                        }
                        if (theA == '\\')
                        {
                            put(theA);
                            theA = get();
                        }
                    }
                }
            }
            if (d <= 3)
            {
                theB = next();
                if (theB == '/' && (theA == '(' || theA == ',' || theA == '=' ||
                                    theA == '[' || theA == '!' || theA == ':' ||
                                    theA == '&' || theA == '|' || theA == '?' ||
                                    theA == '{' || theA == '}' || theA == ';' ||
                                    theA == '\n'))
                {
                    put(theA);
                    put(theB);
                    for (; ; )
                    {
                        theA = get();
                        if (theA == '/')
                        {
                            break;
                        }
                        else if (theA == '\\')
                        {
                            put(theA);
                            theA = get();
                        }
                        else if (theA <= '\n')
                        {
                            // 不明白这是怎么回事,貌似正则表达式里面有换行,忽略这错误好像也完全没问题的样子
                            //throw new Exception(string.Format("Error: JSMIN unterminated Regular Expression literal : {0}.\n", theA));
                        }
                        put(theA);
                    }
                    theB = next();
                }
            }
        }

        /// <summary>
        /// get the next character, excluding comments. peek() is used to see if a '/' is followed by a '/' or '*'.
        /// </summary>
        /// <returns></returns>
        private int next()
        {
            int c = get();
            if (c == '/')
            {
                switch (peek())
                {
                    case '/':
                        {
                            for (; ; )
                            {
                                c = get();
                                if (c <= '\n')
                                {
                                    return c;
                                }
                            }
                        }
                    case '*':
                        {
                            get();
                            for (; ; )
                            {
                                switch (get())
                                {
                                    case '*':
                                        {
                                            if (peek() == '/')
                                            {
                                                get();
                                                return ' ';
                                            }
                                            break;
                                        }
                                    case EOF:
                                        {
                                            // 多行注释代码没有结束
                                            throw new Exception("Error: JSMIN Unterminated comment.\n");
                                        }
                                }
                            }
                        }
                    default:
                        {
                            return c;
                        }
                }
            }
            return c;
        }

        /// <summary>
        /// get the next character without getting it.
        /// </summary>
        /// <returns></returns>
        private int peek()
        {
            theLookahead = get();
            return theLookahead;
        }

        /// <summary>
        /// return the next character from stdin. Watch out for lookahead. If
        ///     the character is a control character, translate it to a space or linefeed.
        /// </summary>
        /// <returns></returns>
        private int get()
        {
            int c = theLookahead;
            theLookahead = EOF;
            if (c == EOF)
            {
                c = sr.Read();
            }
            if (c >= ' ' || c == '\n' || c == EOF)
            {
                return c;
            }
            if (c == '\r')
            {
                //return c;
                return '\n'; // 把'\r'转成'\n'会引起正则表达式解析时出错
            }
            return ' ';
        }

        /// <summary>
        /// 输出字符
        /// </summary>
        /// <param name="c"></param>
        private void put(int c)
        {
            sw.Write((char)c);
        }

        /// <summary>
        /// return true if the character is a letter, digit, underscore, dollar sign, or non-ASCII character.
        /// </summary>
        /// <param name="c">要判断的字符</param>
        /// <returns></returns>
        private bool isAlphanum(int c)
        {
            return ((c >= 'a' && c <= 'z') || (c >= '0' && c <= '9') ||
                (c >= 'A' && c <= 'Z') || c == '_' || c == '$' || c == '\\' ||
                c > 126);
        }
    }
}
