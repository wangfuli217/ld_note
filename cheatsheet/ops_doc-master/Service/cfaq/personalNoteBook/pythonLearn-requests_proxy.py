#request url with proxy
#refer to: http://docs.python-requests.org/en/master/user/advanced/

import requests

proxies = {
    'http' : '10.144.xx.xx:8080',
    'https': '10.144.xx.xx:8080'
    }

if __name__ == '__main__':         
    r = requests.get("https://github.com/favicon.ico", proxies = proxies)
    with open('github.ico', 'wb') as f:
        f.write(r.content)
    print(r.status_code, '\n',r.headers)        
    print('main ok')
    
    
    
///////////////////////////////////////output:
    200 
 {'Server': 'GitHub.com', 'Date': 'Sun, 11 Feb 2018 02:31:36 GMT', 'Content-Type': 'image/x-icon', 'Content-Length': '6518', 
 'Last-Modified': 'Sat, 10 Feb 2018 20:39:49 GMT', 'ETag': '"5a7f5895-1976"', 'Expires': 'Wed, 09 Feb 2028 02:31:36 GMT', 
 'Cache-Control': 'max-age=315360000', 'Accept-Ranges': 'bytes', 'X-GitHub-Request-Id': 'F85D:3DDD:16B7BFF:24F4893:5A7FAB07', 'X-Frame-Options': 'DENY'}
 
main ok
