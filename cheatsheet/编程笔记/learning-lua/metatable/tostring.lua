arr = { 1, 2, 3, 4 }
arr = setmetatable(arr, {
    __tostring = function(self)
        local result = '{'
        local sep = ''
        for _, i in pairs(self) do
            result = result .. sep .. i
            sep = ', '
        end
        result = result .. '}'
        return result
    end
})
print(arr) --> {1, 2, 3, 4}
