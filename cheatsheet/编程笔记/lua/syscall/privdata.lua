#!/usr/local/bin/lua

for _, file in ipairs(arg) do
  local voidstr = "void *"
  local pos = 0
  for line in io.lines(file) do
    vstart, vend, substr = string.find(line, voidstr, 1, true)
    pos = pos + 1
    if vstart ~= nil then
        mstr = string.match(line:sub(vend,-1), "[()]")
        blankstr = line:sub(1,vstart-1)
        blankstr = string.match(blankstr, "%S")
        if blankstr == nil and mstr == nil then
          estart, eend, substr = string.find(line, "%;", 1, true)
          print(file, "[".. pos .."]", line)
        end
    end
  end
end