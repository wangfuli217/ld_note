local _M = {}

function _M:hello(str)
    print('hello', str)
end

function _M.world(str)
    print('world', str)
end

return _M
