
main.c�е�start_kernel�У�sock_init��Ҫ������׽����йصĳ�ʼ���� [sk_init, skb_init init_inodecache register_filesystem]
                          do_initcall ���Э���ʼ����
                          inet_inet������INET�׽����йصĳ�ʼ����


socket(��Ҫ˵��)
{
�׽��ִ���һ��ͨ����·��һ�ˣ��洢�˸ö�������ͨ���йص���Ϣ��
��Щ��Ϣ����:ʹ�õ�Э�顢�׽���״̬��Դ��Ŀ�ĵ�ַ����������� 
���С����ݻ���Ϳ�ѡ��־�ȡ�                                  


SOCK_STREAM     �������ӵ��׽���            
SOCK_DGRAM      �������ݰ����׽���          
SOCK_RAW        ԭʼ�׽���                  
SOCK_RDM        �ɿ����ͱ����׽���          �ṩ�ɿ������ݰ����񣬴򲻱�֤���ĵ���˳��
SOCK_SEQPACKET  ˳������׽���              �ṩ˫�����ӷ��񣬱�֤˳�򡢿ɿ��Լ����ݰ�ȡ��󳤶ȣ�ÿ�ν�������ʱ�������һ�������ı��ġ�
SOCK_DCCP       ���ݰ�ӵ������Э���׽���    
SOCK_PACKET     ����ģʽ�׽���              ֧��ֱ�Ӵ������豸ֱ�ӻ�ȡ���ݰ�
                                            
����
socket sys_socket sock_create inet_create 
                              unix_create
����
send sys_send inet_sendmsg
              unix_stream_sendmsg
             
}

socket(�ֶ�)
{
socket_state state;
SS_FREE           ���׽�����δ���䣬δʹ��  
SS_UNCONNECTED    ���׽���δ�����κ�һ���Զ˵��׽���
SS_CONNECTING     �������ӹ�����
SS_CONNECTED      ������һ���׽���
SS_DISCONNECTING  ���ڶϿ����ӵĹ����С�

flags ��־
struct proto_ops *ops
struct fasync_struct *fasync_list;
struct file
struct sock
wait_queue_head_t wait
short type;
SOCK_STREAM     �������ӵ��׽���        
SOCK_DGRAM      �������ݰ����׽���      
SOCK_RAW        ԭʼ�׽���              
SOCK_RDM        �ɿ����ͱ����׽���      
SOCK_SEQPACKET  ˳������׽���          
SOCK_DCCP       ���ݰ�ӵ������Э���׽���
SOCK_PACKET     ����ģʽ�׽���          
passcred;
}

