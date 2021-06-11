//2011/01/13 lynn 新增產品類別   行:130-141
/**
 * <P> Title: pili                          </P>
 * <P> Description: 業務邏輯公用工具類別    </P>
 * <P> Copyright: Copyright (c) 2010/07/23  </P>
 * <P> Company:Everunion Tech. Ltd.         </P>
 * @author Holer
 * @version 0.8 Original Design from design document.
 */

using System;
using System.Data;
using System.Collections;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Text.RegularExpressions;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Reflection;
using System.Text;
using System.Collections.Generic;

using Com.Everunion.File;
using Com.Everunion.File.Dao;


namespace Com.Everunion.Util
{

    /// <summary>
    /// 工具類
    /// </summary>
    public class ServiceUtil
    {
        private static readonly log4net.ILog log = log4net.LogManager.GetLogger(typeof(ServiceUtil));

        /// <summary>
        /// 性別的中文名稱的資料
        /// </summary>
        private static Hashtable sexNameHt = new Hashtable();

        /// <summary>
        /// 性別的編碼的資料
        /// </summary>
        private static Hashtable sexCodeHt = new Hashtable();


        /// <summary>
        /// 款式的中文名稱的資料
        /// </summary>
        private static Hashtable modusNameHt = new Hashtable();

        /// <summary>
        /// 款式的編碼的資料
        /// </summary>
        private static Hashtable modusCodeHt = new Hashtable();


        /// <summary>
        /// 尺寸的名稱的資料
        /// </summary>
        private static Hashtable sizeNameHt = new Hashtable();

        /// <summary>
        /// 尺寸的編碼的資料
        /// </summary>
        private static Hashtable sizeCodeHt = new Hashtable();

        /// <summary>
        /// 產品分類的資料
        /// </summary>
        private static SortedList prodTypeSl = new SortedList();

        /// <summary>
        /// 性別SortedList
        /// </summary>
        private static SortedList sexSl = new SortedList();

        /// <summary>
        /// 尺寸SortedList
        /// </summary>
        private static SortedList sizeSl = new SortedList();

        /// <summary>
        /// 款式SortedList
        /// </summary>
        private static SortedList modusSl = new SortedList();

        /// <summary>
        /// 503輔料類別
        /// </summary>
        private static SortedList type_503Sl = new SortedList();

        /// <summary>
        /// 輔料材質
        /// </summary>
        private static SortedList qualitySl = new SortedList();

        /// <summary>
        /// 503輔料顏色
        /// </summary>
        private static SortedList color_503Sl = new SortedList();

        /// <summary>
        /// 503輔料尺寸
        /// </summary>
        private static SortedList size_503Sl = new SortedList();

        /// <summary>
        /// 505輔料類別
        /// </summary>
        private static SortedList type_505Sl = new SortedList();

        /// <summary>
        /// 505輔料尺寸
        /// </summary>
        private static SortedList size_505Sl = new SortedList();

        /// <summary>
        /// 輔料風格
        /// </summary>
        private static SortedList styleSl = new SortedList();

        /// <summary>
        /// 輔料內容
        /// </summary>
        private static SortedList contentSl = new SortedList();

        /// <summary>
        /// 506長短織
        /// </summary>
        private static SortedList short_lenSl = new SortedList();

        /// <summary>
        /// 506 產品別
        /// </summary>
        private static SortedList type_506Sl = new SortedList();

        /// <summary>
        /// 506 材質
        /// </summary>
        private static SortedList quality_506Sl = new SortedList();

        /// <summary>
        /// 506 丹尼
        /// </summary>
        private static SortedList dannySl = new SortedList();

        /// <summary>
        /// 506 條數
        /// </summary>
        private static SortedList article_numSl = new SortedList();

        /// <summary>
        /// 507 材質
        /// </summary>
        private static SortedList quality_507Sl = new SortedList();

        /// <summary>
        /// 507 組織
        /// </summary>
        private static SortedList organizationSl = new SortedList();

        /// <summary>
        /// 507 加工(前加工)
        /// </summary>
        private static SortedList processSl = new SortedList();

        /// <summary>
        /// 508 加工(後加工)
        /// </summary>
        private static SortedList process_508Sl = new SortedList();

