using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;
using System.Linq;

namespace Barfoo.Library.Text
{
    /// <summary>
    /// 摘要段
    /// </summary>
    public struct SummarySegment
    {
        //开始位置
        public int begin;
        //结束位置
        public int end;

        //public SummarySegment()
        //{
        //    this.begin = 0;
        //    this.end = -1;
        //}

        //构造函数
        public SummarySegment(int begin, int end)
        {
            this.begin = begin;
            this.end = end;
        }

        //段长度
        public int Length
        {
            get { return begin < end ? end - begin : 0; }
        }

        //设置为空
        public void SetNull()
        {
            this.begin = 0;
            this.end = -1;
        }

        //是否为空
        public bool IsNull()
        {
            return this.end == -1;
        }

    }

    /// <summary>
    /// 分类摘要生成器
    /// </summary>
    public class Summary
    {
        //语句的断点
        private readonly string SummarySpace = "。！？；.!?;，";
        //最大摘要长度，摘要的长度限制SummaryLengthLimit
        private readonly int MaxSummaryLength = 250;
        //加上颜色段
        private readonly string replaceHtml = "<font color=\"#C60A00\">{0}</font>";

        private readonly Regex reg = new Regex(@"(?<=[\s\S]{200,300}</font>)[\s\S]+");

        //源文件
        private string source;
        //关键字列表
        //private List<string> keywordList;

        //生成摘要
        //private StringBuilder summarySB;
        //摘要段列表
        private List<SummarySegment> segmentList;

        //摘取段列表
        public List<SummarySegment> SegmentList
        {
            get { return segmentList; }
        }


        /// <summary>
        /// 构造函数
        /// </summary>
        public Summary()
        {
            segmentList = new List<SummarySegment>();
            //summarySB = new StringBuilder();
        }

        /// <summary>
        /// 截取关键字所在的那句话，组成一个块
        /// </summary>
        /// <param name="keyword"></param>
        /// <returns></returns>
        private SummarySegment SelectSegment(string keyword)
        {
            return SelectSegment(keyword, 0);
        }

        /// <summary>
        /// 截取关键字所在的那句话，组成一个块
        /// </summary>
        /// <param name="keyword"></param>
        /// <param name="startIndex"></param>
        /// <returns></returns>
        private SummarySegment SelectSegment(string keyword, int startIndex)
        {
            if (startIndex > source.Length)
            {
                SummarySegment ss = new SummarySegment();
                ss.SetNull();
                return ss;
            }

            int posKey = source.IndexOf(keyword, startIndex);
            if (posKey > -1)
            {
                int posBefore;
                for (posBefore = posKey; posBefore >= 0; posBefore--)
                {
                    if (SummarySpace.IndexOf(source[posBefore]) > -1)
                    {
                        //posBefore++;//指向后一位
                        break;
                    }
                }
                posBefore++;//指向后一位
                int posEnd;
                for (posEnd = posKey; posEnd < source.Length; posEnd++)
                {
                    if (SummarySpace.IndexOf(source[posEnd]) > -1)
                    {
                        posEnd++; //指向后一位
                        break;
                    }
                }
                //if (posEnd >= source.Length) posEnd = source.Length - 1;//不能出界

                SummarySegment ss = new SummarySegment(posBefore, posEnd);
                return ss;
                //AddSegment(ss);
                //return false;
            }
            else
            {
                SummarySegment ss = new SummarySegment();
                ss.SetNull();
                return ss;
                //return false;
            }
        }

        private int GetMin(int a, int b)
        {
            if (a < b)
                return a;
            else
                return b;
        }

        private int GetMax(int a, int b)
        {
            if (a >= b)
                return a;
            else
                return b;
        }

