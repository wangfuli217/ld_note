²¿ÊðÃèÊö·ûÊµ¼ÊÉÏÊÇÒ»¸öXMLÎÄ¼þ£¬°üº¬ÁËºÜ¶àÃèÊöservlet/JSPÓ¦ÓÃµÄ¸÷¸ö·½ÃæµÄÔªËØ£¬Èçservlet×¢²á¡¢servletÓ³ÉäÒÔ¼°¼àÌýÆ÷×¢²á¡£²¿ÊðÃèÊö·û´ÓÏÂÃæµÄXMLÍ·¿ªÊ¼£º
<?xml version="1.0" encoding="ISO-8859-1"?>
Õâ¸öÍ·Ö¸¶¨ÁËXMLµÄ°æ±¾ºÅÒÔ¼°ËùÊ¹ÓÃµÄ±àÂë¡£Í·µÄÏÂÃæÊÇDOCTYPEÉùÃ÷£º
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
Õâ¶Î´úÂëÖ¸¶¨ÎÄ¼þÀàÐÍ¶¨Òå(DTD)£¬¿ÉÒÔÍ¨¹ýËü¼ì²éXMLÎÄµµµÄÓÐÐ§ÐÔ¡£ÏÂÃæÏÔÊ¾µÄ<!DOCTYPE>ÔªËØÓÐ¼¸¸öÌØÐÔ£¬ÕâÐ©ÌØÐÔ¸æËßÎÒÃÇ¹ØÓÚDTDµÄÐÅÏ¢£º
¡ñ        web-app¶¨Òå¸ÃÎÄµµ(²¿ÊðÃèÊö·û£¬²»ÊÇDTDÎÄ¼þ)µÄ¸ùÔªËØ
¡ñ        PUBLICÒâÎ¶×ÅDTDÎÄ¼þ¿ÉÒÔ±»¹«¿ªÊ¹ÓÃ
¡ñ       "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"ÒâÎ¶×ÅDTDÓÉSun Microsystems, Inc.   
           Î¬»¤¡£¸ÃÐÅÏ¢Ò²±íÊ¾ËüÃèÊöµÄÎÄµµÀàÐÍÊÇDTD Web Application 2.3£¬¶øÇÒDTDÊÇÓÃÓ¢ÎÄÊéÐ´µÄ¡£
¡ñ        URL"http://java.sun.com/dtd/web-app_2_3.dtd"±íÊ¾DÎÄ¼þµÄÎ»ÖÃ¡£
×¢Òâ£º
ÔÚ²¿ÊðÃèÊö·ûÖÐ£¬ <!--¡­-->ÓÃÓÚ×¢ÊÍ¡£
²¿ÊðÃèÊö·ûµÄ¸ùÔªËØÊÇweb-app¡£DTDÎÄ¼þ¹æ¶¨£¬web-appÔªËØµÄ×ÓÔªËØµÄÓï·¨ÈçÏÂ£º
<!ELEMENT web-app (icon?, display-name?, description?,
distributable?, context-param*, filter*, filter-mapping*,
listener*, servlet*, servlet-mapping*, session-config?,
mime-mapping*, welcome-file-list?,
error-page*, taglib*, resource-env-ref*, resource-ref*,
security-constraint*, login-config?, security-role*,env-entry*,
ejb-ref*, ejb-local-ref*)>
ÕýÈçÄúËù¿´µ½µÄ£¬Õâ¸öÔªËØº¬ÓÐ23¸ö×ÓÔªËØ£¬¶øÇÒ×ÓÔªËØ¶¼ÊÇ¿ÉÑ¡µÄ¡£ÎÊºÅ(£¿)±íÊ¾×ÓÔªËØÊÇ¿ÉÑ¡µÄ£¬¶øÇÒÖ»ÄÜ³öÏÖÒ»´Î¡£ÐÇºÅ(*)±íÊ¾×ÓÔªËØ¿ÉÔÚ²¿ÊðÃèÊö·ûÖÐ³öÏÖÁã´Î»ò¶à´Î¡£ÓÐÐ©×ÓÔªËØ»¹¿ÉÒÔÓÐËüÃÇ×Ô¼ºµÄ×ÓÔªËØ¡£

