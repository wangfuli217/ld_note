IO()
{
    Windows支持多种不同种类的设备。在此，我们把设备定义为能够与之进行通信的任何东西。如文件、目录、串口、并口、套接字、
控制台等。接下来讨论是与这些设备进行通信，此种方式下与线程通信时，线程需要挂起等待设备响应---这种方式被称为同步IO。
}

IO()
{
CreateFile函数。
    CreateFile当然可以创建和打开磁盘文件。但是不要被它的名字所迷惑。它同样可以打开其他设备。根据传入参数的不同可以
让CreateFile打开不同的设备。

HANDLE CreateFile（
   PCTSTR pszName,
   DWORD dwDesiredAccess,
   DWORD dwShareMode,
   PSECURITY_ATTRIBUTES psa,
   DWORD dwCreationDisposition,
   DWORD dwFlagsAndAttributes,
   HANDLE hFileTemplate);
   
psaName既表示设备类型也表示该类设备一个实例。
    dwDesiredAccess用来指定我们以何种方式和设备通信。可以传入以下值：
    0                           不允许读写，但可以改变设备属性。
    GENERIC_READ                只读访问
    GENERIC_WRITE               只写访问
    GENERIC_READ|GENERIC_WRITE  读写访问。
    
    dwSharedMode用来指定共享权限：
    0                                独占对设备的访问。如果设备已经打开，我们的CreateFile会失败。
    FILE_SHARE_READ                  只读共享，不允许修改内容。如果设备已经以写入或独占方式打开，我们的CreateFile会失败。
    FILE_SHARE_WRITE                 写共享，不允许读取内容。如果设备已经以读取或独占方式打开，我们的CreateFile会失败。
    FILE_SHARE_READ|FILE_SHARE_WRITE  不关心向设备读还是写数据。如果设备已经以独占方式打开，我们的CreateFile会失败。
    FIEL_SHARE_DELETE                 先将文件标记待删除，所有对该文件引用的句柄都关闭之后，才将其真正的删除。

    psa指向一个PSECURITY_ATTRIBUTES结构，用来指定安全属性。只有当我们在具备安全性的文件系统中，
    如NTFS中创建文件时才会用到此结构。在其他情况下都只需要传入NULL就可以了，此时会用默认的安全属性来创建文件，
    并且返回的句柄是不可继承的。


    dwCreationDisposition参数对文件的含义更重大。它可以是以下值：
    CREATE_NEW        创建一个新文件。如果同名文件存在则失败。
    CREATE_ALWAYS     文件同名文件存在与否都创建文件。存在时会覆盖。
    OPEN_EXISTING     打开一个已存在文件。如不存在，则失败。
    OPEN_ALWAYS       打开一个已存在文件。如不存在，则创建。
    TRUNCATE_EXISTING 打开一个已存在文件，将文件大小截断为0,如果不存在则调用失败。

    dwFlagsAndAttributes有两个用途：
    一，允许我们设置一些标志微调与设备的通信。
    二：如果设备是文件，还可以设置文件属性。
    这些标志大多数是一些信号，用来告诉系统我们打算以何种方式来访问设备，
    这样系统就可以对缓存算法进行优化。此处不再介绍。

    hFileTemplate，既可以标识一个已经打开的文件句柄，也可以是NULL。如果是一个文件句柄，
    那么CreateFile会完全忽略dwFlagsAndAttributes参数，转而使用hFileTemplate标识的文件属性。
    此时，hFileTemplate标识的文件句柄必须是一个用GENERIC_READ标志打开的文件。

    CreateFile成功的创建或打开设备那会返回设备句柄。否则返回INVALID_HANDLE_VALUE。一定要注意返回值不是NULL哦。
  
}

IO()
{
Windows在设计时使用了64位来表示文件大小。但是64位需要分两个32位值来传入。实际上在日常工作中还有使用大于４G的文件。高32位在大多数情况下都会是０。
GetFileSizeEx用于得到文件大小。
    BOOL　GetFileSizeEx(HANDLE　hFile,PLARGE_INTEGER pliFileSize);  
    hFile表示一个一打开文件的句柄。

    pliFileSize表示文件大小。定义如下：
    typedef union _LARGE_INTEGER  
    {  
        struct  
        {  
           DWORD LowPart;  
           LONG HighPart;  
        };  
        LONGLONG QuadPart;  
    }LARGE_INTEGER,*PLARGE_INTEGER;  
    它允许我们以一个64位有符号数或者是两个32位值来表示一个64位数。
    
    
另外一个很重要的函数是GetCompressedFileSize：
DWORD GetCompressedFileSize(PCTSTR pszFileName,PDWORD pdwFileSizeHigh);
这个函数返回文件物理大小，而GetFileSizeEx是返回文件逻辑大小。

    CreateFile会创建一个文件内核对象来管理文件。返回的句柄就是对该文件内核对象的引用。
在这个内核对象中有一个文件指针，它表示应该在哪里执行下一次读取或写入操作。开始时它的值是0。
SetFilePointerEx可以通过操作文件指针实现随机访问文件。
}