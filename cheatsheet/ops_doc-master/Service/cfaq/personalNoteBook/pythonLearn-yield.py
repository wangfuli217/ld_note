
def get(url):
    resp = str(url)
    return resp

def gen_from_urls(urls: tuple) ->tuple:
    result = [ (resp[0], resp[1], resp[2]) for resp in [get(url) for url  in urls] ]
    return tuple(result)     


def gen_from_urls2(urls: tuple) ->tuple:
    for resp in (get(url) for url  in urls):
        yield resp[0], resp[1], resp[2] #return 2-D tuple after loop over
  
  

if __name__ == '__main__':
    urls = ('google','baidu')
    for a, b, c in gen_from_urls(urls) :        
        print(a, b, c)
    print()    
    for a, b, c in gen_from_urls2(urls) :        
        print(a, b, c)
        
    
        

    
////////////////////////////output
g o o
b a i

g o o
b a i
