using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.Drawing.Drawing2D;
using System.Security.Cryptography;
using System.IO;
using System.Net;
using System.Web;

namespace Barfoo.Library.Drawing
{
    /// <summary>
    /// ͼ������
    /// </summary>
    public static class ImageUtility
    {
        /// <summary>
        /// ����ͼƬ�ĶԱȽ��
        /// </summary>
        public enum CompareResult
        {
            ciCompareOk,
            ciPixelMismatch,
            ciSizeMismatch
        };


        /// <summary>
        /// �Ա�����ͼƬ
        /// </summary>
        /// <param name="bmp1">The first bitmap image</param>
        /// <param name="bmp2">The second bitmap image</param>
        /// <returns>CompareResult</returns>
        public static CompareResult CompareTwoImages(Bitmap bmp1, Bitmap bmp2)
        {
            CompareResult cr = CompareResult.ciCompareOk;

            //Test to see if we have the same size of image
            if (bmp1.Size != bmp2.Size)
            {
                cr = CompareResult.ciSizeMismatch;
            }
            else
            {
                //Convert each image to a byte array
                System.Drawing.ImageConverter ic =
                       new System.Drawing.ImageConverter();
                byte[] btImage1 = new byte[1];
                btImage1 = (byte[])ic.ConvertTo(bmp1, btImage1.GetType());
                byte[] btImage2 = new byte[1];
                btImage2 = (byte[])ic.ConvertTo(bmp2, btImage2.GetType());

                //Compute a hash for each image
                SHA256Managed shaM = new SHA256Managed();
                byte[] hash1 = shaM.ComputeHash(btImage1);
                byte[] hash2 = shaM.ComputeHash(btImage2);

                //Compare the hash values
                for (int i = 0; i < hash1.Length && i < hash2.Length
                                  && cr == CompareResult.ciCompareOk; i++)
                {
                    if (hash1[i] != hash2[i])
                        cr = CompareResult.ciPixelMismatch;
                }
            }
            return cr;
        }        
   
        public enum ScaleMode
        {
            /// <summary>
            /// ָ���߿����ţ����ܱ��Σ�
            /// </summary>
            HW,
            /// <summary>
            /// ָ�����߰�����
            /// </summary>
            W,
            /// <summary>
            /// ָ���ߣ�������
            /// </summary>
            H,
            /// <summary>
            /// ָ���߿�ü��������Σ�
            /// </summary>
            Cut
        };

        /// <summary>
        /// Resizes the image by a percentage
        /// </summary>
        /// <param name="imgPhoto">The img photo.</param>
        /// <param name="Percent">The percentage</param>
        /// <returns></returns>
        // http://www.codeproject.com/csharp/imageresize.asp
        public static Image ResizeImageByPercent(Image imgPhoto, int Percent)
        {
            float nPercent = ((float)Percent / 100);

            int sourceWidth = imgPhoto.Width;
            int sourceHeight = imgPhoto.Height;
            int sourceX = 0;
            int sourceY = 0;

            int destX = 0;
            int destY = 0;
            int destWidth = (int)(sourceWidth * nPercent);
            int destHeight = (int)(sourceHeight * nPercent);

            Bitmap bmPhoto = new Bitmap(destWidth, destHeight,
                                     PixelFormat.Format24bppRgb);
            bmPhoto.SetResolution(imgPhoto.HorizontalResolution,
                                    imgPhoto.VerticalResolution);

            Graphics grPhoto = Graphics.FromImage(bmPhoto);
            grPhoto.InterpolationMode = InterpolationMode.HighQualityBicubic;

            grPhoto.DrawImage(imgPhoto,
                new Rectangle(destX, destY, destWidth, destHeight),
                new Rectangle(sourceX, sourceY, sourceWidth, sourceHeight),
                GraphicsUnit.Pixel);

            grPhoto.Dispose();
            return bmPhoto;
        }


        /// <summary>
        /// ���š�����ͼƬ
        /// </summary>
        /// <param name="originalImage"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <param name="mode"></param>
        /// <returns></returns>
        public static Image ResizeImageToAFixedSize(Image originalImage, int width, int height, ScaleMode mode)
        {
            GC.Collect();
            int towidth = width;
            int toheight = height;

            int x = 0;
            int y = 0;
            int ow = originalImage.Width;
            int oh = originalImage.Height;

            switch (mode)
            {
                case ScaleMode.HW:
                    break;
                case ScaleMode.W:
                    if (height > 6000)
                    {
                        toheight = 6000;//����
                    }
                    else
                    {
                        toheight = originalImage.Height * width / originalImage.Width;//̫�����ÿռ��ڴ�̫��
                    }
                    break;
                case ScaleMode.H:
                    towidth = originalImage.Width * height / originalImage.Height;
                    break;
                case ScaleMode.Cut:
                    if ((double)originalImage.Width / (double)originalImage.Height > (double)towidth / (double)toheight)
                    {
                        oh = originalImage.Height;
                        ow = originalImage.Height * towidth / toheight;
                        y = 0;
                        x = (originalImage.Width - ow) / 2;
                    }
                    else
                    {
                        ow = originalImage.Width;
                        oh = originalImage.Width * height / towidth;
                        x = 0;
                        y = (originalImage.Height - oh) / 2;
                    }
                    break;
                default:
                    break;
            }
            //�½�һ��bmpͼƬ
            Image bitmap = new System.Drawing.Bitmap(towidth, toheight);

            //�½�һ������
            Graphics g = System.Drawing.Graphics.FromImage(bitmap);

            //���û������������
            g.CompositingQuality = CompositingQuality.HighQuality;
            g.SmoothingMode = SmoothingMode.HighQuality;
            g.InterpolationMode = InterpolationMode.HighQualityBicubic;

            //��ջ�������͸������ɫ���
            g.Clear(Color.Transparent);

            //��ָ��λ�ò��Ұ�ָ����С����ԭͼƬ��ָ������
            g.DrawImage(originalImage, new Rectangle(0, 0, towidth, toheight),
                new Rectangle(x, y, ow, oh),
                GraphicsUnit.Pixel);

            g.Dispose();

            return bitmap;
        }

