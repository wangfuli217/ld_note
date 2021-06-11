local json = require "cjson"

local function format_table(t)
  local str = ''
  for k, v in pairs(t) do
    str = str .. k .. '==' .. v .. '\r\n'
  end
  return str
end

local tb = {
  ["a"] = 1,
  ["b"] = 2,
  ["c"] = "hello"
}

print(format_table(tb))

-- 将json转换成lua table
local str_json = '{"key":"this is key", "value":"this is value", "num":1}'

local t = json.decode(str_json)

print(format_table(t))

-- ngx.say(format_table(t))
