from xml.sax.saxutils import quoteattr

ip, timestamp, request, status, bytes, referrer, agent = range(7)

def log_fields(line):
    start, stop = 0, 0
    while line[stop] <> " ": stop += 1
    ip = line[start:stop]
    start = stop
    while line[start] <> "[": start += 1
    stop = start+1
    while line[stop] <> "]": stop += 1
    timestamp = line[start+1:stop]
    start = stop+1
    while line[start] <> '"': start += 1
    stop = start+1
    while line[stop] <> '"': stop += 1
    request = line[start+1:stop]
    start, stop = stop, stop+1
    while line[stop] <> '"': stop +=1
    status, bytes = line[start+1:stop].split()
    stop += 1
    start = stop
    while line[stop] <> '"': stop += 1
    referrer = line[start:stop]
    agent = line[stop:].strip(' "\n\r')
    vals = [ip, timestamp, request, status, bytes, referrer, agent]
    return tuple(map(quoteattr, vals))
 
hit_tag = '''
<hit 
  ip=%s 
  timestamp=%s 
  request=%s 
  status=%s 
  bytes=%s 
  referrer=%s
  agent=%s/>'''
 
TOP = '''<html>
  <head>
    <title>Weblog Refresher</title>
    <META HTTP-EQUIV="Refresh" CONTENT="30" /></head>
  <body>
  <table border="0" cellspacing="0" width="100%">
  <tr bgcolor="yellow">
    <th align="left">Referrer</th><th/>
    <th align="left">Resource</th>
  </tr>'''
ROW = '<tr bgcolor="%s"><td>%s</td><td>-&gt;</td><td>%s</td></tr>'
END = '</table></body></html>'
COLOR = ['white','lightgray']