        /// <summary>
        /// �����ַ�������ͼƬ����Ҫ������֤�룩
        /// </summary>
        /// <param name="code">�ַ���</param>
        /// <param name="codesize">ÿһ���ַ��Ĵ�С</param>
        /// <returns></returns>
        public static Image GenerateCaptcha(string code, double codesize)
        {
            if (string.IsNullOrEmpty(code))
            {
                return null;
            }

            System.Drawing.Bitmap image = new System.Drawing.Bitmap((int)Math.Ceiling((code.Length * codesize)), 18);
            Graphics g = Graphics.FromImage(image);

            //�������������
            Random random = new Random();

            //���ͼƬ����ɫ
            g.Clear(Color.White);

            //��ͼƬ�ı���������
            for (int i = 0; i < 25; i++)
            {
                int x1 = random.Next(image.Width);
                int x2 = random.Next(image.Width);
                int y1 = random.Next(image.Height);
                int y2 = random.Next(image.Height);

                g.DrawLine(new Pen(Color.Silver), x1, y1, x2, y2);
            }

            Font font = new System.Drawing.Font("Arial", 12, (System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));
            System.Drawing.Drawing2D.LinearGradientBrush brush = new System.Drawing.Drawing2D.LinearGradientBrush(new Rectangle(0, 0, image.Width, image.Height), Color.Blue, Color.DarkRed, 1.2f, true);
            g.DrawString(code, font, brush, 2, 1);

            //��ͼƬ��ǰ��������
            for (int i = 0; i < 200; i++)
            {
                int x = random.Next(image.Width);
                int y = random.Next(image.Height);

                image.SetPixel(x, y, Color.FromArgb(random.Next()));
            }

            //��ͼƬ�ı߿���
            g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);
            return image;
        }

        /// <summary>
        /// �����ַ���������֤��ͼƬ
        /// </summary>
        /// <param name="checkCode"></param>
        /// <param name="width"></param>
        /// <param name="height"></param>
        /// <returns></returns>
        public static System.Drawing.Bitmap GenerateCaptcha(string checkCode, Int32 width, Int32 height)
        {
            if (checkCode == null || checkCode.Trim() == String.Empty) { return null; }

            System.Drawing.Bitmap image = new System.Drawing.Bitmap(width, height);
            Graphics g = Graphics.FromImage(image);

            try
            {
                //�������������
                Random random = new Random();

                //���ͼƬ����ɫ
                g.Clear(Color.White);

                //��ͼƬ�ı���������
                for (int i = 0; i < 25; i++)
                {
                    int x1 = random.Next(image.Width);
                    int x2 = random.Next(image.Width);
                    int y1 = random.Next(image.Height);
                    int y2 = random.Next(image.Height);

                    g.DrawLine(new Pen(Color.Silver), x1, y1, x2, y2);
                }

                Font font = new System.Drawing.Font("Arial", 15, (System.Drawing.FontStyle.Bold | System.Drawing.FontStyle.Italic));
                System.Drawing.Drawing2D.LinearGradientBrush brush = new System.Drawing.Drawing2D.LinearGradientBrush(new Rectangle(0, 0, image.Width, image.Height), Color.Blue, Color.DarkRed, 1.2f, true);
                g.DrawString(checkCode, font, brush, 2, 3);

                //��ͼƬ��ǰ��������
                for (int i = 0; i < 200; i++)
                {
                    int x = random.Next(image.Width);
                    int y = random.Next(image.Height);

                    image.SetPixel(x, y, Color.FromArgb(random.Next()));
                }

                //��ͼƬ�ı߿���
                g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);

                g.Dispose();

                return image;
            }
            catch
            {
                g.Dispose();
                image.Dispose();

                return null;
            }
        }

        /// <summary>
        /// ��ͼƬת�����ڴ���
        /// </summary>
        /// <param name="image">��ת����ͼƬ</param>
        /// <param name="format">ת���ĸ�ʽ</param>
        /// <returns></returns>
        public static MemoryStream ToMemoryStream(this Image image, ImageFormat format)
        {
            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            image.Save(ms, format);
            return ms;
        }

        /// <summary>
        /// ����ͼƬ����
        /// </summary>
        /// <param name="mimeType"></param>
        /// <returns></returns>
        public static ImageCodecInfo GetEncoderInfo(String mimeType)
        {
            int j;
            System.Drawing.Imaging.ImageCodecInfo[] encoders;
            encoders = System.Drawing.Imaging.ImageCodecInfo.GetImageEncoders();
            for (j = 0; j < encoders.Length; ++j)
            {
                if (encoders[j].MimeType == mimeType)
                    return encoders[j];
            }
            return null;
        }
       
    }
}

