redis.call("HINCRBY", "console.20180811.orders", "10", 1)
redis.call("HINCRBY", "console.20180811.orders", "total", 1)
redis.call("EXPIRE", "console.20180811.orders", 172800)
redis.call("INCRBY", "console.daily.orders:20180811", 1)
redis.call("INCRBY", "console.total.orders", 1)
redis.call("EXPIRE", "console.daily.orders:20180811", 2592000)
local ls = KEYS
local rs = {}
local t
for i = 1, #ls do
    local ret = {}
    string.gsub(
        ls[i],
        "(%d+)%=(%d+)",
        function(c, b)
            ret[c] = b
        end
    )
    t = ret
    for m, n in pairs(ret) do
        rs[m] = n
        redis.call("HINCRBY", "console.20180811.sales:10", m, n)
        redis.call("HINCRBY", "console.20180811.sales:10", "total", n)
        redis.call("HINCRBY", "console.daily.sales:20180811", m, n)
        redis.call("HINCRBY", "console.daily.sales:20180811", "total", n)
        redis.call("HINCRBY", "console.total.sales", m, n)
        redis.call("HINCRBY", "console.total.sales", "total", n)
    end
end
redis.call("EXPIRE", "console.20180811.sales:10:10", 86400)
redis.call("EXPIRE", "console.daily.sales:20180811", 2592000)
redis.call("HINCRBY", "console.20180811.turnovers", "10", 236.0)
redis.call("HINCRBY", "console.20180811.turnovers", "total", 236.0)
redis.call("EXPIRE", "console.20180811.turnovers", 172800)
redis.call("INCRBY", "console.daily.turnovers:20180811", 236.0)
redis.call("INCRBY", "console.total.turnovers", 236.0)
redis.call("EXPIRE", "console.daily.turnovers:20180811", 2592000)
local horders = redis.call("HGET", "console.20180811.orders", "10")
local dorders = redis.call("GET", "console.daily.orders:20180811")
local torders = redis.call("GET", "console.total.orders")
local hturnovers = redis.call("HGET", "console.20180811.turnovers", "10")
local dturnovers = redis.call("GET", "console.daily.turnovers:20180811")
local tturnovers = redis.call("GET", "console.total.turnovers")
local hvisitors = redis.call("HGET", "console.20180811.visitors", "10")
local dvisitors = redis.call("GET", "console.daily.visitors:20180811")
local tvisitors = redis.call("GET", "console.total.visitors")
local hsales = redis.call("HGET", "console.20180811.sales:10", "total")
local dsales = redis.call("HGET", "console.daily.sales:20180811", "total")
local tsales = redis.call("HGET", "console.total.sales", "total")
local havg = 0
local davg = 0
local tavg = 0
horders = tonumber(horders)
dorders = tonumber(dorders)
hturnovers = tonumber(hturnovers)
dturnovers = tonumber(dturnovers)
tturnovers = tonumber(tturnovers)
torders = tonumber(torders)
if type(horders) == "number" and horders > 0 and type(hturnovers) == "number" and hturnovers > 0 then
    havg = hturnovers / horders
end
if type(dorders) == "number" and dorders > 0 and type(dturnovers) == "number" and dturnovers > 0 then
    davg = dturnovers / dorders
end
if type(torders) == "number" and torders > 0 and type(tturnovers) == "number" and tturnovers > 0 then
    tavg = tturnovers / torders
end
redis.call("HSET", "console.20180811.avg", "10", havg)
redis.call("EXPIRE", "console.20180811.avg", 172800)
redis.call("HSET", "console.20180811.avg", "total", davg)
redis.call("SET", "console.daily.avg:20180811", davg)
redis.call("SET", "console.total.avg", tavg)
redis.call("EXPIRE", "console.daily.avg:20180811", 2592000)
local ex_orders = redis.call("EXISTS", "console.max.orders")
if ex_orders == 0 then
    redis.call("HSET", "console.max.orders", "max", 0)
    redis.call("HSET", "console.max.orders", "maxtime", 1533916800)
    redis.call("HSET", "console.max.orders", "day", dorders)
    redis.call("HSET", "console.max.orders", "daytime", 1533916800)
else
    local max_orders = redis.call("HGET", "console.max.orders", "max")
    local max_orders_time = redis.call("HGET", "console.max.orders", "maxtime")
    local day_orders = redis.call("HGET", "console.max.orders", "day")
    local day_orders_time = redis.call("HGET", "console.max.orders", "daytime")
    if tonumber(day_orders_time) ~= 1533916800 and tonumber(max_orders) < tonumber(day_orders) then
        redis.call("HSET", "console.max.orders", "max", day_orders)
        redis.call("HSET", "console.max.orders", "maxtime", day_orders_time)
    end
end
redis.call("HSET", "console.max.orders", "day", dorders)
redis.call("HSET", "console.max.orders", "daytime", 1533916800)
local ex_turnovers = redis.call("EXISTS", "console.max.turnovers")
if ex_turnovers == 0 then
    redis.call("HSET", "console.max.turnovers", "max", 0)
    redis.call("HSET", "console.max.turnovers", "maxtime", 1533916800)
    redis.call("HSET", "console.max.turnovers", "day", dturnovers)
    redis.call("HSET", "console.max.turnovers", "daytime", 1533916800)
