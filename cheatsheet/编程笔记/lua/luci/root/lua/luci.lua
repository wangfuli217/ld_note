#!/usr/bin/lua  --cgi��ִ�������·�� 
require "luci.cacheloader" --����cacheloader�� 
require "luci.sgi.cgi"     --����sgi.cgi��  
luci.dispatcher.indexcache = "/tmp/luci-indexcache" --cache����·����ַ 
luci.sgi.cgi.run() --ִ��run���˷���λ��*/luci/sgi/cgi.lua��


--[[
1�����������192.168.1.1��ͣ�·������Ϊuhttp server���/www/index.html���ҳ�淵�ظ��������
   �������ҳ���ֻ�ˢ�£� ȥ����ҳ��/luci/cgi���������ɫ��ǣ�
   <metahttp-equiv="refresh" content="0; URL=/cgi-bin/luci" />
2. wget 192.168.101.1 ���������������ҳ����� /www/index.html ���ҳ��
   ��ͨ��firefox����˽ҳ��+wiresharkץ��Ҳ���Եõ� /www/index.html ���ҳ��
]]
