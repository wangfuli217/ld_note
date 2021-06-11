using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;
using System.Security;
using System.Threading;
using System.Windows.Forms;

namespace Barfoo.Library.Drawing
{
    /// <summary>
    /// ��Asp.Netֱ�ӵ��õİ�װ��
    /// ���ߣ�Kai.Ma http://kaima.cnblogs.com
    /// </summary>
    public class WebPreview2 
    { 
    
        private Uri _uri = null;
        private Exception _ex = null;
        private Bitmap _bitmap = null;
        private int _timeout = 400 * 3000;//�����̳߳�ʱʱ��
        private int _width = 300;//��ͼ��
        private int _height = 4000;//��ͼ��
        private bool _fullPage = false;

        private WebPreview2(Uri uri)
            : this(uri, 400 * 3000, 300, 4000, true)
        {

        }

        private WebPreview2(Uri uri, int timeout, int width, int height, bool fullPage)
        {
            _uri = uri;
            _timeout = timeout;
            _width = width;
            _height = height;
            _fullPage = fullPage;
        }

        internal Bitmap GetWebPreview()
        {
            try
            {
                //Asp.Net����Winform������ActiveX���ؼ������뿪���߳�
                Thread t = new Thread(new ParameterizedThreadStart(StaRun));
                t.SetApartmentState(ApartmentState.STA);
                t.Start(this);

                if (!t.Join(_timeout))
                {
                    t.Abort();
                    throw new TimeoutException();
                }

                if (_ex != null) throw _ex;
                if (_bitmap == null) throw new Exception();

                return _bitmap;
            }
            catch
            {
                GC.Collect();
                return null;
            }
        }

        public static Bitmap GetWebPreview(Uri uri)
        {
            WebPreview2 wp = new WebPreview2(uri);
            
            return wp.GetWebPreview();
        }
        public static Bitmap GetWebPreview(Uri uri, int timeout, int width, int height, bool fullPage)
        {
            WebPreview2 wp = new WebPreview2(uri,timeout,width,height,fullPage);
            return wp.GetWebPreview();
        }

        /// <summary>
        /// ΪWebBrowser�����̵߳�������ں������൱��Winform�����Main()
        /// </summary>
        /// <param name="_wp"></param>
        private static void StaRun(object _wp)
        {
            WebPreview2 wp = (WebPreview2)_wp;
            try
            {
               // WebPreviewBase wpb = new WebPreviewBase(wp._uri,wp._width,wp._height,wp._fullPage);
                WebPreviewBase wpb = new WebPreviewBase(wp._uri,wp._fullPage);
                wp._bitmap = wpb.GetWebPreview();
            }
            catch (Exception ex)
            {
                wp._ex = ex;
            }
        }
    }


    /// <summary>
    /// ��װ���ץͼ���ࡣWebBrowser�Դ���BrawToBitmap����ץ��һЩ��վ��ͼƬ��
    /// ����һЩת�����վ�᷵�ؿհ�ͼƬ�����Բ���ԭ����ͨ��IViewObject�ӿ�
    /// ȡ�������ͼ��ʵ��SNAP����л�������ߡ���ɡ���
    /// ԭ���ߣ���  �� http://chinasf.cnblogs.com
    /// ��װ�ߣ�Kai.Ma http://kaima.cnblogs.com
    /// </summary>
    class WebPreviewBase: IDisposable
    {
        Uri _uri = new Uri("about:blank");//ԭʼuri
        int _thumbW = 1024;     //����ͼ�߶�
        int _thumbH = 4000;      //����ͼ���
        WebBrowser _wb;         //���������
        bool _fullpage = false; //�Ƿ�ץȡȫͼ

        public WebPreviewBase(Uri uri,bool fullpage)
        {
            _wb = new WebBrowser();
            _wb.AllowWebBrowserDrop = true;
            _wb.AllowNavigation = true;
            _wb.ScriptErrorsSuppressed = false;
            _wb.ScrollBarsEnabled = false;
           // _wb.Size = new Size(1024, 4000);//������ֱ���Ϊ1024x768            
            _wb.NewWindow += new System.ComponentModel.CancelEventHandler(CancelEventHandler);
          
            _uri = uri;
        }

