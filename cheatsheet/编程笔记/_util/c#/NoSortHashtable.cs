/**
 * <P> Title: zmo                      		</P>	
 * <P> Description: 不排序的Hashtable       </P>	
 * <P> Copyright: Copyright (c) 2011-01-21	</P>	
 * <P> Company:Everunion Tech. Ltd.         </P>	
 * @author dennis
 * @version 0.1 Original Design from design document.	
*/
using System;
using System.Collections.Generic;
using System.Text;
using System.Collections;

namespace Com.Everunion.Util
{
    /// <summary>
    /// NoSortHashtable的摘要說明
    /// </summary>
    public class NoSortHashtable : Hashtable
    {
        //log物件
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(NoSortHashtable));
        //主鍵
        private ArrayList keys = new ArrayList();


        /// <summary>
        /// 構造函數
        /// </summary>
        public NoSortHashtable()
        {
        }


        /// <summary>
        /// 加入資料
        /// </summary>
        /// <param name="key">主鍵</param>
        /// <param name="value">對應值</param>
        public override void Add(object key, object value)
        {
            base.Add(key, value);
            keys.Add(key);
        }


        /// <summary>
        /// 取得主鍵
        /// </summary>
        public override ICollection Keys
        {
            get
            {
                return keys;
            }
        }


        /// <summary>
        /// 清空
        /// </summary>
        public override void Clear()
        {
            base.Clear();
            keys.Clear();
        }


        /// <summary>
        /// 根據主鍵刪除
        /// </summary>
        /// <param name="key">主鍵</param>
        public override void Remove(object key)
        {
            base.Remove(key);
            keys.Remove(key);
        }


        /// <summary>
        /// 取得IDictionaryEnumerator
        /// </summary>
        /// <returns>IDictionaryEnumerator</returns>
        public override IDictionaryEnumerator GetEnumerator()
        {
            return base.GetEnumerator();
        }
    }
}