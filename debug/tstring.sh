tstring()
{
是的，一旦知道 TCHAR 和_T 是如何工作的，那么这个问题很简单。基本思想是 TCHAR 要么是char，
要么是 wchar_t，这取决于 _UNICODE 的值：
    // abridged from tchar.h
    #ifdef _UNICODE
    typedef wchar_t TCHAR;
    #define __T(x) L ## x
    #else
    typedef char TCHAR;
    #define __T(x) x
    #endif
当你在工程设置中选择 Unicode 字符集时，编译器会用 _UNICODE 定义进行编译。如果你选择MBCS（多字节字符集），
则编译器将不会带 _UNICODE 定义 。一切取决于_UNICODE 的值。同样，每一个使用字符指针的 Windows API 函数
会有一个 A(ASCII) 和一个 W(Wide/Unicode) 版本，这些版本的 实际定义也是根据 _UNICODE 的值来决定：
    #ifdef UNICODE
    #define CreateFile CreateFileW
    #else
    #define CreateFile CreateFileA
    #endif
模板被潜在的字符类型（char 或 wchar_t）参数化，因此，对于 TCHAR 版本，所要做的就是使用 TCHAR 来模仿定义。
       typedef basic_string< TCHAR,
        char_traits< TCHAR >,
        allocator< TCHAR > >
        tstring;
现在便有了一个 tstring，它基于 TCHAR——也就是说，它要么是 char，要么是 wchar_t，这取决于 _UNICODE 的值。 
以上示范并指出了 STL 是怎样使用 basic_string 来实现基于任何类型的字符串的。定义一个新的 typedef 并不是
解决此问题最有效的方法。一个更好的方法是基于 string 和wstring 来简单 地定义 tstring，如下：
       #ifdef _UNICODE
       #define tstring wstring
       #else
       #define tstring string
       #endif
       
    这个方法之所以更好，是因为 STL 中已经定义了 string 和 wstring，那为什么还要使用模板来定义一个新的和其中之一
 一样的字符串类呢？ 暂且叫它 tstring。可以用 #define 将 tstring 定义为 string 和 wstring，这样可以避免创建另外
 一个模板类（ 虽然当今的编译器非常智能，如果它把该副本类丢弃，我一点也不奇怪）。
 不管怎样，一旦定义了 tstring，便可以像下面这样编码：
       tstring s = _T("Hello, world");
       _tprintf(_T("s =%s\n"),s.c_str());
basic_string::c_str 方法返回一个指向潜在字符类型的常量指针；在这里，该字符类型要么是const char*，要么是 const wchar_t*。
Figure 2 是一个简单的示范程序，举例说明了 tstring 的用法。它将“Hello,world”写入一个文件，并报告写了多少个字节。我对 工程进行了设置，以便用 Unicode 生成 debug 版本，用 MBCS 生成 Release 版本。你可以分别进行编译/生成并运行程序，然后比较结果。
Figure 3 显示了例子的运行情况。

Figure 3 运行中的 tstring

　　顺便说一下，MFC 和 ATL 现在已经联姻，以便都使用相同的字符串实现。结合后的实现使用一个叫做 CStringT 的模板类，这在某种意义上 ，其机制类似 STL 的 basic_string，用它可以根据任何潜在的字符类型来创建 CString 类。在 MFC 包含文件 afxstr.h 中定义了三种字符 串类型，如下：

       typedef ATL::CStringT< wchar_t,

        StrTraitMFC< wchar_t > > CStringW;

       typedef ATL::CStringT< char,

        StrTraitMFC< char > > CStringA;

       typedef ATL::CStringT< TCHAR,

        StrTraitMFC< TCHAR > > CString;

CStringW，CStringA 和 CString 正是你所期望的：CString 的宽字符，ASCII 和 TCHAR 版本。
　　那么，哪一个更好，STL 还是 CStirng？两者都很好，你可以选择你最喜欢的一个。但有一个问题要考虑到：就是你想要链接哪个库，以及你是否已经在使用 MFC/ATL。从编码 的角度来看，我更喜欢 CString 的两个特性：
　　其一是无论使用宽字符还是char，都可以很方便地对 CString 进行初始化。

       CString s1 = "foo";

       CString s2 = _T("bar");   

　　这两个初始化都正常工作，因为 CString 自己进行了所有必要的转换。使用 STL 字符串，你必须使用_T()对 tstring 进行初始化，因为你 无法通过一个char*初始化一个wstring，反之亦然。
　　其二是 CString 对 LPCTSTR 的自动转换操作，你可以像下面这样编码：

       CString s;

       LPCTSTR lpsz = s;

　　另一方面，使用 STL 必须显式调用 c_str 来完成这种转换。这确实有点挑剔，某些人会争辩说，这样能更好地了解何时进行转换。比如， 在C风格可变参数的函数中使用 CString 可能会有麻烦，像 printf：

       printf("s=%s\n", s); // 错误

       printf("s=%s\n", (LPCTSTR)s);// 必需的 

　　没有强制类型转换的话，得到的是一些垃圾结果，因为 printf 希望 s 是 char*。
我敢肯定很多读者都犯过这种错误。防止这种灾祸是 STL 设计者不提供转换操作符的一个毋庸置疑的理由。
而是坚持要你调用 c_str。一般来讲，喜欢使用 STL 家伙趋向于理论和学究气，而 Redmontonians（译者：指微软）的大佬们则更注重实用和散漫。
嘿，不管怎样，std::string 和 CString 之间的实用差别是微不足道的
}