-- string 
print('"abc" < "def"', "abc" < "def")
print('"abc" > "def"', "abc" > "def")
print('"abc" == "abc"', "abc" == "abc")
print('"abc" == "a".."bc"', "abc" == "a".."bc")

-- table self and other type
print('{} == "table"', {} == "table")
print('{} == {}', {} == {}) -- two different tables are created here
t = {}
t2 = t
print("t == t2", t == t2) -- we're referencing the same table here

-- string and number
print('"10" == 10', "10" == 10)
print('tonumber("10") == 10', tonumber("10") == 10)
