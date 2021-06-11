from time import sleep

from random import Random

def random_str(randomlength=8):
    str = ''
    chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz0123456789'
    length = len(chars) - 1
    random = Random()
    for i in range(randomlength):
        str+=chars[random.randint(0, length)]
    return str

d = dict()
for i in range(10):
    d[random_str()] = random_str()

for k, v in d.items():
    print("set", k, v)

for k in d:
    print("get", k)

print("shutdown")
