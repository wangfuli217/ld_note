����������ʵ������һ��XML�ļ��������˺ܶ�����servlet/JSPӦ�õĸ��������Ԫ�أ���servletע�ᡢservletӳ���Լ�������ע�ᡣ�����������������XMLͷ��ʼ��
<?xml version="1.0" encoding="ISO-8859-1"?>
���ͷָ����XML�İ汾���Լ���ʹ�õı��롣ͷ��������DOCTYPE������
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
��δ���ָ���ļ����Ͷ���(DTD)������ͨ�������XML�ĵ�����Ч�ԡ�������ʾ��<!DOCTYPE>Ԫ���м������ԣ���Щ���Ը������ǹ���DTD����Ϣ��
��        web-app������ĵ�(����������������DTD�ļ�)�ĸ�Ԫ��
��        PUBLIC��ζ��DTD�ļ����Ա�����ʹ��
��       "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"��ζ��DTD��Sun Microsystems, Inc.   
           ά��������ϢҲ��ʾ���������ĵ�������DTD Web Application 2.3������DTD����Ӣ����д�ġ�
��        URL"http://java.sun.com/dtd/web-app_2_3.dtd"��ʾD�ļ���λ�á�
ע�⣺
�ڲ����������У� <!--��-->����ע�͡�
�����������ĸ�Ԫ����web-app��DTD�ļ��涨��web-appԪ�ص���Ԫ�ص��﷨���£�
<!ELEMENT web-app (icon?, display-name?, description?,
distributable?, context-param*, filter*, filter-mapping*,
listener*, servlet*, servlet-mapping*, session-config?,
mime-mapping*, welcome-file-list?,
error-page*, taglib*, resource-env-ref*, resource-ref*,
security-constraint*, login-config?, security-role*,env-entry*,
ejb-ref*, ejb-local-ref*)>
�������������ģ����Ԫ�غ���23����Ԫ�أ�������Ԫ�ض��ǿ�ѡ�ġ��ʺ�(��)��ʾ��Ԫ���ǿ�ѡ�ģ�����ֻ�ܳ���һ�Ρ��Ǻ�(*)��ʾ��Ԫ�ؿ��ڲ����������г�����λ��Ρ���Щ��Ԫ�ػ������������Լ�����Ԫ�ء�

