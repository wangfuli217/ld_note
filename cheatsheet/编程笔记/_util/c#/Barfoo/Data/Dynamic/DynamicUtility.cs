using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Dynamic;

using Barfoo.Library.Serialization;

namespace Barfoo.Library.Data.Dynamic
{
    /// <summary>
    /// <![CDATA[
    /// dynamic dObj = new DynamicUtility();
    /// dObj.Name = "SinSay";
    /// dObj.Boolean = true;
    /// dObj.Args = new string[] {"1", "2", "3"};
    /// Console.WriteLine("Name: {0}, Boolean: {1}, Args: {2}, Args[1]: {3}",
    ///     dObj.Name, dObj.Boolean, dObj.Args, dObj.Args[1]);
    /// 
    /// var json = dObj.ToString();
    /// Console.WriteLine(json); //get all json text
    /// var dObj2 = new DynamicUtility(json); //recover to dynamic obj
    /// Console.WriteLine(dObj2.Name);
    /// 
    /// var undefine = dObj2.Get("Undefine", "DefaultValue");
    /// 
    /// //Attention!!!! DO NOT DO LIKE THIS!!!
    /// //dObj.Args[1] = "other"; //Un Wroks!
    /// ]]>
    /// </summary>
    public class DynamicUtility : DynamicObject
   {

        #region Public Method

        /// <summary>
        /// 将json格式的字符串转化成 dynamic 类型
        /// </summary>
        /// <param name="json">json格式的字符串</param>
        /// <returns>dynamic 类型的实体类</returns>
        public static dynamic ToDynamic(string json)
        {
            return new DynamicUtility(json);
        }

        /// <summary>
        /// 将json格式的字符串转化成 dynamic 类型
        /// </summary>
        /// <param name="json">json格式的字符串</param>
        /// <returns>dynamic 类型的实体类</returns>
        public static dynamic ToDynamic(Dictionary<string, object> dicObject)
        {
            return new DynamicUtility(dicObject);
        }

        public virtual String ToJson()
        {
            return JsonUtility.ToJson(this.PrivateDic);
        }

        #endregion

        #region Private Member

        private Dictionary<string, object> PrivateDic;

        #endregion

        #region Constructor

        /// <summary>
        /// 解析dynamic类
        /// <![CDATA[
        ///     dynamic baeObject = new DynamicUtility("{json内容}");
        ///     if (baeObject == null || baeObject.Status == null || baeObject.Status == false) ...
        /// ]]>
        /// </summary>
        /// <param name="dicObject"></param>
        public DynamicUtility(string jsonContent)
        {
            var result = JsonUtility.FromJson(jsonContent) as Dictionary<string, object>;
            this.PrivateDic = result;
        }

        /// <summary>
        /// 解析dynamic类
        /// <![CDATA[
        ///     var result = Barfoo.Library.Serialization.JsonUtility.FromJson("{json内容}") as Dictionary<string, object>;
        ///     dynamic baeObject = new Barfoo.Library.Data.DynamicUtility(result);
        ///     if (baeObject == null || baeObject.Status == null || baeObject.Status == false) ...
        /// ]]>
        /// </summary>
        /// <param name="dicObject"></param>
        public DynamicUtility(Dictionary<string, object> dicObject)
        {
            this.PrivateDic = dicObject;
        }

        public DynamicUtility() 
        {
            this.PrivateDic = new Dictionary<string, object>();
        }

        #endregion

        #region Override Method

        /// <summary>
        /// 获取动态类型的属性
        /// </summary>
        /// <param name="binder"></param>
        /// <param name="result"></param>
        /// <returns></returns>
        public override bool TryGetMember(System.Dynamic.GetMemberBinder binder, out object result)
        {
            if (PrivateDic.ContainsKey(binder.Name))
            {
                var member = PrivateDic[binder.Name];

                var enumerableMember = (member as IEnumerable<object>);
                if (enumerableMember != null)
                {
                    result = GetListObject(enumerableMember);
                }
                else if ((member as Dictionary<string, object>) != null)
                {
                    result = GetObject((member as Dictionary<string, object>));
                }
                else
                {
                    result = member;
                }
            }
            else
            {
                result = null;
            }

            return true;
        }

        /// <summary>
        /// 设置属性
        /// </summary>
        /// <param name="binder"></param>
        /// <param name="value"></param>
        /// <returns></returns>
        public override bool TrySetMember(System.Dynamic.SetMemberBinder binder, object value)
        {
            this.PrivateDic[binder.Name] = value;
            return true;
        }

        public override bool TryInvokeMember(System.Dynamic.InvokeMemberBinder binder, object[] args, out object result)
        {
            //args[0] 为调用的属性名， args[1] 为默认值
            if (binder.Name.Equals("Get") && args != null && args.Length == 2)
            {
                if (args[0] != null && this.PrivateDic.ContainsKey(args[0].ToString()))
                {
                    result = this.PrivateDic[args[0].ToString()];
                }
                else
                {
                    result = args[1];
                }
                return true;
            }
            else
            {
                return base.TryInvokeMember(binder, args, out result);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return this.ToJson();
        }

        #endregion

        #region Private Method

        /// <summary>
        /// 获取动态类型的列表结果
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        private DynamicListObject GetListObject(IEnumerable<object> list)
        {
            //return list.Select(dicObj => new DynamicListObject(dicObj as )).ToList();
            return new DynamicListObject(list.ToList());
        }

        /// <summary>
        /// 获取动态类型
        /// </summary>
        /// <param name="objDic"></param>
        /// <returns></returns>
        private DynamicObject GetObject(Dictionary<string, object> objDic)
        {
            return new DynamicUtility(objDic);
        }

        #endregion
    }
}
