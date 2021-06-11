package guoling;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

//import org.apache.log4j.Logger;

public class HttpUtil {

	/**
	 * 连接超时
	 */
	private static int connectTimeOut = 5000;

	/**
	 * 读取数据超时
	 */
	private static int readTimeOut = 10000;

	/**
	 * 请求编码
	 */
	private static String requestEncoding = "UTF-8";

	/**
	 * 页面返回编码
	 */
	private static String receiveEncoding = "UTF-8";

	//private static Logger logger = Logger.getLogger(HttpTest.class);


	/**
	 * @return 连接超时(毫秒)
	 * @see com.hengpeng.common.web.HttpRequestProxy#connectTimeOut
	 */
	public static int getConnectTimeOut() {
		return HttpUtil.connectTimeOut;
	}

	/**
	 * @return 读取数据超时(毫秒)
	 * @see com.hengpeng.common.web.HttpRequestProxy#readTimeOut
	 */
	public static int getReadTimeOut() {
		return HttpUtil.readTimeOut;
	}

	/**
	 * @return 请求编码
	 * @see com.hengpeng.common.web.HttpRequestProxy#requestEncoding
	 */
	public static String getRequestEncoding() {
		return requestEncoding;
	}

	/**
	 * @param connectTimeOut 连接超时(毫秒)
	 * @see com.hengpeng.common.web.HttpRequestProxy#connectTimeOut
	 */
	public static void setConnectTimeOut(int connectTimeOut) {
		HttpUtil.connectTimeOut = connectTimeOut;
	}

	/**
	 * @param readTimeOut 读取数据超时(毫秒)
	 * @see com.hengpeng.common.web.HttpRequestProxy#readTimeOut
	 */
	public static void setReadTimeOut(int readTimeOut) {
		HttpUtil.readTimeOut = readTimeOut;
	}

	/**
	 * @param requestEncoding 请求编码
	 * @see com.hengpeng.common.web.HttpRequestProxy#requestEncoding
	 */
	public static void setRequestEncoding(String requestEncoding) {
		HttpUtil.requestEncoding = requestEncoding;
	}


	/**
	 *  将 map 类型的参数转成字符串
	 * @param parameters 参数映射表
	 * @return 请求的字符串
	 * @throws UnsupportedEncodingException
	 */
	public static String urlEncode(Map<?, ?> parameters) throws UnsupportedEncodingException {
		StringBuffer params = new StringBuffer();
		if (parameters == null){
			parameters = new HashMap<String, String>();
		}
		for (Iterator<?> iter = parameters.entrySet().iterator(); iter.hasNext();) {
			Entry<?, ?> element = (Entry<?, ?>) iter.next();
			params.append(element.getKey().toString());
			params.append("=");
			Object value = element.getValue();
			if (value == null) {
				value = "";
			}
			params.append(URLEncoder.encode(value.toString(), HttpUtil.requestEncoding).replaceAll("[+]", "%20"));
			params.append("&");
		}

		if (params.length() > 0) {
			params = params.deleteCharAt(params.length() - 1);
		}

		return params.toString();
	}
	
	/**
	 * 获取url里面的参数,以MAP的形式返回
	 * @param url 请求地址
	 * @return 以MAP的形式返回请求里面的参数
	 */
	public static Map<String, String> getRequestParams(String url) throws UnsupportedEncodingException {
	    Map<String, String> parameters = new HashMap<String, String>();
		// 解析请求参数
		int paramIndex = url.indexOf("?");
		if (paramIndex > 0) {
			String paramStr = url.substring(paramIndex + 1, url.length());
			String[] paramArray = paramStr.split("&");
			for (int i = 0; i < paramArray.length; i++) {
				String string = paramArray[i];
				int index = string.indexOf("=");
				if (index > 0) {
					String parameter = string.substring(0, index);
					String value = string.substring(index + 1, string.length());
					value = java.net.URLDecoder.decode(String.valueOf(value), receiveEncoding);
					parameters.put(parameter, value);
				}
			}
		}
		return parameters;
	}

