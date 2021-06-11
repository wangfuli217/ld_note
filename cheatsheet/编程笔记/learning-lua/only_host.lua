local only_host = ''
local m, err = ngx.re.match(host, '^([^:]+)', 'jo');
if m then
    only_host = m[1]
else
    if err then
        ngx.log(ngx.INFO, "Host match error: ", err)
        return ngx.exit(ngx.HTTP_FORBIDDEN)
    end

    ngx.log(ngx.INFO, "Host not match")
end