        /// <summary>
        /// 初始化
        /// </summary>
        static ServiceUtil()
        {
            //性別的資料
            sexNameHt.Add("1", "男");
            sexNameHt.Add("2", "女");
            sexNameHt.Add("3", "中性");
            sexNameHt.Add("4", "男童");
            sexNameHt.Add("5", "女童");
            sexCodeHt = changeHashtable(sexNameHt);

            //款式的資料
            modusNameHt.Add("01", "長襯");
            modusNameHt.Add("02", "外套");
            modusNameHt.Add("03", "背心");
            modusNameHt.Add("04", "風衣");
            modusNameHt.Add("05", "洋裝");
            modusNameHt.Add("06", "長褲");
            modusNameHt.Add("07", "短褲");
            modusNameHt.Add("08", "長裙");
            modusNameHt.Add("09", "短裙");
            modusNameHt.Add("10", "POLO短袖衫");
            modusNameHt.Add("11", "圓領短袖衫");
            modusNameHt.Add("12", "短立領長袖");
            modusNameHt.Add("13", "半拉立領短袖");
            modusNameHt.Add("14", "V領短袖衫");
            modusNameHt.Add("15", "V領長袖衫");
            modusCodeHt = changeHashtable(modusNameHt);

            //尺寸的資料
            sizeNameHt.Add("00", "XXS");
            sizeNameHt.Add("01", "XS");
            sizeNameHt.Add("03", "S");
            sizeNameHt.Add("05", "M");
            sizeNameHt.Add("07", "L");
            sizeNameHt.Add("09", "XL");
            sizeNameHt.Add("11", "XXL");
            sizeNameHt.Add("13", "XXXL");
            sizeNameHt.Add("15", "XXXXL");
            sizeNameHt.Add("17", "XXXXXL");
            sizeNameHt.Add("19", "XXXXXXL");
            sizeNameHt.Add("21", "XXXXXXXL");
            sizeCodeHt = changeHashtable(sizeNameHt);

            //尺寸的編碼的資料(補充)
            sizeCodeHt.Add("2L", "11");
            sizeCodeHt.Add("3L", "13");
            sizeCodeHt.Add("4L", "15");
            sizeCodeHt.Add("5L", "17");
            sizeCodeHt.Add("6L", "19");
            sizeCodeHt.Add("7L", "21");

            //2011/01/13 lynn 新增產品類別  start
            //產品分類
            prodTypeSl.Add("501", "CAJA");
            prodTypeSl.Add("502", "ZMO");
            prodTypeSl.Add("503", "輔料");
            prodTypeSl.Add("504", "圖庫");
            prodTypeSl.Add("505", "輔料");
            prodTypeSl.Add("506", "紗");
            prodTypeSl.Add("507", "胚布");
            prodTypeSl.Add("508", "成品布");
            prodTypeSl.Add("511", "上海裕隆");
            //2011/01/13 lynn end

            // 性別SortedList
            sexSl.Add("1", "男");
            sexSl.Add("2", "女");
            sexSl.Add("3", "中性");
            sexSl.Add("4", "男童");
            sexSl.Add("5", "女童");

            //尺寸SortedList
            sizeSl.Add("00", "XXS");
            sizeSl.Add("01", "XS");
            sizeSl.Add("03", "S");
            sizeSl.Add("05", "M");
            sizeSl.Add("07", "L");
            sizeSl.Add("09", "XL");
            sizeSl.Add("11", "2L");
            sizeSl.Add("13", "3L");
            sizeSl.Add("15", "4L");
            sizeSl.Add("17", "5L");
            sizeSl.Add("19", "6L");
            sizeSl.Add("21", "7L");

            //款式SortedList
            modusSl.Add("01", "長襯");
            modusSl.Add("02", "外套");
            modusSl.Add("03", "背心");
            modusSl.Add("04", "風衣");
            modusSl.Add("05", "洋裝");
            modusSl.Add("06", "長褲");
            modusSl.Add("07", "短褲");
            modusSl.Add("08", "長裙");
            modusSl.Add("09", "短裙");
            modusSl.Add("10", "POLO短袖衫");
            modusSl.Add("11", "圓領短袖衫");
            modusSl.Add("12", "短立領長袖");
            modusSl.Add("13", "半拉立領短袖");
            modusSl.Add("14", "V領短袖衫");
            modusSl.Add("15", "V領長袖衫");
             modusSl.Add("16", "長袖車衣");
            modusSl.Add("17", "雙層網運動衫");
            modusSl.Add("18", "高領衫");
            modusSl.Add("19", "圓領長袖衫");
            modusSl.Add("20", "短袖T恤");
            modusSl.Add("21", "內褲");
            modusSl.Add("22", "大衣");
            modusSl.Add("23", "短袖襯衫");
            modusSl.Add("24", "七分褲");

            // 503 輔料類別
            type_503Sl.Add("01", "塑膠袋");
            type_503Sl.Add("02", "鈕扣");
            type_503Sl.Add("03", "各式標");
            type_503Sl.Add("04", "包裝盒");
            type_503Sl.Add("05", "各式吊卡");
            type_503Sl.Add("06", "各式副料");
            type_503Sl.Add("07", "型錄/DM");
            type_503Sl.Add("08", "鬆緊帶");
            type_503Sl.Add("09", "各式線");

            // 輔料材質
            qualitySl.Add("001", "單件袋");
            qualitySl.Add("002", "OPP自粘袋");
            qualitySl.Add("003", "雙色單面磁白雷射釦");
            qualitySl.Add("004", "MADE IN TAIWAN尺寸熱轉印標");
            qualitySl.Add("005", "洗標");
            qualitySl.Add("006", "折標");
            qualitySl.Add("007", "ZMO標");
            qualitySl.Add("008", "AKWATEK商標");
            qualitySl.Add("009", "ZMO紙盒");
            qualitySl.Add("010", "AKWATEK吊卡");
            qualitySl.Add("011", "ZMO吊卡");
            qualitySl.Add("012", "雙層條碼貼紙");
            qualitySl.Add("013", "針織帶");
            qualitySl.Add("014", "封口貼紙");
            qualitySl.Add("015", "91%MOD POLYESTER  9%尺寸熱轉印標");
            qualitySl.Add("016", "88%MOD POLYESTER  12%尺寸熱轉印標");
            qualitySl.Add("017", "ZMO售後服務卡");
            qualitySl.Add("018", "線扣");
            qualitySl.Add("019", "AKWATEK DM");
            qualitySl.Add("020", "speedyFresh水滴吊卡");
            qualitySl.Add("021", "蕾絲鬆緊帶");
            qualitySl.Add("022", "小蝴蝶結 ");
            qualitySl.Add("023", "花邊鬆緊帶(大)");
            qualitySl.Add("024", "花邊鬆緊帶(小)");
            qualitySl.Add("025", "蕾絲布");
            qualitySl.Add("026", "滾口帶");
            qualitySl.Add("027", "走馬帶");
            qualitySl.Add("028", "82%MOD POLYESTER  18%SPANDEX 尺寸熱轉印標");
            qualitySl.Add("029", "92%MOD POLYESTER  8%SPANDEX 尺寸熱轉印標");
            qualitySl.Add("030", "尼龍線");
            qualitySl.Add("031", "特多龍線");
            qualitySl.Add("032", "帽繩");
            qualitySl.Add("033", "褲腰繩");
            qualitySl.Add("034", "夾鏈袋");
            qualitySl.Add("035", "蝴蝶ZMO+57%Acrylic+38%Modal+5%Spandex 尺寸熱轉印標");
            qualitySl.Add("036", "蝴蝶ZMO+91%Polyester+9%Spandex 尺寸熱轉印標");
            qualitySl.Add("037", "蝴蝶ZMO+100%Polyester 尺寸熱轉印標");

            // 503 輔料顏色
            color_503Sl.Add("01", " 紅");
            color_503Sl.Add("02", "粉紅");
            color_503Sl.Add("03", "桃紅");
            color_503Sl.Add("04", "橙色");
            color_503Sl.Add("05", "黃色");
            color_503Sl.Add("06", "鵝黃");
            color_503Sl.Add("07", "深綠");
            color_503Sl.Add("08", "淺綠");
            color_503Sl.Add("09", "青綠");
            color_503Sl.Add("10", "深藍");
            color_503Sl.Add("11", "水藍");
            color_503Sl.Add("12", "藍");
            color_503Sl.Add("13", "深紫");
            color_503Sl.Add("14", "淺紫");
            color_503Sl.Add("15", "深棕");
            color_503Sl.Add("16", "淺棕");
            color_503Sl.Add("17", "深灰");
            color_503Sl.Add("18", "淺灰");
            color_503Sl.Add("19", "亮黑");
            color_503Sl.Add("20", "霧黑");
            color_503Sl.Add("21", "膚色");
            color_503Sl.Add("22", "白色");
            color_503Sl.Add("23", "透明");
            color_503Sl.Add("24", "銀色");
            color_503Sl.Add("25", "藍綠");
            color_503Sl.Add("26", "咖啡紫");

            // 503輔料尺寸
            size_503Sl.Add("00","無規格");
            size_503Sl.Add("01", "18LX4H");
            size_503Sl.Add("02", "3.5x2.6cm-S");
            size_503Sl.Add("03", "3.5x2.6cm-M");
            size_503Sl.Add("04", "3.5x2.6cm-L");
            size_503Sl.Add("05", "3.5x2.6cm-XL");
            size_503Sl.Add("06", "3.5x2.6cm-XXL");
            size_503Sl.Add("07", "3L");
            size_503Sl.Add("08", "3/8\"");
            size_503Sl.Add("09", "18X22X2.5cm");
            size_503Sl.Add("10", "15X19X3cm");
            size_503Sl.Add("11", "直徑2.5cm");
            size_503Sl.Add("12", "28X35X4cm");
            size_503Sl.Add("13", "30X36X4cm");
            size_503Sl.Add("14", "5x4.85cm-S");
            size_503Sl.Add("15", "5x4.85cm-M");
            size_503Sl.Add("16", "5x4.85cm-L");
            size_503Sl.Add("17", "5x4.85cm-XL");
            size_503Sl.Add("18", "5x4.85cm-XXL");
            size_503Sl.Add("19", "5x4.85cm-XXXL");
            size_503Sl.Add("20", "5.2x9cm");
            size_503Sl.Add("21", "H10cm");
            size_503Sl.Add("22", "22.8x27.9cm");
            size_503Sl.Add("23", "35.7X26.6cm");
            size_503Sl.Add("24", "1.9X4.2cm");
            size_503Sl.Add("25", "6x8.3cm");
            size_503Sl.Add("26", "5.4x7.1cm");
            size_503Sl.Add("27", "6x3.1cm");
            size_503Sl.Add("28", "7x2cm");
            size_503Sl.Add("29", "8x5.9cm");
            size_503Sl.Add("30", "59.4x21cm");
            size_503Sl.Add("31", "10x5cm");
            size_503Sl.Add("32", "2.5x5.5cm");
            size_503Sl.Add("33", "45\"");
            size_503Sl.Add("34", "56\"");
            size_503Sl.Add("35", "5x9cm");
            size_503Sl.Add("36", "19x16cm");
            size_503Sl.Add("37", "2.7x3.6cm-S");
            size_503Sl.Add("38", "2.7x3.6cm-M");
            size_503Sl.Add("39", "2.7x3.6cm-L");
            size_503Sl.Add("40", "2.7x3.6cm-XL");
            size_503Sl.Add("41", "2.7x3.6cm-2L");
            size_503Sl.Add("42", "2.6x3.2cm-S");
            size_503Sl.Add("43", "2.6x3.2cm-M");
            size_503Sl.Add("44", "2.6x3.2cm-L");
            size_503Sl.Add("45", "2.6x3.2cm-XL");
            size_503Sl.Add("46", "2.6x3.2cm-2L");

            //505輔料類別
            type_505Sl.Add("01", "雙層條碼貼紙");
            type_505Sl.Add("02", "拉鍊");

            //  505輔料尺寸
            size_505Sl.Add("01", "S");
            size_505Sl.Add("02", "M");
            size_505Sl.Add("03", "L");
            size_505Sl.Add("04", "XL");
            size_505Sl.Add("05", "XXL");
            size_505Sl.Add("06", "XXXL");
            size_505Sl.Add("07", "5\"");
            size_505Sl.Add("08", "6.25\"");
            size_505Sl.Add("09", "5.5\"");
            size_505Sl.Add("10", "24\"");
            size_505Sl.Add("11", "24-1/2\"");
            size_505Sl.Add("12", "25\"");
            size_505Sl.Add("13", "25-1/4\"");
            size_505Sl.Add("14", "26\"");
            size_505Sl.Add("15", "26-3/4\"");
            size_505Sl.Add("16", "21\"");
            size_505Sl.Add("17", "21-1/2\"");
            size_505Sl.Add("18", "22\"");
            size_505Sl.Add("19", "22-1/2\"");

             //輔料風格
            styleSl.Add("1", "具象");
            styleSl.Add("2", "抽象");
            styleSl.Add("3", "立體");
            styleSl.Add("4", "半立體");

             //輔料內容
            contentSl.Add("01", "人物");
            contentSl.Add("02", "自然風景");
            contentSl.Add("03", "交通");
            contentSl.Add("04", "動物");
            contentSl.Add("05", "植物");
            contentSl.Add("06", "昆蟲");
            contentSl.Add("07", "建築");
            contentSl.Add("08", "LOGO");
            contentSl.Add("09", "運動");
            contentSl.Add("10", "食物");
            contentSl.Add("11", "幾何");
            contentSl.Add("12", "流線");
            contentSl.Add("13", "節日");
            contentSl.Add("14", "生活用品");
            contentSl.Add("15", "鞋子");

            //506 長/短纖
            short_lenSl.Add("1", "長纖");
            short_lenSl.Add("2", "短纖");
            short_lenSl.Add("3", "混紡");

            // 506 產品別
            type_506Sl.Add("01","加工絲");
            type_506Sl.Add("02","原絲");
            type_506Sl.Add("03","MJS");
            type_506Sl.Add("04","MVS");

            // 506 材質
            quality_506Sl.Add("01","100%T");
            quality_506Sl.Add("02", "100%C");

            // 506 丹尼
            dannySl.Add("1", "20");
            dannySl.Add("2", "30");
            dannySl.Add("3", "40");
            dannySl.Add("4", "50");
            dannySl.Add("5", "75");
            dannySl.Add("6", "100");
            dannySl.Add("7", "150");

            // 506 條數
            article_numSl.Add("01","20");
            article_numSl.Add("02","30");
            article_numSl.Add("03","36");
            article_numSl.Add("04","40");
            article_numSl.Add("05","48");
            article_numSl.Add("06","60");
            article_numSl.Add("07","72");
            article_numSl.Add("08","96");
            article_numSl.Add("09","120");
            article_numSl.Add("10","144");
            article_numSl.Add("11", "288");

            // 507 材質
            quality_507Sl.Add("01","100%POLYESTER");
            quality_507Sl.Add("02","88%polyester+12%Spandex");
            quality_507Sl.Add("03","82%polyester+18%Spandex");
            quality_507Sl.Add("04","91%POLYESTER+9%SPANDEX");
            quality_507Sl.Add("05","92%POLYESTER+8%SPANDEX");
            quality_507Sl.Add("06","97%POLYESTER+3%OP");
            quality_507Sl.Add("07","98%POLYESTER+2%OP");
            quality_507Sl.Add("08","87%POLYESTER+13%SPANDEX");

            // 組織
            organizationSl.Add("01","單面");
            organizationSl.Add("02","單面+OP");
            organizationSl.Add("03","鳥眼");
            organizationSl.Add("04","羅紋");
            organizationSl.Add("05","虹吸");
            organizationSl.Add("06","MESH");
            organizationSl.Add("07","雙面");
            organizationSl.Add("08","刺洞");
            organizationSl.Add("09","斜紋");
            organizationSl.Add("10","橫磯");

            // 507加工
            processSl.Add("0","磨毛");
            processSl.Add("1","刷毛");

            // 508 加工(後加工)
            process_508Sl.Add("1","AKWATEK");
            process_508Sl.Add("2","貼合");
            process_508Sl.Add("3","潑水");
        }

