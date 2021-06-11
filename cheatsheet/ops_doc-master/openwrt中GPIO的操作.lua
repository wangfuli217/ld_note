1. Shell中实现, 比如对GPIO 26的操作
echo 26 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio26/direction
echo in > /sys/class/gpio/gpio26/direction
echo 1 > /sys/class/gpio/gpio26/value
cat /sys/class/gpio/gpio26/value


2. LUA中的操作可以直接引用 Ewelina, Rafa, Rafa写的例程
gpio.lua
--@author: Ewelina, Rafa, Rafa
--GPIO utilities

--Writes 'what' to 'where'
function writeToFile (where,what)
    local fileToWrite=io.open(where, 'w')
    fileToWrite:write(what)
    fileToWrite:close()    
end
--Reads a character from file 'where' and returns the string
function readFromFile (where)
    local fileToRead=io.open(where, 'r')
    fileStr = fileToRead:read(1)
    fileToRead:close()    
    return fileStr
end

--Returns true if file exists
function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

--Exports gpio ID to use as an output pin
function configureOutGPIO (id)
    if not file_exists('/sys/class/gpio/gpio'..id..'/direction') then
        writeToFile('/sys/class/gpio/export',id)
    end
    writeToFile('/sys/class/gpio/gpio'..id..'/direction','out')
end

--Exports gpio ID to use as an input pin
function configureInGPIO (id)
    if not file_exists('/sys/class/gpio/gpio'..id..'/direction') then
        writeToFile('/sys/class/gpio/export',id)
    end
    writeToFile('/sys/class/gpio/gpio'..id..'/direction','in')
end

--Reads GPIO 'id' and returns it's value
--@Pre: GPIO 'id' must be exported with configureInGPIO
function readGPIO(id)
    gpioVal = readFromFile('/sys/class/gpio/gpio'..id..'/value')
    return gpioVal
end

--Writes a value to GPIO 'id'
--@Pre: GPIO 'id' must be exported with configureOutGPIO
function writeGPIO(id, val)
    gpioVal = writeToFile('/sys/class/gpio/gpio'..id..'/value)
end
    
    
    
inputtest.lua
-Read the state of the buttons connected to pins 139, 138 and 137 and print it to the console

require ("gpio")

local buttons = {}
buttons[1]=139
buttons[2]=138
buttons[3]=137

for i,v in ipairs(buttons) do
    configureInGPIO (v)
end

while true do
    for i,v in ipairs(buttons) do
        local val = readGPIO(v)
        if val.."" == '1' then
            print ('Button '..i .. ' pressed')
        end
    end
    
end


outputtest.lua
--Read the state of a button and turn on a led connected to a different gpio as follows:
--button 139 turns on led 158
--button 138 turns on led 162
--button 137 turns on led 161

require ("gpio")

local buttons = {}
buttons[1]=139
buttons[2]=138
buttons[3]=137

local leds = {}
leds[1]=158
leds[2]=162
leds[3]=161

for i,v in ipairs(buttons) do
    --configure v as input gpio
    configureInGPIO(v)
end
for i,v in ipairs(leds) do
    --configure v as output gpio
    configureOutGPIO(v)
end

while true do
    for i,v in ipairs(buttons) do
        local val = readGPIO(v)
        if val.."" == '1' then
            print ('button '..i .. ' pressed')
            writeGPIO(leds[i],1)
        else
            writeGPIO(leds[i],0)
        end
    end
    
end