        /// <summary>
        /// 添加一个段到列表
        /// </summary>
        /// <param name="ss"></param>
        private void AddSegment(SummarySegment ss)
        {
            for (int i = 0; i < segmentList.Count; i++)
            {
                if (ss.begin < segmentList[i].begin)
                {
                    segmentList.Insert(i, ss);
                    while (segmentList.Count > i + 1)
                    {
                        if (ss.end < segmentList[i + 1].begin)
                        {
                            break;
                        }
                        else if (segmentList[i + 1].begin <= ss.end)
                        {
                            //if (ss.end < segmentList[i+1].end)
                            //    ss.end = segmentList[i+1].end;
                            //ss.end = ss.end < segmentList[i + 1].end ? segmentList[i + 1].end : ss.end;
                            ss.end = GetMax(ss.end, segmentList[i + 1].end);
                        }
                        segmentList.RemoveAt(i + 1);
                    }
                    //修改ss，重新赋值，值类型，不能修改
                    segmentList.RemoveAt(i);
                    segmentList.Insert(i, ss);
                    return;
                }
                else if (ss.begin <= segmentList[i].end)
                {
                    ss.begin = GetMin(ss.begin, segmentList[i].begin);
                    ss.end = GetMax(ss.end, segmentList[i].end);
                    segmentList.Insert(i, ss);
                    segmentList.RemoveAt(i + 1);
                    while (segmentList.Count > i + 1)
                    {
                        if (ss.end < segmentList[i + 1].begin)
                            break;
                        else if (segmentList[i + 1].begin <= ss.end)
                        {
                            ss.end = GetMax(ss.end, segmentList[i + 1].end);
                        }
                        segmentList.RemoveAt(i + 1);
                    }
                    //修改ss，重新赋值，值类型，不能修改
                    segmentList.RemoveAt(i);
                    segmentList.Insert(i, ss);
                    return;
                    //int lastEnd = ss.end;
                    //while (segmentList[i].end < lastEnd)
                    //{
                    //    if (segmentList.Count > i + 1)
                    //    {
                    //        if (lastEnd < segmentList[i + 1].begin)
                    //        {
                    //            segmentList[i].end = lastEnd;
                    //            break;
                    //        }
                    //        else
                    //        {
                    //            lastEnd = lastEnd < segmentList[i + 1].end ? segmentList[i + 1].end : lastEnd;
                    //            segmentList.RemoveAt(i + 1);
                    //        }
                    //    }
                    //    else
                    //    {
                    //        segmentList[i].end = lastEnd;
                    //        break;
                    //    }
                    //}
                    //return;
                }
                //循环下一个
            }
            //否则加在结尾
            segmentList.Add(ss);
            return;
        }

        /// <summary>
        /// 截取分段块的总长度
        /// </summary>
        /// <returns></returns>
        private int GetSegmentLength()
        {
            int len = 0;
            foreach (SummarySegment ss in segmentList)
            {
                len += ss.Length;
            }
            return len;
        }

        /// <summary>
        /// 循环递归构建分类块
        /// </summary>
        private void BuildSegement(Dictionary<string, int> hashKeyword,int layer)
        {
            if (layer > 10)
            {
                //int a = 20;
                return;
            }
            if (hashKeyword.Count == 0) return;
            Dictionary<string, int> hashCache = new Dictionary<string, int>();
            foreach (KeyValuePair<string, int> kvp in hashKeyword)
            {
                //string s = kvp.Key.Trim();
                //int i = s.Length;
                //bool b = string.IsNullOrEmpty(s);
                SummarySegment ss = SelectSegment(kvp.Key, kvp.Value);
                if (!ss.IsNull())
                {
                    AddSegment(ss);
                    //if (!hashCache.ContainsKey(kvp.Key))
                    hashCache.Add(kvp.Key, ss.end);
                }
                if (GetSegmentLength() > MaxSummaryLength) return;
            }
            BuildSegement(hashCache,++layer);
        }

        /// <summary>
        /// 后续补充争强块
        /// </summary>
        private void ReinforceSegment()
        {
            int len = GetSegmentLength();
            //while (len < MaxSummaryLength)
            if (len < MaxSummaryLength)
            {
                SummarySegment ss = new SummarySegment();
                if (segmentList.Count > 0)
                    ss.begin = segmentList[0].end;
                else
                    ss.begin = 0;
                ss.end = ss.begin + (MaxSummaryLength - len);
                ss.end = GetMin(ss.end, source.Length);
                AddSegment(ss);

                //len = GetSegmentLength();
            }
        }

