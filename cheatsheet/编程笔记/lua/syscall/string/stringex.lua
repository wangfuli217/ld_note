-- 去除字符串首尾的空格
function trim (s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

-- 将一个字符串中全局变量$varname出现的地方替换为变量varname的值
function expand (s)
    s = string.gsub(s, "$(%w+)", function (n)
       return _G[n]
    end)
    return s
end
name = "Lua"; status = "great"
print(expand("$name is $status, isn't it?"))


function expand (s)
    return (string.gsub(s, "$(%w+)", function (n)
       return tostring(_G[n])
    end))
end

print(expand("print = $print; a = $a"))

-- 收集一个字符串中所有的单词，然后插入到一个表中
words = {}
string.gsub(s, "(%a+)", function (w)
    table.insert(words, w)
end)

-- 收集一个字符串中所有的单词，然后插入到一个表中
words = {}
for w in string.gfind(s, "(%a)") do -- for w in string.gfind(s, "(%a)") do
    table.insert(words, w)
end

-- url code transition 
function unescape (s)
    s = string.gsub(s, "+", " ")
    s = string.gsub(s, "%%(%x%x)", function (h)
       return string.char(tonumber(h, 16))
    end)
    return s
end
print(unescape("a%2Bb+%3D+c")) 

-- url decode
cgi = {}
function decode (s)
    for name, value in string.gfind(s, "([^&=]+)=([^&=]+)") do
       name = unescape(name)
       value = unescape(value)
       cgi[name] = value
    end
end

-- url code transition 
function escape (s)
    s = string.gsub(s, "([&=+%c])", function (c)
       return string.format("%%%02X", string.byte(c))
    end)
    s = string.gsub(s, " ", "+")
    return s
end

-- url encode
function encode (t)
    local s = ""
    for k,v in pairs(t) do
       s = s .. "&" .. escape(k) .. "=" .. escape(v)
    end
    return string.sub(s, 2)     -- remove first `&'
end

-- 另一个对模式匹配而言有用的技术是在进行真正处理之前，对目标串先进行预处理。
function code (s)
    return (string.gsub(s, "\\(.)", function (x)
       return string.format("\\%03d", string.byte(x))
    end))
end

function decode (s)
    return (string.gsub(s, "\\(%d%d%d)", function (d)
       return "\"" .. string.char(d)
    end))
end




