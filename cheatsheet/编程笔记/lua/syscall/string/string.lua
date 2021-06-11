-- 1. 创建字符串
-- 2. 连接字符串
-- 3. 获取字符串长度

--[[
  Unicode
  string.reverse、string.byte、string.char、string.upper、string.lower不支持UTF-8编码格式的string型变量
  string.format、string.rep可以支持UTF-8编码格式的string型变量(除了"%c"操作外)，
  string.len、string.sub同样支持UTF-8编码格式的string型变量。
  在模式匹配函数中，对UTF-8的支持程度决定于模式串的格式，字母组成的模式串是无问题的，字符类和字符组只支持ASCII格式的字符。
--]]
