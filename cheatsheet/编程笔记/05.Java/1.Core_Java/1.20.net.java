
网络的基础知识:
    1、ip: 主机在网络中的唯一标识, 是一个逻辑地址。
        127. 0. 0. 1 表示本机地址。(没有网卡该地址仍然可以用)
    2、端口: 端口是一个软件抽象的概念。如果把Ip地址看作是一个电话号码的话, 端口就相当于分机号。
        进程一定要和一个端口建立绑定监听关系。端口号占两个字节。
    3、协议: 通讯双方为了完成预先制定好的功能而达成的约定。
    4、TCP/IP网络七层模型:
        物理层Physical(硬件)、 数据链路层DataLink(二进制) 、网络层Network(IP协议:寻址和路由)
        传输层Transport(TCP协议, UDP协议) 、会话层Session(端口)
        表示层Presentation、应用层Application(HTTP,FTP,TELET,SMTP,POPS,DNS)
        注: 层与层之间是单向依赖关系。对等层之间会有一条虚连接。Java中的网络编程就是针对传输层编程
    5、网络通信的本质是进程间通信。
    6、Tcp协议和UDP协议
        TCP: 开销大, 用于可靠性要求高的场合。TCP的过程相当于打电话的过程。面向连接, 可靠, 低效
        UDP: 用在对实时性要求比较高的场合。UDP的过程相当于写信的过程。无连接, 不可靠, 效率高

网络套节字 Socket(TCP)
    1、一个Socket相当于一个电话机。
        OutputStream相当于话筒
        InputStream相当于听筒
    2、服务器端要创建的对象: java.Net.ServerSocket
    3、创建一个TCP服务器端程序的步骤:
       1). 创建一个 ServerSocket
       2). 从 ServerSocket 接受客户连接请求
       3). 创建一个服务线程处理新的连接
       4). 在服务线程中, 从 socket 中获得I/O流
       5). 对I/O流进行读写操作, 完成与客户的交互
       6). 关闭I/O流
       7). 关闭Socket
/***********************************************************/
import java.net.*;
import java.io.*;
public class TcpServer{//服务器端
    public static void main(String[] args) {
        ServerSocket ss = null;
        Socket s = null;
        try{
            ss= new ServerSocket(10222);
            s = ss.accept();//客户端连上后返回Socket, 监听端口
            OutputStream os = s.getOutputStream();
            PrintWriter pw = new PrintWriter(os);
            pw.println("欢迎欢迎！");//要换行, 否则不能读取
            pw.flush();//从内存输出去
        }catch(Exception e){}
        finally{
            if(s!=null )try{s.close(); }catch(Exception e){}
            if(ss!=null)try{ss.close();}catch(Exception e){}
        }
    }
}

public class TcpClient {//接受端
    public static void main(String[] args) throws Exception {
        Socket s = new Socket("10.3.1.79", 10222);
        BufferedReader br = new BufferedReader(new InputStreamReader
            (s.getInputStream()));
        System.out.println(br.readLine());
        s.close();
    }
}
/***********************************************************/

    4、建立TCP客户端
    创建一个TCP客户端程序的步骤:
      1). 创建Socket
      2). 获得I/O流
      3). 对I/O流进行读写操作
      4). 关闭I/O流
      5). 关闭Socket

    5、网络套节字Socket(UDP)
       1. UDP编程必须先由客户端发出信息。
       2. 一个客户端就是一封信, Socket相当于美国式邮筒(信件的收发都在一个邮筒中)。
       3. 端口与协议相关, 所以TCP的3000端口与UDP的3000端口不是同一个端口

    6、URL: 统一资源定位器
       唯一的定位一个网络上的资源
       如:http://www.tarena.com.cn:8088
/***下载程序**************************************************************/
import java.net.*;
import java.io.*;
class TestUrl{
    public static void main(String[] args) throws Exception{
        String str = "http://192.168.0.23:8080/project_document.zip";
        URL url = new URL(str);//上句指定下载的地址和文件
        URLConnection urlConn = url.openConnection();
        urlConn.connect();
        InputStream is = urlConn.getInputStream();
        FileOutputStream fos = new FileOutputStream("/home/sd0807/down.zip");
        byte[] buf = new byte[4096];            //上句指定下载的地址和下载后的名称
        int length = 0;
        while((length=is.read(buf))!=-1){
            fos.write(buf, 0, length);
        }
        fos.close();
        is.close();
    }
}
/***************************************************************************/



网路:
java.net.InetAddress类
     InetAddress getLocalHost() throws UnknownHostException    取得本地端的IP
           InetAddress myaddress = InetAddress.getLocalHost();   System.out.println(myaddress);
     InetAddress getByName(String host) throws UnknownHostException   籍由DNS以Host名称取得主机的IP地址。
           InetAddress sa = InetAddress.getByName("www.moug.net");   System.out.println(myaddress); // 打印21.188.250.59
     String getHostName()  取得IP地址对应的名称
     InetAddress[] getAllByName(String host) throws UnknownHostException  取得该host对应的所有IP地址列表。
          InetAddress sa[] =  InetAddress.getAllByName("www.microsoft.com");
          for(int i=0; i<sa.length;i++){ System.out.println(sa[i]); }  // 打印: www.microsoft.com/207.46.19.254  换行 www.microsoft.com/207.46.19.190

java.net.URL 类
     InputStream openStream() throws IOException  获取HTML文件的内容
          下例中以DataInputStream对象的 read方法读取HTML内容。
/********************************************************/
 import java.net.*;
 import java.io.*;
 public class test{
     public static void main(String[] args) {
        try{
            int num;
            byte buf[] = new byte[4096];
            URL u = new URL("http://www.baidu.com/");
            DataInputStream di = new DataInputStream(u.openStream());
            while((num=di.read(buf))!=-1) {
                System.out.write(buf,0,num);
            }
        } catch (Exception e){
            System.out.println("发生了"+e+"异常");
        }
    }
}
/********************************************************/