web.xmlÎÄ¼þÖÐweb-appÔªËØÉùÃ÷µÄÊÇÏÂÃæÃ¿¸ö×ÓÔªËØµÄÉùÃ÷¡£ÏÂÃæµÄÕÂ½Ú½²Êö²¿ÊðÃèÊö·ûÖÐ¿ÉÄÜ°üº¬µÄËùÓÐ×ÓÔªËØ¡£
×¢Òâ£º
ÔÚServlet 2.3ÖÐ£¬×ÓÔªËØ±ØÐë°´ÕÕDTDÎÄ¼þÓï·¨ÃèÊöÖÐÖ¸¶¨µÄË³Ðò³öÏÖ¡£±ÈÈç£¬Èç¹û²¿ÊðÃèÊö·ûÖÐµÄweb-appÔªËØÓÐservletºÍservlet-mappingÁ½¸ö×ÓÔªËØ£¬Ôòservlet×ÓÔªËØ±ØÐë³öÏÖÔÚservlet-mapping×ÓÔªËØÖ®Ç°¡£ÔÚServlet 2.4ÖÐ£¬Ë³Ðò²¢²»ÖØÒª¡£
ÏÂÃæ¶Ôweb.xmlÎÄ¼þ¸÷ÔªËØ½øÐÐÏê½â
1. iconÔªËØ
iconÔªËØÓÃÀ´Ö¸¶¨GIF¸ñÊ½»òJPEG¸ñÊ½µÄÐ¡Í¼±ê(16¡Á16)»ò´óÍ¼±ê(32¡Á32)µÄÎÄ¼þÃû¡£
<!ELEMENT icon (small-icon?, large-icon?)>
<!ELEMENT small-icon (#PCDATA)>
<!ELEMENT large-icon (#PCDATA)>
iconÔªËØ°üÀ¨Á½¸ö¿ÉÑ¡µÄ×ÓÔªËØ£ºsmall-icon×ÓÔªËØºÍlarge-icon×ÓÔªËØ¡£ÎÄ¼þÃûÊÇWebÓ¦ÓÃ¹éµµÎÄ¼þ(WAR)µÄ¸ùµÄÏà¶ÔÂ·¾¶¡£
²¿ÊðÃèÊö·û²¢Ã»ÓÐÊ¹ÓÃiconÔªËØ¡£µ«ÊÇ£¬Èç¹ûÊ¹ÓÃXML¹¤¾ß±à¼­²¿ÊðÃèÊö·û£¬XML±à¼­Æ÷¿ÉÒÔÊ¹ÓÃiconÔªËØ¡£
2. display-nameÔªËØ
Èç¹ûÊ¹ÓÃ¹¤¾ß±à¼­²¿ÊðÃèÊö·û£¬display-nameÔªËØ°üº¬µÄ¾ÍÊÇXML±à¼­Æ÷ÏÔÊ¾µÄÃû³Æ¡£
<!ELEMENT display-name (#PCDATA)>
ÏÂÃæÊÇÒ»¸öº¬ÓÐdisplay-nameÔªËØµÄ²¿ÊðÃèÊö·û£º
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<display-name>Online Store Application</display-name>
</web-app>
3. descriptionÔªËØ
¿ÉÒÔÊ¹ÓÃdescriptionÔªËØÀ´Ìá¹©ÓÐ¹Ø²¿ÊðÃèÊö·ûµÄÐÅÏ¢¡£XML±à¼­Æ÷¿ÉÒÔÊ¹ÓÃdescriptionÔªËØµÄÖµ¡£
<!ELEMENT description (#PCDATA)>
4. distributableÔªËØ
¿ÉÒÔÊ¹ÓÃdistributableÔªËØÀ´¸æËßservlet/JSPÈÝÆ÷£¬±àÐ´½«ÔÚ·Ö²¼Ê½WebÈÝÆ÷ÖÐ²¿ÊðµÄÓ¦ÓÃ£º
<!ELEMENT distributable EMPTY>
ÀýÈç£¬ÏÂÃæÊÇÒ»¸öº¬ÓÐdistributableÔªËØµÄ²¿ÊðÃèÊö·ûµÄÀý×Ó£º
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<distributable/>
</web-app>
5. context-paramÔªËØ
context-paramÔªËØº¬ÓÐÒ»¶Ô²ÎÊýÃûºÍ²ÎÊýÖµ£¬ÓÃ×÷Ó¦ÓÃµÄservletÉÏÏÂÎÄ³õÊ¼»¯²ÎÊý¡£²ÎÊýÃûÔÚÕû¸öWebÓ¦ÓÃÖÐ±ØÐëÊÇÎ©Ò»µÄ¡£
<!ELEMENT context-param (param-name, param-value, description?)>
<!ELEMENT param-name (#PCDATA)>
<!ELEMENT param-value (#PCDATA)>
<!ELEMENT description (#PCDATA)>
param-name ×ÓÔªËØ°üº¬ÓÐ²ÎÊýÃû£¬¶øparam-value×ÓÔªËØ°üº¬µÄÊÇ²ÎÊýÖµ¡£×÷ÎªÑ¡Ôñ£¬¿ÉÓÃdescription×ÓÔªËØÀ´ÃèÊö²ÎÊý¡£
ÏÂÃæÊÇÒ»¸öº¬ÓÐcontext-paramÔªËØµÄÓÐÐ§²¿ÊðÃèÊö·û£º
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<context-param>
<param-name>jdbcDriver</param-name>
<param-value>com.mysql.jdbc.Driver</param-value>
</context-param>
</web-app>
6. filterÔªËØ
filterÔªËØÓÃÓÚÖ¸¶¨WebÈÝÆ÷ÖÐµÄ¹ýÂËÆ÷¡£ÔÚÇëÇóºÍÏìÓ¦¶ÔÏó±»servlet´¦ÀíÖ®Ç°»òÖ®ºó£¬¿ÉÒÔÊ¹ÓÃ¹ýÂËÆ÷¶ÔÕâÁ½¸ö¶ÔÏó½øÐÐ²Ù×÷¡£ÀûÓÃÏÂÒ»½Ú½éÉÜµÄfilter-mappingÔªËØ£¬¹ýÂËÆ÷±»Ó³Éäµ½Ò»¸öservlet»òÒ»¸öURLÄ£Ê½¡£Õâ¸ö¹ýÂËÆ÷µÄfilterÔªËØºÍfilter-mappingÔªËØ±ØÐë¾ßÓÐÏàÍ¬µÄÃû³Æ¡£
<!ELEMENT filter (icon?, filter-name, display-name?, description?,
filter-class, init-param*)>
<!ELEMENT filter-name (#PCDATA)>
<!ELEMENT filter-class (#PCDATA)>
icon¡¢display-nameºÍdescriptionÔªËØµÄÓÃ·¨ºÍÉÏÒ»½Ú½éÉÜµÄÓÃ·¨ÏàÍ¬¡£init-paramÔªËØÓëcontext-paramÔªËØ¾ßÓÐÏàÍ¬µÄÔªËØÃèÊö·û¡£filter-nameÔªËØÓÃÀ´¶¨Òå¹ýÂËÆ÷µÄÃû³Æ£¬¸ÃÃû³ÆÔÚÕû¸öÓ¦ÓÃÖÐ¶¼±ØÐëÊÇÎ©Ò»µÄ¡£filter-classÔªËØÖ¸¶¨¹ýÂËÆ÷ÀàµÄÍêÈ«ÏÞ¶¨µÄÃû³Æ¡£
ÏÂÃæÊÇÒ»¸öÊ¹ÓÃfilterÔªËØµÄ²¿ÊðÃèÊö·ûµÄÀý×Ó£º
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<filter>
<filter-name>Encryption Filter</filter-name>
<filter-class>com.branysoftware.EncryptionFilter</filter-class>
</filter>
</web-app>
7. filter-mappingÔªËØ
filter-mappingÔªËØÓÃÀ´ÉùÃ÷WebÓ¦ÓÃÖÐµÄ¹ýÂËÆ÷Ó³Éä¡£¹ýÂËÆ÷¿É±»Ó³Éäµ½Ò»¸öservlet»òÒ»¸öURLÄ£Ê½¡£½«¹ýÂËÆ÷Ó³Éäµ½Ò»¸öservletÖÐ»áÔì³É¹ýÂËÆ÷×÷ÓÃÓÚservletÉÏ¡£½«¹ýÂËÆ÷Ó³Éäµ½Ò»¸öURLÄ£Ê½ÖÐÔò¿ÉÒÔ½«¹ýÂËÆ÷Ó¦ÓÃÓÚÈÎºÎ×ÊÔ´£¬Ö»Òª¸Ã×ÊÔ´µÄURLÓëURLÄ£Ê½Æ¥Åä¡£¹ýÂËÊÇ°´ÕÕ²¿ÊðÃèÊö·ûµÄfilter-mappingÔªËØ³öÏÖµÄË³ÐòÖ´ÐÐµÄ¡£
<!ELEMENT filter-mapping (filter-name, (url-pattern | servlet-name))>
<!ELEMENT filter-name (#PCDATA)>
<!ELEMENT url-pattern (#PCDATA)>
<!ELEMENT servlet-name (#PCDATA)>
filter-nameÖµ±ØÐë¶ÔÓ¦filterÔªËØÖÐÉùÃ÷µÄÆäÖÐÒ»¸ö¹ýÂËÆ÷Ãû³Æ¡£ÏÂÃæÊÇÒ»¸öº¬ÓÐfilter-mappingÔªËØµÄ²¿ÊðÃèÊö·û£º
<?xml version="1.0" encoding="ISO-8859-1">
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<filter>
<filter-name>Encryption Filter</filter-name>
<filter-class>com.brainysoftware.EncryptionFilter</filter-class>
</filter>
<filter-mapping>
<filter-name>Encryption Filter</filter-name>
<servlet-name>EncryptionFilteredServlet</servlet-name>
</filter-mapping>
</web-app>
8. listenerÔªËØ
listenerÔªËØÓÃÀ´×¢²áÒ»¸ö¼àÌýÆ÷Àà£¬¿ÉÒÔÔÚWebÓ¦ÓÃÖÐ°üº¬¸ÃÀà¡£Ê¹ÓÃlistenerÔªËØ£¬¿ÉÒÔÊÕµ½ÊÂ¼þÊ²Ã´Ê±ºò·¢ÉúÒÔ¼°ÓÃÊ²Ã´×÷ÎªÏìÓ¦µÄÍ¨Öª¡£
<!ELEMENT listener (listener-class)>
<!ELEMENT listener-class (#PCDATA)>
ÏÂÃæÊÇÒ»¸öº¬ÓÐlistenerÔªËØµÄÓÐÐ§²¿ÊðÃèÊö·û£º
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<listener>
<listener-class>MyAppListener</listener-class>
</listener>
</web-app>
9. servletÔªËØ
servletÔªËØÓÃÀ´ÉùÃ÷Ò»¸öservlet¡£
<!ELEMENT servlet (icon?, servlet-name, display-name?, description?,
(servlet-class|jsp-file), init-param*, load-on-startup?, run-as?,
security-role-ref*)>
<!ELEMENT servlet-name (#PCDATA)>
<!ELEMENT servlet-class (#PCDATA)>
<!ELEMENT jsp-file (#PCDATA)>
<!ELEMENT init-param (param-name, param-value, description?)>
<!ELEMENT load-on-startup (#PCDATA)>
<!ELEMENT run-as (description?, role-name)>
<!ELEMENT role-name (#PCDATA)>
icon¡¢display-nameºÍdescriptionÔªËØµÄÓÃ·¨ºÍÉÏÒ»½Ú½éÉÜµÄÓÃ·¨ÏàÍ¬¡£init-paramÔªËØÓëcontext-paramÔªËØ¾ßÓÐÏàÍ¬µÄÔªËØÃèÊö·û¡£¿ÉÒÔÊ¹ÓÃinit-param×ÓÔªËØ½«³õÊ¼»¯²ÎÊýÃûºÍ²ÎÊýÖµ´«µÝ¸øservlet¡£
(1) servlet-name¡¢servlet-classºÍjsp-fileÔªËØ
servletÔªËØ±ØÐëº¬ÓÐservlet-nameÔªËØºÍservlet-classÔªËØ£¬»òÕßservlet-nameÔªËØºÍjsp-fileÔªËØ¡£ÃèÊöÈçÏÂ£º
¡ñ        servlet-nameÔªËØÓÃÀ´¶¨ÒåservletµÄÃû³Æ£¬¸ÃÃû³ÆÔÚÕû¸öÓ¦ÓÃÖÐ±ØÐëÊÇÎ©Ò»µÄ¡£
¡ñ        servlet-classÔªËØÓÃÀ´Ö¸¶¨servletµÄÍêÈ«ÏÞ¶¨µÄÃû³Æ¡£
¡ñ        jsp-fileÔªËØÓÃÀ´Ö¸¶¨Ó¦ÓÃÖÐJSPÎÄ¼þµÄÍêÕûÂ·¾¶¡£Õâ¸öÍêÕûÂ·¾¶±ØÐëÓÉa/¿ªÊ¼¡£
(2) load-on-startupÔªËØ
µ±Æô¶¯WebÈÝÆ÷Ê±£¬ÓÃload-on-startupÔªËØ×Ô¶¯½«servlet¼ÓÈëÄÚ´æ¡£¼ÓÔØservlet¾ÍÒâÎ¶×ÅÊµÀý»¯Õâ¸öservlet£¬²¢µ÷ÓÃËüµÄinit·½·¨¡£¿ÉÒÔÊ¹ÓÃÕâ¸öÔªËØÀ´±ÜÃâµÚÒ»¸öservletÇëÇóµÄÏìÓ¦ÒòÎªservletÔØÈëÄÚ´æËùµ¼ÖÂµÄÈÎºÎÑÓ³Ù¡£Èç¹ûload-on-startupÔªËØ´æÔÚ£¬¶øÇÒÒ²Ö¸¶¨ÁËjsp-fileÔªËØ£¬ÔòJSPÎÄ¼þ»á±»ÖØÐÂ±àÒë³Éservlet£¬Í¬Ê±²úÉúµÄservletÒ²±»ÔØÈëÄÚ´æ¡£
load-on-startupÔªËØµÄÄÚÈÝ¿ÉÒÔÎª¿Õ£¬»òÕßÊÇÒ»¸öÕûÊý¡£Õâ¸öÖµ±íÊ¾ÓÉWebÈÝÆ÷ÔØÈëÄÚ´æµÄË³Ðò¡£¾Ù¸öÀý×Ó£¬Èç¹ûÓÐÁ½¸öservletÔªËØ¶¼º¬ÓÐload-on-startup×ÓÔªËØ£¬Ôòload-on-startup×ÓÔªËØÖµ½ÏÐ¡µÄservlet½«ÏÈ±»¼ÓÔØ¡£Èç¹ûload-on-startup×ÓÔªËØÖµÎª¿Õ»ò¸ºÖµ£¬ÔòÓÉWebÈÝÆ÷¾ö¶¨Ê²Ã´Ê±ºò¼ÓÔØservlet¡£Èç¹ûÁ½¸öservletµÄload-on-startup×ÓÔªËØÖµÏàÍ¬£¬ÔòÓÉWebÈÝÆ÷¾ö¶¨ÏÈ¼ÓÔØÄÄÒ»¸öservlet¡£
(3) run-asÔªËØ
Èç¹û¶¨ÒåÁËrun-asÔªËØ£¬Ëü»áÖØÐ´ÓÃÓÚµ÷ÓÃWebÓ¦ÓÃÖÐservletËùÉè¶¨µÄEnterprise JavaBean(EJB)µÄ°²È«Éí·Ý¡£Role-nameÊÇÎªµ±Ç°WebÓ¦ÓÃ¶¨ÒåµÄÒ»¸ö°²È«½ÇÉ«µÄÃû³Æ¡£
(4) security-role-refÔªËØ
security-role-refÔªËØ¶¨ÒåÒ»¸öÓ³Éä£¬¸ÃÓ³ÉäÔÚservletÖÐÓÃisUserInRole (String name)µ÷ÓÃµÄ½ÇÉ«ÃûÓëÎªWebÓ¦ÓÃ¶¨ÒåµÄ°²È«½ÇÉ«ÃûÖ®¼ä½øÐÐ¡£security-role-refÔªËØµÄÃèÊöÈçÏÂ£º
<!ELEMENT security-role-ref (description?, role-name, role-link)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT role-name (#PCDATA)>
<!ELEMENT role-link (#PCDATA)>
role-linkÔªËØÓÃÀ´½«°²È«½ÇÉ«ÒýÓÃÁ´½Óµ½ÒÑ¶¨ÒåµÄ°²È«½ÇÉ«¡£role-linkÔªËØ±ØÐëº¬ÓÐÒÑ¾­ÔÚsecurity-roleÔªËØÖÐ¶¨ÒåµÄÒ»¸ö°²È«½ÇÉ«µÄÃû³Æ¡£
(5) Faces ServletµÄservletÔªËØ
ÔÚ JSFÓ¦ÓÃÖÐ£¬ÐèÒªÎªFaces Servlet¶¨ÒåÒ»¸öservletÔªËØ£¬ÈçÏÂËùÊ¾£º
<?xml version="1.0"?>
<!DOCTYPE web-app PUBLIC
"-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<!-- Faces Servlet -->
<servlet>
<servlet-name>Faces Servlet</servlet-name>
<servlet-class>javax.faces.webapp.FacesServlet</servlet-class>
<load-on-startup> 1 </load-on-startup>
</servlet>
<!-- Faces Servlet Mapping -->
<servlet-mapping>
<servlet-name>Faces Servlet</servlet-name>
<url-pattern>/faces/*</url-pattern>
</servlet-mapping>
</web-app>
10. seervlet-mapping ÔªËØ
seervlet-mapping ÔªËØ½«URLÄ£Ê½Ó³Éäµ½Ä³¸öservlet¡£
<!ELEMENT servlet-mapping (servlet-name, url-pattern)>
<!ELEMENT servlet-name (#PCDATA)>
<!ELEMENT url-pattern (#PCDATA)>
ÔÚÇ°ÃæµÄ¡°servletÔªËØ¡±Ò»½ÚÖÐÒÑ¾­½éÉÜÁËÊ¹ÓÃservlet-mappingÔªËØµÄÀý×Ó¡£
11. session-configÔªËØ
session-configÔªËØÎªWebÓ¦ÓÃÖÐµÄjavax.servlet.http.HttpSession¶ÔÏó¶¨Òå²ÎÊý¡£
<!ELEMENT session-config (session-timeout?)>
<!ELEMENT session-timeout (#PCDATA)>
session-timeoutÔªËØÓÃÀ´Ö¸¶¨Ä¬ÈÏµÄ»á»°³¬Ê±Ê±¼ä¼ä¸ô£¬ÒÔ·ÖÖÓÎªµ¥Î»¡£¸ÃÔªËØÖµ±ØÐëÎªÕûÊý¡£Èç¹ûsession-timeoutÔªËØµÄÖµÎªÁã»ò¸ºÊý£¬Ôò±íÊ¾»á»°½«ÓÀÔ¶²»»á³¬Ê±¡£
ÏÂÃæÊÇÒ»¸ö²¿ÊðÃèÊö·û£¬ÔÚÓÃ»§×î½ü·ÃÎÊHttpSession¶ÔÏó30·ÖÖÓºó£¬HttpSession¶ÔÏóÄ¬ÈÏÎªÎÞÐ§£º
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<session-config>
<session-timeout>30</session-timeout>
</session-config>
</web-app>
12. mime-mappingÔªËØ
mime-mappingÔªËØ½«mimeÀàÐÍÓ³Éäµ½À©Õ¹Ãû¡£
<!ELEMENT mime-mapping (extension, mime-type)>
<!ELEMENT extension (#PCDATA)>
<!ELEMENT mime-type (#PCDATA)>
extensionÔªËØÓÃÀ´ÃèÊöÀ©Õ¹Ãû¡£mime-typeÔªËØÔòÎªMIMEÀàÐÍ¡£
¾Ù¸öÀý×Ó£¬ÏÂÃæµÄ²¿ÊðÃèÊö·û½«À©Õ¹ÃûtxtÓ³ÉäÎªtext/plain£º
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<mime-mapping>
<extension>txt</extension>
<mime-type>text/plain</mime-type>
</mime-mapping>
</web-app>
13. welcome-file-listÔªËØ
µ±ÓÃ»§ÔÚä¯ÀÀÆ÷ÖÐÊäÈëµÄURL²»°üº¬Ä³¸öservletÃû»òJSPÒ³ÃæÊ±£¬welcome-file-listÔªËØ¿ÉÖ¸¶¨ÏÔÊ¾µÄÄ¬ÈÏÎÄ¼þ¡£
<!ELEMENT welcome-file-list (welcome-file+)>
<!ELEMENT welcome-file (#PCDATA)>
¾Ù¸öÀý×ÓËµÃ÷£¬¼ÙÉèÓÃ»§ÔÚä¯ÀÀÆ÷µÄµØÖ·¿òÖÐÊäÈëhttp://www.mycompany.com/appName/µÈµØÖ·¡£Èç¹ûÔÚWebÓ¦ÓÃµÄ²¿ÊðÃèÊö·ûÖÐÖ¸¶¨welcome-file-listÔªËØ£¬ÓÃ»§¾Í»á¿´µ½Ò»¸öÈ¨ÏÞ´íÎóÏûÏ¢£¬»òÕßÊÇÓ¦ÓÃÄ¿Â¼ÏÂµÄÎÄ¼þºÍÄ¿Â¼ÁÐ±í¡£Èç¹û¶¨ÒåÁËwelcome-file-listÔªËØ£¬ÓÃ»§¾ÍÄÜ¿´µ½ÓÉ¸ÃÔªËØÖ¸¶¨µÄ¾ßÌåÎÄ¼þ¡£
welcome-file×ÓÔªËØÓÃÓÚÖ¸¶¨Ä¬ÈÏÎÄ¼þµÄÃû³Æ¡£welcome-file-listÔªËØ¿ÉÒÔ°üº¬Ò»¸ö»ò¶à¸öwelcome-file×ÓÔªËØ¡£Èç¹ûÔÚµÚÒ»¸öwelcome-fileÔªËØÖÐÃ»ÓÐÕÒµ½Ö¸¶¨µÄÎÄ¼þ£¬WebÈÝÆ÷¾Í»á³¢ÊÔÏÔÊ¾µÚ¶þ¸ö£¬ÒÔ´ËÀàÍÆ¡£
ÏÂÃæÊÇÒ»¸ö°üº¬welcome-file-listÔªËØµÄ²¿ÊðÃèÊö·û¡£¸ÃÔªËØ°üº¬Á½¸öwelcome-fileÔªËØ£ºµÚÒ»¸öÖ¸¶¨Ó¦ÓÃÄ¿Â¼ÖÐµÄmain.htmlÎÄ¼þ£¬µÚ¶þ¸ö¶¨ÒåjspÄ¿Â¼ÏÂµÄwelcom.jspÎÄ¼þ£¬jspÄ¿Â¼Ò²ÔÚÓ¦ÓÃÄ¿Â¼ÏÂ¡£
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<welcome-file-list>
<welcome-file>main.html</welcome-file>
<welcome-file>jsp/welcome.jsp</welcome-file>
</welcome-file-list>
</web-app>
Èç¹ûÓÃ»§¼üÈëµÄURL²»°üº¬servletÃû³Æ¡¢JSPÒ³Ãæ»òÆäËû×ÊÔ´£¬Ôò²»»áÔÚÓ¦ÓÃÄ¿Â¼ÖÐÕÒµ½main.htmlÎÄ¼þ£¬ÕâÊ±¾Í»áÏÔÊ¾jspÄ¿Â¼ÏÂµÄwelcome.jspÎÄ¼þ¡£
14. error-pageÔªËØ
error-pageÔªËØÓÃÓÚ½«Ò»¶Î´íÎó´úÂë»òÒ»¸öÒì³£ÀàÐÍÓ³Éäµ½WebÓ¦ÓÃÖÐµÄ×ÊÔ´Â·¾¶£¬´Ó¶øÔÚ²úÉúÌØÊâµÄHTTP´íÎó»òÖ¸¶¨µÄJavaÒì³£Ê±£¬½«ÏÔÊ¾Ïà¹ØµÄ×ÊÔ´¡£
<!ELEMENT error-page ((error-code | exception-type), location)>
<!ELEMENT error-code (#PCDATA)>
<!ELEMENT exception-type (#PCDATA)>
<!ELEMENT location (#PCDATA)>
error-codeÔªËØ°üº¬HTTP´íÎó´úÂë¡£exception-typeÊÇJavaÒì³£ÀàÐÍµÄÍêÈ«ÏÞ¶¨µÄÃû³Æ¡£locationÔªËØÊÇWebÓ¦ÓÃÖÐµÄ×ÊÔ´Ïà¶ÔÓÚÓ¦ÓÃÄ¿Â¼µÄÂ·¾¶¡£locationµÄÖµ±ØÐë´Óa/¿ªÊ¼¡£
¾Ù¸öÀý×Ó£¬Ã¿´Î²úÉúHTTP 404´íÎó´úÂëÊ±£¬ÏÂÃæµÄ²¿ÊðÃèÊö·û¿ÉÊ¹WebÈÝÆ÷ÏÔÊ¾error404.htmlÒ³Ãæ£º
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<error-page>
<error-code>404</error-code>
<location>/error404.html</location>
</error-page>
</web-app>
15. taglibÔªËØ
taglibÔªËØÃèÊöJSP¶¨ÖÆ±ê¼Ç¿â¡£
<!ELEMENT taglib (taglib-uri, taglib-location)>
<!ELEMENT taglib-uri (#PCDATA)>
<!ELEMENT taglib-location (#PCDATA)>
taglib-uriÔªËØÊÇÓÃÓÚWebÓ¦ÓÃÖÐµÄ±ê¼Ç¿âµÄURI¡£taglib-uriÔªËØµÄÖµÓëWEB-INFÄ¿Â¼Ïà¶ÔÓ¦¡£
taglib-locationÔªËØ°üº¬Ò»¸öÎ»ÖÃ£¬ÆäÖÐ¿ÉÒÔÕÒµ½±ê¼Ç¿âµÄ±ê¼Ç¿âÃèÊö·û(TLD)ÎÄ¼þ¡£
16. resource-env-refÔªËØ
¿ÉÒÔÊ¹ÓÃresource-env-refÔªËØÀ´Ö¸¶¨¶Ô¹ÜÀí¶ÔÏóµÄservletÒýÓÃµÄÉùÃ÷£¬¸Ã¶ÔÏóÓëservlet»·¾³ÖÐµÄ×ÊÔ´Ïà¹ØÁª¡£
<!ELEMENT resource-env-ref (description?, resource-env-ref-name,
resource-env-ref-type)>
<!ELEMENT resource-env-ref-name (#PCDATA)>
<!ELEMENT resource-env-ref-type (#PCDATA)>
resource-env-ref-nameÔªËØÊÇ×ÊÔ´»·¾³ÒýÓÃµÄÃû³Æ£¬ÆäÖµÎªservlet´úÂëÖÐÊ¹ÓÃµÄ»·¾³µÄÈë¿ÚÃû³Æ¡£¸ÃÃû³ÆÊÇÒ»¸öÓëjava:comp/envÏà¶ÔÓ¦µÄJavaÃüÃûºÍÄ¿Â¼½Ó¿Ú(JNDI)Ãû³Æ£¬¸ÃÃû³ÆÔÚÕû¸öWebÓ¦ÓÃÖÐ±ØÐëÊÇÎ©Ò»µÄ¡£
17. resource-refÔªËØ
resource-refÔªËØÓÃÓÚÖ¸¶¨¶ÔÍâ²¿×ÊÔ´µÄservletÒýÓÃµÄÉùÃ÷¡£
<!ELEMENT resource-ref (description?, res-ref-name,
res-type, res-auth, res-sharing-scope?)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT res-ref-name (#PCDATA)>
<!ELEMENT res-type (#PCDATA)>
<!ELEMENT res-auth (#PCDATA)>
<!ELEMENT res-sharing-scope (#PCDATA)>
resource-ref×ÓÔªËØµÄÃèÊöÈçÏÂ£º
¡ñ        res-ref-nameÊÇ×ÊÔ´¹¤³§ÒýÓÃÃûµÄÃû³Æ¡£¸ÃÃû³ÆÊÇÒ»¸öÓëjava:comp/envÉÏÏÂÎÄÏà¶ÔÓ¦µÄJNDIÃû³Æ£¬²¢ÇÒÔÚÕû¸öWebÓ¦ÓÃÖÐ±ØÐëÊÇÎ©Ò»µÄ¡£
¡ñ        res-auth±íÃ÷£ºservlet´úÂëÍ¨¹ý±à³Ì×¢²áµ½×ÊÔ´¹ÜÀíÆ÷£¬»òÕßÊÇÈÝÆ÷½«´ú±íservlet×¢²áµ½×ÊÔ´¹ÜÀíÆ÷¡£¸ÃÔªËØµÄÖµ±ØÐëÎªApplication»òContainer¡£
¡ñ        res-sharing-scope±íÃ÷£ºÊÇ·ñ¿ÉÒÔ¹²ÏíÍ¨¹ý¸ø¶¨×ÊÔ´¹ÜÀíÆ÷Á¬½Ó¹¤³§ÒýÓÃ»ñµÃµÄÁ¬½Ó¡£¸ÃÔªËØµÄÖµ±ØÐëÎªShareable(Ä¬ÈÏÖµ)»òUnshareable¡£
18. security-constraintÔªËØ
²¿ÊðÃèÊö·ûÖÐµÄsecurity-constraintÔªËØÔÊÐí²»Í¨¹ý±à³Ì¾Í¿ÉÒÔÏÞÖÆ¶ÔÄ³¸ö×ÊÔ´µÄ·ÃÎÊ¡£
<!ELEMENT security-constraint (display-name?,
web-resource-collection+,
auth-constraint?, user-data-constraint?)>
<!ELEMENT display-name (#PCDATA)>
<!ELEMENT web-resource-collection (web-resource-name, description?,
url-pattern*, http-method*)>
<!ELEMENT auth-constraint (description?, role-name*)>
<!ELEMENT user-data-constraint (description?, transport-guarantee)>
(1) web-resource-collectionÔªËØ
web-resource-collectionÔªËØ±êÊ¶ÐèÒªÏÞÖÆ·ÃÎÊµÄ×ÊÔ´×Ó¼¯¡£ÔÚweb-resource-collectionÔªËØÖÐ£¬¿ÉÒÔ¶¨ÒåURLÄ£Ê½ºÍHTTP·½·¨¡£Èç¹û²»´æÔÚHTTP·½·¨£¬¾Í½«°²È«Ô¼ÊøÓ¦ÓÃÓÚËùÓÐµÄ·½·¨¡£
<!ELEMENT web-resource-collection (web-resource-name, description?,
url-pattern*, http-method*)>
<!ELEMENT web-resource-name (#PCDATA)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT url-pattern (#PCDATA)>
<!ELEMENT http-method (#PCDATA)>
web-resource-nameÊÇÓëÊÜ±£»¤×ÊÔ´Ïà¹ØÁªµÄÃû³Æ¡£http-methodÔªËØ¿É±»¸³ÓèÒ»¸öHTTP·½·¨£¬±ÈÈçGETºÍPOST¡£
(2) auth-constraintÔªËØ
auth-constraintÔªËØÓÃÓÚÖ¸¶¨¿ÉÒÔ·ÃÎÊ¸Ã×ÊÔ´¼¯ºÏµÄÓÃ»§½ÇÉ«¡£Èç¹ûÃ»ÓÐÖ¸¶¨auth-constraintÔªËØ£¬¾Í½«°²È«Ô¼ÊøÓ¦ÓÃÓÚËùÓÐ½ÇÉ«¡£
<!ELEMENT auth-constraint (description?, role-name*)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT role-name (#PCDATA)>
role-nameÔªËØ°üº¬°²È«½ÇÉ«µÄÃû³Æ¡£
(3) user-data-constraintÔªËØ
user-data-constraintÔªËØÓÃÀ´ÏÔÊ¾ÔõÑù±£»¤ÔÚ¿Í»§¶ËºÍWebÈÝÆ÷Ö®¼ä´«µÝµÄÊý¾Ý¡£
<!ELEMENT user-data-constraint (description?, transport-guarantee)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT transport-guarantee (#PCDATA)>
transport-guaranteeÔªËØ±ØÐë¾ßÓÐÈçÏÂµÄÄ³¸öÖµ£º
¡ñ        NONE£¬ÕâÒâÎ¶×ÅÓ¦ÓÃ²»ÐèÒª´«Êä±£Ö¤¡£
¡ñ        INTEGRAL£¬ÒâÎ¶×Å·þÎñÆ÷ºÍ¿Í»§¶ËÖ®¼äµÄÊý¾Ý±ØÐëÒÔÄ³ÖÖ·½Ê½·¢ËÍ£¬¶øÇÒÔÚ´«ËÍÖÐ²»ÄÜ¸Ä±ä¡£
¡ñ        CONFIDENTIAL£¬ÕâÒâÎ¶×Å´«ÊäµÄÊý¾Ý±ØÐëÊÇ¼ÓÃÜµÄÊý¾Ý¡£
ÔÚ´ó¶àÊýÇé¿öÏÂ£¬°²È«Ì×½Ó×Ö²ã(SSL)ÓÃÓÚINTEGRAL»òCONFIDENTIAL¡£
19. login-configÔªËØ
login-configÔªËØÓÃÀ´Ö¸¶¨ËùÊ¹ÓÃµÄÑéÖ¤·½·¨¡¢ÁìÓòÃûºÍ±íµ¥ÑéÖ¤»úÖÆËùÐèµÄÌØÐÔ¡£
<!ELEMENT login-config (auth-method?, realm-name?,
form-login-config?)>
<!ELEMENT auth-method (#PCDATA)>
<!ELEMENT realm-name (#PCDATA)>
<!ELEMENT form-login-config (form-login-page, form-error-page)>
login-config×ÓÔªËØµÄÃèÊöÈçÏÂ£º
¡ñ        auth-methodÖ¸¶¨ÑéÖ¤·½·¨¡£ËüµÄÖµÎªÏÂÃæµÄÒ»¸ö£ºBASIC¡¢DIGEST¡¢FORM»ò CLIENT-CERT
¡ñ        realm-nameÖ¸¶¨HTTP BasicÑéÖ¤ÖÐÊ¹ÓÃµÄÁìÓòÃû¡£
¡ñ        form-login-configÖ¸¶¨»ùÓÚ±íµ¥µÄµÇÂ¼ÖÐÓ¦¸ÃÊ¹ÓÃµÄµÇÂ¼Ò³ÃæºÍ³ö´íÒ³Ãæ¡£Èç¹ûÃ»ÓÐÊ¹ÓÃ»ùÓÚ±íµ¥µÄÑéÖ¤£¬ÔòºöÂÔÕâÐ©ÔªËØ¡£Õâ¸öÔªËØµÄ¶¨ÒåÈçÏÂ£¬ÆäÖÐform-login-pageÓÃÓÚÖ¸¶¨ÏÔÊ¾µÇÂ¼Ò³ÃæµÄ×ÊÔ´Â·¾¶£¬ form-error-pageÔòÓÃÓÚÖ¸¶¨ÓÃ»§µÇÂ¼Ê§°ÜÊ±ÏÔÊ¾³ö´íÒ³ÃæµÄ×ÊÔ´Â·¾¶¡£ÕâÁ½¸öÒ³ÃæÂ·¾¶¶¼±ØÐëÒÔa/¿ªÊ¼£¬²¢ÓëÓ¦ÓÃÄ¿Â¼Ïà¶ÔÓ¦¡£
<!ELEMENT form-login-config (form-login-page, form-error-page)>
<!ELEMENT form-login-page (#PCDATA)>
<!ELEMENT form-error-page (#PCDATA)>
20. security-roleÔªËØ
security-roleÔªËØÖ¸¶¨ÓÃÓÚ°²È«Ô¼ÊøÖÐµÄ°²È«½ÇÉ«µÄÉùÃ÷¡£
<!ELEMENT security-role (description?, role-name)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT role-name (#PCDATA)>
21. env-entryÔªËØ
env-entryÔªËØÓÃÓÚÖ¸¶¨Ó¦ÓÃ»·¾³Èë¿Ú¡£
<!ELEMENT env-entry (description?, env-entry-name, env-entry-value?,
env-entry-type)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT env-entry-name (#PCDATA)>
<!ELEMENT env-entry-value (#PCDATA)>
<!ELEMENT env-entry-type (#PCDATA)>
env-entry-nameÔªËØ°üº¬WebÓ¦ÓÃ»·¾³Èë¿ÚµÄÃû³Æ¡£¸ÃÃû³ÆÊÇÒ»¸öÓëjava:comp/envÏà¶ÔÓ¦µÄJNDIÃû³Æ£¬²¢ÇÒÔÚÕû¸öÓ¦ÓÃÖÐ±ØÐëÊÇÎ©Ò»µÄ¡£
env-entry-valueÔªËØ°üº¬WebÓ¦ÓÃ»·¾³Èë¿ÚµÄÖµ¡£¸ÃÖµ±ØÐëÊÇÒ»¸ö×Ö·û´®ÀàÐÍµÄÖµ£¬²¢ÇÒ¶ÔÓÚÖ¸¶¨ÀàÐÍµÄ¹¹Ôìº¯ÊýÊÇÓÐÐ§µÄ£¬¸Ãº¯Êý»ñµÃÒ»¸öString²ÎÊý£»»òÕß¶ÔÓÚjava.lang.CharacterÊÇÓÐÐ§µÄ£¬java.lang.Character¶ÔÏóÊÇÒ»¸ö×Ö·û¡£
env-entry-typeÔªËØ°üº¬»·¾³Èë¿ÚÖµµÄÍêÈ«ÏÞ¶¨µÄJavaÀàÐÍ£¬¸Ã»·¾³Èë¿ÚÖµÊÇWebÓ¦ÓÃ´úÂëËùÆÚÍûµÄ¡£Õâ¸öenv-entry-typeÔªËØµÄÖµ±ØÐëÊÇÈçÏÂÖ®Ò»£º
java.lang.Boolean
java.lang.Byte
java.lang.Character
java.lang.String
java.lang.Short
java.lang.Integer
java.lang.Long
java.lang.Float
java.lang.Double
22. ejb-refÔªËØ
ejb-refÔªËØÓÃÓÚÖ¸¶¨EJBµÄhome½Ó¿ÚµÄÒýÓÃ¡£
<!ELEMENT ejb-ref (description?, ejb-ref-name, ejb-ref-type, home,
remote, ejb-link?)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT ejb-ref-name (#PCDATA)>
<!ELEMENT ejb-ref-type (#PCDATA)>
<!ELEMENT home (#PCDATA)>
<!ELEMENT remote (#PCDATA)>
<!ELEMENT ejb-link (#PCDATA)>
ejb-ref-name°üº¬EJBÒýÓÃµÄÃû³Æ¡£EJBÒýÓÃÊÇservlet»·¾³ÖÐµÄÒ»¸öÈë¿Ú£¬ËüÓëjava:comp/envÏà¶ÔÓ¦¡£Õâ¸öÃû³ÆÔÚWebÓ¦ÓÃÖÐ±ØÐëÊÇÎ©Ò»µÄ¡£ÎªÇóÒ»ÖÂÐÔ£¬ÍÆ¼öÄúµÄejb-ref-nameÔªËØÃû³ÆÒÔejb/¿ªÊ¼¡£
ejb-ref-nameÔªËØ°üº¬ÒýÓÃµÄEJBµÄÆÚÍûÀàÐÍ¡£Õâ¸öÖµ±ØÐëÊÇEntity»òSession¡£
homeÔªËØ°üº¬EJBµÄhome½Ó¿ÚµÄÍêÈ«ÏÞ¶¨µÄÃû³Æ¡£remoteÔªËØ°üº¬EJBµÄremote½Ó¿ÚµÄÍêÈ«ÏÞ¶¨µÄÃû³Æ¡£
ejb-ref»òejb-local-refÔªËØÖÐÓÃµ½µÄejb-linkÔªËØ¿ÉÖ¸¶¨EJB ÒýÓÃ±»Á´½Óµ½ÁíÒ»¸öEJB¡£Ejb-linkÔªËØµÄÖµ±ØÐëÊÇÍ¬Ò»¸öJ2EEÓ¦ÓÃµ¥ÔªÖÐÄ³¸öEJBµÄejb-name¡£Ejb-linkÔªËØÖÐµÄÃû³Æ¿ÉÒÔÓÉÖ¸¶¨ejb-jarµÄÂ·¾¶Ãû×é³É£¬¸Ãejb-jar°üº¬ÒýÓÃµÄEJB¡£Ä¿±êbeanµÄÃû³ÆÌí¼ÓÔÚºóÃæ£¬ÓÃ×Ö·ûa# ÓëÂ·¾¶Ãû·Ö¸ô¡£Â·¾¶ÃûÓë°üº¬ÒýÓÃEJBµÄWebÓ¦ÓÃµÄWARÏà¶ÔÓ¦¡£Õâ¾ÍÔÊÐíÎÒÃÇÎ©Ò»±êÊ¶¾ßÓÐÏàÍ¬ejb-nameµÄ¶à¸öÆóÒµbean¡£
23. ejb-local-refÔªËØ
ejb-local-refÔªËØÓÃÓÚÉùÃ÷¶ÔEJBµÄ±¾µØhomeµÄÒýÓÃ¡£
<!ELEMENT ejb-local-ref (description?, ejb-ref-name, ejb-ref-type,
local-home, local, ejb-link?)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT ejb-ref-name (#PCDATA)>
<!ELEMENT ejb-ref-type (#PCDATA)>
<!ELEMENT local-home (#PCDATA)>
<!ELEMENT local (#PCDATA)>
<!ELEMENT ejb-link (#PCDATA)>
localÔªËØ°üº¬EJB±¾µØ½Ó¿ÚµÄÍêÈ«ÏÞ¶¨µÄÃû³Æ¡£Local-homeÔªËØ°üº¬EJB±¾µØhome½Ó¿ÚµÄÍêÈ«ÏÞ¶¨µÄÃû³Æ¡£

