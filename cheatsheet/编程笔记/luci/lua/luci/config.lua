-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Licensed to the public under the Apache License 2.0.

local util = require "luci.util"
module("luci.config",  -- 如果luci.config存在则返回自身内容，否则返回luci.model.uci.cursor()中get_all获得内容
		function(m)
			if pcall(require, "luci.model.uci") then
				local config = util.threadlocal()
				setmetatable(m, {
					__index = function(tbl, key) -- 变量不再情况下的，变量默认值
						if not config[key] then
							config[key] = luci.model.uci.cursor():get_all("luci", key)
						end
						return config[key]
					end
				})
			end
		end)
