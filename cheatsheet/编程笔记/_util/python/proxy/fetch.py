#! /usr/bin/env python
# coding=utf-8
#############################################################################
#                                                                           #
#   File: fetch.py                                                          #
#                                                                           #
#   Copyright (C) 2008-2010 Du XiaoGang <dugang.2008@gmail.com>             #
#                                                                           #
#   Home: http://gappproxy.googlecode.com                                   #
#                                                                           #
#   This file is part of GAppProxy.                                         #
#                                                                           #
#   GAppProxy is free software: you can redistribute it and/or modify       #
#   it under the terms of the GNU General Public License as                 #
#   published by the Free Software Foundation, either version 3 of the      #
#   License, or (at your option) any later version.                         #
#                                                                           #
#   GAppProxy is distributed in the hope that it will be useful,            #
#   but WITHOUT ANY WARRANTY; without even the implied warranty of          #
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the           #
#   GNU General Public License for more details.                            #
#                                                                           #
#   You should have received a copy of the GNU General Public License       #
#   along with GAppProxy.  If not, see <http://www.gnu.org/licenses/>.      #
#                                                                           #
#############################################################################

import wsgiref.handlers, urlparse, StringIO, logging, base64, zlib, re
from google.appengine.ext import webapp
from google.appengine.api import urlfetch
from google.appengine.api import urlfetch_errors

