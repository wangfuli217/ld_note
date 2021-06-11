import java.io.BufferedInputStream; 
import java.io.BufferedOutputStream; 
import java.io.DataInputStream; 
import java.io.DataOutputStream; 
import java.io.File; 
import java.io.FileInputStream; 
import java.io.FileOutputStream; 
import java.io.IOException; 
import java.net.InetSocketAddress; 
import java.nio.ByteBuffer;  
import java.nio.CharBuffer; 
import java.nio.channels.SelectionKey; 
import java.nio.channels.Selector; 
import java.nio.channels.ServerSocketChannel; 
import java.nio.channels.SocketChannel; 
import java.nio.charset.Charset; 
import java.nio.charset.CharsetDecoder; 
import java.nio.charset.CharsetEncoder; 
import java.util.Iterator;

public class NewSocketServer { 
  
    private static final int port = 9527; 
    private Selector selector; 
    private ByteBuffer clientBuffer = ByteBuffer.allocate(1024);   
    private CharsetDecoder decoder = Charset.forName("GB2312").newDecoder(); 
    private CharsetEncoder encoder = Charset.forName("GB2312").newEncoder();  
    //��������ʽ���ó�GBKҲ��.UTF-8���У���������  ��ǰ�ᶼ�ǿͻ���û�������κα�������ʽ�� 
     
    public void setListener() throws Exception{ 
         
        selector = Selector.open(); //��ѡ����    
         
        ServerSocketChannel server = ServerSocketChannel.open();  //����һ�� ServerSocketChannelͨ�� 
        server.socket().bind(new InetSocketAddress(port));  //ServerSocketChannel�󶨶˿�   
        server.configureBlocking(false);   //����ͨ��ʹ�÷�����ģʽ 
        server.register(selector, SelectionKey.OP_ACCEPT); //��ͨ����selector��ע��  �������ӵĶ��� 
         
        while(true) 
        {     
            selector.select();   //select() ��������ֱ���ڸ�selector��ע���channel�ж�Ӧ����Ϣ���� 
            Iterator iter = selector.selectedKeys().iterator();    
            while (iter.hasNext()) {     
                SelectionKey key = (SelectionKey) iter.next();    
                iter.remove();  // ɾ������Ϣ  
                process(key);   // ��ǰ�߳��ڴ�����Ϊ�˸�Ч��һ�������һ���߳��д������Ϣ�� 
            }    
        }    
    } 
     
     private void process(SelectionKey key) throws IOException {    
            if (key.isAcceptable()) { // ��������    
                ServerSocketChannel server = (ServerSocketChannel) key.channel();    
                SocketChannel channel = server.accept();//������io��socket��ServerSocketChannel��accept�������� SocketChannel 
                channel.configureBlocking(false);   //���÷�����ģʽ    
                SelectionKey sKey = channel.register(selector, SelectionKey.OP_READ);  
                sKey.attach("read_command"); //������յ���������֮�����Ϊÿ����������һ��ID 
            }  
            else if (key.isReadable()) { // ����Ϣ     
                SocketChannel channel = (SocketChannel) key.channel();    
                String name = (String) key.attachment();  
                if(name.equals("read_command")){ 
                    int count = channel.read(clientBuffer);  
                    if (count > 0) {    
                        clientBuffer.flip();    
                        CharBuffer charBuffer = decoder.decode(clientBuffer);    
                        String command = charBuffer.toString();    
                         
                        //command���磺get abc.png ����  put aaa.png 
                        System.out.println("command===="+command);  //�õ��ͻ��˴���������  
                         
                        String[] temp =command.split(" "); 
                        command = temp[0];  //����  ��put����get 
                        String filename = temp[1];  //�ļ��� 
                         
                        SelectionKey sKey = channel.register(selector,SelectionKey.OP_WRITE);    
                        if(command.equals("put"))sKey.attach("UploadReady#"+filename);  //Ҫ������ͨ�����ļ��� 
                        else if(command.equals("get")){  
                            if(!new File("C:\\",filename).exists()){ //�����ļ�������C�̸�Ŀ¼ 
                                System.out.println("û������ļ����޷��ṩ���أ�"); 
                                sKey.attach("notexists");  
                            } 
                            else sKey.attach("DownloadReady#"+filename); //Ҫ������ͨ�����ļ��� 
                        } 
                    } else {    
                        channel.close();    
                    }    
                } 
                else if(name.startsWith("read_file")){//��������¿�һ���߳�     �ļ�����Ҳ������NIO  
                    DataOutputStream fileOut =  
                        new DataOutputStream( 
                                new BufferedOutputStream( 
                                        new FileOutputStream( 
                                                new File("C:\\",name.split("#")[1])))); 
  
                    int passlen = channel.read(clientBuffer);   
                    while (passlen>=0) {    
                        clientBuffer.flip();   
                        fileOut.write(clientBuffer.array(), 0, passlen);  
                        passlen = channel.read(clientBuffer); 
                    } 
                    System.out.println("�ϴ���ϣ�"); 
                    fileOut.close();  
                    channel.close(); 
                } 
                clientBuffer.clear();    
            }  
            else if (key.isWritable()) { // д�¼�    
                SocketChannel channel = (SocketChannel) key.channel();    
                String flag = (String) key.attachment();     
                if(flag.startsWith("downloading")){//��������¿�һ���߳�   �ļ�����Ҳ������NIO 
                    DataInputStream fis = new DataInputStream( 
                            new BufferedInputStream( 
                                    new FileInputStream( 
                                            new File("C:\\",flag.split("#")[1]))));  
                      
                    byte[] buf = new byte[1024]; 
                    int len =0;  
                    while ((len = fis.read(buf))!= -1) {  
                        channel.write(ByteBuffer.wrap(buf, 0, len));   
                    }   
                    fis.close();      
                    System.out.println("�ļ��������"); 
                    channel.close(); 
                } 
                else if(flag.equals("notexists")){  
                    //channel.write(encoder.encode(CharBuffer.wrap(flag)));    
                    channel.write(ByteBuffer.wrap(flag.getBytes())); //���ñ���Ҳ��    �ͻ���ֱ�ӽ���    ����Ҳ�������� 
                    channel.close(); 
                } 
                else if(flag.startsWith("UploadReady")){  
                    channel.write(encoder.encode(CharBuffer.wrap("UploadReady")));  
                     
                    //������������ע���ͨ���Ķ�����    selectorѡ�񵽸�ͨ���Ľ�������Զ��д������Ҳ���޷���ת������Ľ����ϴ��Ĵ��� 
                    SelectionKey sKey =channel.register(selector, SelectionKey.OP_READ);//register�Ǹ��ǵ�????!!! 
                    sKey.attach("read_file#"+flag.split("#")[1]); 
                    //key.attach("read_file#"+flag.split("#")[1]); //select���������� 
                } 
                else if(flag.startsWith("DownloadReady")){  
                    channel.write(ByteBuffer.wrap("׼������".getBytes()));  
                    //channel.write(encoder.encode(CharBuffer.wrap("׼������")));    
                    key.attach("downloading#"+flag.split("#")[1]); 
                }  
            }   
        }    
     
    public static void main(String[] args) { 
         
        try { 
             System.out.println("�ȴ�����" + port + "�˿ڵĿͻ�������.....");  
            new NewSocketServer().setListener(); 
        } catch (Exception e) { 
            e.printStackTrace(); 
        } 
 
    } 
}