else
    local max_turnovers = redis.call("HGET", "console.max.turnovers", "max")
    local max_turnovers_time = redis.call("HGET", "console.max.turnovers", "maxtime")
    local day_turnovers = redis.call("HGET", "console.max.turnovers", "day")
    local day_turnovers_time = redis.call("HGET", "console.max.turnovers", "daytime")
    if tonumber(day_turnovers_time) ~= 1533916800 and tonumber(max_turnovers) < tonumber(day_turnovers) then
        redis.call("HSET", "console.max.turnovers", "max", day_turnovers)
        redis.call("HSET", "console.max.turnovers", "maxtime", day_turnovers_time)
    end
end
redis.call("HSET", "console.max.turnovers", "day", dturnovers)
redis.call("HSET", "console.max.turnovers", "daytime", 1533916800)
local ex_sales = redis.call("EXISTS", "console.max.sales")
if ex_sales == 0 then
    redis.call("HSET", "console.max.sales", "max", 0)
    redis.call("HSET", "console.max.sales", "maxtime", 1533916800)
    redis.call("HSET", "console.max.sales", "day", dsales)
    redis.call("HSET", "console.max.sales", "daytime", 1533916800)
else
    local max_sales = redis.call("HGET", "console.max.sales", "max")
    local max_sales_time = redis.call("HGET", "console.max.sales", "maxtime")
    local day_sales = redis.call("HGET", "console.max.sales", "day")
    local day_sales_time = redis.call("HGET", "console.max.sales", "daytime")
    if tonumber(day_sales_time) ~= 1533916800 and tonumber(max_sales) < tonumber(day_sales) then
        redis.call("HSET", "console.max.sales", "max", day_sales)
        redis.call("HSET", "console.max.sales", "maxtime", day_sales_time)
    end
end
redis.call("HSET", "console.max.sales", "day", dsales)
redis.call("HSET", "console.max.sales", "daytime", 1533916800)
local ex_avg = redis.call("EXISTS", "console.max.avg")
if ex_avg == 0 then
    redis.call("HSET", "console.max.avg", "max", 0)
    redis.call("HSET", "console.max.avg", "maxtime", 1533916800)
    redis.call("HSET", "console.max.avg", "day", davg)
    redis.call("HSET", "console.max.avg", "daytime", 1533916800)
else
    local max_avg = redis.call("HGET", "console.max.avg", "max")
    local max_avg_time = redis.call("HGET", "console.max.avg", "maxtime")
    local day_avg = redis.call("HGET", "console.max.avg", "day")
    local day_avg_time = redis.call("HGET", "console.max.avg", "daytime")
    if tonumber(day_avg_time) ~= 1533916800 and tonumber(max_avg) < tonumber(day_avg) then
        redis.call("HSET", "console.max.avg", "max", day_avg)
        redis.call("HSET", "console.max.avg", "maxtime", day_avg_time)
    end
end
redis.call("HSET", "console.max.avg", "day", davg)
redis.call("HSET", "console.max.avg", "daytime", 1533916800)
local hrate = 0
local drate = 0
local trate = 0
hvisitors = tonumber(hvisitors)
dvisitors = tonumber(dvisitors)
if type(horders) == "number" and horders > 0 and type(hvisitors) == "number" and hvisitors > 0 then
    hrate = horders / hvisitors
end
if type(dorders) == "number" and dorders > 0 and type(dvisitors) == "number" and dvisitors > 0 then
    drate = dorders / dvisitors
end
redis.call("HSET", "console.20180811.rate", "10", hrate)
redis.call("HSET", "console.20180811.rate", "total", drate)
redis.call("EXPIRE", "console.20180811.rate", 172800)
redis.call("SET", "console.daily.rate:20180811", drate)
redis.call("EXPIRE", "console.daily.rate:20180811", 2592000)
tvisitors = tonumber(tvisitors)
torders = tonumber(torders)
local trate = 0
if type(torders) == "number" and torders > 0 and type(tvisitors) == "number" and tvisitors > 0 then
    trate = torders / tvisitors
end
redis.call("SET", "console.total.rate", trate)
local ex_rate = redis.call("EXISTS", "console.max.rate")
if ex_rate == 0 then
    redis.call("HSET", "console.max.rate", "max", 0)
    redis.call("HSET", "console.max.rate", "maxtime", 1533916800)
    redis.call("HSET", "console.max.rate", "day", drate)
    redis.call("HSET", "console.max.rate", "daytime", 1533916800)
else
    local max_rate = redis.call("HGET", "console.max.rate", "max")
    local max_rate_time = redis.call("HGET", "console.max.rate", "maxtime")
    local day_rate = redis.call("HGET", "console.max.rate", "day")
    local day_rate_time = redis.call("HGET", "console.max.rate", "daytime")
    if tonumber(day_rate_time) ~= 1533916800 and tonumber(max_rate) < tonumber(day_rate) then
        redis.call("HSET", "console.max.rate", "max", day_rate)
        redis.call("HSET", "console.max.rate", "maxtime", day_rate_time)
    end
end
redis.call("HSET", "console.max.rate", "day", drate)
redis.call("HSET", "console.max.rate", "daytime", 1533916800)

--> return ls

local ks = {"a", "b"}
local ls = KEYS
local rs = {}
local js = redis.call("keys", "store*")
for i = 1, #js do
    rs[i] = js[i]
end
return #ls[1]