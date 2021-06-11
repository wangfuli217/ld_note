import java.net.InetSocketAddress;
import java.nio.ByteBuffer;
import java.nio.channels.AsynchronousSocketChannel;
import java.nio.channels.CompletionHandler;
import java.util.concurrent.ExecutionException;

public class EchoAioClient {
    private final AsynchronousSocketChannel client ;
    
    public EchoAioClient() throws Exception{
       client = AsynchronousSocketChannel.open();
    }
    
    public void start()throws Exception{
        client.connect(new InetSocketAddress("127.0.0.1",8000),null,new CompletionHandler<Void,Void>() {
            @Override
            public void completed(Void result, Void attachment) {
                try {
                    client.write(ByteBuffer.wrap("this is a test".getBytes())).get();
                    System.out.println("send data to server");
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
            }

            @Override
            public void failed(Throwable exc, Void attachment) {
                exc.printStackTrace();
            }
        });
        final ByteBuffer bb = ByteBuffer.allocate(1024);
        client.read(bb, null, new CompletionHandler<Integer,Object>(){

			@Override
			public void completed(Integer result, Object attachment) {
				 System.out.println(result);
			     System.out.println(new String(bb.array()));
			}

			@Override
			public void failed(Throwable exc, Object attachment) {
					exc.printStackTrace();
				}
        	}
        );
        

        
        try {
            // Wait for ever
            Thread.sleep(Integer.MAX_VALUE);
        } catch (InterruptedException ex) {
            System.out.println(ex);
        }
        
    }
    
    public static void main(String args[])throws Exception{
        new EchoAioClient().start();
    }
}