        /// <summary>
        /// 生成分类摘要
        /// </summary>
        /// <param name="text"></param>
        /// <param name="keyword"></param>
        /// <returns></returns>
        public string BuildSummary(string text, string[] keywordList)
        {
            try
            {
                if (string.IsNullOrEmpty(text))
                {
                    return "";
                }
                text = text.Replace("\\r\\n", "");
                text = text.Replace("\\t", "");
                this.source = text;
                //this.keywordList = keywordList;
                segmentList.Clear();

                Dictionary<string, int> hashKeyword = new Dictionary<string, int>();
                foreach (string keyword in keywordList)
                {
                    if (!string.IsNullOrEmpty(keyword) && !hashKeyword.ContainsKey(keyword))
                        hashKeyword.Add(keyword, 0);
                }
                //if (keywordList.Count == 0)
                if (keywordList.Length == 0 || text.Length <= MaxSummaryLength)
                {
                    int summaryLen = source.Length > MaxSummaryLength ? MaxSummaryLength : source.Length;
                    segmentList.Add(new SummarySegment(0, summaryLen));
                }
                else
                {
                    BuildSegement(hashKeyword, 0);

                    ReinforceSegment();
                }

                //输出
                StringBuilder summarySB = new StringBuilder();
                foreach (SummarySegment ss in segmentList)
                {
                    string segment = source.Substring(ss.begin, ss.Length);
                    //if (segment.Length > 200)
                    //{
                    //    segment = segment.Substring(0, 200);
                    //}
                    //加颜色
                    foreach (string keyword in hashKeyword.Keys)
                    {
                        segment = segment.Replace(keyword, string.Format(replaceHtml, keyword));
                    }
                    //if (summarySB.Length + segment.Length > 250)
                    //    break;
                    summarySB.Append(segment);
                    summarySB.Append("...");
                }
                string strNoHtml = ClearHtmlTag(summarySB.ToString());
                if (strNoHtml.Length > 400)
                {
                    string strTemp = strNoHtml.Substring(0, 400); //reg.Replace(summarySB.ToString(), "");
                    return strTemp;
                }
                else
                {
                    return summarySB.ToString();
                }
            }
            catch 
            {
                return "";
                //return text.Length > 200 ? text.Substring(0, 200) : text;
            }

        }

        #region 去除html标签
        /// <summary>
        /// 去除html标签
        /// </summary>
        public static string ClearHtmlTag(string strText)
        {
            try
            {
                string html = strText;
                html = Regex.Replace(html, @"<[^>]+/?>|</[^>]+>", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"-->", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"<!--.*", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"&(nbsp|#160);", " ", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"&#(\d+);", "", RegexOptions.IgnoreCase);

                return html;
            }
            catch
            {
                return strText;
            }
        }
        #endregion
    }


    /// <summary>
    /// 摘要生成类
    /// </summary>
    public class ArchiveSummaryBuilder
    {
        public int SummaryLength { get; set; }
        private const string SentencePattern = @"(?<sentence>((^|[。！？；!?;])[^。！？；!?;]*?(?<keyword>{0})[^。！？；!?;]*?([。！？；!?;]|$))+[\s\S]{{0,{1}}})";

        public ArchiveSummaryBuilder()
        {
            SummaryLength = 250;
        }

        public string BuildSummary(string input, string[] keywords)
        {
            if (string.IsNullOrEmpty(input))
                return string.Empty;

            if (keywords == null || keywords.Length == 0)
                return string.Concat(input.Substring(0, Math.Min(input.Length, SummaryLength)), "...");

            input = input.Replace("\r\n", string.Empty).Replace("\t", string.Empty);

            keywords = keywords.Clone() as string[];
            //循环转义关键字正则字符
            EscapeKeywords(keywords);

            if (input.Length < SummaryLength / 2) return input;


            var keywordstring = string.Join("|", keywords);
            var pattern = string.Format(SentencePattern, keywordstring, 0);
            var matches = Regex.Matches(input, pattern);

            var sb = new StringBuilder();
            if (matches.Count > 0)
            {
                var matchlength = 0;
                foreach (Match match in matches)
                {
                    matchlength += match.Groups["sentence"].Value.Length;
                }

                //如果摘要太短 在句子后面补内容
                if (matchlength < input.Length && matchlength < SummaryLength / 2)
                {
                    var length = (SummaryLength - matchlength) / (matches.Count <= 0 ? 1 : matches.Count);
                    pattern = string.Format(SentencePattern, keywordstring, length);
                    matches = Regex.Matches(input, pattern);

                    matchlength = 0;
                    foreach (Match match in matches)
                    {
                        matchlength += match.Groups["sentence"].Value.Length;
                    }
                }

                var needsubstr = matchlength > SummaryLength;
                foreach (Match match in matches)
                {
                    if (!needsubstr)
                        sb.Append(string.Concat(match.Groups["sentence"].Value, "..."));
                    else
                    {
                        var index = 0;
                        foreach (var key in keywords)
                        {
                            if (match.Groups["sentence"].Value.IndexOf(key) > 0)
                            {
                                index = match.Groups["sentence"].Value.IndexOf(key);
                            }
                        }
                        var percent = SummaryLength / 1.0 / matchlength;
                        var length = match.Groups["sentence"].Value.Length * percent;

                        index = Math.Min(index, match.Groups["sentence"].Value.Length - (int)length - 1);
                        index = Math.Max(0, index);
                        sb.Append(string.Concat(match.Groups["sentence"].Value.Substring(index, (int)length), "..."));
                    }
                }
            }
            else
            {
                sb.Append(string.Concat(input.Substring(0, Math.Min(input.Length, SummaryLength)), "..."));
            }

            return sb.ToString();
        }

