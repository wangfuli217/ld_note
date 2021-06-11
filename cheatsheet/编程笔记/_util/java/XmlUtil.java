/**
 * <P> Title: test                                          </P>
 * <P> Description: xml檔案讀寫工具                        </P>
 * <P> Copyright: Copyright (c) 2010/03/16                  </P>
 * <P> Company:Everunion Tech. Ltd.                         </P>
 */


package com.util;

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


/**
 * xml檔案讀寫工具，基於DOM的解析模式
 * @author Holer W. L. Feng
 * @version 0.1
 */
public class XmlUtil
{
    
    /**
     *  取得 xml 檔案的根元件
     *  @param file xml檔案，例如："src/file/student.xml"
     *  @return xml檔案的根元件
     */
    public static Element getRootElement( String file )
    {
        // 需要讀寫的xml檔案
        File xmlFile = new File(file);
        // 創建一個DOM解析器工廠
        DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
        Document document = null;
        try
        {
            // 從工廠中生成一個DOM解析器； throws ParserConfigurationException
            DocumentBuilder builder = factory.newDocumentBuilder();
            // 開始解析 ；throws SAXException, IOException
            document = builder.parse(xmlFile);
        }
        catch ( Exception e )
        {
            System.out.println("XmlUtil.XmlUtil:" + e.toString());
        }
        // 取出唯一的根元件
        return document.getDocumentElement();
    }
    
    
    /**
     *  遍歷元件，包含： 子元件、屬性、文本內容、注釋內容；但不包括宣告的內容
     *  @param rootElement 根元件
     *  @return xml檔案的所有內容
     */
    public static String getAll( Element rootElement )
    {
        // 防呆
        if ( rootElement == null )
            return "";
        StringBuffer message = new StringBuffer();
        // 元素的標籤名
        message.append("<" + rootElement.getTagName());
        // 取得標籤的屬性
        NamedNodeMap attMap = rootElement.getAttributes();
        // 迴圈取得所有的屬性
        for ( int i = 0; i < attMap.getLength(); i++ )
        {
            Attr attr = (Attr)attMap.item(i);
            message.append(" " + attr.getName() + "=\"" + attr.getValue() + "\"");
        }
        message.append(">");
        
        // 取得元素的所有子節點
        NodeList nl = rootElement.getChildNodes();
        for ( int j = 0; j < nl.getLength(); j++ )
        {
            Node n = nl.item(j);
            // 如果是元件
            if ( Node.ELEMENT_NODE == n.getNodeType() )
                // 遞歸呼叫，以迴圈取得下一個元件
                message.append(getAll((Element)n));
            // 如果是注釋
            else if ( Node.DOCUMENT_POSITION_CONTAINS == n.getNodeType() )
                message.append("<!--" + n.getTextContent() + "-->");
            // 如果不是元件，即是文本內容
            else
                message.append(n.getTextContent());
        }
        // 列印結束標籤
        message.append("</" + rootElement.getTagName() + ">");
        return message.toString();
    }
    
    
    /**
     * 根據 TagName 取得其文本內容
     * @param element 節點元件
     * @param tagName Tag名稱
     * @param tagNumber 第幾個Tag,從0開始
     * @return 這一個節點的文本內容，取不到此子節點時傳回null
     */
    public static String getTextByTag(Element element, String tagName, int tagNumber)
    {
        // 防呆
        if ( element == null || tagName == null )
            return null;
        // 傳回子節點列表
        NodeList list = element.getElementsByTagName(tagName);
        //取不到時，list.getLength() == 0
        if ( list.getLength() > 0 )
        {
            Element tag = (Element)list.item(tagNumber);
            return tag.getTextContent();
        }
        return null;
    }
    
    
    /**
     * 根據 TagName 取得其文本內容
     * @param element 節點元件
     * @param tagName Tag名稱
     * @return 這一個節點的文本內容，取不到此子節點時傳回null
     */
    public static String getTextByTag(Element element, String tagName)
    {
        return getTextByTag(element, tagName, 0);
    }
    
    
    public static void main(String[] args) throws ParserConfigurationException,
            SAXException, IOException
    {
        //System.out.print(getAll(getRootElement( "src/test.xml" )));
        System.out.print(getTextByTag(getRootElement( "src/test.xml" ), "type2"));
    }
    

}