        /// <summary>
        /// 取得下拉框內容
        /// </summary>
        /// <param name="type">所需要的下拉框</param>
        /// <returns>下拉框內容</returns>
        public static string HtmlSelect( string type)
        {
            StringBuilder select = new StringBuilder();
            // 尺寸
            if ("size".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry size in sizeSl)
               {
                   select.Append("<option value='" + size.Key.ToString() + "'>" + size.Key.ToString() + "&nbsp;" + size.Value.ToString() + "</option>");
               }
            }
            // 性別
            if ("sex".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry sex in sexSl)
                {
                    select.Append("<option value='" + sex.Key.ToString() + "'>" + sex.Key.ToString() + "&nbsp;" + sex.Value.ToString() + "</option>");
                }
            }
            // 款式
            if ("modus".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry modus in modusSl)
                {
                    select.Append("<option value='" + modus.Key.ToString() + "'>" + modus.Key.ToString() + "&nbsp;" + modus.Value.ToString() + "</option>");
                }
            }
            // 產品大類
            if ( "bigtype".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry bigtype in prodTypeSl)
                {
                    select.Append("<option value='" + bigtype.Key.ToString() + "'>" + bigtype.Key.ToString() + "&nbsp;" + bigtype.Value.ToString() + "</option>");
                }
            }
            // 產品小類
            if ("smalltype".Equals(type))
            {
                  IList<ProdType> smalltypelist = ProdTypeDao.GetInstance().SelectProdTypeAll();
                  IEnumerator<ProdType> smalltype = smalltypelist.GetEnumerator();
                  while ( smalltype.MoveNext() )
                   {
                     select.Append("<option value='" + smalltype.Current.Id + "'>" + smalltype.Current.Id + "&nbsp;" + smalltype.Current.Name +"</option>");
                    }
            }
            // 503 輔料類別
            if ( "type_503".Equals(type) )
            {
                foreach (System.Collections.DictionaryEntry type_503 in type_503Sl)
                {
                    select.Append("<option value='" + type_503.Key.ToString() + "'>" + type_503.Key.ToString() + "&nbsp;" + type_503.Value.ToString() + "</option>");
                }
            }
            // 輔料材質
            if ("quality".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry quality in qualitySl)
                {
                    select.Append("<option value='" + quality.Key.ToString() + "'>" + quality.Key.ToString() + "&nbsp;" + quality.Value.ToString() + "</option>");
                }
            }
            // 503 輔料顏色
            if ("color_503".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry color_503 in color_503Sl)
                {
                    select.Append("<option value='" + color_503.Key.ToString() + "'>" + color_503.Key.ToString() + "&nbsp;" + color_503.Value.ToString() + "</option>");
                }
            }
            // 503 輔料尺寸
            if ("size_503".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry size_503 in size_503Sl)
                {
                    select.Append("<option value='" + size_503.Key.ToString() + "'>" + size_503.Key.ToString() + "&nbsp;" + size_503.Value.ToString() + "</option>");
                }
            }
            // 505輔料類別
            if ("type_505".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry type_505 in type_505Sl)
                {
                    select.Append("<option value='" + type_505.Key.ToString() + "'>" + type_505.Key.ToString() + "&nbsp;" + type_505.Value.ToString() + "</option>");
                }
            }
            // 505輔料尺寸
            if ("size_505".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry size_505 in size_505Sl)
                {
                    select.Append("<option value='" + size_505.Key.ToString() + "'>" + size_505.Key.ToString() + "&nbsp;" + size_505.Value.ToString() + "</option>");
                }
            }
            // 輔料風格
            if ("style".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry style in styleSl)
                {
                    select.Append("<option value='" + style.Key.ToString() + "'>" + style.Key.ToString() + "&nbsp;" + style.Value.ToString() + "</option>");
                }
            }
            // 輔料內容
            if ("content".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry content in contentSl)
                {
                    select.Append("<option value='" + content.Key.ToString() + "'>" + content.Key.ToString() + "&nbsp;" + content.Value.ToString() + "</option>");
                }
            }
            // 506長短織
            if ("short_len".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry short_len in short_lenSl)
                {
                    select.Append("<option value='" + short_len.Key.ToString() + "'>" + short_len.Key.ToString() + "&nbsp;" + short_len.Value.ToString() + "</option>");
                }
            }
            // 506 產品別
            if ("type_506".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry type_506 in type_506Sl)
                {
                    select.Append("<option value='" + type_506.Key.ToString() + "'>" + type_506.Key.ToString() + "&nbsp;" + type_506.Value.ToString() + "</option>");
                }
            }
            // 506 材質
            if ("quality_506".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry quality_506 in quality_506Sl)
                {
                    select.Append("<option value='" + quality_506.Key.ToString() + "'>" + quality_506.Key.ToString() + "&nbsp;" + quality_506.Value.ToString() + "</option>");
                }
            }
            // 506 丹尼
            if ("danny".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry danny in dannySl)
                {
                    select.Append("<option value='" + danny.Key.ToString() + "'>" + danny.Key.ToString() + "&nbsp;&nbsp;&nbsp;" + danny.Value.ToString() + "</option>");
                }
            }
            // 506 條數
            if ("article_num".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry article_num in article_numSl)
                {
                    select.Append("<option value='" + article_num.Key.ToString() + "'>" + article_num.Key.ToString() + "&nbsp;&nbsp;&nbsp;" + article_num.Value.ToString() + "</option>");
                }
            }
            // 507 材質
            if ("quality_507".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry quality_507 in quality_507Sl)
                {
                    select.Append("<option value='" + quality_507.Key.ToString() + "'>" + quality_507.Key.ToString() + "&nbsp;" + quality_507.Value.ToString() + "</option>");
                }
            }
            // 組織
            if ("organization".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry organization in organizationSl)
                {
                    select.Append("<option value='" + organization.Key.ToString() + "'>" + organization.Key.ToString() + "&nbsp;" + organization.Value.ToString() + "</option>");
                }
            }
            // 507 加工
            if ("process".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry process in processSl)
                {
                    select.Append("<option value='" + process.Key.ToString() + "'>" + process.Key.ToString() + "&nbsp;" + process.Value.ToString() + "</option>");
                }
            }
            // 508 加工
            if ("process_a".Equals(type))
            {
                foreach (System.Collections.DictionaryEntry process_a in process_508Sl)
                {
                    select.Append("<option value='" + process_a.Key.ToString() + "'>" + process_a.Key.ToString() + "&nbsp;" + process_a.Value.ToString() + "</option>");
                }
            }
            // 傳回
            return select.ToString();
        }


        public static string HtmlInput( string type)
        {
            StringBuilder input = new StringBuilder();
            if( "no".Equals(type) )
            {
                input.Append("<input type='text' id='no_All' name='no_All' value='款號' maxlength='3'  size='5' onblur=\"if(this.value=='')this.value='款號';\" onfocus=\"if(this.value == '款號'){this.value=''};\" />");
            }
            //501,502
            if( "color".Equals(type) )
            {
                input.Append("<input type='text' id='color_All' name='color_All' value='顏色'  maxlength='2' size='5' onblur=\"if(this.value=='')this.value='顏色';\" onfocus=\"if(this.value == '顏色'){this.value=''};\"/>");
            }
            // 504 風格編號
            if ("style_no_504".Equals(type))
            {
                input.Append("<input type='text' id='style_no_504' name='style_no_504' value='風格編號' size='6' maxlength='3' onblur=\"if(this.value=='')this.value='風格編號';\" onfocus=\"if(this.value == '風格編號'){this.value=''};\"/>");
            }
            // 505 款號
            if ("no_505".Equals(type))
            {
                input.Append("<input type='text' id='no_505' name='no_505' value='款號' size='5' maxlength='3' onblur=\"if(this.value=='')this.value='款號';\" onfocus=\"if(this.value == '款號'){this.value=''};\"/>");
            }
            // 505 顏色
            if ("color_505".Equals(type))
            {
                input.Append("<input type='text' id='color_505' name='color_505' value='顏色' maxlength='2' size='5' onblur=\"if(this.value=='')this.value='顏色';\" onfocus=\"if(this.value == '顏色'){this.value=''};\"/>");
            }
            // 色碼
            if ("color_code".Equals(type))
            {
                input.Append("<input type='text' id='code_color' name='code_color' value='色碼' maxlength='2' size='5' onblur=\"if(this.value=='')this.value='色碼';\" onfocus=\"if(this.value == '色碼'){this.value=''};\"/>");
            }
            // 布號
            if ("cloth_no".Equals(type))
            {
                input.Append("<input type='text' id='cloth_no' name='cloth_no' value='布號' maxlength='3' size='5' onblur=\"if(this.value=='')this.value='布號';\" onfocus=\"if(this.value == '布號'){this.value=''};\"/>");
            }
            return input.ToString();
        }


        /// <summary>
        /// 取得下拉框內容,從1開始,到end值為止
        /// </summary>
        /// <param name="end">下拉框的最大值</param>
        /// <returns>下拉框內容</returns>
        public static string HtmlSelect(int end)
        {
            return HtmlSelect(1, end);
        }


        /// <summary>
        /// 取得下拉框內容,從start開始,到end值為止
        /// </summary>
        /// <param name="start">下拉框的開始值</param>
        /// <param name="end">下拉框的結束值</param>
        /// <returns>下拉框內容</returns>
        public static string HtmlSelect(int start, int end)
        {
            StringBuilder select = new StringBuilder();
            for ( int i = start; i <= end; i++ )
            {
                select.Append("<option value=" + i + ">" + i + "</option>");
            }
            return select.ToString();
        }


        /// <summary>
        /// 取得下拉框內容,從start開始,到end值為止
        /// </summary>
        /// <param name="start">下拉框的開始值</param>
        /// <param name="end">下拉框的結束值</param>
        /// <param name="init">預設選中的值</param>
        /// <returns>下拉框內容</returns>
        public static string HtmlSelect(int start, int end, int init)
        {
            StringBuilder select = new StringBuilder();
            for ( int i = start; i <= end; i++ )
            {
                string selected = (i == init ? " selected" : "");
                select.Append("<option value=" + i + selected + ">" + i + "</option>");
            }
            return select.ToString();
        }


        /// <summary>
        /// 取得產品分類
        /// </summary>
        /// <returns></returns>
        public static SortedList GetProdType()
        {
            return prodTypeSl;
        }


        /// <summary>
        /// 取得性別SortedList
        /// </summary>
        /// <returns></returns>
        public static SortedList GetSexSl()
        {
            return sexSl;
        }


        /// <summary>
        /// 取得尺寸SortedList
        /// </summary>
        /// <returns></returns>
        public static SortedList GetSizeSl()
        {
            return sizeSl;
        }


        /// <summary>
        /// 取得款式SortedList
        /// </summary>
        /// <returns></returns>
        public static SortedList GetModusSl()
        {
            return modusSl;
        }


        /// <summary>
        /// 取得性別的編碼
        /// </summary>
        /// <param name="name">性別的中文名稱</param>
        /// <returns>性別的編碼</returns>
        public static string GetSexCode(string name)
        {
            //根據名稱取編碼
            return getHashtableValue(sexCodeHt, name);
        }


        /// <summary>
        /// 取性別的中文名稱
        /// </summary>
        /// <param name="code">性別的編碼</param>
        /// <returns>性別的中文名稱</returns>
        public static string GetSex(string code)
        {
            //根據編碼取名稱
            return getHashtableValue(sexNameHt, code);
        }


        /// <summary>
        /// 取性別的中文名稱
        /// </summary>
        /// <param name="id">貨品的編碼</param>
        /// <returns>性別的中文名稱</returns>
        public static string GetSexById(string id)
        {
            // 防呆
            if ( string.IsNullOrEmpty(id) || id.Length != 15 )
            {
                return "";
            }
            string code = id.Substring(3,1);
            //根據編碼取名稱
            return GetSex(code);
        }


        /// <summary>
        /// 取得產品類別的編碼
        /// </summary>
        /// <param name="name">產品類別的中文名稱</param>
        /// <returns>產品類別的編碼</returns>
        public static string GetProdTypeCode(string name)
        {
            //根據名稱取編碼
            ProdType p = ProdTypeDao.GetInstance().SelectProdTypeByName(name);
            if ( p != null && p.Oid > 0 )
            {
                return p.Id;
            }
            //如果傳進來的是 編碼, 直接傳回
            p = ProdTypeDao.GetInstance().SelectProdTypeById(name);
            if ( p != null && p.Oid > 0 )
            {
                return p.Id;
            }
            //查找不到,傳回
            return "";
        }


        /// <summary>
        /// 取得產品類別的中文名稱
        /// </summary>
        /// <param name="prodType">產品類別的編碼</param>
        /// <returns>產品類別的中文名稱</returns>
        public static string GetProdType(string code)
        {
            //根據編碼取名稱
            ProdType p = ProdTypeDao.GetInstance().SelectProdTypeById(code);
            if ( p != null && p.Oid > 0 )
            {
                return p.Name;
            }
            //如果傳進來的是 名稱, 直接傳回
            p = ProdTypeDao.GetInstance().SelectProdTypeByName(code);
            if ( p != null && p.Oid > 0 )
            {
                return p.Name;
            }
            //查找不到,傳回
            return "";
        }


        /// <summary>
        /// 取得產品類別的中文名稱
        /// </summary>
        /// <param name="id">貨品的編碼</param>
        /// <returns>產品類別的中文名稱</returns>
        public static string GetProdTypeById(string id)
        {
            // 防呆
            if ( string.IsNullOrEmpty(id) || id.Length != 15 )
            {
                return "";
            }
            string code = id.Substring(4, 2);
            //根據編碼取名稱
            return GetProdType(code);
        }


        /// <summary>
        /// 取得款式的編碼
        /// </summary>
        /// <param name="name">款式的中文名稱</param>
        /// <returns>款式的編碼</returns>
        public static string GetModusCode(string name)
        {
            //根據名稱取編碼
            return getHashtableValue(modusCodeHt, name);
        }


        /// <summary>
        /// 取款式的中文名稱
        /// </summary>
        /// <param name="code">款式的編碼</param>
        /// <returns>款式的中文名稱</returns>
        public static string GetModus(string code)
        {
            //根據編碼取名稱
            return getHashtableValue(modusNameHt, code);
        }


        /// <summary>
        /// 取款式的中文名稱
        /// </summary>
        /// <param name="id">貨品的編碼</param>
        /// <returns>款式的中文名稱</returns>
        public static string GetModusById(string id)
        {
            // 防呆
            if ( string.IsNullOrEmpty(id) || id.Length != 15 )
            {
                return "";
            }
            string code = id.Substring(6, 2);
            //根據編碼取名稱
            return GetModus(code);
        }


        /// <summary>
        /// 取得尺寸的編碼
        /// </summary>
        /// <param name="modus">尺寸的名稱</param>
        /// <returns>尺寸的編碼</returns>
        public static string GetSizeCode(string name)
        {
            //根據名稱取編碼
            return getHashtableValue(sizeCodeHt, name);
        }


        /// <summary>
        /// 取得尺寸的中文名稱
        /// </summary>
        /// <param name="code">尺寸的編碼</param>
        /// <returns>尺寸的中文名稱</returns>
        public static string GetSizeKey(string code)
        {
            //根據編碼取名稱
            return getHashtableValue(sizeNameHt, code);
        }


        /// <summary>
        /// 取得尺寸的中文名稱
        /// </summary>
        /// <param name="id">貨品的編碼</param>
        /// <returns>尺寸的中文名稱</returns>
        public static string GetSizeById(string id)
        {
            // 防呆
            if ( string.IsNullOrEmpty(id) || id.Length != 15 )
            {
                return "";
            }
            string code = id.Substring(8, 2);
            //根據編碼取名稱
            return GetSizeKey(code);
        }


        /// <summary>
        /// 判斷是否尺寸
        /// </summary>
        /// <param name="source">資料</param>
        /// <returns>是尺寸則傳回true,否則傳回false</returns>
        public static bool IsSize(string source)
        {
            return (!"".Equals(GetSizeCode(source)));
        }


        /// <summary>
        /// 取顏色的編碼
        /// </summary>
        /// <param name="color">顏色代碼</param>
        /// <returns>顏色值</returns>
        public static string getColorCode(string color)
        {
            string col = color.Substring(0, 2);
            //顏色
            if ( Regex.IsMatch(col, "^[a-zA-Z]{2}$") )
            {
                return col;
            }
            return "";
        }


        /// <summary>
        /// 判斷是否貨品款號
        /// </summary>
        /// <param name="source">資料</param>
        /// <returns>是則傳回true,否則傳回false</returns>
        public static bool IsProNo(object source)
        {
            string data = StringUtil.ToStr(source);
            return Regex.IsMatch(data, "^[a-zA-Z]{2}[0-9]{3}$");
        }


        /// <summary>
        /// 取進出貨日期
        /// </summary>
        /// <param name="tradeDate">進出貨日期</param>
        /// <returns>進出貨日期</returns>
        public static string getTradedate(object tradeDate)
        {
            string[] dates = new string[3];
            string date = StringUtil.ToStr(tradeDate);
            string defaultDate = DateTime.Now.ToString(@"yyyy\/MM\/dd");

            //沒有日期時,傳回當天
            if ( string.IsNullOrEmpty(date) )
                return defaultDate;
            //刪除“出貨日期:”字樣
            date = date.Replace("出貨日期", "").Replace("進貨日期", "").Replace(":", "").Replace("：", "");
            return StringUtil.ToGYDateStr(date);
        }


        /// <summary>
        /// 轉換 Hashtable,將它的 key 和 value 轉換過來,組成一個新的 Hashtable
        /// </summary>
        /// <param name="oldHashtable">原本的Hashtable</param>
        /// <returns>轉換後的Hashtable</returns>
        public static Hashtable changeHashtable(Hashtable oldHashtable)
        {
            Hashtable hashtable = new Hashtable();
            // 轉換
            foreach ( DictionaryEntry objDE in oldHashtable )
            {
                hashtable.Add(objDE.Value, objDE.Key);
            }
            return hashtable;
        }


        /// <summary>
        /// 取得 Hashtable 裡面的值,如果傳入的是裡面的值也會傳回值本身
        /// </summary>
        /// <param name="hashtable">儲存值的Hashtable</param>
        /// <param name="key">取值的key</param>
        /// <returns>取得的值</returns>
        public static string getHashtableValue(Hashtable hashtable, string key)
        {
            //根據 key 取 value
            if ( hashtable.ContainsKey(key) )
            {
                return hashtable[key].ToString();
            }
            //如果傳進來的是 value, 直接傳回
            if ( hashtable.ContainsValue(key) )
            {
                return key;
            }
            //傳回
            return "";
        }


        /// <summary>
        /// 取得 圖檔
        /// </summary>
        /// <param name="pic">圖檔的地址</param>
        /// <returns>取得的值</returns>
        public static string getPic(string pic)
        {
            //沒有圖檔時,顯示預設圖檔
            if ( string.IsNullOrEmpty(pic) )
            {
                return "/images/noimage_b.gif";
            }
            //傳回
            return pic;
        }


        /// <summary>
        /// 將List按貨品ID排序
        /// </summary>
        /// <param name="list">需排序的貨品集</param>
        public static void sort(IList<Product> list)
        {
            //防呆
            if ( list == null || list.Count == 0 )
            {
                return;
            }
            //用冒泡法排序
            Product tem = list[0];
            for ( int i = 0; i < list.Count; i++ )
            {
                for ( int j = 0; j < list.Count - i - 1; j++ )
                {
                    if ( list[j].Id.CompareTo(list[j + 1].Id) > 0 )
                    {
                        tem = list[j];
                        list[j] = list[j + 1];
                        list[j + 1] = tem;
                    }
                }
            }
        }


        /// <summary>
        /// 資料庫庫存修改記錄
        /// </summary>
        /// <param name="Pid">貨品編號</param>
        /// <param name="Type">操作單類型(中文名稱)</param>
        /// <param name="Tid">交易單號</param>
        /// <param name="Owid">出庫倉庫</param>
        /// <param name="Iwid">入庫倉庫</param>
        /// <param name="OriginQtyOut">出庫原始數量</param>
        /// <param name="OriginQtyIn">入庫原始數量</param>
        /// <param name="Changeqty">變動數量</param>
        /// <param name="Maker">變動人</param>
        public static void InventoryLog(string Pid, string Type, string Tid, string Owid, string Iwid,
           decimal OriginQtyOut, decimal OriginQtyIn, decimal Changeqty, string Maker)
        {
            try
            {
                Com.Everunion.Stock.InventoryLog paramObj = new Com.Everunion.Stock.InventoryLog();
                DateTime now = DateTime.Now;
                // 記錄當時時間
                paramObj.Createtime = string.Format("{0:yyyy/MM/dd HH:mm:ss ffff}", now);
                // 記錄內容
                paramObj.Pid = Pid;
                paramObj.Type = Type;
                paramObj.Tid = Tid;
                paramObj.Owid = Owid;
                paramObj.Iwid = Iwid;
                paramObj.OriginQtyOut = OriginQtyOut;
                paramObj.OriginQtyIn = OriginQtyIn;
                paramObj.Changeqty = Changeqty;
                paramObj.Maker = Maker;

                //成功
                Com.Everunion.Stock.Dao.InventoryLogDao.GetInstance().InsertInventoryLog(paramObj);
            }
            //失敗
            catch
            {
                log.Error("資料庫庫存修改Log 無法記錄");
            }
        }


    }
}
