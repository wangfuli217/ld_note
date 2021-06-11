local env = require "test_env"

print("")
print("")
print("env:             ", env)           -- table: 0x1f3e5f0
print("test_env:        ", test_env)      -- table: 0x1f3e5f0
print("_G.test_env:     ", _G.test_env)   -- table: 0x1f3e5f0

print("env.local_var            = nil           result:", env.local_var)        -- nil
print("env.global_var           = global_var    result:", env.global_var)       -- global_var 这里的 global_var 其实是 _G.global_var

print("_G.global_var            = global_var    result:", _G.global_var)        -- global_var

print("env.env_local_var        = nil           result:", _G.env_local_var)     -- nil
print("env.env_global_var       = nil           result:", _G.env_global_var)    -- nil

print("test_env.env_local_var   = nil           result:", test_env.env_local_var)   -- nil 这里是 _G.test_env.env_local_var
print("test_env.env_global_var  = env_global_var result:", test_env.env_global_var) -- nil 这里是 _G.test_env.env_local_var  如果test_env.lua中 test_env 变量前面加上 local 这里就不能这么用