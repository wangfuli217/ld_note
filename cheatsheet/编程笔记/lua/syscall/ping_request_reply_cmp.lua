#!/usr/local/bin/lua

local s2os, s2oe
local o2ss, o2se
local s2ototal = 0
local o2stotal = 0

for _, file in ipairs(arg) do
  for line in io.lines(file) do
    s2os, s2oe = string.find(line, '192.168.1.2 > 192.168.1.8', 1, false)
    if(s2os) then
      s2ototal = s2ototal + 1
    end
      
    o2ss, o2se = string.find(line, '192.168.1.8 > 192.168.1.2', 1, false)
    if(o2ss) then
      o2stotal = o2stotal + 1
      
      if(s2ototal ~= o2stotal) then
        print(line)
        s2ototal = 0
        o2stotal = 0
      end
    end
  end
end

