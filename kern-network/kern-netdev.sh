net_device(�������������豸�����ݽṹ)
{
net_device�ṹ�������������ӿڲ�������Ҫ�Ľṹ�����в��������˽ӿڷ������Ϣ��������Ӳ����Ϣ����ʹ�ýṹ�ܴ�ܸ��ӡ�
���ӿں�������ȫ������һ��Ҳ��������ϵ�һ��ʧ����˿��Կ���������һ��ע��"Actually, this whole structure is a big mistake"��  
net_device�ṹ�ĳ�Ա���¿��Է�Ϊ���¼���:                              
1)Ӳ����Ϣ��Ա����:�������豸��صĵײ�Ӳ����Ϣ����������������豸���������ⲿ����Ϣ��Ч��                          
2)�ӿ���Ϣ��Ա����:��Щ��Ϣ��Ҫ��Ϊ����Ӳ�����͵�setup()�����õģ�����̫����˵��ether_setup()����̫�����豸���øú������ô󲿷ֳ�Ա��                                    
3)�豸�����ӿڱ���:�豸�Ľӿ���Ҫ�ṩ�������ݻ�����豸��һЩ���ܣ��緢�����ݰ��Ľӿڡ������                      
   �ر��豸�Ľӿڵȡ�����Щ�ӿ��У���Щ�Ǳ���ģ�����Щ�ǿ�ѡ�ģ������豸�ṩ�������йء�                            
4)������Ա������                                                       


1. ͨ���ֶ�
�����豸���������ע���豸ʱ�������������к���%d��ʽ���ַ�������ʹ��һ����0��ʼ����ı���滻����ʹ֮��Ϊϵͳ��Ψһ�����ơ�     
name�ֶΣ�

���������豸���������Ӷ��struct net_device�ṹ��ϵͳ��Ҫ��װ��������豸ʱ����Ҫ����Щ�豸��֯��������ȫ�ֱ���
dev_baseͳһ����
next�ֶΣ�

ָ���ɱ������豸������ģ�顣
owner�ֶΣ�

�����豸������ֵ��Ҳ��������ʶ�����豸���������豸��dev_get_indexΪ���豸����һ������ֵ���Ա���ٶ�λ�����豸
ifindex�ֶΣ�

�����豸��״̬��Ϣ
state�ֶΣ�

ʱ���ֶΣ� trans_start ����ķ���ʱ��
           last_rx     ������հ�ʱ��
           watchdog_timero ��Ϸ������ݵĶ�ʱ��
           watchdog_tmer ��ʱ���б�
           
priv�ֶΣ�ָ���������豸�����йص�˽�����ݽṹ

�豸���й����ֶΣ� qdiscָ�� struct Qdisc���͵Ľṹ�壬�����������豸���Ŷӹ��� 
                   qdisc_ingress������й���
                   qdisc_list���й�������

refcnt�ֶΣ����������豸�����ô�����

ͬ�����ֶΣ� ingress_lock ���뱣����
             xmit_lock ����ָ�� hard_start_xmit��ͬ����
             xmit_lock_owner ӵ�з�����xmit_lock�Ĵ��������
             queue_lock ���б�����             
2. Ӳ�������ֶ�
�ڴ湲���ֶΣ���ַmem_start��mem_endָ���˷��Ͱ���������
              ��ַrmem_start��rmem_endָ���˽��հ�������
base_addr: �����������������豸IO����ַ
irq���豸ʹ�õ��жϺ�
dms��������豸��DMAͨ����
if_port:��˿��豸ʹ�õĲ�ͬ�˿ڣ��������������ȷ����������̫���豸��Ҫ����BNC��˫���ߡ�AUI�˿ڡ�

              

3. ����������ֶ�
hard_header_length:��ʾ��2��Э��ͷ�����ȡ�������̫������hard_header_length�ֶ�ȡֵΪ14.
mtu�ֶΣ�����䵥Ԫ����̫��1500�ֽڡ��������Э��ģ��ͨ���ײ��豸�������ݰ�ʱ��������ݸ�ֵ���к����Ƭ��
         �Ա��ⷢ�����������ݰ���
tx_queue_len: �����豸������е���󳤶ȡ�
type���ӿڵ�Ӳ�����͡�ARPģ�鴦���У���type���жϽӿڵ�Ӳ����ַ���͡�����̫���ӿڸ��ֶ�ֵӦΪARPHRD_ETHER��                             
��ַ�ֶΣ�broadcast�㲥��ַ��dev_addr Ӳ����ַ addr_lenӲ����ַ���ȣ�dev_mc_list �ಥ��ַ��mc_count��devx_mc_list�е�ַ��Ŀ��
   

