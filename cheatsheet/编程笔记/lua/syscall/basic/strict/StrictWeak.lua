require('Strict')
-- The so-called 'weak' mode is the default after require'ing Strict
-- 'Weak' means globals have to be initialised in the main part of a
-- program before they can be used (similar to strict.lua)
-- So z, below, is correctly initialised, whereas y is not
function test1()
	local e
	print(z)      -- z has been initialised, so OK
	e=os.exit     -- os.exit exists, so OK
	e=string.exit -- not there, error
end
function test2()
	y=9  -- if y wasn't initialised in main part, this is an error
	print(y)
end
z=0
print(pcall(test1))
-- y=1
print(pcall(test2))
y=2 -- initialise and be happy
print(pcall(test2))