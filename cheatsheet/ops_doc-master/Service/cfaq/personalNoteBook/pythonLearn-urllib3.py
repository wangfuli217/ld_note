#http://httpbin.org/ , provide HTTP Request & Response Service
#everyone could use this URL to test urllib3 API usage.
#help(urllib3.ProxyManager) to know the API


import certifi  #for https
import urllib3


def request(url, useProxy):
    
    if useProxy:
        client = urllib3.ProxyManager(proxy_url = 'https://xx.xx.xx.xx:port',
                                      cert_reqs = 'CERT_REQUIRED',
                                      ca_certs  = certifi.where()
                                      )
    else:
        client = urllib3.PoolManager(cert_reqs = 'CERT_REQUIRED',
                                     ca_certs  = certifi.where()
                                     )
        
    try:
        response = client.request('GET',
                          url,
                          retries = False,
                          timeout = 10.0)
        
    except urllib3.exceptions.NewConnectionError:
        print('connection failed')

    return response;



if __name__ == '__main__':
    
    r = request('https://www.baidu.com', useProxy = False)            
    print(r.status, '\n', r.headers,'\n')
    
    if r.status  in {200:'OK', 302:'redirection'} : 
        print('\n connect ok. \n')
    else:        
        print('\n connect error, status = ', r.status)
        
    
        
/////////////////////////////////////////output:
200 
 HTTPHeaderDict({'Accept-Ranges': 'bytes', 'Cache-Control': 'no-cache', 'Connection': 'Keep-Alive', 'Content-Length': '14722', 
                 'Content-Type': 'text/html', 'Date': 'Fri, 09 Feb 2018 14:17:20 GMT', 'Last-Modified': 'Tue, 06 Feb 2018 08:39:00 GMT', 
                 'P3p': 'CP=" OTI DSP COR IVA OUR IND COM "', 'Pragma': 'no-cache', 'Server': 'BWS/1.1', 'Set-Cookie': 'BAIDUID=15729A2C518F95F7C49E031E2D4E8CC3:FG=1; expires=Thu, 31-Dec-37 23:55:55 GMT; 
                 max-age=2147483647; path=/; domain=.baidu.com, BIDUPSID=15729A2C518F95F7C49E031E2D4E8CC3; expires=Thu, 31-Dec-37 23:55:55 GMT; max-age=2147483647; path=/; 
                 domain=.baidu.com, PSTM=1518185840; expires=Thu, 31-Dec-37 23:55:55 GMT; max-age=2147483647; path=/; domain=.baidu.com', 'Vary': 'Accept-Encoding', 'X-Ua-Compatible': 'IE=Edge,chrome=1'}) 


 connect ok. 
