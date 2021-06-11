
XML(eXtensible Markup Language)是万维网联盟(World Wide Web Consortium W3C)定义的一种可扩展标志语言。
    可扩展性指允许用户按照XML规则自定义标记(tags 标签)。
强项：轻松表达多层结构的数据；可扩展。
优点：平台无关，语言无关。设计目标是描述数据并集中于数据的内容，与显示分离。
提醒：不能用XML来直接写网页。即便是包含了XML数据，依然要转换成HTML格式才能在浏览器上显示。

语法规则：
    XML文件有且仅有一个根标记，其他标记必须封装在根标记中，文件的标记必须形成树状结构。
    大小写敏感。
    标记的属性必须用""或''括起来。

XML细节：
一、 声明
    大多数XML文档以XML声明作为开始，它向解析器提供了关于文档的基本信息。
    建议使用XML声明，但它不是必需的。如果有的话，那么它一定是文档的第一行内容。
      如：<?xml  version="1.0"  encoding="UTF-8" standalone="no"?>
    声明最多可以包含三个名称-值对（许多人称它们为属性，尽管在技术上它们并不是）。
      <?xml 问号与xml之间不能有空格。
    1)version 是使用的XML 版本:1.0, 1.1
    2)encoding 是该文档所使用的字符集。该声明中引用的ISO-8859-1 字符集包括大多数西欧语言用到的所有字符。
      默认字符在UTF-8字符集中，这是一个几乎支持世界上所有语言的字符和象形文字的Unicode 标准。
    3)standalone（可以是yes 或no）定义了是否孤立处理该文档。
      如果XML文档没有引用任何其它文件，则可以指定 standalone="yes"。
      如果XML文档引用其它描述该文档可以包含什么的文件(如DTD)，则 standalone="no"。默认值为"no"

二、 标记
    左尖括号“<“和右尖括号“>“之间的文本
      1. 在<  >中的称为开始标记；在</  >中的称为结束标记
      2. 空标记：不包含元素的标记。空标签必须以“/>”结束。格式： <空标记的名称/> <空标记的名称 属性列表/>
    注意：
      除空标记外，标签必须成对：有始有终。所有的开始标签和结束标签必须匹配。
      在标记符“<“和"标记的名称"之间不能含有空格。在标记符"/>"前面可以有空格或回行。
      标签必须嵌套正确。
    XML标记必须遵循下面的命名规则:
    　1.名字中可以包含字母、数字以及其它字母或文字；还可包含下划线(_)、点(.)、连字符(-)
    　2.名字不能以数字开头；可以用字母、文字或者下划线开头。
    　3.名字不能以字母xml (或XML 或Xml ..) 开头；
    　4.名字中不能包含空格。

三、 元素
    位于开始标记与结束标记间
    一份文档有且只有一个根元素。
    根元素下的所有元素叫“子元素”。
    标签必须嵌套正确。
    不包含自子元素的元素叫“叶子”；包含子元素的元素叫“分支”。
    如： <eric>…… </eric>

四、 属性
    一个元素的开始标志中的名称－值对
    所有的属性值必须位于单引号或双引号中。
    每一个元素的属性不允许出现超过一次。
    开始标志内，类似赋值语句
    如：<eric age="80">……</eric>

五、 注释
    注释可以出现在文档的任何位置。(但不建议放在声明前面，部分浏览器会报错)
    注释以 <!-- 开始，以 -->  结束。
    注释内不能包含双连字符（--）；除此之外，注释可以包含任何内容。
    注释内的任何标记都被忽略

六、 处理指令
    处理指令是为使用一段特殊代码而设计的标记，简称为PI。
    大多数XML 文档都是以XML 声明开始，该声明本身就是特殊的处理指令。
    处理指令对应用程序特定的数据进行编码。一条处理指令包含一个目标，后跟数据。用<?和?>定界符将处理指令包起来。
    目标确定应用程序，而对应用程序不能识别的目标，其会忽略这些处理指令。

