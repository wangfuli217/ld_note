using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace Com.Everunion.Util
{
    public  class DataValidate
    {
        /*ㄇ盽ノタ玥笷Α
         * 
         * 
         * 
            ^\d+$//で皌獶璽俱计タ俱计 + 0 
            ^[0-9]*[1-9][0-9]*$//で皌タ俱计 
            ^((-\d+)|(0+))$//で皌獶タ俱计璽俱计 + 0 
            ^-[0-9]*[1-9][0-9]*$//で皌璽俱计 
            ^-?\d+$//で皌俱计 
            ^\d+(\.\d+)?$//で皌獶璽疊翴计タ疊翴计 + 0 
            ^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$//で皌タ疊翴计 
            ^((-\d+(\.\d+)?)|(0+(\.0+)?))$//で皌獶タ疊翴计璽疊翴计 + 0 
            ^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$//で皌璽疊翴计 
            ^(-?\d+)(\.\d+)?$//で皌疊翴计 
            ^[A-Za-z]+$//で皌パ26璣ゅダ舱Θ才﹃ 
            ^[A-Z]+$//で皌パ26璣ゅダ糶舱Θ才﹃ 
            ^[a-z]+$//で皌パ26璣ゅダ糶舱Θ才﹃ 
            ^[A-Za-z0-9]+$//で皌パ计㎝26璣ゅダ舱Θ才﹃ 
            ^\w+$//で皌パ计26璣ゅダ┪购絬舱Θ才﹃ 
            ^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$//で皌email 
            ^[a-zA-z]+://で皌(\w+(-\w+)*)(\.(\w+(-\w+)*))*(\?\S*)?$//で皌url 

            で皌いゅ才タ玥笷Α [\u4e00-\u9fa5] 
            で皌蛮竊才(珹簙ず)[^\x00-\xff] 
            で皌︽タ玥笷Α\n[\s| ]*\r 
            で皌HTML夹癘タ玥笷Α/<(.*)>.*<\/>|<(.*) \/>/ 
            で皌Юタ玥笷Α(^\s*)|(\s*$) 
            で皌Emailタ玥笷Α\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)* 
            で皌呼URLタ玥笷Α^[a-zA-z]+://(\w+(-\w+)*)(\.(\w+(-\w+)*))*(\?\S*)?$ 
            で皌眀腹琌猭(ダ秨繷す砛5-16竊す砛ダ计购絬)^[a-zA-Z][a-zA-Z0-9_]{4,15}$ 
            で皌瓣ず筿杠腹絏(\d{3}-|\d{4}-)?(\d{8}|\d{7})? 
            で皌乃癟QQ腹^[1-9]*[1-9][0-9]*$ 
         * */


        private static Regex RegNumber = new Regex("^[0-9]+$");
        private static Regex RegNumberSign = new Regex("^[+-]?[0-9]+$");
        private static Regex RegDecimal = new Regex("^[0-9]+[.]?[0-9]+$");
        private static Regex RegDecimalSign = new Regex("^[+-]?[0-9]+[.]?[0-9]+$"); //单基^[+-]?\d+[.]?\d+$
        private static Regex RegEmail = new Regex("^[\\w-]+@[\\w-]+\\.(com|net|org|edu|mil|tv|biz|info)$");//w 璣ゅダ┪计才﹃㎝ [a-zA-Z0-9] 粂猭妓 
        private static Regex RegCHZN = new Regex("[\u4e00-\u9fa5]");
        protected DataValidate()
        {
        }

        public static bool IsAreaCode(string input) 
        {
            return ((IsNumber(input) && (input.Length >= 3)) && (input.Length <= 5));
        }

        public static bool IsDecimal(string input)
        {
            if (string.IsNullOrEmpty(input))
            {
                return false;
            }
            return Regex.IsMatch(input, "^[0-9]+[.]?[0-9]+$");
        }

        public static bool IsDecimalSign(string input)
        {
            if (string.IsNullOrEmpty(input))
            {
                return false;
            }
            return Regex.IsMatch(input, "^[+-]?[0-9]+[.]?[0-9]+$");
        }


        /// <summary>
        /// 浪代琌才emailΑ
        /// </summary>
        /// <param name="strEmail">璶耞email才﹃</param>
        /// <returns>耞挡狦</returns>
        public static bool IsEmail(string strEmail)
        {
            if (string.IsNullOrEmpty(strEmail))
            {
                return false;
            }
            return Regex.IsMatch(strEmail, @"^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$");
        }



        public static bool IsIP(string strIp)
        {
            return (!string.IsNullOrEmpty(strIp) && Regex.IsMatch(strIp.Trim(), @"^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\.(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])$"));
        }

        /// <summary>
        /// 耞倒﹚才﹃(strNumber)琌琌计
        /// </summary>
        /// <param name="strNumber">璶絋粄才﹃</param>
        /// <returns>琌玥true ぃ琌玥 false</returns>
        public static bool IsNumber(string strNumber)
        {
            return Regex.IsMatch(strNumber, "^[0-9]+$");
        }

        public static bool IsNumberSign(string input)
        {
            if (string.IsNullOrEmpty(input))
            {
                return false;
            }
            return Regex.IsMatch(input, "^[+-]?[0-9]+$");
        }

        /// <summary>
        /// 浪代琌才秎絪Α
        /// </summary>
        /// <param name="postCode"></param>
        /// <returns></returns>
        public static bool IsPostCode(string postCode)
        {
            return Regex.IsMatch(postCode, @"^\d{6}$");
        }


        /// <summary>
        /// 浪代琌才ō靡腹絏Α
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        public static bool IsIdentityNumber(string num)
        {
            return Regex.IsMatch(num, @"^\d{17}[\d|X]|\d{15}$");
        }
        /// <summary>
        /// 浪代琌才丁Α
        /// </summary>
        /// <returns></returns>
        public static bool IsTime(string timeval)
        {
            return Regex.IsMatch(timeval, @"20\d{2}\-[0-1]{1,2}\-[0-3]?[0-9]?(\s*((([0-1]?[0-9])|(2[0-3])):([0-5]?[0-9])(:[0-5]?[0-9])?))?");
        }

        /// <summary>
        /// 浪代琌才urlΑ,玡ゲ惠Τhttp://
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public static bool IsURL(string url)
        {
            if (string.IsNullOrEmpty(url))
            {
                return false;
            }
            return Regex.IsMatch(url, @"^http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?$");
        }
        /// <summary>
        /// 浪代琌才筿杠Α
        /// </summary>
        /// <param name="phoneNumber"></param>
        /// <returns></returns>
        public static bool IsPhoneNumber(string phoneNumber)
        {
            return Regex.IsMatch(phoneNumber, @"^(\(\d{3}\)|\d{3}-)?\d{7,8}$");
        }

        public static bool IsValidId(string input)
        {
            if (string.IsNullOrEmpty(input))
            {
                return false;
            }
            input = input.Replace("|", "").Replace(",", "").Replace("-", "").Replace(" ", "").Trim();
            if (string.IsNullOrEmpty(input))
            {
                return false;
            }
            return IsNumber(input);
        }

        public static bool IsValidUserName(string userName, out string   msg)
        {
            userName = userName.Trim();
            msg = "";
            if (string.IsNullOrEmpty(userName))
            {
                msg = "眀腹ぃ";
                return false;
            }
            if (userName.Length > 30)
            {
                msg = "眀腹ぃ30";
                return false;
            }
            else if (userName.Length < 4)
            {
                msg = "眀腹ぃ4";
                return false;
            }
            string str = "\\/\"[]:|<>+=;,?*@.";
            for (int i = 0; i < userName.Length; i++)
            {
                if (str.IndexOf(userName[i]) >= 0)
                {
                    msg = "眀腹Τ獶猭才";
                    return false;
                }
            }
            return true;
        }


        #region いゅ浪代

        /// <summary>
        /// 浪代琌Τいゅ才
        /// </summary>
        /// <param name="inputData"></param>
        /// <returns></returns>
        public static bool IsHasCHZN(string inputData)
        {
            Match m = RegCHZN.Match(inputData);
            return m.Success;
        }
        #endregion


        /// <summary>
        /// 浪代琌才ら戳Α
        /// </summary>
        /// <returns></returns>
        public static bool IsDate(string timeval)
        {
            try
            {
                DateTime.Parse(timeval);
                return true;
            }
            catch
            {
                return false;
            }
            //return Regex.IsMatch(timeval, @"20\d{2}/[0-9]{2}/[0-3]?[0-9]{1}");
        }
    }
}
