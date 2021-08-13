using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Barfoo.Library.Serialization;

namespace Barfoo.Library.Data.Dynamic
{
    public class DynamicListObject : DynamicUtility
    {
        #region Private Member

        private List<object> PrivateList;

        #endregion

        #region Constructor

        /// <summary>
        /// 解析dynamic类
        /// </summary>
        /// <param name="dicObject"></param>
        public DynamicListObject(List<object> dicList)
        {
            this.PrivateList = dicList;
        }

        public DynamicListObject() 
        {
            this.PrivateList = new List<object>();
        }

        #endregion

        #region Override Method

        public override bool TryGetIndex(System.Dynamic.GetIndexBinder binder, object[] indexes, out object result)
        {
            if (indexes != null && indexes.Length == 1 && int.Parse(indexes[0].ToString()) < this.PrivateList.Count)
            {
                result = this.PrivateList[int.Parse(indexes[0].ToString())];
                return true;
            }
            return base.TryGetIndex(binder, indexes, out result);
        }

        public override bool TrySetIndex(System.Dynamic.SetIndexBinder binder, object[] indexes, object value)
        {
            if (indexes != null && indexes.Length == 1 && int.Parse(indexes[0].ToString()) < this.PrivateList.Count)
            {
                this.PrivateList[int.Parse(indexes[0].ToString())] = value;
                return true;
            }
            return base.TrySetIndex(binder, indexes, value);
        }

        public override string ToJson()
        {
            return JsonUtility.ToJson(this.PrivateList);
        }

        public override string ToString()
        {
            return this.ToJson();
        }

        #endregion
    }
}