七、 实体
    XML 规范预定义了五个实体。
      &lt;   ==== <
      &gt;   ==== >
      &quot; ==== ”
      &apos; ==== ‘
      &amp;  ==== &
    自定义实体:在DTD中定义 <!ENTITY 实体标志 "实体内容">
      在xml中引用自定义实体，用  &实体标志;  代表实体内容。
    另外，无法从键盘输入的字符可以使用字符引用，就是用字符的Unicode代码点来引用该字符。
      以"&#x"开始字符引用，以分号结尾，x必须为小写，使用十六进制。如： &#x003D; 表示等于号。
      也可以使用字符引用来引用 <,>,',",&  "
      查看字符的代码点（附件-> 系统工具-> 字符映射表）。

八、 CDATA
    当一段文本中出现很多实体引用和字符引用时，会导致文本数据的读写困难，CDATA段就是为了解决这一问题引入的。
    DATA区段开始于 "<![CDATA["  结束于  "]]>"
    CDATA内部的所有东西都会被解析器忽略解析，不用检查它的格式。
    但是CDATA段中不能嵌套另一个CDATA段。

九、 属性
    属性是标记的属性，可以为标记添加附加信息。
    (1)属性的组成
       属性是一个名值对，必须由名称和值组成，属性必须在标记的开始标记或空标记中声明，用"="为属性指定一个值。
       语法如下：
           <标记名称 属性列表/>
           <标记名称 属性列表>XXX</标记名称>
       例如: <桌子 width="40" height='100'/>
    (2)使有属性的原则
       属性不体现数据的结构，只是数据的附加信息；
       一个信息是作为一个标记的属性或子标记，取决于具体问题，不要因为属性的频繁使用破坏XML的数据结构。
       下面是一个结构清晰的XML文件:
           <楼房 height="23m" width="12m">
               <结构>混凝土</结构>
               <类别>商用</类别>
           </楼房>
      下面是一个结构不清晰的XML文件:
          <楼房 height="23m" width="12m" 结构="混凝土" 建筑商="华海集团" 类别="商用"></楼房>

十、 名称空间/包
    XML文件允许自定义标记，所以可能出现同名字的标记，为了区分这些标记，就需要使用名称空间。
    名称空间的目的是有效的区分相同的标记，其实并不真实存在。
    语法： 声明有前缀的名称空间  xmlns:前缀名=名称空间的名字
          声明无前缀的名称空间  xmlns=名称空间的名字  (缺省)
    注意：当且仅当它们的名字相同时称二个名称空间相同，也就是说，对于有前缀的名称空间，如果二个名称空间的名字相同，即使前缀不相同，也是相同的名称空间，返之同然。前缀只是方便引用而已。



基本术语
    一、序言Prolog：包括XML声明(XML Declaration)和文档类型声明(Document Type Declaration)。
    二、良构(well-formed 规范的)：符合W3C定义的XML文档。

验证
    为什么需要验证？
    对XML文件施加额外的约束，以便交流。

一、DTD验证
    文档类型定义(Document Type Definition)
    DTD定义了XML文档内容的结构，保证XML以一致的格式存储数据。精确的定义词汇表，对XML的内容施加约束。
    符合DTD的规范XML文档称为有效的文档。由DTD定义的词汇表以及文档语法，XML解析器可以检查XML文档内容的有效性。
    规范的XML文件不一定是有效的；有效的一定是规范的。

1、 DTD声明
    1) DTD声明可以在单独的一个文件中
    2) DTD声明可以内嵌在XML文件中
    3) DTD声明可以一部分在单独的文件中，另一部分内嵌在XML文件中

2、 引入外部DTD文件
    <!DOCTYPE data SYSTEM "Client.dtd">
    Data：根节点名称
    Client.dtd：dtd文件路径