4. ����������ֶ�
atalk_ptr��AppleTalk���ָ�룬AppleTalkΪ��·��Э����
ip_ptr��IPV4�������,�洢������Ϊin_device�ṹ
dn_ptr��DECnet������ݣ�DECnet ���������豸��˾(Digital Equipment Corporation) �Ƴ���֧�ֵ�һ��Э�鼯��                                               
ip6_ptr��IPV6�������
ec_ptr��Econet�������
ax25_ptr��AX.25Э����Ϣ
family�������豸���õ�Э���ַ�壻
pa_alen:Э���ַ���ȡ� pa_adr��ʾ�����豸��ַ��pa_baddr �㲥��ַ pa_mask�������� pa_dstaddr ��Ե�����
����TCP-IPЭ���壺familyֵȡAF_INET����pa_alen�ֶ���4�ֶΡ�
flag�ֶΣ�
IFF_UP����ʶ�ӿ��Ѽ�����Կ�ʼ�������ݰ���
IFF_BROADCAST����ʶ�ýӿ�����㲥�� 
IFF_DEBUG:��ʶ����ģʽ���ñ�־�������������ڵ���Ŀ�ĵĴ���printk���á��û������ͨ��ioctl���û�����ñ�־��                            
IFF_LOOPBACK:�ñ�־ֻ�ܶԻػ��豸�������á��ں˼��IFF_LOOPBACK��־���жϽӿ��Ƿ�Ϊ�ػ��豸�������ǽ�lo��Ϊ����Ľӿ����ƽ����жϡ�           

�ñ�־�����ӿ����ӵ���Ե���·�������־�������������ã���ʱҲ��ifconfig���á�����PPP�����������øñ�־��              
IFF_POINTOPOINT:�ӿ�Ϊ��Ե�����
IFF_NOTRAILERS: ��������trailer
IFF_RUNNING:    ��Դ�ѷ���
IFF_NOARP���ñ�־�����ӿڲ�֧��ARP�����磬��Ե�ӿڲ���Ҫ����ARP����Ϊ���������ARP�����������ܹ�������õ���Ϣ���������������紫������   
IFF_PROMISC�����øñ�־���������ģʽ��Ĭ������£���̫���ӿ�ʹ��һ��Ӳ����������ȷ����ֻ���չ㲥���ݰ����Լ�ֱ��
���͵��ӿ�Ӳ����ַ�����ݰ�����tcpdump���������ݰ����������ڽӿ������û���ģʽ����ʹ������ͨ��������ʵ��������ݰ���                                                           
IFF_ALLMULTI���ñ�־���߽ӿڽ������е��鲥���ݰ���������IFF_MULTICAST�����õ�����£��ں�������ִ���鲥·��ʱ����
             �ñ�־��IFF_ALLMULTI�Խӿ�������ֻ���ġ�   
IFF_MASTER�������ؾ���Ⱥ(bundle)��
IFF_SLAVE���ñ�־�ɸ��ؾ������ʹ�ã��ӿ��������������˽�ñ�־�� 
IFF_MULTICAST���ñ�־�������������ã���ʶ�ýӿ��ܹ������鲥���͡�ether_setup Ĭ������IFF_MULTICAST������������
               ����֧���鲥���ͱ����ڳ�ʼ��ʱ����ñ�־��                                          
IFF_PORTSEL������ͨ��ifmapѡ��������͡� 
IFF_DYNAMIC���ñ�־�������������ã���ʾ�ӿڵ�ַ�ɸı䡣���־û�б�ʹ�á��ӿڹر�ʱ������ַ��                                                                     

5. �豸���������еĺ���
int (*init)(struct netdevice *dev);�豸��ʼ����������ע�������豸ʱ�����ã�������ʼ�����������豸��struct net_devide�ṹ�壬
���ǣ���ָ����Ա�����ΪNULL��
int (*uninit)(struct netdevice *dev); ע���豸�ĺ�������ɾ�������豸ʱ������
int (*destructor)(struct netdevice *dev); �����豸��Ϣ�ĺ��������豸�����һ�����ü�����ɾ�����ں˵��øú�����
int (*open)(struct netdevice *dev); ���豸�ĺ��������豸�����һ�����ü�����ɾ�����ں˵��øú���
int (*stop)(struct netdevice *dev); ֹͣ�豸�ĺ���

int (*hard_start_xmit)(struct sk_buff *skb, struct netdevice *dev);�����з������ݰ��ĺ������Ѳ���skb����������ݷ��ͳ�ȥ
int (*hard_header)(struct sk_buff *skb, struct netdevice *dev�� unsigned short type, void *daddr, void *saddr, unsigned len);
����Ӳ��ͷ���ĺ��������ݲ����е�Դ������Ŀ������Ӳ����ַ�������豸Ӳ��ͷ����

