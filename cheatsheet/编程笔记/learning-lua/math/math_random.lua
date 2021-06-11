math.randomseed(100) --把种子设置为100
print(math.random()) -->output  0.0012512588885159
print(math.random(100)) -->output  57
print(math.random(100, 360)) -->output  150

math.randomseed(os.time()) --把100换成os.time()
print(math.random()) -->output 0.88369396038697
print(math.random(100)) -->output 66
print(math.random(100, 360)) -->output 228