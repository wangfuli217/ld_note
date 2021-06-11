print(string.find("abc cba", "ab"))
print(string.find("abc cba", "ab", 2)) --从索引为2的位置开始匹配字符串：ab
print(string.find("abc cba", "ba", -1)) --从索引为7的位置开始匹配字符串：ba
print(string.find("abc cba", "ba", -3)) --从索引为6的位置开始匹配字符串：ba
print(string.find("abc cba", "(%a+)", 1)) --从索引为1处匹配最长连续且只含字母的字符串
print(string.find("abc cba", "(%a+)", 1, true)) --从索引为1的位置开始匹配字符串：(%a+)
