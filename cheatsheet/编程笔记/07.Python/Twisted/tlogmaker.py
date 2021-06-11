#!/usr/bin/env python2.2
from webloglib import log_fields, TOP, ROW, END, COLOR
import webloglib as wll
from urllib import unquote_plus as uqp
import os, twisted.internet 

LOG = open('../access-log')
RECS = []
PAGE = 'www/refresher.html'
def update():
    global RECS
    page = open(PAGE+'.tmp','w')
    RECS.extend(LOG.readlines())
    RECS = RECS[-35:]
    print >> page, TOP
    odd = 0
    for rec in RECS:
    hit = [field.strip('"') for field in log_fields(rec)]
        if hit[wll.status]=='200' and hit[wll.referrer]!='-':
        resource = hit[wll.request].split()[1]
            referrer = uqp(hit[wll.referrer]).replace('&amp;',' &')
        print >> page, ROW % (COLOR[odd], referrer, resource)
        odd = not odd
    print >> page, END
    page.close()
    os.rename(PAGE+'.tmp',PAGE) 
    twisted.internet.reactor.callLater(5, update)

update()    
twisted.internet.reactor.run()
from twisted.web import static
resource = static.File("~/rpc/www")
