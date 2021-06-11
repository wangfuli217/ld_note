local curl = require "cURL"

-- HTTP Get
curl.easy()
:setopt_url('http://httpbin.org/get')
:setopt_httpheader{
    "X-Test-Header1: Header-Data1",
    "X-Test-Header2: Header-Data2",
}
:setopt_writefunction(io.stderr) -- use io.stderr:write()
:perform()
:close()
