local function table_is_empty(t)
    return next(t) == nil
end

local function table_is_array(t)
    if type(t) ~= "table" then
        return false
    end
    local i = 0
    for _ in pairs(t) do
        i = i + 1
        if t[i] == nil then
            return false
        end
    end
    return true
end

local function table_is_map(t)
    if type(t) ~= "table" then
        return false
    end
    for k, _ in pairs(t) do
        if type(k) == "number" then
            return false
        end
    end
    return true
end
