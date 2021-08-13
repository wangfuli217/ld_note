/**
 * <P> Title: zmo                      		</P>	
 * <P> Description: 圖片放縮        		</P>	
 * <P> Copyright: Copyright (c) 2011-01-14	</P>	
 * <P> Company:Everunion Tech. Ltd.         </P>	
 * @author dennis
 * @version 0.1 Original Design from design document.	
*/
using System;
using System.Collections.Generic;
using System.Text;

namespace Com.Everunion.Util
{
    /// <summary>
    /// MagickScale圖片放縮
    /// </summary>
    public class MagickScale
    {
        //log物件
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(MagickScale));


        /// <summary>
        /// 儲存放縮圖片
        /// </summary>
        /// <param name="imagePath">圖片路徑</param>
        /// <param name="saveToPath">放縮儲存圖片路徑</param>
        /// <param name="width">寬度</param>
        /// <param name="height">高度</param>
        /// <returns>bool:是否儲存成功</returns>
        public static bool saveThumbnail(string imagePath, string saveToPath, int width, int height)
        {
            //初始化
            bool recode = false;
            try
            {
                //原圖片是否存在
                if ( !System.IO.File.Exists(imagePath) )
                {
                    throw new Exception("[" + imagePath + "]該圖片路徑不存在!");
                }
                //引用Image
                MagickNet.Image img = new MagickNet.Image(imagePath);
                img.Quality = 100;
                //引用Bitmap
                System.Drawing.Bitmap bitmap = new System.Drawing.Bitmap(imagePath);
                //原寬
                int sourceWidth = bitmap.Width;
                //原高
                int sourceHeight = bitmap.Height;
                //
                int widthRate = width, heightRate = height;
                //寬比例
                if ( width < 1 && height > 0 )
                {
                    //寬比例
                    widthRate = Convert.ToInt32(( sourceWidth * height ) / sourceHeight);
                }
                //高比例
                else if ( height < 1 && width > 0 )
                {
                    //高比例
                    heightRate = Convert.ToInt32(( sourceHeight * width ) / sourceWidth);
                }
                //比例圖片
                img.Resize(new System.Drawing.Size(widthRate, heightRate));
                //儲存
                img.Write(saveToPath);
                //關閉img
                img.Dispose();
                recode = true;
            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("MagickScale.saveThumbnail error:" + e.Message);
            }
            //操作訊息
            return recode;
        }


        /// <summary>
        /// 取得圖片尺寸
        /// </summary>
        /// <param name="imagePath">圖片路徑</param>
        /// <returns>int[]:寬高(0:寬,1:高)</returns>
        public static int[] getImageWH(string imagePath) 
        {
            //初始化
            int[] recode = new int[2];
            try
            {
                //原圖片是否存在
                if ( !System.IO.File.Exists(imagePath) )
                {
                    throw new Exception("[" + imagePath + "]該圖片路徑不存在!");
                }
                //引用Bitmap
                System.Drawing.Bitmap bitmap = new System.Drawing.Bitmap(imagePath);
                //原寬
                recode[0] = bitmap.Width;
                //原高
                recode[1] = bitmap.Height;
            }
            //拋出例外
            catch ( Exception e )
            {
                log.Error("MagickScale.getImageWH error:" + e.Message);
            }
            //操作訊息
            return recode;
        }
    }
}
