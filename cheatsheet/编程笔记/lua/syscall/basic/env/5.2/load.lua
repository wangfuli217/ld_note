local sandbox_env = {
  print = print,
}

local chunk = load("print('inside sandbox'); os.execute('echo unsafe')", "sandbox string", "bt", sandbox_env)

chunk() -- prevents os.execute from being called, instead raises an error saying that os is nil