        /// <summary>
        /// URI ��ַ
        /// </summary>
        public Uri Uri
        {
            get { return _uri; }
            set { _uri = value; }
        }
        /// <summary>
        /// ����ͼ���
        /// </summary>
        public int ThumbW
        {
            get { return _thumbW; }
            set { _thumbW = value; }
        }
        /// <summary>
        /// ����ͼ�߶�
        /// </summary>
        public int ThumbH
        {
            get { return _thumbH; }
            set { _thumbH = value; }
        }
        //��ֹ����
        public void CancelEventHandler(object sender,System.ComponentModel.CancelEventArgs e)
        {
            e.Cancel = true;
        }
        /// <summary>
        /// ��ʼ��
        /// </summary>
        protected void InitComobject()
        {
            try
            {
                _wb.Navigate(this._uri);
                //��Ϊû�д��壬���Ա������
                while (_wb.ReadyState != WebBrowserReadyState.Complete)
                {
                    //�����ػ�
                    Application.DoEvents();
                }
                //������ע�ͣ���Ȼ��ҳ�ϵĶ�����ץ������
                _wb.Stop();
                if (_wb.ActiveXInstance == null) throw new Exception("ʵ������Ϊ��");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// ��ȡWebԤ��ͼ
        /// </summary>
        /// <returns>Bitmap</returns>
        public Bitmap GetWebPreview()
        {
            #region ����ͼƬ�߿�������������߿���ӦͼƬ�߿�
            int w = _wb.Width;
            int h = _wb.Height;
            Size sz = _wb.Size;
            if (_fullpage)
            {
                h = _wb.Document.Body.ScrollRectangle.Height; // +SystemInformation.VerticalScrollBarWidth;
                w = _wb.Document.Body.ScrollRectangle.Width; // +SystemInformation.HorizontalScrollBarHeight;
            }

            // ��С��Ȳ���С������ͼ���
            if (w < _thumbW)
                w = _thumbW;

            // ������С�߶ȣ����������
            if (h < sz.Height)
                h = sz.Height;
            //_wb.Size = new Size(w, h);

            #endregion

            try
            {
                Bitmap thumBitmap = null;
                InitComobject();
                //����snapshot�࣬ץȡ�����ActiveX��ͼ��
                Snapshot snap = new Snapshot();
                int wit= _wb.Document.Body.ScrollRectangle.Width;
                //int wit = 1024;
                int hei = _wb.Document.Body.ScrollRectangle.Height;
                _wb.Size = new Size(wit, hei);
                thumBitmap = snap.TakeSnapshot(_wb.ActiveXInstance, new Rectangle(0, 0, wit,hei));
                //int wit= thumBitmap.Width;
                //����ͼƬ��С������ѡ���Կ��Ϊ��׼���߶ȱ��ֱ���
                //thumBitmap = (Bitmap)ImageLibrary2.ResizeImageToAFixedSize(thumBitmap, _thumbW, _thumbH, ImageLibrary2.ScaleMode.W);
                thumBitmap = (Bitmap)ImageUtility.ResizeImageToAFixedSize(thumBitmap, 700, hei, ImageUtility.ScaleMode.W);
                return thumBitmap;
            }
            catch (Exception ex)
            {
                GC.Collect();
                throw ex;
            }
        }

        public void Dispose()
        {
            _wb.Dispose();
        }

    }


    #region WebPreview�����
    /// <summary>
    /// ActiveX ���������
    /// AcitveX ����ʵ�� IViewObject �ӿ�
    /// 
    /// ����:���
    /// http://chinasf.cnblogs.com
    /// chinasf@hotmail.com
    /// </summary>
    class Snapshot
    {
        /// <summary>
        /// ȡ����
        /// </summary>
        /// <param name="pUnknown">Com ����</param>
        /// <param name="bmpRect">ͼ���С</param>
        /// <returns></returns>
        public Bitmap TakeSnapshot(object pUnknown, Rectangle bmpRect)
        {
            if (pUnknown == null)
                return null;
            //����Ϊcom����
            if (!Marshal.IsComObject(pUnknown))
                return null;
            //IViewObject �ӿ�
            UnsafeNativeMethods.IViewObject ViewObject = null;
            IntPtr pViewObject = IntPtr.Zero;
            //�ڴ�ͼ
            Bitmap pPicture = new Bitmap(bmpRect.Width, bmpRect.Height);
            Graphics hDrawDC = Graphics.FromImage(pPicture);
            //��ȡ�ӿ�
            object hret = Marshal.QueryInterface(Marshal.GetIUnknownForObject(pUnknown),
                ref UnsafeNativeMethods.IID_IViewObject, out pViewObject);
            try
            {
                ViewObject = Marshal.GetTypedObjectForIUnknown(pViewObject, typeof(UnsafeNativeMethods.IViewObject)) as UnsafeNativeMethods.IViewObject;
                //����Draw����
                ViewObject.Draw((int)DVASPECT.DVASPECT_CONTENT,
                    -1,
                    IntPtr.Zero,
                    null,
                    IntPtr.Zero,
                    hDrawDC.GetHdc(),
                    new NativeMethods.COMRECT(bmpRect),
                    null,
                    IntPtr.Zero,
                    0);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                throw ex;
            }
            GC.Collect();
            //�ͷ�
            hDrawDC.Dispose();
            return pPicture;
        }
    }

    /// <summary>
    /// �� .Net 2.0 �� System.Windows.Forms.Dll ����ȡ
    /// ��Ȩ���У�΢��˾
    /// </summary>
    internal static class NativeMethods
    {
        [StructLayout(LayoutKind.Sequential)]
        public sealed class tagDVTARGETDEVICE
        {
            [MarshalAs(UnmanagedType.U4)]
            public int tdSize;
            [MarshalAs(UnmanagedType.U2)]
            public short tdDriverNameOffset;
            [MarshalAs(UnmanagedType.U2)]
            public short tdDeviceNameOffset;
            [MarshalAs(UnmanagedType.U2)]
            public short tdPortNameOffset;
            [MarshalAs(UnmanagedType.U2)]
            public short tdExtDevmodeOffset;
        }

        [StructLayout(LayoutKind.Sequential)]
        public class COMRECT
        {
            public int left;
            public int top;
            public int right;
            public int bottom;
            public COMRECT()
            {
            }

            public COMRECT(Rectangle r)
            {
                this.left = r.X;
                this.top = r.Y;
                this.right = r.Right;
                this.bottom = r.Bottom;
            }

            public COMRECT(int left, int top, int right, int bottom)
            {
                this.left = left;
                this.top = top;
                this.right = right;
                this.bottom = bottom;
            }

            public static NativeMethods.COMRECT FromXYWH(int x, int y, int width, int height)
            {
                return new NativeMethods.COMRECT(x, y, x + width, y + height);
            }

            public override string ToString()
            {
                return string.Concat(new object[] { "Left = ", this.left, " Top ", this.top, " Right = ", this.right, " Bottom = ", this.bottom });
            }

        }

        [StructLayout(LayoutKind.Sequential)]
        public sealed class tagLOGPALETTE
        {
            [MarshalAs(UnmanagedType.U2)]
            public short palVersion;
            [MarshalAs(UnmanagedType.U2)]
            public short palNumEntries;
        }
    }

    /// <summary>
    /// �� .Net 2.0 �� System.Windows.Forms.Dll ����ȡ
    /// ��Ȩ���У�΢��˾
    /// </summary>
    [SuppressUnmanagedCodeSecurity]
    internal static class UnsafeNativeMethods
    {
        public static Guid IID_IViewObject = new Guid("{0000010d-0000-0000-C000-000000000046}");

        [ComImport, Guid("0000010d-0000-0000-C000-000000000046"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        public interface IViewObject
        {
            [PreserveSig]
            int Draw([In, MarshalAs(UnmanagedType.U4)] int dwDrawAspect, int lindex, IntPtr pvAspect, [In] NativeMethods.tagDVTARGETDEVICE ptd, IntPtr hdcTargetDev, IntPtr hdcDraw, [In] NativeMethods.COMRECT lprcBounds, [In] NativeMethods.COMRECT lprcWBounds, IntPtr pfnContinue, [In] int dwContinue);
            [PreserveSig]
            int GetColorSet([In, MarshalAs(UnmanagedType.U4)] int dwDrawAspect, int lindex, IntPtr pvAspect, [In] NativeMethods.tagDVTARGETDEVICE ptd, IntPtr hicTargetDev, [Out] NativeMethods.tagLOGPALETTE ppColorSet);
            [PreserveSig]
            int Freeze([In, MarshalAs(UnmanagedType.U4)] int dwDrawAspect, int lindex, IntPtr pvAspect, [Out] IntPtr pdwFreeze);
            [PreserveSig]
            int Unfreeze([In, MarshalAs(UnmanagedType.U4)] int dwFreeze);
            void SetAdvise([In, MarshalAs(UnmanagedType.U4)] int aspects, [In, MarshalAs(UnmanagedType.U4)] int advf, [In, MarshalAs(UnmanagedType.Interface)] IAdviseSink pAdvSink);
            void GetAdvise([In, Out, MarshalAs(UnmanagedType.LPArray)] int[] paspects, [In, Out, MarshalAs(UnmanagedType.LPArray)] int[] advf, [In, Out, MarshalAs(UnmanagedType.LPArray)] IAdviseSink[] pAdvSink);
        }
    }
    #endregion 
}
