#!/bin/sh
#Alex Top 100 Sites in China
#Author:Bi Qin
#Website:http://www.lifetyper.com
#Version:X00
set -x
echo -e "Choose Your DNS Sever As Below:\n\
##0##:Input My Own DNS\n\
##1##:114 DNS\n\
##2##:AliYun DNS\n\
##3##:CNNIC DNS\n\
##4##:Shanghai Unicom\n\
##5##:Ovear DNS\n\
##6##:Opener DNS\n\
Your Choice:"
read DNSCount
if [ $DNSCount = "0" ];
then
	echo "DNS IP:"
	read ChinaDNS	
elif [ $DNSCount = "1" ];
then
	ChinaDNS="114.114.114.114"
elif [ $DNSCount = "2" ];
then
	ChinaDNS="223.5.5.5"
elif [ $DNSCount = "3" ];
then
	ChinaDNS="1.2.4.8"
elif [ $DNSCount = "4" ];
then
	ChinaDNS="210.22.84.3"
elif [ $DNSCount = "5" ];
then
	ChinaDNS="60.190.217.130"
elif [ $DNSCount = "6" ];
then
	ChinaDNS="112.124.47.27"
else
	echo "Wrong Select,Using 114DNS As Default!"
	ChinaDNS="114.114.114.114"
fi

#PAGES="20"
OutPutFile="./dnsmasq.conf"
Attach1="./ChinaCDN.txt"
Attach2="./ChinaCustom.txt"
CR='\015'
if [ -f $OutPutFile ];
then
	rm -rf $OutPutFile
fi
echo "Autofix windows CR/LF issue in TXT file!"
tr -d $CR <$Attach1 >CDNList.txt
rm $Attach1
mv CDNList.txt ChinaCDN.txt
tr -d $CR <$Attach2 >CustomList.txt
rm $Attach2
mv CustomList.txt ChinaCustom.txt
echo "##Dnsmasq.conf generated date:$(date)##" >>$OutPutFile
echo "##Dnsmasq.conf generated date:$(date)##"
echo "##All .CN Domain##" >>$OutPutFile
echo "##All .CN Domain##" 
echo "server=/cn/$ChinaDNS" >>$OutPutFile
echo "##Alexa Top500 In China##">>$OutPutFile
echo "##Alexa Top500 In China##"
for i in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 
do
echo -ne "\r# Generate dnsoption for Page $i##"
curl -s "http://www.alexa.com/topsites/countries;$i/CN" | grep "/siteinfo/"|\
grep -vE ".cn|twitter|tumblr|google|gmail|flickr|youtube|facebook|amazon|godaddy|wikipedia" |\
sed -e "s#^[^\/]*\/[^\/]*\/\([^\/]*\).*\".*#server=/\1/$ChinaDNS#g"\
>>$OutPutFile
done
echo "###Domain For China CDN###">>$OutPutFile
echo "###Domain For China CDN###"
cat $Attach1|while read SingleDomain
do
	echo "server=/$SingleDomain/$ChinaDNS">>$OutPutFile
done
echo "###Domain For China Custom###">>$OutPutFile
echo "###Domain For China Custom###"
cat $Attach2|while read SingleDomain
do
	echo "server=/$SingleDomain/$ChinaDNS">>$OutPutFile
done
exit 0