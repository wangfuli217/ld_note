
正则表达式
类: java.util.regex.Pattern
  1.典型的调用顺序是
     Pattern p = Pattern.compile("a*b");  // "a*b"是 正则表达式
     Matcher m = p.matcher("aaaaab");     // "aaaaab" 是 需要比较的内容
     boolean b = m.matches();             // 返回比较结果, true / false
  2.在仅使用一次正则表达式时。此方法编译表达式并在单个调用中将输入序列与其匹配。
     boolean b = Pattern.matches("a*b", "aaaaab");
  例: 价格验证, 要求不小于0的小数类型, 为0、正整数、小数时返回true；其它为false。
      如: “0”、“55”、“0.5”、“5,687,657”返回true, 而“.5”、“5.”、“01”返回false
      "^0|([1-9]+\\d*)|([1-9]\\d{0,2}(,\\d{3})+)|([1-9]\\d{0,2}(,\\d{3})+[\\.]\\d+[^0]$)|((0|([1-9]+\\d*))[\\.]\\d+[^0]$)"
       //其实是, 0或者正整数或者带逗号的写法或者小数
