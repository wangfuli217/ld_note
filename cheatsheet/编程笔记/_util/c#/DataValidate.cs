using System;
using System.Collections.Generic;
using System.Text;
using System.Text.RegularExpressions;

namespace Com.Everunion.Util
{
    public  class DataValidate
    {
        /*�@�Ǳ`�Ϊ����h��F��
         * 
         * 
         * 
            ^\d+$�@�@//�ǰt�D�t��ơ]����� + 0�^ 
            ^[0-9]*[1-9][0-9]*$�@�@//�ǰt����� 
            ^((-\d+)|(0+))$�@�@//�ǰt�D����ơ]�t��� + 0�^ 
            ^-[0-9]*[1-9][0-9]*$�@�@//�ǰt�t��� 
            ^-?\d+$�@�@�@�@//�ǰt��� 
            ^\d+(\.\d+)?$�@�@//�ǰt�D�t�B�I�ơ]���B�I�� + 0�^ 
            ^(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*))$�@�@//�ǰt���B�I�� 
            ^((-\d+(\.\d+)?)|(0+(\.0+)?))$�@�@//�ǰt�D���B�I�ơ]�t�B�I�� + 0�^ 
            ^(-(([0-9]+\.[0-9]*[1-9][0-9]*)|([0-9]*[1-9][0-9]*\.[0-9]+)|([0-9]*[1-9][0-9]*)))$�@�@//�ǰt�t�B�I�� 
            ^(-?\d+)(\.\d+)?$�@�@//�ǰt�B�I�� 
            ^[A-Za-z]+$�@�@//�ǰt��26�ӭ^��r���զ����r�Ŧ� 
            ^[A-Z]+$�@�@//�ǰt��26�ӭ^��r�����j�g�զ����r�Ŧ� 
            ^[a-z]+$�@�@//�ǰt��26�ӭ^��r�����p�g�զ����r�Ŧ� 
            ^[A-Za-z0-9]+$�@�@//�ǰt�ѼƦr�M26�ӭ^��r���զ����r�Ŧ� 
            ^\w+$�@�@//�ǰt�ѼƦr�B26�ӭ^��r���Ϊ̤U���u�զ����r�Ŧ� 
            ^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$�@�@�@�@//�ǰtemail�a�} 
            ^[a-zA-z]+://�ǰt(\w+(-\w+)*)(\.(\w+(-\w+)*))*(\?\S*)?$�@�@//�ǰturl 

            �ǰt����r�Ū����h��F���G [\u4e00-\u9fa5] 
            �ǰt���r�`�r��(�]�A�~�r�b��)�G[^\x00-\xff] 
            �ǰt�Ŧ檺���h��F���G\n[\s| ]*\r 
            �ǰtHTML�аO�����h��F���G/<(.*)>.*<\/>|<(.*) \/>/ 
            �ǰt�����Ů檺���h��F���G(^\s*)|(\s*$) 
            �ǰtEmail�a�}�����h��F���G\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)* 
            �ǰt���}URL�����h��F���G^[a-zA-z]+://(\w+(-\w+)*)(\.(\w+(-\w+)*))*(\?\S*)?$ 
            �ǰt�b���O�_�X�k(�r���}�Y�A���\5-16�r�`�A���\�r���Ʀr�U���u)�G^[a-zA-Z][a-zA-Z0-9_]{4,15}$ 
            �ǰt�ꤺ�q�ܸ��X�G(\d{3}-|\d{4}-)?(\d{8}|\d{7})? 
            �ǰt�˰TQQ���G^[1-9]*[1-9][0-9]*$ 
         * */


        private static Regex RegNumber = new Regex("^[0-9]+$");
        private static Regex RegNumberSign = new Regex("^[+-]?[0-9]+$");
        private static Regex RegDecimal = new Regex("^[0-9]+[.]?[0-9]+$");
        private static Regex RegDecimalSign = new Regex("^[+-]?[0-9]+[.]?[0-9]+$"); //������^[+-]?\d+[.]?\d+$
        private static Regex RegEmail = new Regex("^[\\w-]+@[\\w-]+\\.(com|net|org|edu|mil|tv|biz|info)$");//w �^��r���μƦr���r�Ŧ�A�M [a-zA-Z0-9] �y�k�@�� 
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
        /// �˴��O�_�ŦXemail�榡
        /// </summary>
        /// <param name="strEmail">�n�P�_��email�r�Ŧ�</param>
        /// <returns>�P�_���G</returns>
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
        /// �P�_���w���r�Ŧ�(strNumber)�O�_�O�ƭȫ�
        /// </summary>
        /// <param name="strNumber">�n�T�{���r�Ŧ�</param>
        /// <returns>�O�h��[true ���O�h��^ false</returns>
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
        /// �˴��O�_�ŦX�l�s�榡
        /// </summary>
        /// <param name="postCode"></param>
        /// <returns></returns>
        public static bool IsPostCode(string postCode)
        {
            return Regex.IsMatch(postCode, @"^\d{6}$");
        }


        /// <summary>
        /// �˴��O�_�ŦX�����Ҹ��X�榡
        /// </summary>
        /// <param name="num"></param>
        /// <returns></returns>
        public static bool IsIdentityNumber(string num)
        {
            return Regex.IsMatch(num, @"^\d{17}[\d|X]|\d{15}$");
        }
        /// <summary>
        /// �˴��O�_�ŦX�ɶ��榡
        /// </summary>
        /// <returns></returns>
        public static bool IsTime(string timeval)
        {
            return Regex.IsMatch(timeval, @"20\d{2}\-[0-1]{1,2}\-[0-3]?[0-9]?(\s*((([0-1]?[0-9])|(2[0-3])):([0-5]?[0-9])(:[0-5]?[0-9])?))?");
        }

        /// <summary>
        /// �˴��O�_�ŦXurl�榡,�e�����ݧt��http://
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
        /// �˴��O�_�ŦX�q�ܮ榡
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
                msg = "�b�����ର��";
                return false;
            }
            if (userName.Length > 30)
            {
                msg = "�b�����פ���j��30";
                return false;
            }
            else if (userName.Length < 4)
            {
                msg = "�b�����פ���p��4";
                return false;
            }
            string str = "\\/\"[]:|<>+=;,?*@.";
            for (int i = 0; i < userName.Length; i++)
            {
                if (str.IndexOf(userName[i]) >= 0)
                {
                    msg = "�b���t���D�k�r��";
                    return false;
                }
            }
            return true;
        }


        #region �����˴�

        /// <summary>
        /// �˴��O�_������r��
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
        /// �˴��O�_�ŦX����榡
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
