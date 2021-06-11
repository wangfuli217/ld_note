local tab1 = os.date("*t") --返回一个描述当前日期和时间的表
local ans1 = "{"
--把tab1转换成一个字符串
for k, v in pairs(tab1) do
    ans1 = string.format("%s %s = %s,", ans1, k, tostring(v))
end

ans1 = ans1 .. "}"
print("tab1 = ", ans1)


local tab2 = os.date("*t", 360) --返回一个描述日期和时间数为360秒的表
local ans2 = "{"
--把tab2转换成一个字符串
for k, v in pairs(tab2) do
    ans2 = string.format("%s %s = %s,", ans2, k, tostring(v))
end

ans2 = ans2 .. "}"
print("tab2 = ", ans2)

print(os.date("today is %A, in %B"))
print(os.date("now is %x %X"))