        public void EscapeKeywords(string[] keywords)
        {
            if (keywords == null || keywords.Length.Equals(0))
                return;

            for (int i = 0; i < keywords.Length; i++)
            {
                keywords[i] = Regex.Escape(keywords[i]);
            }
        }
    }



    /// <summary>
    /// 关键字标记类
    /// </summary>
    public class KeywordMarker
    {
        private const string KeywordPattern = "(?<keyword>{0})";
        private const string MarkePattern = "<font color=\"#C60A00\">$1</font>";
        private const string MarkePattern2 = "<font style=\"text-decoration:underline\">$1</font>";
        public string Marke(string input, string[] keywords)
        {
            if (string.IsNullOrEmpty(input)) return input;
            if (keywords == null || keywords.Length == 0) return input;

            input = ClearHtmlTag(input);
            //按长度倒序排序关键字(关键字中时同出现"广州"和"广州市"的时候，确保标记"广州市"的优先级比"广州"高)
            Array.Sort(keywords, new Comparison<string>(CompareByLength));
            keywords = keywords.Reverse().ToArray();
            //循环转义关键字正则附号
            EscapeKeywords(keywords);

            return Regex.Replace(input, string.Format(KeywordPattern, string.Join("|", keywords)), MarkePattern);
        }

        public string Marke(string input, string[] keywords,string[] attachKeywords)
        {
            if (string.IsNullOrEmpty(input)) return input;
            if ((keywords == null || keywords.Length == 0)&&(attachKeywords==null||attachKeywords.Length==0)) return input;

            input = ClearHtmlTag(input);
            var content=input;
            if (keywords != null && keywords.Length != 0)
            {
                //按长度倒序排序关键字(关键字中时同出现"广州"和"广州市"的时候，确保标记"广州市"的优先级比"广州"高)
                Array.Sort(keywords, new Comparison<string>(CompareByLength));
                keywords = keywords.Reverse().ToArray();
                //循环转义关键字正则附号
                EscapeKeywords(keywords);
                content= Regex.Replace(input, string.Format(KeywordPattern, string.Join("|", keywords)), MarkePattern);
            }
            if (attachKeywords != null && attachKeywords.Length != 0)
            {
                //按长度倒序排序关键字(关键字中时同出现"广州"和"广州市"的时候，确保标记"广州市"的优先级比"广州"高)
                Array.Sort(attachKeywords, new Comparison<string>(CompareByLength));
                attachKeywords = attachKeywords.Reverse().ToArray();
                //循环转义关键字正则附号
                EscapeKeywords(attachKeywords);
                content = Regex.Replace(content, string.Format(KeywordPattern, string.Join("|", attachKeywords)), MarkePattern2);
            }
            return content;
        }

      
        public string MarkeNotHtml(string input, string[] keywords)
        {
            if (string.IsNullOrEmpty(input)) return input;
            if (keywords == null || keywords.Length == 0) return input;

            //按长度倒序排序关键字(关键字中时同出现"广州"和"广州市"的时候，确保标记"广州市"的优先级比"广州"高)
            Array.Sort(keywords, new Comparison<string>(CompareByLength));

            keywords = keywords.Reverse().ToArray();
            //循环转义关键字正则附号
            EscapeKeywords(keywords);

            return Regex.Replace(input, string.Format(KeywordPattern, string.Join("|", keywords)), MarkePattern);
        }


        public void EscapeKeywords(string[] keywords)
        {
            if (keywords == null || keywords.Length.Equals(0))
                return;

            for (int i = 0; i < keywords.Length; i++)
            {
                keywords[i] = Regex.Escape(keywords[i]);
            }
        }

        private static int CompareByLength(string x, string y)
        {
            if (x == null)
            {
                if (y == null)
                    return 0;
                else
                    return -1;
            }
            else
            {
                if (y == null)
                    return 1;
                else
                {
                    int retval = x.Length.CompareTo(y.Length);

                    if (retval != 0)
                        return retval;
                    else
                        return x.CompareTo(y);
                }
            }
        }

        #region 去除html标签
        /// <summary>
        /// 去除html标签
        /// </summary>
        public string ClearHtmlTag(string strText)
        {
            try
            {
                string html = strText;
                html = Regex.Replace(html, @"<[^>]+/?>|</[^>]+>", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"-->", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"<!--.*", "", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"&(nbsp|#160);", " ", RegexOptions.IgnoreCase);
                html = Regex.Replace(html, @"&#(\d+);", "", RegexOptions.IgnoreCase);

                return html;
            }
            catch
            {
                return strText;
            }
        }
        #endregion
    }
}