3、 DTD四种标记声明
    元素(ELEMENT)、属性(ATTLIST)、实体(ENTITY)、符号(NOTATION)

  1) 元素(ELEMENT) XML元素类型声明
     声明元素： <!ELEMENT elementName (contentModel)>
     元素的内容通过内容模式来描述。
     DTD 内容模式的种类有：
         EMPTY   元素不能包含任何数据，但可以有属性(前提是必须声明其属性)。
                 不能有子元素。不能有文本数据（包括空白，换行符）。
                 DTD中定义： <!ELEMENT elementName EMPTY>
                 XML中：<elementName/>（推荐） 或者：<elementName></elementName>
       (#PCDATA) 规定元素只包含已析的字符数据，而不包含任何类型的子元素的内容类型。
                 DTD中定义： <!ELEMENT student (#PCDATA)>
                 XML中合法内容： <student>watching TV</student>
      (Elements) 元素由内容模式部件指定。
                 <!ELEMENT  name  (child particles) >
                 内容模式部件可以是下表列出的内容。
                    <!ELEMENT name (a,b)>  子元素a、b必须出现，且按照列表的顺序
                    <!ELEMENT name (a|b)>  选择；子元素a、b只能出现一个
                    <!ELEMENT name (a)  >  子元素a只能且必须出现一次
                    <!ELEMENT name (a)+ >  子元素a出现一次或多次
                    <!ELEMENT name (a)* >  子元素a出现任意次(包括零次、一次及多次)
                    <!ELEMENT name (a)? >  子元素a出现一次或不出现
        Mixed    混合模式：子元素中既可有文本数据又可有下级子元素。
                 <!ELEMENT rn (#PCDATA| an | en)*>“|”和“*”必须写。
                 上句表示在 rn 内，字符数据 或 en及an 可以出现任意多次，顺序不限。
                 优先写(#PCDATA)  如：(#PCDATA|name)* 正确   (name|#PCDATA)* 错误
         ANY     元素可以包含任何类型的数据。子元素(必须在DTD中有定义) 和 文本数据(包括空白)。
                 DTD中定义： <!ELEMENT a ANY> <!ELEMENT b ANY>
                 XML中合法内容： <a>somngthing</a> 或者 <a/> 或者 <a><b>oo</b></a>

   2) 属性(ATTLIST) 特定元素类型可设置的属性&属性的允许值声明
        <!ATTLIST elementName
        attributeName1 attributeType attributeDefault
        .......
        attributeNameN attributeType attributeDefault>
     属性类型 (Attribute Type)：
        CDATA该属性只能包含字符数据(注意与CDATA段、PCDATA的区别)
        NMTOKEN  是CDATA的子集，它的字符只能是字母,数字,句点,破折号,下划线或冒号。
        NMTOKENS 类似NMTOKEN，但这个可以包含多个值，每个值之间用空格隔开。
        ID       该属性的取值在同一文档内是唯一的。一个元素只能有一个ID类型的属性。
        IDREF    类似指针，指向文档中其他地方声明的ID值。如果该属性取值和指向的ID值不匹配，则返回错误。
        IDREFS   类似IDREF，但它可以具有由空格分隔开的多个引用。
        ENTITY   该属性的值必须对应一个在文档内部声明的但还没有分析过的实体。
        ENTITYS  类似ENTITY，但它可以包含由空格分隔开的多个实体。
        NOTATION 该属性的值必须引用在文档中其他地方声明的某个注释的名称。
        (enumerated) 类似枚举的变量，该属性必须匹配所列的值。各值用“|”分隔开。
                 如： (春|夏|秋|冬) 实际内容文档只能从中取一个。
     属性特性 (Attribute Default) ：
        #REQUIRED   必须有且只能有一个属性。
        #IMPLIED    可有可无。
        #FIXED      在DTD中定义默认值，XML中可以不指定，指定则必须等于该默认值。
        attribute-value 如果不指定则用DTD定义的默认值，指定则用指定的值。

<![CDATA[############ 属性(ATTLIST)的举例 ############## ]]>
例一（#REQUIRED）
    DTD中： <!ELEMENT el (#PCDATA)> <!ATTLIST el at1 NMTOKENS #REQUIRED  at2 CDATA #REQUIRED>
    XML中，正确： <el at1 = "10 20" at2="10" >something</el>
    XML中，错误： <el at="10">something</el>  (没有写另一个#REQUIRED的属性 at2 )

例二(#IMPLIED，#FIXED)
    DTD中： <!ELEMENT el (#PCDATA)> <!ATTLIST el at CDATA #FIXED "10"  at2 CDATA #IMPLIED >
    XML中，正确： <el at2="20" >something</el> （at有默认值"10"，at2 可写可不写)
    XML中，错误： <el at="11" >something</el>（at要么不写，要写只能写成跟默认值相同的）

例三(attribute-value)
    DTD中：<!ELEMENT el (#PCDATA)> <!ATTLIST el at CDATA "10" at2 CDATA "20" >
    XML中，正确： <el at="11" >something</el>

例四(enumerated + attribute-value)
    DTD中：<!ELEMENT el (#PCDATA)> <!ATTLIST el at (10|20|30) "10">
    XML中，正确： <el at="20">something</el>  (at要么不写，默认值 10；要么在(10|20|30)中选一个写)
<![CDATA[############ 属性(ATTLIST)举例 完毕 ############## ]]>

  3) 实体(ENTITY)   可重用的内容声明
     在DTD中定义 <!ENTITY 实体标志 "实体内容">
     在xml中引用自定义的实体，用  &实体标志;  代表实体内容。
      4) 符号(NOTATION) 不要解析的外部内容的格式声明。


3、 内部实体：在xml文件里面写(少用)
    外部实体：另外在xml同一文件夹下建立一个dtd文件(提倡)
<!--**************** 内外部的实体举例 ***************** -->
外部的：
      <?xml  version="1.0"  encoding="UTF-8" standalone="no"?>
      <!DOCTYPE root SYSTEM "goodsInfo.dtd"><!--用这句引用外部dtd-->
      <root><goodsInfo>
          <goodsName>goodsName</goodsName>
          <goodsPrice>goodsPrice</goodsPrice>
      </goodsInfo></root>

      以下是名为"goodsInfo.dtd"文件
      <!ELEMENT root   (goodsInfo)>
      <!ELEMENT goodsInfo  (goodsName,goodsPrice)>
      <!ELEMENT goodsName  (#PCDATA)>
      <!ELEMENT goodsPrice (#PCDATA)>

内部的：
      <?xml  version="1.0"?>
      <!DOCTYPE root [
          <!ELEMENT root(student)>
          <!ELEMENT student (#PCDATA)>
          <!ENTITY CCTV  "中央电视台">
      ]>  <!--把DTD文件写在体内-->
      <root><student>
          student watch &CCTV;<!--使用自定义实体 CCTV-->
      </student></root>
<!--***************** 内外部的实体举例 完毕 ********************** -->


XML处理模式
一、 DOM 文档对象模式
    1.DOM特点：
      以树型结构访问XML文档。 一棵DOM树包含全部元素节点和文本节点。可以前后遍历树中的每一个节点。
      整个文档树在内存中，便于操作；支持删除、修改、重新排列等多种功能。
      将整个文档调入内存（包括无用的节点），浪费时间和空间。
      一旦解析了文档还需多次访问这些数据；硬件资源充足（内存、CPU）情况下使用。
    2.DOM树与节点
      XML文档被解析成树型结构。
      树由节点组成。共有12种不同的节点。
      节点可以包含其他节点（依赖于节点的类型）。
      父节点包含子节点。叶子节点没有子节点。
    3.节点类型
      Document node   包含：一个根Element节点。一个或多个处理指令节点。
      Document Fragment node
      Element node包含：其他Element节点。若干个Text节点。若干个Attribute节点。
      Attribute node  包含：一个Text节点。
      Text node
      Comment node
      Processing instruction node
      Document type node
      Entity node
      Entity reference node
      CDATA section node
      Notation node


二、 SAX 基于事件处理模式
    解析器向一个事件处理程序发送事件，比如元素开始和元素结束，而事件处理器则处理该信息。
    然后应用程序本身就能够处理该数据。原始的文档仍然保留完好无损。

<![CDATA[################## SAX处理器(遍历XML) ###########################]]>
import java.io.IOException;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;
import org.xml.sax.helpers.DefaultHandler;

public class TestSAXParser {
    /** 基于SAX方式解析XML文档 */
    public static void main(String[] args)
    throws SAXException,ParserConfigurationException,IOException{
        SAXParserFactory factory = SAXParserFactory.newInstance(); //创建SAX解析器工厂
        factory.setValidating(true);                               //让error方法生效
        SAXParser parser = factory.newSAXParser();                 //生成一个具体的SAX解析器
        parser.parse("src/file/student.xml",new XMLreader());      //开始解析
}}

class XMLreader extends DefaultHandler {
    // 只需覆盖我们感兴趣的方法
    private int counter = 0;// 定义一个计数器，保存XML文档触发事件的次数

    @Override   // 文档开始事件触发
    public void startDocument() throws SAXException {
        counter++;
        System.out.println(counter + ".解析XML文件开始...");}

    @Override  // 文档结束事件触发
    public void endDocument() throws SAXException {
    counter++;
    System.out.println("\r\n"+counter + ".解析XML文件结束...");}

    @Override  // 元素开始事件触发
    public void startElement(String uri, String localName, String qName,
    Attributes atts) throws SAXException {
      counter++;
      System.out.print(counter+".<"+qName);
        for(int i=0; i<atts.getLength();i++){ //读取标志的所有属性
          System.out.print(" "+atts.getLocalName(i)+"="+atts.getValue(i));
      }System.out.print(">"); }

    @Override  // 元素结束事件触发
    public void endElement(String uri, String localName, String qName) throws SAXException {
        counter++;
        System.out.print(counter +".</"+qName+">");}

    @Override // 文本事件触发  打印时尽量不要换行，否则很难看
    public void characters(char[] ch, int start, int length)throws SAXException {
        counter++;
        String text = new String(ch, start, length); // 当前元素的文本值
        System.out.print(counter + ".Text=" + text);}

    @Override //这是可恢复错误。需在SAXParserFactory设置有效性错误才能生效
    public void error(SAXParseException e) throws SAXException {
        System.out.println("xml文档有效性错误："+e);}

    @Override //严重错误
    public void fatalError(SAXParseException e) throws SAXException {
        System.out.println("xml文档严重的有效性错误："+e);}
}
<![CDATA[################## SAX处理器(遍历XML)结束 ###########################]]>

三、 DOM
<![CDATA[######################### DOM遍历方式 ###########################]]>
import java.io.File;
import java.io.IOException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Attr;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**基于DOM的解析XML文档*/
public class TestDOMParser {
    public static void main(String[] args)
    throws ParserConfigurationException,SAXException,IOException{
        //创建一个DOM解析器工厂
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        //从工厂中生成一个DOM解析器； throws ParserConfigurationException
        DocumentBuilder builder = factory.newDocumentBuilder();
        //绑定需要解析的XML文件
        File xmlFile = new File("src/file/student.xml");//相对地址，相对于这个工程
        //开始解析 ；throws SAXException,IOException
        Document document = builder.parse(xmlFile);
        //取出唯一的根元素
        Element rootElement = document.getDocumentElement();
        //调用业务方法： 遍历根元素
        printElement(rootElement);
    }

    /** 遍历元素，包含： 子元素、属性、文本内容 */
    private static void printElement(Element e){
        //打印出元素的标签名
        System.out.print("<"+e.getTagName());
        //获取开始标签的属性
        NamedNodeMap attMap = e.getAttributes();
        //循环遍历所有的属性
        for (int i=0;i<attMap.getLength();i++){
            Attr attr = (Attr)attMap.item(i);
            System.out.print(" "+attr.getName()+"=\""+attr.getValue()+"\"");}
        System.out.print(">");

        //获取当前元素的所有子节点
        NodeList nl = e.getChildNodes();
        for (int j=0;j<nl.getLength();j++){
            Node n = nl.item(j);
            if (Node.ELEMENT_NODE==n.getNodeType()){
                printElement((Element)n);//递归调用，以遍历下一个元素
            } else {
                System.out.print(n.getTextContent());
            }
        }
        //打印结束标签
        System.out.print("</"+e.getTagName()+">");
}}
<![CDATA[ ###################### DOM遍历 完毕 ##########################]]>

比较DOM与SAX：
    DOM:处理大型文件时其性能下降的非常厉害。这个问题是由DOM的树结构所造成的，这种结构占用的内存较多，而且DOM必须在解析文件之前把整个文档装入内存,适合对XML的随机访问
    优点：1.提供随机定义元素操作，来回移动指针
         2.将整个XML文件一次性加载到内存，形成虚的内存树
    缺点：1.如果XML文件较大，内存空间占用较大
         2.强制将较大的XML文件加载到内存中，有可能损害文件
         3.功能通用性

    SAX:不同于DOM,SAX是事件驱动型的XML解析方式。它顺序逐行读取XML文件，不需要一次全部装载整个文件。当遇到像文件开头，文档结束，或者标签开头与标签结束时，它会触发一个事件，用户通过在其回调事件中写入处理代码来处理XML文件，适合对XML的顺序访问






















