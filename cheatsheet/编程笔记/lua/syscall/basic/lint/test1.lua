local really_aborting
local function abort() os.exit(1) end
if not os.getenv("HOME") then
  realy_aborting = true
  abortt()
end