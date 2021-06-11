local dir = require "dir"

for fname in dir.open(".") do
    print(fname)
end


-- lxp
local count = 0
callback = {
    StartElement = function (parse, tagname)
        io.write("+ ", string.rep(" ", count), tagname, "\n")
    end,

    EndElement = function (parser, tagname)
        count = count - 1
        io.write("- ", string.rep(" ", count), tagname, "\n")
    end,
}

local lxp = require "lxp"
p = lxp.new(callback)
for l in io.lines() do
    assert(p:parse(l))
    assert(p:parse("\n"))
end
assert(p:parse())
p:close()