class MainHandler(webapp.RequestHandler):
    Software = "GAppProxy/2.0.0"
    # hop to hop header should not be forwarded
    H2H_Headers = ["connection", "keep-alive", "proxy-authenticate", "proxy-authorization", "te", "trailers", "transfer-encoding", "upgrade"]
    Forbid_Headers = ["if-range"]
    Fetch_Max = 3

    def sendErrorPage(self, status, description):
        self.response.headers["Content-Type"] = "application/octet-stream"
        # http over http
        # header
        self.response.out.write("HTTP/1.1 %d %s\r\n" % (status, description))
        self.response.out.write("Server: %s\r\n" % self.Software)
        self.response.out.write("Content-Type: text/html\r\n")
        self.response.out.write("\r\n")
        # body
        content = "<h1>Fetch Server Error</h1><p>Error Code: %d<p>Message: %s" % (status, description)
        self.response.out.write(zlib.compress(content))

    def post(self):
        try:
            # get post data
            orig_method = self.request.get("method").encode("utf-8")
            orig_path = base64.b64decode(self.request.get("encoded_path").encode("utf-8"))
            orig_headers = base64.b64decode(self.request.get("headers").encode("utf-8"))
            orig_post_data = base64.b64decode(self.request.get("postdata").encode("utf-8"))

            # check method
            if orig_method != "GET" and orig_method != "HEAD" and orig_method != "POST":
                # forbid
                self.sendErrorPage(590, "Invalid local proxy, Method not allowed.")
                return
            if orig_method == "GET":
                method = urlfetch.GET
            elif orig_method == "HEAD":
                method = urlfetch.HEAD
            elif orig_method == "POST":
                method = urlfetch.POST

            # check path
            (scm, netloc, path, params, query, _) = urlparse.urlparse(orig_path)
            if (scm.lower() != "http" and scm.lower() != "https") or not netloc:
                self.sendErrorPage(590, "Invalid local proxy, Unsupported Scheme.")
                return
            # create new path
            new_path = urlparse.urlunparse((scm, netloc, path, params, query, ""))

            # make new headers
            new_headers = {}
            content_length = 0
            si = StringIO.StringIO(orig_headers)
            while True:
                line = si.readline()
                line = line.strip()
                if line == "":
                    break
                # parse line
                (name, _, value) = line.partition(":")
                name = name.strip()
                value = value.strip()
                nl = name.lower()
                if nl in self.H2H_Headers or nl in self.Forbid_Headers:
                    # don't forward
                    continue
                new_headers[name] = value
                if name.lower() == "content-length":
                    content_length = int(value)
            # predined header
            new_headers["Connection"] = "close"

            # check post data
            if content_length != 0:
                if content_length != len(orig_post_data):
                    logging.warning("Invalid local proxy, Wrong length of post data, %d!=%d." % (content_length, len(orig_post_data)))
                    #self.sendErrorPage(590, "Invalid local proxy, Wrong length of post data, %d!=%d." % (content_length, len(orig_post_data)))
                    #return
            else:
                orig_post_data = ""
            if orig_post_data != "" and orig_method != "POST":
                self.sendErrorPage(590, "Invalid local proxy, Inconsistent method and data.")
                return
        except Exception, e:
            self.sendErrorPage(591, "Fetch server error, %s." % str(e))
            return

        # fetch, try * times
        range_request = False
        for i in range(self.Fetch_Max):
            try:
                # the last time, try with Range
                if i == self.Fetch_Max - 1 and method == urlfetch.GET and not new_headers.has_key("Range"):
                    range_request = True
                    new_headers["Range"] = "bytes=0-65535"
                # fetch
                resp = urlfetch.fetch(new_path, orig_post_data, method, new_headers, False, False)
                # ok, got
                if range_request:
                    range_supported = False
                    for h in resp.headers:
                        if h.lower() == "accept-ranges":
                            if resp.headers[h].strip().lower() == "bytes":
                                range_supported = True
                                break
                        elif h.lower() == "content-range":
                            range_supported = True
                            break
                    if range_supported:
                        self.sendErrorPage(592, "Fetch server error, Retry with range header.")
                    else:
                        self.sendErrorPage(591, "Fetch server error, Sorry, file size up to Google's limit and the target server doesn't accept Range request.")
                    return
                break
            except Exception, e:
                logging.warning("urlfetch.fetch(%s) error: %s." % (range_request and "Range" or "", str(e)))
        else:
            self.sendErrorPage(591, "Fetch server error, The target server may be down or not exist. Another possibility: try to request the URL directly.")
            return

        # forward
        self.response.headers["Content-Type"] = "application/octet-stream"
        # status line
        self.response.out.write("HTTP/1.1 %d %s\r\n" % (resp.status_code, self.response.http_status_message(resp.status_code)))
        # headers
        # default Content-Type is text
        text_content = True
        for header in resp.headers:
            if header.strip().lower() in self.H2H_Headers:
                # don"t forward
                continue
            # there may have some problems on multi-cookie process in urlfetch.
            # Set-Cookie: "wordpress=lovelywcm%7C1248344625%7C26c45bab991dcd0b1f3bce6ae6c78c92; expires=Thu, 23-Jul-2009 10:23:45 GMT; path=/wp-content/plugins; domain=.wordpress.com; httponly, wordpress=lovelywcm%7C1248344625%7C26c45bab991dcd0b1f3bce6ae6c78c92; expires=Thu, 23-Jul-2009 10:23:45 GMT; path=/wp-content/plugins; domain=.wordpress.com; httponly,wordpress=lovelywcm%7C1248344625%7C26c45bab991dcd0b1f3bce6ae6c78c92; expires=Thu, 23-Jul-2009 10:23:45 GMT; path=/wp-content/plugins; domain=.wordpress.com; httponly
            if header.lower() == "set-cookie":
                scs = resp.headers[header].split(",")
                nsc = ""
                for sc in scs:
                    if nsc == "":
                        nsc = sc
                    elif re.match(r"[ \t]*[0-9]", sc):
                        # expires 2nd part
                        nsc += "," + sc
                    else:
                        # new one
                        self.response.out.write("%s: %s\r\n" % (header, nsc.strip()))
                        nsc = sc
                self.response.out.write("%s: %s\r\n" % (header, nsc.strip()))
                continue
            # other
            self.response.out.write("%s: %s\r\n" % (header, resp.headers[header]))
            # check Content-Type
            if header.lower() == "content-type":
                if resp.headers[header].lower().find("text") == -1:
                    # not text
                    text_content = False
        self.response.out.write("\r\n")
        # only compress when Content-Type is text/xxx
        if text_content:
            self.response.out.write(zlib.compress(resp.content))
        else:
            self.response.out.write(resp.content)

    def get(self):
        self.response.headers["Content-Type"] = "text/html; charset=utf-8"
        self.response.out.write( \
"""
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>GAppProxy已经在工作了</title>
    </head>
    <body>
        <table width="800" border="0" align="center">
            <tr><td align="center"><hr></td></tr>
            <tr><td align="center">
                <b><h1>%s 已经在工作了</h1></b>
            </td></tr>
            <tr><td align="center"><hr></td></tr>

            <tr><td align="center">
                GAppProxy是一个开源的HTTP Proxy软件,使用Python编写,运行于Google App Engine平台上. 
            </td></tr>
            <tr><td align="center"><hr></td></tr>

            <tr><td align="center">
                更多相关介绍,请参考<a href="http://gappproxy.googlecode.com/">GAppProxy项目主页</a>. 
            </td></tr>
            <tr><td align="center"><hr></td></tr>

            <tr><td align="center">
                <img src="http://code.google.com/appengine/images/appengine-silver-120x30.gif" alt="Powered by Google App Engine" />
            </td></tr>
            <tr><td align="center"><hr></td></tr>
        </table>
    </body>
</html>
""" % self.Software)

def main():
    application = webapp.WSGIApplication([("/fetch.py", MainHandler)])
    wsgiref.handlers.CGIHandler().run(application)

if __name__ == "__main__":
    main()