web.xml�ļ���web-appԪ��������������ÿ����Ԫ�ص�������������½ڽ��������������п��ܰ�����������Ԫ�ء�
ע�⣺
��Servlet 2.3�У���Ԫ�ر��밴��DTD�ļ��﷨������ָ����˳����֡����磬��������������е�web-appԪ����servlet��servlet-mapping������Ԫ�أ���servlet��Ԫ�ر��������servlet-mapping��Ԫ��֮ǰ����Servlet 2.4�У�˳�򲢲���Ҫ��
�����web.xml�ļ���Ԫ�ؽ������
1. iconԪ��
iconԪ������ָ��GIF��ʽ��JPEG��ʽ��Сͼ��(16��16)���ͼ��(32��32)���ļ�����
<!ELEMENT icon (small-icon?, large-icon?)>
<!ELEMENT small-icon (#PCDATA)>
<!ELEMENT large-icon (#PCDATA)>
iconԪ�ذ���������ѡ����Ԫ�أ�small-icon��Ԫ�غ�large-icon��Ԫ�ء��ļ�����WebӦ�ù鵵�ļ�(WAR)�ĸ������·����
������������û��ʹ��iconԪ�ء����ǣ����ʹ��XML���߱༭������������XML�༭������ʹ��iconԪ�ء�
2. display-nameԪ��
���ʹ�ù��߱༭������������display-nameԪ�ذ����ľ���XML�༭����ʾ�����ơ�
<!ELEMENT display-name (#PCDATA)>
������һ������display-nameԪ�صĲ�����������
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<display-name>Online Store Application</display-name>
</web-app>
3. descriptionԪ��
����ʹ��descriptionԪ�����ṩ�йز�������������Ϣ��XML�༭������ʹ��descriptionԪ�ص�ֵ��
<!ELEMENT description (#PCDATA)>
4. distributableԪ��
����ʹ��distributableԪ��������servlet/JSP��������д���ڷֲ�ʽWeb�����в����Ӧ�ã�
<!ELEMENT distributable EMPTY>
���磬������һ������distributableԪ�صĲ��������������ӣ�
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<distributable/>
</web-app>
5. context-paramԪ��
context-paramԪ�غ���һ�Բ������Ͳ���ֵ������Ӧ�õ�servlet�����ĳ�ʼ��������������������WebӦ���б�����Ωһ�ġ�
<!ELEMENT context-param (param-name, param-value, description?)>
<!ELEMENT param-name (#PCDATA)>
<!ELEMENT param-value (#PCDATA)>
<!ELEMENT description (#PCDATA)>
param-name ��Ԫ�ذ����в���������param-value��Ԫ�ذ������ǲ���ֵ����Ϊѡ�񣬿���description��Ԫ��������������
������һ������context-paramԪ�ص���Ч������������
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
6. filterԪ��
filterԪ������ָ��Web�����еĹ����������������Ӧ����servlet����֮ǰ��֮�󣬿���ʹ�ù�������������������в�����������һ�ڽ��ܵ�filter-mappingԪ�أ���������ӳ�䵽һ��servlet��һ��URLģʽ�������������filterԪ�غ�filter-mappingԪ�ر��������ͬ�����ơ�
<!ELEMENT filter (icon?, filter-name, display-name?, description?,
filter-class, init-param*)>
<!ELEMENT filter-name (#PCDATA)>
<!ELEMENT filter-class (#PCDATA)>
icon��display-name��descriptionԪ�ص��÷�����һ�ڽ��ܵ��÷���ͬ��init-paramԪ����context-paramԪ�ؾ�����ͬ��Ԫ����������filter-nameԪ��������������������ƣ�������������Ӧ���ж�������Ωһ�ġ�filter-classԪ��ָ�������������ȫ�޶������ơ�
������һ��ʹ��filterԪ�صĲ��������������ӣ�
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
7. filter-mappingԪ��
filter-mappingԪ����������WebӦ���еĹ�����ӳ�䡣�������ɱ�ӳ�䵽һ��servlet��һ��URLģʽ����������ӳ�䵽һ��servlet�л���ɹ�����������servlet�ϡ���������ӳ�䵽һ��URLģʽ������Խ�������Ӧ�����κ���Դ��ֻҪ����Դ��URL��URLģʽƥ�䡣�����ǰ��ղ�����������filter-mappingԪ�س��ֵ�˳��ִ�еġ�
<!ELEMENT filter-mapping (filter-name, (url-pattern | servlet-name))>
<!ELEMENT filter-name (#PCDATA)>
<!ELEMENT url-pattern (#PCDATA)>
<!ELEMENT servlet-name (#PCDATA)>
filter-nameֵ�����ӦfilterԪ��������������һ�����������ơ�������һ������filter-mappingԪ�صĲ�����������
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
8. listenerԪ��
listenerԪ������ע��һ���������࣬������WebӦ���а������ࡣʹ��listenerԪ�أ������յ��¼�ʲôʱ�����Լ���ʲô��Ϊ��Ӧ��֪ͨ��
<!ELEMENT listener (listener-class)>
<!ELEMENT listener-class (#PCDATA)>
������һ������listenerԪ�ص���Ч������������
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<listener>
<listener-class>MyAppListener</listener-class>
</listener>
</web-app>
9. servletԪ��
servletԪ����������һ��servlet��
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
icon��display-name��descriptionԪ�ص��÷�����һ�ڽ��ܵ��÷���ͬ��init-paramԪ����context-paramԪ�ؾ�����ͬ��Ԫ��������������ʹ��init-param��Ԫ�ؽ���ʼ���������Ͳ���ֵ���ݸ�servlet��
(1) servlet-name��servlet-class��jsp-fileԪ��
servletԪ�ر��뺬��servlet-nameԪ�غ�servlet-classԪ�أ�����servlet-nameԪ�غ�jsp-fileԪ�ء��������£�
��        servlet-nameԪ����������servlet�����ƣ�������������Ӧ���б�����Ωһ�ġ�
��        servlet-classԪ������ָ��servlet����ȫ�޶������ơ�
��        jsp-fileԪ������ָ��Ӧ����JSP�ļ�������·�����������·��������a/��ʼ��
(2) load-on-startupԪ��
������Web����ʱ����load-on-startupԪ���Զ���servlet�����ڴ档����servlet����ζ��ʵ�������servlet������������init����������ʹ�����Ԫ���������һ��servlet�������Ӧ��Ϊservlet�����ڴ������µ��κ��ӳ١����load-on-startupԪ�ش��ڣ�����Ҳָ����jsp-fileԪ�أ���JSP�ļ��ᱻ���±����servlet��ͬʱ������servletҲ�������ڴ档
load-on-startupԪ�ص����ݿ���Ϊ�գ�������һ�����������ֵ��ʾ��Web���������ڴ��˳�򡣾ٸ����ӣ����������servletԪ�ض�����load-on-startup��Ԫ�أ���load-on-startup��Ԫ��ֵ��С��servlet���ȱ����ء����load-on-startup��Ԫ��ֵΪ�ջ�ֵ������Web��������ʲôʱ�����servlet���������servlet��load-on-startup��Ԫ��ֵ��ͬ������Web���������ȼ�����һ��servlet��
(3) run-asԪ��
���������run-asԪ�أ�������д���ڵ���WebӦ����servlet���趨��Enterprise JavaBean(EJB)�İ�ȫ��ݡ�Role-name��Ϊ��ǰWebӦ�ö����һ����ȫ��ɫ�����ơ�
(4) security-role-refԪ��
security-role-refԪ�ض���һ��ӳ�䣬��ӳ����servlet����isUserInRole (String name)���õĽ�ɫ����ΪWebӦ�ö���İ�ȫ��ɫ��֮����С�security-role-refԪ�ص��������£�
<!ELEMENT security-role-ref (description?, role-name, role-link)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT role-name (#PCDATA)>
<!ELEMENT role-link (#PCDATA)>
role-linkԪ����������ȫ��ɫ�������ӵ��Ѷ���İ�ȫ��ɫ��role-linkԪ�ر��뺬���Ѿ���security-roleԪ���ж����һ����ȫ��ɫ�����ơ�
(5) Faces Servlet��servletԪ��
�� JSFӦ���У���ҪΪFaces Servlet����һ��servletԪ�أ�������ʾ��
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
10. seervlet-mapping Ԫ��
seervlet-mapping Ԫ�ؽ�URLģʽӳ�䵽ĳ��servlet��
<!ELEMENT servlet-mapping (servlet-name, url-pattern)>
<!ELEMENT servlet-name (#PCDATA)>
<!ELEMENT url-pattern (#PCDATA)>
��ǰ��ġ�servletԪ�ء�һ�����Ѿ�������ʹ��servlet-mappingԪ�ص����ӡ�
11. session-configԪ��
session-configԪ��ΪWebӦ���е�javax.servlet.http.HttpSession�����������
<!ELEMENT session-config (session-timeout?)>
<!ELEMENT session-timeout (#PCDATA)>
session-timeoutԪ������ָ��Ĭ�ϵĻỰ��ʱʱ�������Է���Ϊ��λ����Ԫ��ֵ����Ϊ���������session-timeoutԪ�ص�ֵΪ����������ʾ�Ự����Զ���ᳬʱ��
������һ�����������������û��������HttpSession����30���Ӻ�HttpSession����Ĭ��Ϊ��Ч��
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE web-app
PUBLIC "-//Sun Microsystems, Inc.//DTD Web Application 2.3//EN"
"http://java.sun.com/dtd/web-app_2_3.dtd">
<web-app>
<session-config>
<session-timeout>30</session-timeout>
</session-config>
</web-app>
12. mime-mappingԪ��
mime-mappingԪ�ؽ�mime����ӳ�䵽��չ����
<!ELEMENT mime-mapping (extension, mime-type)>
<!ELEMENT extension (#PCDATA)>
<!ELEMENT mime-type (#PCDATA)>
extensionԪ������������չ����mime-typeԪ����ΪMIME���͡�
�ٸ����ӣ�����Ĳ�������������չ��txtӳ��Ϊtext/plain��
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
13. welcome-file-listԪ��
���û���������������URL������ĳ��servlet����JSPҳ��ʱ��welcome-file-listԪ�ؿ�ָ����ʾ��Ĭ���ļ���
<!ELEMENT welcome-file-list (welcome-file+)>
<!ELEMENT welcome-file (#PCDATA)>
�ٸ�����˵���������û���������ĵ�ַ��������http://www.mycompany.com/appName/�ȵ�ַ�������WebӦ�õĲ�����������ָ��welcome-file-listԪ�أ��û��ͻῴ��һ��Ȩ�޴�����Ϣ��������Ӧ��Ŀ¼�µ��ļ���Ŀ¼�б����������welcome-file-listԪ�أ��û����ܿ����ɸ�Ԫ��ָ���ľ����ļ���
welcome-file��Ԫ������ָ��Ĭ���ļ������ơ�welcome-file-listԪ�ؿ��԰���һ������welcome-file��Ԫ�ء�����ڵ�һ��welcome-fileԪ����û���ҵ�ָ�����ļ���Web�����ͻ᳢����ʾ�ڶ������Դ����ơ�
������һ������welcome-file-listԪ�صĲ�������������Ԫ�ذ�������welcome-fileԪ�أ���һ��ָ��Ӧ��Ŀ¼�е�main.html�ļ����ڶ�������jspĿ¼�µ�welcom.jsp�ļ���jspĿ¼Ҳ��Ӧ��Ŀ¼�¡�
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
����û������URL������servlet���ơ�JSPҳ���������Դ���򲻻���Ӧ��Ŀ¼���ҵ�main.html�ļ�����ʱ�ͻ���ʾjspĿ¼�µ�welcome.jsp�ļ���
14. error-pageԪ��
error-pageԪ�����ڽ�һ�δ�������һ���쳣����ӳ�䵽WebӦ���е���Դ·�����Ӷ��ڲ��������HTTP�����ָ����Java�쳣ʱ������ʾ��ص���Դ��
<!ELEMENT error-page ((error-code | exception-type), location)>
<!ELEMENT error-code (#PCDATA)>
<!ELEMENT exception-type (#PCDATA)>
<!ELEMENT location (#PCDATA)>
error-codeԪ�ذ���HTTP������롣exception-type��Java�쳣���͵���ȫ�޶������ơ�locationԪ����WebӦ���е���Դ�����Ӧ��Ŀ¼��·����location��ֵ�����a/��ʼ��
�ٸ����ӣ�ÿ�β���HTTP 404�������ʱ������Ĳ�����������ʹWeb������ʾerror404.htmlҳ�棺
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
15. taglibԪ��
taglibԪ������JSP���Ʊ�ǿ⡣
<!ELEMENT taglib (taglib-uri, taglib-location)>
<!ELEMENT taglib-uri (#PCDATA)>
<!ELEMENT taglib-location (#PCDATA)>
taglib-uriԪ��������WebӦ���еı�ǿ��URI��taglib-uriԪ�ص�ֵ��WEB-INFĿ¼���Ӧ��
taglib-locationԪ�ذ���һ��λ�ã����п����ҵ���ǿ�ı�ǿ�������(TLD)�ļ���
16. resource-env-refԪ��
����ʹ��resource-env-refԪ����ָ���Թ�������servlet���õ��������ö�����servlet�����е���Դ�������
<!ELEMENT resource-env-ref (description?, resource-env-ref-name,
resource-env-ref-type)>
<!ELEMENT resource-env-ref-name (#PCDATA)>
<!ELEMENT resource-env-ref-type (#PCDATA)>
resource-env-ref-nameԪ������Դ�������õ����ƣ���ֵΪservlet������ʹ�õĻ�����������ơ���������һ����java:comp/env���Ӧ��Java������Ŀ¼�ӿ�(JNDI)���ƣ�������������WebӦ���б�����Ωһ�ġ�
17. resource-refԪ��
resource-refԪ������ָ�����ⲿ��Դ��servlet���õ�������
<!ELEMENT resource-ref (description?, res-ref-name,
res-type, res-auth, res-sharing-scope?)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT res-ref-name (#PCDATA)>
<!ELEMENT res-type (#PCDATA)>
<!ELEMENT res-auth (#PCDATA)>
<!ELEMENT res-sharing-scope (#PCDATA)>
resource-ref��Ԫ�ص��������£�
��        res-ref-name����Դ���������������ơ���������һ����java:comp/env���������Ӧ��JNDI���ƣ�����������WebӦ���б�����Ωһ�ġ�
��        res-auth������servlet����ͨ�����ע�ᵽ��Դ������������������������servletע�ᵽ��Դ����������Ԫ�ص�ֵ����ΪApplication��Container��
��        res-sharing-scope�������Ƿ���Թ���ͨ��������Դ���������ӹ������û�õ����ӡ���Ԫ�ص�ֵ����ΪShareable(Ĭ��ֵ)��Unshareable��
18. security-constraintԪ��
�����������е�security-constraintԪ������ͨ����̾Ϳ������ƶ�ĳ����Դ�ķ��ʡ�
<!ELEMENT security-constraint (display-name?,
web-resource-collection+,
auth-constraint?, user-data-constraint?)>
<!ELEMENT display-name (#PCDATA)>
<!ELEMENT web-resource-collection (web-resource-name, description?,
url-pattern*, http-method*)>
<!ELEMENT auth-constraint (description?, role-name*)>
<!ELEMENT user-data-constraint (description?, transport-guarantee)>
(1) web-resource-collectionԪ��
web-resource-collectionԪ�ر�ʶ��Ҫ���Ʒ��ʵ���Դ�Ӽ�����web-resource-collectionԪ���У����Զ���URLģʽ��HTTP���������������HTTP�������ͽ���ȫԼ��Ӧ�������еķ�����
<!ELEMENT web-resource-collection (web-resource-name, description?,
url-pattern*, http-method*)>
<!ELEMENT web-resource-name (#PCDATA)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT url-pattern (#PCDATA)>
<!ELEMENT http-method (#PCDATA)>
web-resource-name�����ܱ�����Դ����������ơ�http-methodԪ�ؿɱ�����һ��HTTP����������GET��POST��
(2) auth-constraintԪ��
auth-constraintԪ������ָ�����Է��ʸ���Դ���ϵ��û���ɫ�����û��ָ��auth-constraintԪ�أ��ͽ���ȫԼ��Ӧ�������н�ɫ��
<!ELEMENT auth-constraint (description?, role-name*)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT role-name (#PCDATA)>
role-nameԪ�ذ�����ȫ��ɫ�����ơ�
(3) user-data-constraintԪ��
user-data-constraintԪ��������ʾ���������ڿͻ��˺�Web����֮�䴫�ݵ����ݡ�
<!ELEMENT user-data-constraint (description?, transport-guarantee)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT transport-guarantee (#PCDATA)>
transport-guaranteeԪ�ر���������µ�ĳ��ֵ��
��        NONE������ζ��Ӧ�ò���Ҫ���䱣֤��
��        INTEGRAL����ζ�ŷ������Ϳͻ���֮������ݱ�����ĳ�ַ�ʽ���ͣ������ڴ����в��ܸı䡣
��        CONFIDENTIAL������ζ�Ŵ�������ݱ����Ǽ��ܵ����ݡ�
�ڴ��������£���ȫ�׽��ֲ�(SSL)����INTEGRAL��CONFIDENTIAL��
19. login-configԪ��
login-configԪ������ָ����ʹ�õ���֤�������������ͱ���֤������������ԡ�
<!ELEMENT login-config (auth-method?, realm-name?,
form-login-config?)>
<!ELEMENT auth-method (#PCDATA)>
<!ELEMENT realm-name (#PCDATA)>
<!ELEMENT form-login-config (form-login-page, form-error-page)>
login-config��Ԫ�ص��������£�
��        auth-methodָ����֤����������ֵΪ�����һ����BASIC��DIGEST��FORM�� CLIENT-CERT
��        realm-nameָ��HTTP Basic��֤��ʹ�õ���������
��        form-login-configָ�����ڱ��ĵ�¼��Ӧ��ʹ�õĵ�¼ҳ��ͳ���ҳ�档���û��ʹ�û��ڱ�����֤���������ЩԪ�ء����Ԫ�صĶ������£�����form-login-page����ָ����ʾ��¼ҳ�����Դ·���� form-error-page������ָ���û���¼ʧ��ʱ��ʾ����ҳ�����Դ·����������ҳ��·����������a/��ʼ������Ӧ��Ŀ¼���Ӧ��
<!ELEMENT form-login-config (form-login-page, form-error-page)>
<!ELEMENT form-login-page (#PCDATA)>
<!ELEMENT form-error-page (#PCDATA)>
20. security-roleԪ��
security-roleԪ��ָ�����ڰ�ȫԼ���еİ�ȫ��ɫ��������
<!ELEMENT security-role (description?, role-name)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT role-name (#PCDATA)>
21. env-entryԪ��
env-entryԪ������ָ��Ӧ�û�����ڡ�
<!ELEMENT env-entry (description?, env-entry-name, env-entry-value?,
env-entry-type)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT env-entry-name (#PCDATA)>
<!ELEMENT env-entry-value (#PCDATA)>
<!ELEMENT env-entry-type (#PCDATA)>
env-entry-nameԪ�ذ���WebӦ�û�����ڵ����ơ���������һ����java:comp/env���Ӧ��JNDI���ƣ�����������Ӧ���б�����Ωһ�ġ�
env-entry-valueԪ�ذ���WebӦ�û�����ڵ�ֵ����ֵ������һ���ַ������͵�ֵ�����Ҷ���ָ�����͵Ĺ��캯������Ч�ģ��ú������һ��String���������߶���java.lang.Character����Ч�ģ�java.lang.Character������һ���ַ���
env-entry-typeԪ�ذ����������ֵ����ȫ�޶���Java���ͣ��û������ֵ��WebӦ�ô����������ġ����env-entry-typeԪ�ص�ֵ����������֮һ��
java.lang.Boolean
java.lang.Byte
java.lang.Character
java.lang.String
java.lang.Short
java.lang.Integer
java.lang.Long
java.lang.Float
java.lang.Double
22. ejb-refԪ��
ejb-refԪ������ָ��EJB��home�ӿڵ����á�
<!ELEMENT ejb-ref (description?, ejb-ref-name, ejb-ref-type, home,
remote, ejb-link?)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT ejb-ref-name (#PCDATA)>
<!ELEMENT ejb-ref-type (#PCDATA)>
<!ELEMENT home (#PCDATA)>
<!ELEMENT remote (#PCDATA)>
<!ELEMENT ejb-link (#PCDATA)>
ejb-ref-name����EJB���õ����ơ�EJB������servlet�����е�һ����ڣ�����java:comp/env���Ӧ�����������WebӦ���б�����Ωһ�ġ�Ϊ��һ���ԣ��Ƽ�����ejb-ref-nameԪ��������ejb/��ʼ��
ejb-ref-nameԪ�ذ������õ�EJB���������͡����ֵ������Entity��Session��
homeԪ�ذ���EJB��home�ӿڵ���ȫ�޶������ơ�remoteԪ�ذ���EJB��remote�ӿڵ���ȫ�޶������ơ�
ejb-ref��ejb-local-refԪ�����õ���ejb-linkԪ�ؿ�ָ��EJB ���ñ����ӵ���һ��EJB��Ejb-linkԪ�ص�ֵ������ͬһ��J2EEӦ�õ�Ԫ��ĳ��EJB��ejb-name��Ejb-linkԪ���е����ƿ�����ָ��ejb-jar��·������ɣ���ejb-jar�������õ�EJB��Ŀ��bean����������ں��棬���ַ�a# ��·�����ָ���·�������������EJB��WebӦ�õ�WAR���Ӧ�������������Ωһ��ʶ������ͬejb-name�Ķ����ҵbean��
23. ejb-local-refԪ��
ejb-local-refԪ������������EJB�ı���home�����á�
<!ELEMENT ejb-local-ref (description?, ejb-ref-name, ejb-ref-type,
local-home, local, ejb-link?)>
<!ELEMENT description (#PCDATA)>
<!ELEMENT ejb-ref-name (#PCDATA)>
<!ELEMENT ejb-ref-type (#PCDATA)>
<!ELEMENT local-home (#PCDATA)>
<!ELEMENT local (#PCDATA)>
<!ELEMENT ejb-link (#PCDATA)>
localԪ�ذ���EJB���ؽӿڵ���ȫ�޶������ơ�Local-homeԪ�ذ���EJB����home�ӿڵ���ȫ�޶������ơ�

