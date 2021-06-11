﻿using System;
using System.Collections.Generic;
using System.Collections;
using System.Text;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

namespace Com.Everunion.Util
{
    public class Code39 
    { 
        private Hashtable m_Code39 = new Hashtable(); 

        private byte m_Magnify = 0; 
        /// <summary> 
        /// 放大倍数 
        /// </summary> 
        public byte Magnify { get {return m_Magnify; }set{m_Magnify=value;} } 
         
        private int m_Height = 20; 
        /// <summary> 
        /// 图形高 
        /// </summary> 
        public int Height { get { return m_Height; } set { m_Height = value; } } 
         
        private Font m_ViewFont = null; 
        /// <summary> 
        /// 字体大小 
        /// </summary> 
        public Font ViewFont { get { return m_ViewFont; } set { m_ViewFont = value; } } 
         


        public Code39() 
        {             
            m_Code39.Add("A", "1101010010110"); 
            m_Code39.Add("B", "1011010010110"); 
            m_Code39.Add("C", "1101101001010"); 
            m_Code39.Add("D", "1010110010110"); 
            m_Code39.Add("E", "1101011001010"); 
            m_Code39.Add("F", "1011011001010"); 
            m_Code39.Add("G", "1010100110110"); 
            m_Code39.Add("H", "1101010011010"); 
            m_Code39.Add("I", "1011010011010"); 
            m_Code39.Add("J", "1010110011010"); 
            m_Code39.Add("K", "1101010100110"); 
            m_Code39.Add("L", "1011010100110"); 
            m_Code39.Add("M", "1101101010010"); 
            m_Code39.Add("N", "1010110100110"); 
            m_Code39.Add("O", "1101011010010"); 
            m_Code39.Add("P", "1011011010010"); 
            m_Code39.Add("Q", "1010101100110"); 
            m_Code39.Add("R", "1101010110010"); 
            m_Code39.Add("S", "1011010110010"); 
            m_Code39.Add("T", "1010110110010"); 
            m_Code39.Add("U", "1100101010110"); 
            m_Code39.Add("V", "1001101010110"); 
            m_Code39.Add("W", "1100110101010"); 
            m_Code39.Add("X", "1001011010110"); 
            m_Code39.Add("Y", "1100101101010"); 
            m_Code39.Add("Z", "1001101101010"); 
            m_Code39.Add("0", "1010011011010"); 
            m_Code39.Add("1", "1101001010110"); 
            m_Code39.Add("2", "1011001010110"); 
            m_Code39.Add("3", "1101100101010"); 
            m_Code39.Add("4", "1010011010110"); 
            m_Code39.Add("5", "1101001101010"); 
            m_Code39.Add("6", "1011001101010"); 
            m_Code39.Add("7", "1010010110110"); 
            m_Code39.Add("8", "1101001011010"); 
            m_Code39.Add("9", "1011001011010"); 
            m_Code39.Add("+", "1001010010010"); 
            m_Code39.Add("-", "1001010110110"); 
            m_Code39.Add("*", "1001011011010"); 
            m_Code39.Add("/", "1001001010010"); 
            m_Code39.Add("%", "1010010010010"); 
            m_Code39.Add("$", "1001001001010"); 
            m_Code39.Add(".", "1100101011010"); 
            m_Code39.Add(" ", "1001101011010"); 

        } 

         
        public enum Code39Model 
        { 
            /// <summary> 
            /// 基本类别 1234567890ABC 
            /// </summary> 
            Code39Normal, 
            /// <summary> 
            /// 全ASCII方式 +A+B 来表示小写 
            /// </summary> 
            Code39FullAscII 
        } 
        /// <summary> 
        /// 获得条码图形 
        /// </summary> 
        /// <param name="p_Text">文字信息</param> 
        /// <param name="p_Model">类别</param> 
        /// <param name="p_StarChar">是否增加前后*号</param> 
        /// <returns>图形</returns> 
        public Bitmap GetCodeImage(string p_Text, Code39Model p_Model, bool p_StarChar) 
        { 
            string _ValueText = ""; 
            string _CodeText = ""; 
            char[] _ValueChar = null; 
            switch (p_Model) 
            { 
                case Code39Model.Code39Normal: 
                    _ValueText = p_Text.ToUpper(); 
                    break; 
                default: 
                    _ValueChar=p_Text.ToCharArray(); 
                    for (int i = 0; i != _ValueChar.Length; i++) 
                    { 
                        if ((int)_ValueChar[i] >= 97 && (int)_ValueChar[i] <= 122) 
                        { 
                            _ValueText +="+"+ _ValueChar[i].ToString().ToUpper(); 
                             
                        } 
                        else 
                        { 
                            _ValueText += _ValueChar[i].ToString(); 
                        } 
                    } 
                    break; 
            } 


            _ValueChar = _ValueText.ToCharArray(); 

            if (p_StarChar == true) _CodeText += m_Code39["*"]; 

            for (int i = 0; i != _ValueChar.Length; i++) 
            { 
                if (p_StarChar==true && _ValueChar[i] == '*') throw new Exception("带有起始符号不能出现*"); 

                object _CharCode=m_Code39[_ValueChar[i].ToString()]; 
                if (_CharCode == null) throw new Exception("不可用的字符" + _ValueChar[i].ToString()); 
                _CodeText += _CharCode.ToString(); 
            } 


            if (p_StarChar == true) _CodeText += m_Code39["*"]; 
           

            Bitmap _CodeBmp = GetImage(_CodeText); 
            GetViewImage(_CodeBmp, p_Text); 
            return _CodeBmp; 
        } 

         

        /// <summary> 
        /// 绘制编码图形 
        /// </summary> 
        /// <param name="p_Text">编码</param> 
        /// <returns>图形</returns> 
        private Bitmap GetImage(string p_Text) 
        { 
            char[] _Value = p_Text.ToCharArray();              

            //宽 == 需要绘制的数量*放大倍数 + 两个字的宽    
            Bitmap _CodeImage = new Bitmap(_Value.Length * ((int)m_Magnify + 1) , (int)m_Height); 
           // Bitmap _CodeImage = new Bitmap(150 , 60);
            Graphics _Garphics = Graphics.FromImage(_CodeImage); 

            _Garphics.FillRectangle(Brushes.White, new Rectangle(0, 0, _CodeImage.Width, _CodeImage.Height)); 
           
            int _LenEx = 0; 
            for (int i = 0; i != _Value.Length; i++) 
            { 
                int _DrawWidth = m_Magnify + 1; 
                if (_Value[i] == '1') 
                { 
                    _Garphics.FillRectangle(Brushes.Black, new Rectangle(_LenEx, 0, _DrawWidth, m_Height)); 

                } 
                else 
                { 
                    _Garphics.FillRectangle(Brushes.White, new Rectangle(_LenEx, 0, _DrawWidth, m_Height)); 
                } 
                _LenEx += _DrawWidth; 
            } 
            _Garphics.Dispose(); 
            return _CodeImage; 
        } 
        /// <summary> 
        /// 绘制文字 
        /// </summary> 
        /// <param name="p_CodeImage">图形</param> 
        /// <param name="p_Text">文字</param> 
        private void GetViewImage(Bitmap p_CodeImage,string p_Text) 
        { 
            if (m_ViewFont == null) return; 
            Graphics _Graphics = Graphics.FromImage(p_CodeImage); 
            SizeF _FontSize = _Graphics.MeasureString(p_Text, m_ViewFont); 

            if (_FontSize.Width > p_CodeImage.Width || _FontSize.Height > p_CodeImage.Height - 20) 
            { 
                _Graphics.Dispose(); 
                return; 
            } 
            int _StarHeight = p_CodeImage.Height - (int)_FontSize.Height; 

            _Graphics.FillRectangle(Brushes.White, new Rectangle(0, _StarHeight, p_CodeImage.Width,(int)_FontSize.Height)); 

            int _StarWidth = (p_CodeImage.Width - (int)_FontSize.Width) / 2; 

            _Graphics.DrawString(p_Text, m_ViewFont, Brushes.Black, _StarWidth, _StarHeight); 

            _Graphics.Dispose(); 

        } 
    } 
}