net_proto_family(Э�������)
{
LinuxĿǰ���֧��32��Э���壬ÿ��Э������һ��net_proto_family�ṹ  
ʵ������ʾ����ϵͳ��ʼ��ʱ���Ը�Э�����Ӧ��Э���峣��Ϊ�±꣬���� 
sock_register()���ṹע�ᵽȫ������net_families[NPROTO]��(NPROTOΪ 
32�������⣬����һ����ַ��ĸ����ַ���õ�ַ�峣������ʶ����Ŀǰ 
Ϊֹ��Э���峣���͵�ַ�峣����һһ��Ӧ�ģ���ֵ��ͬ��               
���ڲ�ͬ��Э���壬�䴫���Ľṹ��ʵ�����ž޴�Ĳ��죬�������Ե� 
�׽��ִ�������Ҳ���кܴ����𣬶�net_proto_family�ṹ��������Щ     
����ʹ�ø�Э�����ڳ�ʼ��ʱ������ͳһ��sock_register()ע�ᵽ      
net_families�����С����ʵ����net_proto_family�ṹ�ṩ��һ��       
Э���嵽�׽��ִ���֮��Ľӿڡ�                                     
InternetЭ�����Ӧ��ʵ��Ϊinet_family_ops���׽��ִ�������Ϊ        
inet_create()��                                                    

Э�����Ӧ��Э���峣����InternetЭ������PF_INET��
family

Э������׽��ִ�������ָ�룬ÿ��Э���嶼��һ����ͬ��ʵ��     
(*create)(struct net *net, struct socket *sock, int protocol);



}

Э�����׽��ֵĲ����������ܲ�ͬ����Linuxͨ��struct proto_ops�����ͳһ�ӿ���������Щ������
�ں�ΪINETЭ�����TCP��UDPЭ��ֱ��ṩ��inet_stream_ops��inet_dgram_ops����������
proto_ops(Э���������)
{

inet_stream_ops inet_dgram_ops inet_raw_ops

family; Э����
owner ; ����ģ��
release �ͷ��׽���
bind    ���׽��ְ󶨵�ַ
connect ������������
socketpair ���öԶ��׽���
accept ������������
getname ��ȡ������
poll ��poll��ʽ��ѯ
ioctl ִ��ioctl����
listen �����׽��ֶ˿�
shutdown �ر��׽���
setsockopt �����׽���ѡ��
getsockopt ��ȡ�׽���ѡ��
sendmsg ��������
recvmsg ��������
sendpages ����ҳ������
}

proto(����������)
{
raw_prot udp_prot tcp_prot

close �ر��׽���
connect ��������
disconnect �ж�����
accept ��������
ioctl IO����
init ��ʼ���׽���
destroy ����׽���
shutdown ��how����ķ�ʽ�ر��׽���
setsockopt �����׽���ѡ��
getsockopt ��ȡ�׽���ѡ��
sendmsg ��������
recvmsg ��������
sendpage ����ҳ������
bind �󶨵�ַ���׽���
backlog_rcv �Ӷ��н���
hash ͨ��hash������׽���
unhash �׽��ֵķ�hash����
get_port ��ȡ�˿�
entry_memory_pressure ѹ���ڴ�
memory_allocated ������ڴ���
sockets_allocated ������׽��ֽ���
memory_pressure ��memory_allocated�ڴ�����й�
sysctl_mem  �ڴ��������ָ��
sysctl_rmem д�ڴ��������ָ��
sysctl_wmem ���ڴ��������ָ��
max_header ���ͷ��
name[32] ��������


}

struct sock�������׽����ڴ����ı�ʾ�ṹ�����е��׽������ͨ���ýӿ���ʹ������Э��ջ�ķ���
��ȷ��sk_family PF_INET; ��ȷ�� sk_type SOCK_STREAM SOCK_DGRAM SOCK_RAW.
�����ķ�����sk_prot��ʾ����ָ��
sock(�������Э��)
{
sock�ṹ�ǹ��ɴ�����ƿ�Ļ������������Э�����޹أ�         
��������Э���崫���Э��Ĺ�����Ϣ����˲���ֱ����Ϊ         
�����Ŀ��ƿ���ʹ�ã���ͬЭ����Ĵ������ʹ��sock�ṹ       
ʱ������������չ��ʹ���ʺϸ��ԵĴ������ԡ����磬inet_sock  
�ṹ������sock�ṹ������һЩ������ɵģ���IPv4Э���崫��     
���ƿ�Ļ���                                                 

ָ������ӿڲ��ָ��,�����TCP�׽��֣�Ϊtcp_prot   �����UDP�׽���Ϊudp_prot��                                                                    
#define sk_prot     __sk_common.skc_prot              
sk_zapped IPX�е����ӱ�־

�ر��׽ӿڵı�־������ֵ֮һ:                     
RCV_SHUTDOWN: ����ͨ���رգ������������������    
SEND_SHUTDOWN: ����ͨ���رգ������������������   
SHUTDOWN_MASK: ��ʾ��ȫ�ر�                       
sk_shutdown 

sk_use_write_queue Ϊ1��ʾ�����Э��ʹ����

��ʶ������һЩ״̬������ֵ֮һ:                             
SOCK_SNDBUF_LOCK: �û�ͨ���׽ӿ�ѡ�������˷��ͻ�������С      
* SOCK_RCVBUF_LOCK: �û�ͨ���׽ӿ�ѡ�������˽��ջ�������С    
* SOCK_BINDADDR_LOCK: �Ѿ����˱��ص�ַ                      
* SOCK_BINDPORT_LOCK: �Ѿ����˱��ض˿�                      
sk_userlocks                                                  �û���

ͬ���������а�����������:һ�������û����̶�ȡ����   
�����������㴫������֮���ͬ���������ǿ���Linux 
�°벿���ʱ�������ƿ��ͬ�������������°벿ͬ    
ʱ���ʱ�������ƿ�                                  
sk_lock;                                                      �׽�����

���ջ�������С�����ޣ�Ĭ��ֵ��sysctl_rmem_default����32767
sk_rcvbuf                                                     ���ջ���������

���̵ȴ����С����̵ȴ����ӡ��ȴ�������������ȴ�           
������ʱ�����Ὣ�����ݴ浽�˶����С������Ա���           
����sk_clone()�г�ʼ��ΪNULL���ó�Աʵ�ʴ洢��socket�ṹ   
�е�wait��Ա�����������sock_init_data()����ɡ�           
sk_sleep                                                     �ȴ������ײ�

Ŀ��·����棬һ�㶼���ڴ���������ƿ鷢��  
���ݱ���ʱ������δ���ø��ֶβŴ�·�ɱ��·��  
�����в�ѯ����Ӧ��·�������������ֶΣ���������
�������ݵ�������������ݵ���������ٲ�ѯĿ��  
·�ɡ�ĳЩ����»�ˢ�´�Ŀ��·�ɻ��棬����Ͽ�
���ӡ����½��������ӡ�TCP�ش������°󶨶˿�   
�Ȳ���                                        
sk_dst_cache                                                ·�ɻ���ָ��

����Ŀ��·�ɻ���Ķ�д��
sk_dst_lock                                               Ŀ�ı������

��IPSee��صĴ������
sk_policy

���ն���sk_receive_queue�����б������ݵ��ܳ��� .�ó�Ա��skb_set_owner_r()�����л����
sk_rmem_alloc                                              ���ջ�����з������

���ն��У��ȴ��û����̶�ȡ��TCP�Ƚ��ر�  
�����յ������ݲ���ֱ�Ӹ��Ƶ��û��ռ�ʱ�Ż� 
�����ڴ�                                   
sk_receive_queue                                          �׽��ֻ��������ն���

���ڴ�����ƿ��У�Ϊ���Ͷ����������SKB���������ܳ��ȡ������Ա��            
sk_wmem_queued��ͬ��������Ϊ���Ͷ������SKB���������ڴ涼��ͳ�Ƶ�            
sk_wmem_alloc��Ա�С����磬��tcp_transmit_skb()�л��¡���Ͷ����е�          
SKB����¡������SKB��ռ���ڴ��ͳ�Ƶ�sk_wmem_alloc��������sk_wmem_queued�С�                                                                         
�ͷ�sock�ṹʱ�����Ƚ�sk_wmem_alloc��Ա��1�����Ϊ0��˵��û�д�              
���͵����ݣ��Ż������ͷš���������Ҫ�Ƚ����ʼ��Ϊ1   ,�μ�                  
sk_alloc()���ó�Ա��skb_set_owner_w()�л���¡�                                          
sk_wmem_alloc                                             ���ͻ������������

���Ͷ��У���TCP�У��˶���ͬʱҲ���ش����У�
��sk_send_head֮ǰΪ�ش����У�֮��Ϊ����   
���У��μ�sk_send_head                                    
sk_write_queue                                            �׽��ֻ��������Ͷ���

���丨�������������ޣ��������ݰ�����������ѡ�
���ù���ʱ���䵽���ڴ���鲥���õ�                       
sk_omem_alloc                                             �������������з������

Ԥ���仺�泤�ȣ���ֻ��һ����ʶ��Ŀǰ ֻ����TCP��                        
������Ļ���С�ڸ�ֵʱ�������Ȼ�ɹ���������Ҫ                          
����ȷ�Ϸ���Ļ����Ƿ���Ч���μ�__sk_mem_schedule().                    
��sk_clone()�У�sk_forward_alloc����ʼ��Ϊ0.                            
                                                                        
update:sk_forward_alloc��ʾԤ���䳤�ȡ������ǵ�һ��ҪΪ                 
���ͻ�����з���һ��struct sk_buffʱ�����ǲ�����ֱ��                    
������Ҫ���ڴ��С�����ǻ����ڴ�ҳΪ��λ����                            
Ԥ����(��ʱ��������ķ����ڴ�)����������·���                          
�ɹ���struct sk_buff���뻺�����sk_write_queue�󣬴�sk_forward_alloc    
�м�ȥ��sk_buff��truesizeֵ���ڶ��η���struct sk_buffʱ��ֻҪ��         
��sk_forward_alloc�м�ȥ�µ�sk_buff��truesize���ɣ����sk_forward_alloc 
�Ѿ�С�ڵ�ǰ��truesize�������ټ���һ��ҳ��������ֵ��                  
���ۼ���tcp_memory_allocated��                                          
  Ҳ����˵��ͨ��sk_forward_allocʹȫ�ֱ���tcp_memory_allocated����      
��ǰtcpЭ���ܵĻ����������ڴ�Ĵ�С�����Ҹô�С��                       
ҳ�߽����ġ�                                                      
sk_forward_alloc                                         ��ǰ����Ŀռ�

�ڴ���䷽ʽ���μ�include\linux\gfp.h��ֵΪ__GFP_DMA�� 
sk_allocation                                            ����ģʽ

���ͻ��������ȵ����ޣ����Ͷ����б��������ܳ��Ȳ��� 
������ֵ.Ĭ��ֵ��sysctl_wmem_default����32767      
sk_sndbuf                                               ���ͻ���������

��־λ�����ܵ�ȡֵ�μ�ö������sock_flags.
�ж�ĳ����־�Ƿ����õ���sock_flag������  
�жϣ�������ֱ��ʹ��λ������             
sk_flags                                                 ��־

��ʶ�Ƿ��RAW��UDP����У��ͣ�����ֵ֮һ:  
UDP_CSUM_NOXMIT: ��ִ��У���              
UDP_CSUM_NORCV: ֻ����SunRPC               
UDP_CSUM_DEFAULT: Ĭ��ִ��У���           
sk_no_check

sk_debug                  SO_DEBUG
sk_rcvtstamp              SO_TIMESTAMP
sk_no_largesend           �Դ���ٵ÷���֧��

Ŀ��·�������豸�����ԣ���sk_setup_caps()�и���  
net_device�ṹ��features��Ա����                 
sk_route_caps           ��������������־

�ر��׽���ǰ����ʣ�����ݵ�ʱ��
sk_lingertime        SO_LINGER����
sk_hashent           hash����
sk_pair               

�󱸽��ն��У�Ŀǰֻ����TCP.������ƿ鱻������(��Ӧ�ò�
��ȡ����ʱ),�����µı��Ĵ��ݵ�������ƿ�ʱ��ֻ�ܰѱ��� 
�ŵ��󱸽��ܶ����У�֮�����û����̶�ȡTCP����ʱ���ٴ�  
�ö�����ȡ�����Ƶ��û��ռ���.                          
һ���û����̽���������ƿ飬�ͻ���������               
�󱸶��У���TCP�δ���֮����ӵ����ն����С�             sk_buff�ṹ��backlog����
sk_backlog

ȷ��������ƿ���һЩ��Աͬ�����ʵ�������Ϊ��Щ��Ա���� 
�ж��б����ʣ������첽���ʵ�����                        ���ڻص���������
sk_callback_lock

�������������ϸ�ĳ�����Ϣ��Ӧ�ó���ͨ��setsockopt        
ϵͳ��������IP_RECVERRѡ������ȡ��ϸ������Ϣ����        
�д�����ʱ����ͨ��recvmsg()������flagsΪMSG_ERRQUEUE      
����ȡ��ϸ�ĳ�����Ϣ                                        
update:                                                     
sk_error_queue���ڱ��������Ϣ����ICMP���յ������Ϣ����    
UDP�׽��ֺ�RAW�׽���������ĳ���ʱ�����������������Ϣ��    
SKB��ӵ��ö����ϡ�Ӧ�ó���Ϊ��ͨ��ϵͳ���û�ȡ��ϸ��       
������Ϣ����Ҫ����IP_RECVERR�׽���ѡ�֮���ͨ������      
flagsΪMSG_ERRQUEUE��recvmsgϵͳ��������ȡ��ϸ�ĳ���        
��Ϣ��                                                      
UDP�׽��ֺ�RAW�׽����ڵ���recvmsg��������ʱ����������       
MSG_ERRQUEUE��־��ֻ���׽��ֵĴ�������Ͻ��մ������        
�����������ݡ�ʵ�����������ͨ��ip_recv_error()����ɵġ�   
�ڻ������ӵ��׽����ϣ�IP_RECVERR�������������ͬ������      
���������Ϣ����������У������������������յ��Ĵ�����Ϣ    
���û����̡�����ڻ��ڶ����ӵ�TCPӦ���Ǻ����õģ���Ϊ       
TCPҪ����ٵĴ�������Ҫע����ǣ�TCPû�д�����У�      
MSG_ERRQUEUE���ڻ������ӵ��׽�������Ч�ġ�                  
������Ϣ���ݸ��û�����ʱ��������������Ϣ��Ϊ���ĵ����ݴ���  
���û����̣������Դ�����Ϣ�����ʽ������SKB���ƿ��У�       
ͨ��ͨ��SKB_EXT_ERR������SKB���ƿ��еĴ�����Ϣ�顣          
�μ�sock_exterr_skb�ṹ��                                    �����sk_buff����
sk_error_queue

sk_prot                                                      �׽��ֵĴ����Э�������
��¼��ǰ������з��������һ����������Ĵ����룬��  
Ӧ�ò��ȡ����Զ��ָ�Ϊ��ʼ����״̬.               
���������������tcp_v4_err()������ɵġ�            
sk_err                                                       �����¼
sk_err_soft

sk_ack_backlog                                              ��ǰ�ѽ�����������

���Ӷ��г��ȵ����� ����ֵ���û�ָ��������                        
���г�����/proc/sys/net/core/somaxconn(Ĭ��ֵ��128)֮��Ľ�Сֵ��
sk_max_ack_backlog

���������ɴ��׽���������ݰ���QoS���
sk_priority

�������׽������ͣ���SOCK_STREAM 
sk_type

��ǰ�����׽���������Э�� 
sk_protocol

sk_localroute
ʹ�ñ���·�ɱ��ǲ���·�ɱ�

�������������׽��ֵ��ⲿ���̵������֤��Ŀǰ��Ҫ����PF_UNIXЭ����
sk_peercred

�׽��ֲ���ճ�ʱ����ʼֵΪMAX_SCHEDULE_TIMEOUT��   
����ͨ���׽���ѡ��SO_RCVTIMEO�����ý��յĳ�ʱʱ�䡣
sk_rectimeo

�׽��ֲ㷢�ͳ�ʱ,��ʼֵΪMAX_SCHEDULE_TIMEOUT��     
����ͨ���׽���ѡ��SO_SNDTIMEO�����÷��͵ĳ�ʱʱ�䡣 
sk_sndtimeo

�׽��ֹ��������ڴ�������������ݰ�ͨ��BPF���˴�����й��ˣ� 
ֻ���������׽��ֹ������Ľ�����Ч��                            
sk_filter

������ƿ���˽�����ݵ�ָ��  
sk_protinfo


���ڷ��䴫����ƿ��slab���ٻ��棬��ע���Ӧ�����Э��ʱ����
sk_slab

ͨ��TCP�Ĳ�ͬ״̬����ʵ�����Ӷ�ʱ����FIN_WAIT_2��ʱ���Լ�    
TCP���ʱ������tcp_keepalive_timer��ʵ��                   
��ʱ��������Ϊtcp_keepalive_timer(),�μ�tcp_v4_init_sock() 
��tcp_init_xmit_timers()��                                   
sk_timer

��δ����SOCK_RCVTSTAMP�׽���ѡ��ʱ����¼���Ľ������ݵ�  
Ӧ�ò��ʱ�����������SOCK_RCVTSTAMP�׽���ѡ��ʱ������  
���ݵ�Ӧ�ò��ʱ�����¼��SKB��tstamp��                 
sk_stamp

ָ���Ӧ�׽��ֵ�ָ��
sk_socket

RPC����˽�����ݵ�ָ�� ��IPv4��δʹ��
sk_user_data

ָ��Ϊ��������ƿ����һ�η����ҳ�棬ͨ��                      
�ǵ�ǰ�׽��ַ��Ͷ��������һ��SKB�ķ�Ƭ���ݵ�                   
���һҳ������ĳ�������״̬��Ҳ�п��ܲ���(                     
���磬��tcp_sendmsg�гɹ�������ҳ�棬����������ʧ����)��        
ͬʱ����������ϵͳ��ҳ������������ҳ�棬�����ϵͳ            
��ҳ�棬�ǲ�����ҳ�������޸ĵģ���������ڷ��͹���              
�����������ҳ�棬����Զ�ҳ���е����ݽ����޸Ļ���ӣ�          
�μ�tcp_sendmsg.                                                
                                                                
sk_sndmsg_page��sk_sndmsg_off��Ҫ�𻺴�����ã�����ֱ���ҵ�     
���һ��ҳ�棬Ȼ���԰�����׷�ӵ���ҳ�У�������У������      
��ҳ�棬Ȼ������ҳ�������ݣ�������sk_sndmsg_page��sk_sndmsg_off 
��ֵ                                                            
sk_sndmsg_page

��ʾ����β�������һҳ��Ƭ�ڵ�ҳ��ƫ�ƣ� 
�µ����ݿ���ֱ�Ӵ����λ�ø��Ƶ��÷�Ƭ�� 
sk_sndmsg_off

ָ��sk_write_queue�����е�һ��δ���͵Ľ�㣬���sk_send_head  
Ϊ�����ʾ���Ͷ����ǿյģ����Ͷ����ϵı�����ȫ�����͡�        
sk_send_head;

��ʶ�����ݼ���д���׽ӿڣ� 
Ҳ������д���ݵ�����*/     
sk_write_pending


ָ��sk_security_struct�ṹ����ȫģ��ʹ��
sk_security

���Ͷ��еĻ���������Ƿ���С��
sk_queue_shrunk

��������ƿ��״̬�����仯ʱ��������Щ�ȴ����׽��ֵĽ��̡� 
�ڴ����׽���ʱ��ʼ����IPv4��Ϊsock_def_wakeup()            
    void            (*sk_state_change)(struct sock *sk);

�������ݵ�����մ���ʱ�����ѻ����ź�֪ͨ׼�������׽��ֵ�        
���̡��ڴ����׽���ʱ����ʼ����IPv4��Ϊsock_def_readable()�����   
��netlink�׽��֣���Ϊnetlink_data_ready()��                       
    void            (*sk_data_ready)(struct sock *sk, int bytes);

�ڷ��ͻ����С�����仯���׽��ֱ��ͷ�ʱ��������ȴ����׽��ֶ�     
����˯��״̬�Ľ��̣�����sk_sleep�����Լ�fasync_list�����ϵ�      
���̡������׽���ʱ��ʼ����IPv4��Ĭ��Ϊsock_def_write_space(),    
TCP��Ϊsk_stream_write_space().                                  
void            (*sk_write_space)(struct sock *sk);
  
    
�������Ļص�����������ȴ��ô�����ƿ�Ľ�������˯�ߣ� 
���份��(����MSG_ERRQUEUE).�ڴ����׽���ʱ����ʼ����    
IPv4��Ϊsock_def_error_report().                         
    void        (*sk_error_report)(struct sock *sk);

����TCP��PPPoE�С���TCP�У����ڽ���Ԥ�����кͺ󱸶����е�      
TCP�Σ�TCP��sk_backlog_rcv�ӿ�Ϊtcp_v4_do_rcv()�����Ԥ��      
�����л�����TCP�Σ������tcp_prequeue_process()Ԥ������      
�ú����л�ص�sk_backlog_rcv()������󱸶����л�����TCP�Σ�    
�����release_sock()����Ҳ��ص�sk_backlog_rcv()���ú���     
ָ���ڴ����׽��ֵĴ�����ƿ�ʱ�ɴ����backlog_rcv�ӿڳ�ʼ��    
      int        (*sk_backlog_rcv)(struct sock *sk,struct sk_buff *skb);             
    
���д�����ƿ�����٣����ͷŴ�����ƿ�ǰ�ͷ�һЩ������Դ����   
sk_free()�ͷŴ�����ƿ�ʱ���á���������ƿ�����ü�����Ϊ0ʱ�� 
�������ͷš�IPv4��Ϊinet_sock_destruct().                      
    void                    (*sk_destruct)(struct sock *sk);
  
}

inet_protosw��һ���Ƚ���Ҫ�Ľṹ��ÿ�δ����׽���ʱ���õ����˽ṹҲֻ���׽��ֲ������á�                                    
TCP��Ӧ�Ĵ�����inetsw_array�С�                               

inet_protosw()
{
���ڳ�ʼ��ʱ��ɢ�б��н�typeֵ��ͬ��inet_protosw�ṹʵ�����ӳ�����                                                       
list ����ͷ

��ʶ�׽��ֵ����ͣ�����InternetЭ���干����������SOCK_DGRAM��SOCK_STREAM��SOCK_RAW����Ӧ�ó���㴴�� 
�׽��ֺ���socket�����ĵڶ�������typeȡֵǡ�ö�Ӧ��  
type INET�׽�������

��ʶЭ�������Ĳ�Э��ţ�InternetЭ�����е�ֵ����IPPROTO_TCP��IPPROTO_UDP�ȡ�                                                                     
protocl ���Ĳ�Э��

�׽��������ӿڡ�TCPΪtcp_prot��UDPΪudp_prot��ԭʼ�׽���Ϊ raw_prot��                                                   
prot   �����Э�������

�׽��ִ����ӿڡ�TCPΪinet_stream_ops��UDPΪinet_dgram_ops��ԭʼ�׽���Ϊinet_sockraw_ops��                                                        
ops    Э�����׽��ֲ�����

������0ʱ����Ҫ���鵱ǰ�����׽��ֵĽ����Ƿ�������������TCP��UDP��Ϊ-1,��ʾ������������ļ��飬ֻ��ԭʼ�׽���ΪCAP_NET_RAW��                     
capability ƥ���ֶ�

    ��ʶ�Ƿ���Ҫ����ִ��У��ͣ�����TCP��˵������У����Ǳ���ģ����ֵ��Ψһ
Ϊ0��ע��˴�0ΪҪУ�顣��RAW��UDP��no_checkֵ��ȡ��ΪUDP_CSUM_NOXMIT�ȡ�
no_check У���ֶ�

������־�����ڳ�ʼ��������ƿ��is_icsk��Ա����ȡ��ֵΪINET_PROTOSW_REUSE�ȡ�                              
flags   ��־�ֶ�
}

                                                                     
��ʶ�˿��Ƿ�������                                                                                                                         
#define INET_PROTOSW_REUSE 0x01                                                                  
��ʶ��Э�鲻�ܱ�ж�ػ��滻                                                                                                                 
#define INET_PROTOSW_PERMANENT 0x02                                                                       
��ʶ�ǲ����������͵��׽���                                                                                                                    
#define INET_PROTOSW_ICSK      0x04 



net_protocol()
{
                               tcp_protocol   udp_protocol icmp_protocol
handler ָ��������ݰ�����     tcp_v4_rcv    udp_rcv     icmp_rcv
err_handle ������ĺ���      tcp_v4_err    udp_err     NULL
no_policy                      1             1           0
}


msghdr()
{
msg_name        �����еĵ�ַָ�룬����ָ��ṹ��struct sockaddr
msg_namelen     msg_name�ĳ���
msg_iov          ָ��ṹ��struct iovec��ָ�룬��¼��������
msg_iovlen       msg_iov�ĳ���
msg_control      ���ڷ��͵Ŀ�����Ϣ
msg_controllen   msg_control�ĳ���
msg_flag         ��־�ֶ�
}     


inet_sock()
{
inet_sock�ṹʽ�Ƚ�ͨ�õ�IPv4Э���������飬����IPv4Э�������     
����㣬��UDP��TCP�Լ�ԭʼ������ƿ鹲�е���Ϣ(�ⲿ�ͱ���IP��ַ�� 
�ⲿ�ͱ��ض˿ںš�IP�ײ�ԭ�͡��ö˽ڵ�ʹ�õ�IPѡ���).            

sock�ṹ��ͨ�õ�����������飬���ɴ�����ƿ�Ļ���
struct sock        sk;

���֧��IPv6���ԣ�pinet6��ָ��IPv6���ƿ��ָ�� 
struct ipv6_pinfo    *pinet6;                              

Ŀ��IP��ַ
__be32            daddr;

�Ѱ󶨵ı���IP��ַ����������ʱ����Ϊ������һ���ֲ������������Ĵ�����ƿ�                                 
__be32            rcv_saddr;
Ҳ��ʶ����IP��ַ�����ڷ���ʱʹ�á�rcv_saddr��saddr����������IP��ַ������;��ͬ                       
__be32            saddr;


Ŀ�Ķ˿ں�
__be16            dport;
�����ֽ���洢�ı��ض˿�
__u16            num;
��numת���ɵ������ֽ����Դ�˿ڣ�Ҳ���Ǳ��ض˿�
__be16            sport;


�������ĵ�TTL,Ĭ��ֵΪ-1����ʾʹ��Ĭ�ϵ�TTLֵ�����IP���ݰ�ʱ��TTLֵ���ȴ������ȡ����û��
���ã����·�ɻ����metric�л�ȡ���μ�IP_TTL�׽���ѡ��                                   
__s16            uc_ttl;

���һЩIPPROTO_IP�����ѡ��ֵ�����ܵ�ȡֵΪIP_CMSG_PKTINFO�� 
__u16            cmsg_flags;
ָ��IP���ݰ�ѡ���ָ��
struct ip_options    *opt;

һ������������ֵ����������IP�ײ��е�id��
__u16            id;


��������IP���ݰ��ײ���TOS�򣬲μ�IP_TOS�׽���ѡ��
__u8            tos;

�������öಥ���ݰ���TTL
__u8            mc_ttl;

��ʶ�׽����Ƿ�����·��MTU���ֹ��ܣ���ʼֵ����ϵͳ���Ʋ���ip_no_pmtu_disc��ȷ�����μ�IP_MTU_DISCOVER 
�׽���ѡ����ܵ�ȡֵ��IP_PMTUDISC_DO��           
__u8            pmtudisc;

��ʶ�Ƿ����������չ�Ŀɿ�������Ϣ���μ�IP_RECVERR�׽���ѡ��            
__u8            recverr:1,

��ʶ�Ƿ�Ϊ�������ӵĴ�����ƿ飬���Ƿ�Ϊ����inet_connection_sock�ṹ�Ĵ�����ƿ飬��TCP�Ĵ�����ƿ�  
is_icsk:1,

��ʶ�Ƿ�����󶨷�������ַ���μ�IP_FREEBIND�׽���ѡ��
freebind:1,

��ʶIP�ײ��Ƿ����û����ݹ������ñ�ʶֻ����RAW�׽��֣�һ�����ú�IPѡ���е�IP_TTL��IP_TOS����������       
hdrincl:1,

��ʶ�鲥�Ƿ����·
mc_loop:1,     
transparent:1, 
mc_all:1;      

�����鲥���ĵ������豸�����š����Ϊ0�����ʾ���Դ��κ������豸����                       
int            mc_index;

�����鲥���ĵ�Դ��ַ          
__be32            mc_addr;                   
�����׽��ּ�����鲥��ַ�б�  
struct ip_mc_socklist    *mc_list;        

UDP��ԭʼIP��ÿ�η���ʱ�����һЩ��ʱ��Ϣ����UDP���ݰ���ԭʼIP���ݰ���Ƭ�Ĵ�С                           
cork; 
}
           