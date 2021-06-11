-- lint.lua - A lua linter.
--
-- Warning: In a work in progress.  Not currently well tested.
--
-- This relies on Metalua 0.2 ( http://metalua.luaforge.net/ )
-- libraries (but doesn't need to run under Metalua).
-- The metalua parsing is a bit slow, but does the job well.
--
-- Usage:
--   lua lint.lua myfile.lua
--
-- Features:
--   - Outputs list of undefined variables used.
--     (note: this works well for locals, but globals requires
--      some guessing)
--   - TODO: add other lint stuff.
--
-- David Manura, 2007-03
-- Licensed under the same terms as Lua itself.

-- Capture default list of globals.
local globals = {}; for k,v in pairs(_G) do globals[k] = "global" end

-- Metalua imports
require "mlp_stat"
require "mstd"  --debug
require "disp"  --debug

local filename = assert(arg[1])

-- Load source.
local fh = assert(io.open(filename))
local source = fh:read("*a")
fh:close()

-- Convert source to AST (syntax tree).
local c = mlp.block(mll.new(source))

--Display AST.
--print(tostringv(c))
--print(disp.ast(c))
--print("---")
--for k,v in pairs(c) do print(k,disp.ast(v)) end

-- Helper function: Parse current node in AST recursively.
function traverse(ast, scope, level)
  level = level or 1
  scope = scope or {}

  local blockrecurse

  if ast.tag == "Local" or ast.tag == "Localrec" then
    local vnames, vvalues = ast[1], ast[2]
    for i,v in ipairs(vnames) do
      assert(v.tag == "Id")
      local vname = v[1]
      --print(level, "deflocal",v[1])
      local parentscope = getmetatable(scope).__index
      parentscope[vname] = "local"
    end
    blockrecurse = 1
  elseif ast.tag == "Id" then
    local vname = ast[1]
    --print(level, "ref", vname, scope[vname])
    if not scope[vname] then
      print(string.format("undefined %s at line %d", vname, ast.line))
    end
  elseif ast.tag == "Function" then
    local params = ast[1]
    local body = ast[2]
    for i,v in ipairs(params) do
      local vname = v[1]
      assert(v.tag == "Id" or v.tag == "Dots")
      if v.tag == "Id" then
        scope[vname] = "local"
      end
    end
    blockrecurse = 1
  elseif ast.tag == "Let" then
    local vnames, vvalues = ast[1], ast[2]
    for i,v in ipairs(vnames) do
      local vname = v[1]
      local parentscope = getmetatable(scope).__index
      parentscope[vname] = "global" -- note: imperfect
    end
    blockrecurse = 1
  elseif ast.tag == "Fornum" then
    local vname = ast[1][1]
    scope[vname] = "local"
    blockrecurse = 1
  elseif ast.tag == "Forin" then
    local vnames = ast[1]
    for i,v in ipairs(vnames) do
      local vname = v[1]
      scope[vname] = "local"
    end
    blockrecurse = 1
  end

  -- recurse (depth-first search through AST)
  for i,v in ipairs(ast) do
    if i ~= blockrecurse and type(v) == "table" then
      local scope = setmetatable({}, {__index = scope})
      traverse(v, scope, level+1)
    end
  end
end

-- Default list of defined variables.
local scope = setmetatable({}, {__index = globals})

traverse(c, scope) -- Start check.