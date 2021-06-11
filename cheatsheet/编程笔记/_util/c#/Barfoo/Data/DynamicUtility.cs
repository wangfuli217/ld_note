using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Dynamic;

using Barfoo.Library.Serialization;

namespace Barfoo.Library.Data
{
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

        #endregion

        #region Private Member

        private Dictionary<string, object> PrivateDic;

        #endregion

        #region Constructor

        /// <summary>
        /// 解析dynamic类
        /// <![CDATA[
        ///     dynamic baeObject = new Barfoo.Library.Data.DynamicUtility("{json内容}");
        ///     if (baeObject == null || baeObject.Status == null || baeObject.Status == false) ...
        /// ]]>
        /// </summary>
        /// <param name="dicObject"></param>
        public DynamicUtility(string jsonContent)
        {
            var result = JsonUtility.FromJson(jsonContent) as Dictionary<string, object>;
            PrivateDic = result;
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
            PrivateDic = dicObject;
        }

        public DynamicUtility() { }

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
        public override bool TrySetMember(SetMemberBinder binder, object value)
        {
            this.PrivateDic[binder.Name] = value;
            return true;
        }

        #endregion

        #region Private Method

        /// <summary>
        /// 获取动态类型的列表结果
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        private List<DynamicUtility> GetListObject(IEnumerable<object> list)
        {
            return list.Select(dicObj => new DynamicUtility(dicObj as Dictionary<string, object>)).ToList();
        }

        /// <summary>
        /// 获取动态类型
        /// </summary>
        /// <param name="objDic"></param>
        /// <returns></returns>
        private DynamicUtility GetObject(Dictionary<string, object> objDic)
        {
            return new DynamicUtility(objDic);
        }

        #endregion
    }
}
