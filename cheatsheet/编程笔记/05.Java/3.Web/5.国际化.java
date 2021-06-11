
一、jsp页面上直接调用国际化文件的内容
    1.在目录 “com/xinlab/blueapple/prop/” 下配置几个国际化文件
        CustomStrings.properties        // 默认情况下用
        CustomStrings_zh.properties     // 中文
        CustomStrings_es.properties

    2.配置文件里面写入内容(“#”开头的行表示注释,其余用“=”分隔 key/value)
        # Error message
        ErrorCode.UNKNOWN_ERROR=Sorry, we can not activate the service now. Please try again later.

    3.jsp页面上的调用
        //<!-- 下面这行,引入国际化文件,注意路径和文件名 -->
        <fmt:setBundle basename="com.xinlab.blueapple.prop.CustomStrings" var="CustomStrings"/>
        //<!-- 下面引用国际化内容, bundle 的值对应上面 var 的值, key 的值对应国际化配置文件里面的 key -->
        <div style="color: red;"><fmt:message key='ErrorCode.UNKNOWN_ERROR' bundle='${CustomStrings}'/></div>
        //<!-- key 的值还可以动态写, 这里是根据 request 参数来获取 -->
        <div style="color: red;"><fmt:message key='ErrorCode.${param.ErrorCode}' bundle='${CustomStrings}'/></div>

    4.java文件里的调用
        // 引入国际化文件,注意路径和文件名
        try {
            java.util.ResourceBundle res = java.util.ResourceBundle.getBundle("com.xinlab.blueapple.prop.CustomStrings");
            // 查询出国际化文件里面对应的 key 的值
            String errorMsg = res.getString("ErrorCode.UNKNOWN_ERROR");
            System.out.println(errorMsg); // 打印出国际化的内容
        } catch(java.util.MissingResourceException me) { // 属于 RuntimeException, 可以不捕获, 但最好处理一下
        }

    5.手动更改国际化的区域
        java.util.Locale zhLoc=new java.util.Locale("zh","CN"); // 设成中文
        java.util.ResourceBundle res = java.util.ResourceBundle.getBundle("com.xinlab.blueapple.prop.CustomStrings", zhLoc);
        System.out.println(res.getString("ErrorCode.ERROR"));


