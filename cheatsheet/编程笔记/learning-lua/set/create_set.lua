--reserved = {
--    ["while"] = true,
--    ["end"] = true,
--    ["function"] = true,
--    ["local"] = true,
--}

function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

reserved = Set { "while", "end", "function", "local", }

for k, v in pairs(reserved) do
    print(k, "->", v)
end
