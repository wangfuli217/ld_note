-------------------------------------------------------------------- source.chain
input = source.chain(source.file(io.stdin), normalize("\r\n")) 
output = sink.file(io.stdout) 
pump(input, output)

function filter.cycle(low, ctx, extra)
  return function(chunk)
    local ret
    ret, ctx = low(ctx, chunk, extra)
    return ret
  end
end

function normalize(marker)
  return cycle(eol, 0, marker)
end


#define candidate(c) (c == CR || c == LF)
static int process(int c, int last, const char *marker, luaL_Buffer *buffer) {
    if (candidate(c)) {
        if (candidate(last)) {
            if (c == last) luaL_addstring(buffer, marker);
            return 0;
        } else {
            luaL_addstring(buffer, marker);
            return c;
        }
    } else {
        luaL_putchar(buffer, c);
        return 0;
    }
}

static int eol(lua_State *L) {
    int ctx = luaL_checkint(L, 1);
    size_t isize = 0;
    const char *input = luaL_optlstring(L, 2, NULL, &isize);
    const char *last = input + isize;
    const char *marker = luaL_optstring(L, 3, CRLF);
    luaL_Buffer buffer;
    luaL_buffinit(L, &buffer);
    if (!input) {
       lua_pushnil(L);
       lua_pushnumber(L, 0);
       return 2;
    }
    while (input < last)
        ctx = process(*input++, ctx, marker, &buffer);
    luaL_pushresult(&buffer);
    lua_pushnumber(L, ctx);
    return 2;
}

-------------------------------------------------------------------- filter.chain
local function chain2(f1, f2)
  return function(chunk)
    local ret = f2(f1(chunk))
    if chunk then return ret    -- 连续事件；起始和中间状态
    else return ret .. f2() end -- 结尾事件；情况f2函数中缓冲数据，告知f2函数获取数据结束
  end
end

function filter.chain(...)
  local f = arg[1]
  for i = 2, table.getn(arg) do
    f = chain2(f, arg[i])
  end
  return f
end

local chain = filter.chain(normalize("\r\n"), encode("quoted-printable"))
while 1 do
  local chunk = io.read(2048)
  io.write(chain(chunk))
  if not chunk then break end
end

-------------------------------------------------------------------- Sources
local process = normalize("\r\n")
for chunk in source.file(io.stdin) do
  io.write(process(chunk))
end
io.write(process(nil))

-------------------------------------------------------------------- Maintaining state between calls
function source.cat(...)
  local co = coroutine.create(function()
    local i = 1
    while i <= table.getn(arg) do
      local chunk, err = arg[i]()
      if chunk then coroutine.yield(chunk)
      elseif err then return nil, err 
      else i = i + 1 end 
    end
  end)
  return function()
    return shift(coroutine.resume(co))
  end
end

-------------------------------------------------------------------- Chaining Sources
function source.chain(src, f)
      return source.simplify(function()
        local chunk, err = src()
        if not chunk then return f(nil), source.empty(err)
        else return f(chunk) end
      end)
    end

local load = source.chain(source.file(io.stdin), normalize("\r\n"))
local store, t = sink.table()
while 1 do
  local chunk = load()

  store(chunk)
  if not chunk then break end
end
print(table.concat(t))

function sink.chain(f, snk)
  return function(chunk, err)
    local r, e = snk(f(chunk))
    if not r then return nil, e end
    if not chunk then return snk(nil, err) end
    return 1
  end
end

-------------------------------------------------------------------- Pumps
local load = source.chain(
  source.file(io.open("input.bin", "rb")), 
  encode("base64")
)
local store = sink.chain(
  wrap(76),
  sink.file(io.open("output.b64", "w")), 
)
pump.all(load, store)

-------------------------------------------------------------------- Total
-- Simple sources
function source()
  -- we have data
  return chunk

  -- we have an error
  return nil, err

  -- no more data
  return nil
end

-- Simple sinks
function(chunk, src_err)
  if chunk == nil then
    -- no more data to process, we won't receive more chunks
    if src_err then
      -- source reports an error, TBD what to do with chunk received up to now
    else
      -- do something with concatenation of chunks, all went well
    end
    return true -- or anything that evaluates to true
  elseif chunk == "" then
     -- this is assumed to be without effect on the sink, but may
     --   not be if something different than raw text is processed

     -- do nothing and return true to keep filters happy
     return true -- or anything that evaluates to true
  else 
     -- chunk has data, process/store it as appropriate
     return true -- or anything that evaluates to true
  end

  -- in case of error
  return nil, err
end

-- Pumps
ret, err = pump.step(source, sink)
if ret == 1 then
  -- all ok, continue pumping
elseif err then
  -- an error occured in the sink or source. If in both, the sink
  -- error is lost.
else -- ret == nil and err == nil
  -- done, nothing left to pump
end

ret, err = pump.all(source, sink)
if ret == 1 then
  -- all OK, done
elseif err then
  -- an error occured
else
  -- impossible
end

-- Filters not expanding data

function filter(chunk)
  -- first two cases are to maintain chaining logic that
  -- support expanding filters (see below)
  if chunk == nil then
    return nil
  elseif chunk == "" then
    return ""
  else
    -- process chunk and return filtered data
    return data
  end
end

-- Fancy sources
-- The idea of fancy sources is to enable a source to indicate which other source contains the data from now on.

function source()
  -- we have data
  return chunk

  -- we have an error
  return nil, err

  -- no more data
  return nil, nil

  -- no more data in current source, but use sourceB from now on
  -- ("" could be real data, but should not be nil or false)
  return "", sourceB
end

-- Transforming a fancy source in a simple one:

simple = source.simplify(fancy)

-- Fancy sinks

-- The idea of fancy sinks is to enable a sink to indicate which other sink processes the data from now on.

function(chunk, src_err)
    -- same as above (simple sink), except next sinkK sink
    -- to use indicated after true

    return true, sinkK
end

-- Transforming a fancy sink in a simple one:

simple = sink.simplify(fancy)

-- Filters expanding data

function filter(chunk)
  if chunk == nil then
    -- end of data. If some expanded data is still to be returned
    return partial_data

    -- the chains will keep on calling the filter to get all of
    -- the partial data until the filter return nil
    return nil
  elseif chunk == "" then
    -- a previous filter may have finished returning expanded
    -- data, now it's our turn to expand the data and return it
    return partial_data

    -- the chains will keep on calling the filter to get all of
    -- the partial data until the filter return ""
    return ""
  else
    -- process chunk and return filtered data, potentially partial.
    -- In all cases, the filter is called again with "" (see above)
    return partial_data
  end
end
