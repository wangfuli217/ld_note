args = {"n","S","l","u","f","L"}
function f1()
    for level = 0, 3 do
    　　-- print("level================", level)
    　　-- for k, v in ipairs(args) do 
    　　-- 　　print("arg======", v)
    　　-- 　　local fInfo = debug.getinfo(level, v)
    　　-- 　　for key, val in pairs(fInfo) do
    　　-- 　　　　print("key, val==", key, val)
    　　-- 　　end
    　　-- end
    end
end

function f2()
　　print("f1=====", f1)
　　f1()
end

function main()
　　print("f2=====", f2)
　　f2()
end
print("main======", main)
main()