
Dom 元素

处理 XML 文件的 DOM 元素属性：
    <element>.childNodes       返回目前元素所有子元素的数组
    <element>.children         返回目前元素所有子元素的数组(这个在IE、火狐上也可以用)
    <element>.firstChild       返回目前元素的第一个子元素
    <element>.lastChild        返回目前元素的最后一个子元素
    <element>.nodeValue        指定表示元素值的读/写属性
    <element>.parentNode       返回元素的父节点
    <element>.previousSibling  返回紧邻目前元素之前的元素
    <element>.nextSibling      返回目前元素的后面的元素
    <element>.tagName          返回目前元素的标签名(大写)

沿 XML 文件来回移动的 DOM 元素方法：
    document.getElementById(id)             取得有指定唯一ID属性值文件中的元素
    document.getElementsByTagName(name)     返回目前元素中有指定标签名的子元素的数组
    <element>.hasChildNodes()               返回布尔值，表示元素是否有子元素
    <element>.getAttribute(name)            返回元素的属性值，属性由name指定

动态建立内容时所用的 W3C DOM 属性和方法：
    document.createElement(tagName)         建立由tagName指定的元素。比如以"div"作为参数，则生成一个div元素。
    document.createTextNode(text)           建立一个包含静态文字的节点。
    <element>.appendChild(childNode)        将指定节点增加到目前元素的子节点中。例如：select中增加option子节点
    <element>.getAttribute(name)            取得元素中的name属性的值
    <element>.setAttribute(name,value)      设定元素中的name属性的值
    <element>.insertBefore(Node1,Node2)     将节点Node1作为目前元素的子节点插到Node2元素前面。
    <element>.removeAttribute(name)         从元素中删除属性name
    <element>.removeChild(childNode)        从元素中删除子元素childNode
    <element>.replaceChild(newN,oldN)       将节点oldN替换为节点newN
    <element>.hasChildnodes()               返回布尔值，表示元素是否有子元素

    注意：文字实际上是父元素的一个子节点，所以可以使用firstChild属性来存取元素的文字节点。
        有了文字节点后，可以参考文字节点的nodeValue属性来得到文字。
        读取XML时，须考虑它的空格和换行符也作为子节点。


处理 HTML DOM 元素中3个常用的属性: nodeName、 nodeValue 以及 nodeType
    nodeName 属性(只读)含有某个节点的名称:
        元素节点的 nodeName 是标签名称(永远是大写的)
        属性节点的 nodeName 是属性名称
        文本节点的 nodeName 永远是 #text
        文档节点的 nodeName 永远是 #document

    nodeValue / data
        对于文本节点，nodeValue 属性包含文本。可增删改
        对于属性节点，nodeValue 属性包含属性值。
        nodeValue 属性对于文档节点和元素节点是不可用的。会返回 null
        data同样是文本的内容,这个属性下同样可以增删改。对于文档节点和元素节点不可用,返回 undefine

    nodeType 属性返回节点的类型。节点类型是：
        元素类型                  节点类型
        ELEMENT_NODE                :  1  // 元素
        ATTRIBUTE_NODE              :  2  // 属性
        TEXT_NODE                   :  3  // 文本
        CDATA_SECTION_NODE          :  4
        ENTITY_REFERENCE_NODE       :  5
        ENTITY_NODE                 :  6
        PROCESSING_INSTRUCTION_NODE :  7
        COMMENT_NODE                :  8  // 注释
        DOCUMENT_NODE               :  9  // 文档,即 document
        DOCUMENT_TYPE_NODE          : 10
        DOCUMENT_FRAGMENT_NODE      : 11
        NOTATION_NODE               : 12

    注： 对于属性节点，可使用 “attr.nodeName”和“attr.nodeValue”来查看或者赋值, 也可以使用“attr.name”和“attr.value”。
    只是, attr.nodeValue 会返回真实类型,如 bool,number,string,object 等； 而 attr.value 全是 string 类型(null 则返回"null")

    判断是否 dom 元素，一些特殊节点只有nodeName，没有tagName，比如document的nodeName为“#document”，tagName为空值。
