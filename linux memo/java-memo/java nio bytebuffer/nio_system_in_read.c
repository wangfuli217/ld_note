public static void main(String [] args) throws IOException 
{ 
    // ����һ��capacityΪ256��ByteBuffer 
    ByteBuffer buf = ByteBuffer.allocate(256); 
    while (true) { 
        // �ӱ�׼����������һ���ַ� 
        int c = System.in.read(); 
        // ����������������ʱ���˳�ѭ�� 
        if (c == -1) 
        break; 
         
        // �Ѷ�����ַ�д��ByteBuffer�� 
        buf.put((byte) c); 
        // ������һ��ʱ������ռ����ַ� 
        
        if (c == '\n') { 
            // ����flip()ʹlimit��Ϊ��ǰ��position��ֵ,position��Ϊ0, 
            // Ϊ��������ByteBuffer��ȡ��׼�� 
            buf.flip(); 
            // ����һ��byte���� 
            byte [] content = new byte[buf.limit()]; 
            // ��ByteBuffer�ж�ȡ���ݵ�byte������ 
            buf.get(content); 
            // ��byte���������д����׼��� 
            System.out.print(new String(content)); 
            // ����clear()ʹposition��Ϊ0,limit��Ϊcapacity��ֵ�� 
            // Ϊ������д�����ݵ�ByteBuffer����׼�� 
            buf.clear(); 
        } 
    } 
}