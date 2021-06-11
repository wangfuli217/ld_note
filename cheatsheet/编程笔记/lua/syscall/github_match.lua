for _, file in ipairs(arg) do 
  for line in io.lines(file) do
    github = string.match(line, 'github.com/[%w]-/[%w]-')
    print(github)
  end
end