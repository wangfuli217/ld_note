using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Dynamic;

namespace Barfoo.Library.Data
{
    public class BaeObject : DynamicObject
    {
        #region Private Member

        private Dictionary<string, object> PrivateDic;

        #endregion

        #region Constructor

        public BaeObject(Dictionary<string, object> dicObject)
        {
            PrivateDic = dicObject;
        }

        public BaeObject() { }

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
        private List<BaeObject> GetListObject(IEnumerable<object> list)
        {
            return list.Select(dicObj => new BaeObject(dicObj as Dictionary<string, object>)).ToList();
        }

        /// <summary>
        /// 获取动态类型
        /// </summary>
        /// <param name="objDic"></param>
        /// <returns></returns>
        private BaeObject GetObject(Dictionary<string, object> objDic)
        {
            return new BaeObject(objDic);
        }

        #endregion


    }
}
