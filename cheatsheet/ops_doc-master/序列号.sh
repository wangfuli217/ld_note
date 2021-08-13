sn(思科){
SN: LLLYYWWXXXX，11个字母和数字的组合(后面再具体讲解这些字母和数字代表的意义)。

那么对于前面说了这么多的序列号LLLYYWWXXXX，具体到底有什么特别的编号规则呢？
LLL = 位置编码 ，例如FOC = FoxConn China，即中国富士康
YY = 年份代码 ，08 = 2004，09=2005
WW = 星期代码，01 到52的范围
XXXX = Base-34 Alpha Numeric Unique Identifier，包含了0到9数字和所有字母，除了I和O。


位置编码（这里的编码列表不全，欢迎补充）：
CTH — Celestica – Thailand
FOC — Foxconn – Shenzhen, China
JAB — Jabil – Florida
JPE — Jabil – Malaysia
JSH — Jabil – Shanghai , China
TAU — Solectron – Texas
PEN — Solectron – Malaysia
年份编码：
01 = 1997
02 = 1998
03 = 1999
04 = 2000
05 = 2001
06 = 2002
07 = 2003
08 = 2004
09 = 2005
10 = 2006
11 = 2007
12 = 2008
13 = 2009
14 = 2010
15 = 2011
16 = 2012
17 = 2013
18 = 2014
19 = 2015
20 = 2016
}
sn(rtu){
序列号格式： LLLYYWWXXXXXXX
LLL: 设备类型       OPM OSW RTR    OLS MCU PWR   FAN OTR
                    opm osw router ols mcu power fan otdr
YY:  年             18表示2018年
WW: 年的第几个星期  date +%V -> 25
XXXXXXX: 随机值     7位随机值
}

otdr(opwill){
otdr seq:02030263172050 hardware:A3 software:4.0.0.2
MINF <制造商>,<模块型号>,<硬件版本>,<FPGA版本>,<软件版本>,<出厂日期>,<校准日期>,<序列号>

<制造商>：OPWILL
<模块型号>：OTC2300N-d
<硬件版本>：A1
<FPGA版本>：20120512
<软件版本>：1.0.0.0
<出厂日期>：20120512
<校准日期>：20120512
<序列号>：01010010125001
}


