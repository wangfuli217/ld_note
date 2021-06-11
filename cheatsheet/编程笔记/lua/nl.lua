local count = 1

while true do
    local line = io.read()
    if line == nil then break end
    io.write(string.format("%6d  ", count), line, "\n")
    count = count + 1
end

