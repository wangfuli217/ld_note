--
-- Created by IntelliJ IDEA.
-- User: akagi201
-- Date: 12/4/15
-- Time: 10:26
-- To change this template use File | Settings | File Templates.
--
-- Refs:
-- http://www.cnblogs.com/leezj/p/4230271.html
-- https://coronalabs.com/blog/2014/09/02/tutorial-printing-table-contents/

function print_r(t)
    local print_r_cache = {}
    local function sub_print_r(t, indent)
        if (print_r_cache[tostring(t)]) then
            print(indent .. "*" .. tostring(t))
        else
            print_r_cache[tostring(t)] = true
            if (type(t) == "table") then
                for pos, val in pairs(t) do
                    if (type(val) == "table") then
                        print(indent .. "[" .. pos .. "] => " .. tostring(t) .. " {")
                        sub_print_r(val, indent .. string.rep(" ", string.len(pos) + 8))
                        print(indent .. string.rep(" ", string.len(pos) + 6) .. "}")
                    elseif (type(val) == "string") then
                        print(indent .. "[" .. pos .. '] => "' .. val .. '"')
                    else
                        print(indent .. "[" .. pos .. "] => " .. tostring(val))
                    end
                end
            else
                print(indent .. tostring(t))
            end
        end
    end

    if (type(t) == "table") then
        print(tostring(t) .. " {")
        sub_print_r(t, "  ")
        print("}")
    else
        sub_print_r(t, "  ")
    end
    print()
end

local floor = math.floor
local tb_insert = table.insert

local function slice(st, en, slice_unit)
    if st > en then
        return {}
    end

    local segs = {}

    local left = floor(st / slice_unit) * slice_unit
    local right = left + slice_unit - 1

    repeat
        local s = left
        if s < st then
            s = st
        end

        local e = right
        if e > en then
            e = en
        end

        tb_insert(segs, { st = s, en = e })

        left = left + slice_unit
        right = right + slice_unit
    until left > en

    return segs
end

r = slice(0, 99, 10)

print_r(r)