	/**
	 * <pre>
	 * 发送HTTP请求
	 * </pre>
	 *
	 * @param reqUrl HTTP请求URL
	 * @param parameters 参数映射表
	 * @return HTTP响应的字符串
	 */
	private static String deal(String reqUrl, Map<?, ?> parameters, String recvEncoding, boolean isGet) {
		HttpURLConnection url_con = null;
		String responseContent = null;
		try {
			URL url = new URL(reqUrl);
			url_con = (HttpURLConnection) url.openConnection();
			String method = "POST";
			if (isGet) {
				method = "GET";
			}
			url_con.setRequestMethod(method);
			
			//System.setProperty("sun.net.client.defaultConnectTimeout", String.valueOf(HttpUtil.connectTimeOut));// （单位：毫秒）jdk1.4换成这个,连接超时
			//System.setProperty("sun.net.client.defaultReadTimeout", String.valueOf(HttpUtil.readTimeOut)); // （单位：毫秒）jdk1.4换成这个,读操作超时
			// 1.5换成这个,连接超时
			url_con.setConnectTimeout(HttpUtil.connectTimeOut);//（单位：毫秒）jdk
			url_con.setReadTimeout(HttpUtil.readTimeOut);//（单位：毫秒）jdk 1.5换成这个,读操作超时
			
			url_con.setDoOutput(true);
			byte[] b = urlEncode(parameters).getBytes();
			url_con.getOutputStream().write(b, 0, b.length);
			url_con.getOutputStream().flush();
			url_con.getOutputStream().close();

			InputStream in = url_con.getInputStream();
			if (recvEncoding == null || "".equals(recvEncoding)){
				recvEncoding = receiveEncoding;
			}
			BufferedReader rd = new BufferedReader(new InputStreamReader(in, recvEncoding));
			String tempLine = rd.readLine();
			StringBuffer temp = new StringBuffer();
			String crlf = System.getProperty("line.separator");
			while (tempLine != null) {
				temp.append(tempLine);
				temp.append(crlf);
				tempLine = rd.readLine();
			}
			responseContent = temp.toString();
			rd.close();
			in.close();
			// 输出调试信息
            System.out.println(method + "请求:" + reqUrl + "    参数:" + urlEncode(parameters)); ////////////////////////////////////////////
            System.out.println("    返回:" + responseContent); ////////////////////////////////////////////
		}
		catch (IOException e) {
			//logger.error("网络故障", e);
            System.out.println("网络故障:" + e.toString());
		}
		finally {
			if (url_con != null) {
				url_con.disconnect();
			}
		}
		return responseContent;
    }

	/**
	 * <pre>
	 * 发送带参数的GET的HTTP请求
	 * </pre>
	 *
	 * @param reqUrl HTTP请求URL
	 * @param parameters 参数映射表
	 * @return HTTP响应的字符串
	 */
	public static String get(String reqUrl, Map<?, ?> parameters, String recvEncoding) {
        return deal(reqUrl, parameters, recvEncoding, true);
	}

	/**
	 * <pre>
	 * 发送不带参数的GET的HTTP请求
	 * </pre>
	 *
	 * @param reqUrl HTTP请求URL
	 * @param parameters 参数映射表
	 * @return HTTP响应的字符串
	 */
	public static String get(String reqUrl, Map<?, ?> parameters) {
		return get(reqUrl, parameters, null);
	}

	/**
	 * <pre>
	 * 发送不带参数的GET的HTTP请求
	 * </pre>
	 *
	 * @param reqUrl HTTP请求URL
	 * @return HTTP响应的字符串
	 */
	public static String get(String reqUrl) {
		return get(reqUrl, null, null);
	}

	/**
	 * <pre>
	 * 发送带参数的POST的HTTP请求
	 * </pre>
	 *
	 * @param reqUrl HTTP请求URL
	 * @param parameters 参数映射表
	 * @return HTTP响应的字符串
	 */
	public static String post(String reqUrl, Map<?, ?> parameters, String recvEncoding) {
        return deal(reqUrl, parameters, recvEncoding, false);
	}

	/**
	 * <pre>
	 * 发送带参数的POST的HTTP请求
	 * </pre>
	 *
	 * @param reqUrl HTTP请求URL
	 * @param parameters 参数映射表
	 * @return HTTP响应的字符串
	 */
	public static String post(String reqUrl, Map<String, String> parameters) {
		return post(reqUrl, parameters, null);
	}

	//public static void test_main(String[] args) {
	public static void main(String[] args) {
		String get_temp = get("http://172.16.12.62:1314/version?a=aaa");
		System.out.println("GET返回的消息是:" + get_temp);

		// post
		Map<String, String> map = new HashMap<String, String>();
		map.put("userId", "320");
		map.put("name", "哈哈");
		String temp = post("http://172.16.12.62:1314/version", map);
		System.out.println("返回的消息是:" + temp);
	}

}
