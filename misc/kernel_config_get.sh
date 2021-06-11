
��õ�ǰ����kernel��������Ϣ���ļ���
a��/proc/config.gz ��CONFIG_IKCONFIG_PROC��Ҫ�ó�Y��
b��/boot/config
c��/boot/config-$(uname -r)

config(make menuconfig)
{
General setup-->
<*> Kernel .config support����ӦCONFIG_IKCONFIG��
[*] Enable access to .config through /proc/config.gz����ӦCONFIG_IKCONFIG_PROC��
}

run(compile kernel)
{
(1)���������CONFIG_IKCONFIG��Ҫ���� configs.o �ļ�

(2) configs.o �ļ����� $(obj)/config_data.h�ļ�������������������ͨ��configs.c�ļ��������ɡ�����configs.c�ļ��а�����$(obj)/config_data.h�ļ���

(3) $(obj)/config_data.h�ļ�����������$(obj)/config_data.gz����ǿ��ÿ�α��붼��������$(obj)/config_data.h�ļ���FORCE��������ļ������ɹ����ǣ�5��

(4)$(obj)/config_data.gz�ļ�����������$(KCONFIG_CONFIG)��Ҳ�����ں������ļ�.config������ǿ��ÿ�α��붼��������$(obj)/config_data.gz��FORCE��������ļ���������ͨ����.configִ��gzipѹ�����ɵġ�

(5)������ʵ����ִ��һ��shellָ���$(obj)/config_data.gz�ļ��е�����ͨ���ں˹��߳���scripts/bin2c����һ����Ϊ��kernel_config_data�����ַ������У�����MAGIC_START���꣺"IKCFG_ST"����ͷ��MAGIC_END���꣺ "IKCFG_ED"����β��
}



get(from kernel)
{
1��������ʱͨ��/proc/config.gz��ȡ��
     �ڿ���̨�������cat /proc/config.gz | gzip -d > ����Ҫ�������õ��ļ�����
     ��������򵥣�����Ҳ�����ľ����ԣ����ȱ�������CONFIG_IKCONFIG_PROC����α�����ϵͳ����ʱ���л�ȡ��

2������ֱ��ͨ������õ��ں�ӳ��vmlinux��zImage��uImage��ֱ�ӻ�ȡ
     ���������ʵҲ�ǳ��򵥣��ں˺ڿ����Ѿ���������������ȡ�����ˣ�scripts/extract-ikconfig��ʹ���������򵥣�
     ������ǽ�����룬�Ǿ�������������������������ں�Դ��·����scripts/extract-ikconfig ���ں�ӳ��·���� > ����Ҫ�������õ��ļ�����
     ������߶���gzѹ����ʽ��֧��һ�᲻����2.6.37��ʼ֧��bzip2�� lzma �� lzoѹ����ʽ����2.6.39��ʼ֧�� xzѹ����ʽ����Щ���ں˵�git log�п��Կ�����          

3�����ں��߼���ַ�ռ���ȡ��
     ������ĵ����ɽ��������ǿ���֪���������ļ���ѹ���ļ���ʵ�����ں�ӳ���ֻ�����ݶ��С�����ں������е�ʱ����ʵ�������ں��߼���ַ�ռ��п����ҵ��������ſ����£�
     ��1��ͨ��/proc/kallsyms�ҵ���kernel_config_data��������Ŷ�Ӧ���ں��߼���ַ
     ��2��ͨ��/dev/kmem������õ����߼���ַ��ȡ���ݡ�ѹ���ļ����ݾ��ڣ�"IKCFG_ST"��"IKCFG_ED"֮�䡣
      ���������Ҫ�Լ�дһС�ε�C���룬���Բο�devkmem�Ĵ��루�����������������õ�����С���ߣ�devmem2��devkmem������
      
}