int (*rebuild_header)(struct sk_buff *skb) �ؽ�Ӳ��ͷ���ĺ�������ARP��ַ�������ַ��Ϊ�������ݰ��ؽ�Ӳ��ͷ��
void (*tx_timeout)(struct net_device *dev);�����ͳ�ʱ�ĺ����������ݰ�û���ڹ涨ʱ�䷢�ͳ�ȥʱ���ں˽�ͨ��
�ú������������⣬���ָ����͹��̡�
struct net_device_stat *(*get_stats)(struct net_device *dev)���豸ͳ����Ϣ
int (*set_config)(struct net_device *dev�� struct ifmap *map)��ָ�����ýӿ���Ϣ�ĺ��������豸����ʱ���ɵ��øú������޸��豸IO
��ַ���жϺŵ�������Ϣ
int (*poll)(struct net_device *dev, int quota) ��ѯ�������ʺ�NAPI�������豸���������øú����Բ�ѯ��ʽ��������
int (*do_ioctl)(struct net_device *dev, struct ifreq *ifr, int cmd)��ioctl���������Զ��豸IO�˿ڽ��в���
void (*set_multicast_list)(struct net_device *dev)�������鲥�б�ĺ��������øú������Ըı��豸���鲥�б�ͱ�־
int (*set_mac_address)(struct net_device *dev, void *addr)����Ӳ����ַ�ĺ���������豸�ӿ�֧���޸�Ӳ����ַ���ɵ��øú���
int (*change_mtu)(struct net_device *dev, int net_mtu)�޸Ľӿ�MTU�ĺ�����

}

1. �������豸����ģ�������ںˣ�ϵͳ����ʱ�Զ�ע����豸��
2. �������豸�����������˿Ͷ�̬����ģ�飬�����豸ʱע����豸��
function()
{
ndev = alloc_etherdev(sizeof(struct board_info));
        alloc_netdev_mq
        �����豸��net_device�ṹ����,ÿ��net_device�ṹʵ������һ�������豸,��         
        �ṹ��ʵ����alloc_netdev()����ռ�,����˵������:                               
        @sizeof_priv:ָ�����ڴ洢�������������˽�����ݿ��С,�μ�alloc_etherdrv()����.
        @name:�豸��,ͨ���Ǹ�ǰ׺,��ͬǰ׺���豸�����ͳһ���,��ȷ���豸��Ψһ.       
        @setup:���ú���,���ڳ�ʼ��net_device�ṹʵ���Ĳ�����,�μ�ether_setup()����.    

int register_netdev(struct net_device *dev)
����ע��������豸��ȷ��֮�󣬱����register_netdevice()ע�������豸������      
�����豸������ע�ᵽϵͳ�С����ע��󣬻ᷢ��NETDEV_REGISTER��Ϣ��netdev_chain 
֪ͨ���У�ʹ�����ж��豸ע�����Ȥ��ģ�鶼�ܽ�����Ϣ��                          

1. ��������豸������"%"���ţ������һ���ӿں�
2. ��������豸���ֵĳ���Ϊ0���������豸���ֵĵ�һ���ַ��ǿո��������豸������Ϊ"eth"����Ϊ�����һ���ӿںš�

int register_netdevice(struct net_device *dev)
�ڵ��øú���ǰ�������rtnl_lock()����ȡrtnl������    



alloc_etherdev    ��̫��
alloc_fddidev     ���˷ֲ�ʽ�ӿ�FDDI
alloc_hippi_dev   �����ܲ��нӿ�HPPI
alloc_trdev       ���ƻ���
alloc_fcdev       ����ͨ��
alloc_irdadev     �������ݽӿ�

alloc_netdev��ether_setupλ���ļ� driver/net/eth.c include/linux/netdevice.h
register_netdev��unregister_netdev λ���ļ� net/core/dev.c


}

dev_open()
{
int dev_open(struct net_device *dev)
    �豸һ��ע��󼴿�ʹ�ã����������û����û��ռ�Ӧ�ó���ʹ�ܺ�ſ����շ�����                
��Ϊע�ᵽϵͳ�е������豸�����ʼ״̬�ǹرյģ���ʱ�ǲ��ܴ������ݵģ�����              
����������豸���ܽ������ݵĴ��䡣��Ӧ�ò㣬����ͨ��ifconfig up����(������ͨ��ioctl       
��SIOCSIFFLAGS)�����������豸����SIOCIFFLAGS������ͨ��dev_change_flags()����dev_open()�����������豸��
dev_open()�������豸�ӹر�״̬ת������״̬��������һ��NETDEV_UP��Ϣ�������豸״̬�ı�             
֪ͨ���ϡ�                                            


���豸�����¼�����ɣ�
(1)��� dev->open ����������������������е��������򶼳�ʼ�����������
(2)���� dev->state ��__LINK_STATE_START ��־λ������豸�򿪲������С�
(3)���� dev->flags �� IFF_UP ��־λ����豸������
(4)����dev_activate��ָ������ʼ�����������õ��Ŷӹ��򣬲��������Ӷ�ʱ������
���û�û�������������ƣ���ָ��ȱʡ���Ƚ��ȳ�(FIFO)���С�
(5)���� NETDEV_UP ֪ͨ�� netdev_chain ֪ͨ����֪ͨ���豸ʹ������Ȥ���ں������
}

dev_close()
{
int dev_close(struct net_device *dev)
    �����豸һ���رպ�Ͳ��ܴ��������ˡ������豸�ܱ��û�������ȷ�ػ�����¼�������             
��ֹ����Ӧ�ò㣬����ͨ��ifconfig down����(������ͨ��ioctl()��SIOCSIFFLAGS)���ر������豸������     
�������豸ע��ʱ����ֹ��SIOCSIFFLAGS����ͨ��dev_change_flags()�����������豸 
��ǰ��״̬��ȷ������dev_close()�ر������豸��dev_close()�������豸�Ӽ���״̬ת�����ر�״̬��      
������NETDEV_GOING_DOWN��NETDEV_DOWN��Ϣ�������豸״̬�ı�֪ͨ���ϡ�                               

�������¼�����ɣ�
(1)���� NETDEV_GOING_DOWN ֪ͨ�� netdev_chain ֪ͨ����֪ͨ���豸��ֹ����Ȥ���ں������
(2)���� dev_deactivate ������ֹ���ڶ��й�������ȷ���豸�������ڴ��䣬��ֹͣ
������Ҫ�ļ�ض�ʱ����
(3)��� dev->state ��־��__LINK_STATE_START ��־λ������豸ж�ء�
(4)�����ѯ�����������ڶ��豸��������ݰ�����ȴ��˶�����ɡ���������__LINK_STATE_START ��־λ����������ٽ���������ѯ���豸�ϵ��ȣ����ڱ�־�����ǰ����һ����ѯ�������ȡ�
(5)��� dev->stop ָ�벻������������������е��豸��������ʼ���˺���ָ�롣
(6)��� dev->flags �� IFF_UP ��־λ��ʶ�豸�رա�
(7)���� NETDEV_DOWN ֪ͨ�� netdev_chain ֪ͨ����֪ͨ���豸��ֹ����Ȥ���ں������
}

3c39x(chip driver)
{
�����������������
��������
������ϵͳ�У������������·��Э�����dev_queue_xmit()��λ��net/core/dev.c����ɴ��䣬��dev_queue_xmit�ֻ���þ����������������������򷽷�dev->hard_start_xmit()���Ӷ�������������������������ݴ��䣬�μ�vortex_start_xmit()��

��������
����������������һ������֡ʱ���ͻᴥ��һ���жϣ����жϴ������λ���豸�������У������sk_buff���ݽṹ��������֡���������netif_rx()�����׽��ֻ��������������豸��������С�����3c39x.c����������£�
vortex_interrupt( )---> vortex_rx( )--->netif_rx( )��

}
notifier()
{
������һ�������豸ʱ�����뽫����豸������IP��ַ���          
��·�ɱ�����ӵ�ip_fib_local_table·�ɱ��С�����ͨ���Ը��豸  
�����õ�ÿһ��IP��ַ��������fib_add_ifaddr()����ɵġ�        
NETDEV_UP �豸�Ѵ�

���ر������豸ʱ������fib_disable_ip()��·�ɱ�·�ɻ��� 
��ɾ�����и��豸��·���                               
NETDEV_DOWN �豸�ѹر�
NETDEV_REBOOT �豸����

��ĳ�������豸�����÷����仯ʱ������MTU��PROMISCUITY״̬��
��ˢ��·�ɻ���                                            
NETDEV_CHANGE   �豸��Ϣ�޸�
NETDEV_REGISTER �豸�Ѿ�ע��

��һ�������豸ע��ʱ����·�ɱ�·����������ɾ��     
����ʹ�ø��豸��·������ڶ�·��·������˵��ֻҪ   
��һ������һ��ʹ�ø��豸����·����ͽ���ɾ����       
NETDEV_UNREGISTER �豸δע��

��ĳ�������豸�����÷����仯ʱ������MTU��PROMISCUITY״̬�� 
��ˢ��·�ɻ���                                             
NETDEV_CHANGEMTU   �޸�MTU
NETDEV_CHANGEADDR  �޸�MAC��ַ
NETDEV_GOING_DOWN �豸���ر�
NETDEV_CHANGENAME  �豸���ı�


}