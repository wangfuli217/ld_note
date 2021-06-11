-- And the sandbox example rewritten for 5.1:

local sandbox_env = {
  print = print,
}

local chunk = loadstring("print('inside sandbox'); os.execute('echo unsafe')")
setfenv(chunk, sandbox_env)

chunk() -- prevents os.execute from being called, instead raises an error saying that os is nil