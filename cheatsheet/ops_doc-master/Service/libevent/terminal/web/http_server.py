#!/usr/bin/env python
#coding:utf-8

import os.path

import tornado.httpserver
import tornado.ioloop
import tornado.options
import tornado.web
import socket
import struct
import json
from conf import terminal_servers_conf
from tornado.options import define, options
define("port", default=8000, help="run on the given port", type=int)

class ControlHandler(tornado.web.RequestHandler):
    def command(self):
        address = (self.host, self.port)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        timeout_usecs = 1500000
        s.settimeout(timeout_usecs / 1000000.0)
        success = {'err_code': 0, 'msg' : 'success'}
        fail = {'err_code': 1, 'msg' : 'fail'}
        try:
            s.connect(address)
            head = self.command_line + '\r\n'
            ret = s.send(head)
            if ret != len(head) :
                s.close()
                return json.dumps(fail)
            #recv response
            data = s.recv(4096)
            s.close()
            if len(data) <= 0:
                fail["msg"] = "receive error"
                return json.dumps(fail)

            if head.startswith('close'):
                if data.startswith('CLOSED'):
                    return json.dumps(success)
                else:
                    fail["msg"] = data
                    return json.dumps(fail)
            elif head.startswith('open'):
                if data.startswith('OPENED'):
                    return json.dumps(success)
                else:
                    fail["msg"] = data
                    return json.dumps(fail)
            elif head.startswith('append'):
                if data.startswith('OPENED'):
                    return json.dumps(success)
                else:
                    fail["msg"] = data
                    return json.dumps(fail)
            else:
                fail["msg"] = "command error"
                return json.dumps(fail)
        except Exception, e:
            fail["msg"] = str(e)
            return json.dumps(fail)

    def post(self):
        self.host = self.get_argument("host")
        self.port = int(self.get_argument("port"))
        self.command_line = self.get_argument("command")

        ret = self.command()
        self.write(ret)

class IndexHandler(tornado.web.RequestHandler):
    def server_status(self):
        servers_status = []
        for server in terminal_servers_conf:
            host = server['host']
            port = server['port']
            address = (host, port)
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            timeout_usecs = 1500000
            s.settimeout(timeout_usecs / 1000000.0)
            try:
                s.connect(address)
            
                head = "stats\r\n"
                ret = s.send(head)
                if ret != len(head) :
                    s.close()
                    continue
                stats_dict = {}
                data = s.recv(4096)
                for item in data.split("\r\n"):
                    if item == "END":
                        break
                    else:
                        stats = item.split(" ")
                        key = stats[1]
                        val = stats[2]
                        stats_dict[key] = val
                stats_dict['tag'] = server['tag']
                stats_dict['host'] = server['host']
                stats_dict['port'] = server['port']
                s.close()
                servers_status.append(stats_dict)
                
            except Exception, e:
                print e
                pass
        return servers_status


    def get(self):
        status_infos = self.server_status()
        self.render("index.html", servers=terminal_servers_conf, stats = status_infos)

class DBHandler(tornado.web.RequestHandler):
    def db_info(self, host, port):
        servers_status = []
        address = (host, port)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        timeout_usecs = 1500000
        s.settimeout(timeout_usecs / 1000000.0)
        try:
            s.connect(address)
        
            head = "info\r\n"
            ret = s.send(head)
            if ret != len(head) :
                s.close()
                return servers_status
            
            data = s.recv(4096)
            info_lst = data.split("\n")[2:]
            for info in info_lst:
                items = filter(lambda x: x, info.split(' '))
                if len(items) < 2:
                    continue
                stats_dict = {}
                stats_dict['dbid'] = items[0]
                stats_dict['tag'] = items[1]
                stats_dict['version'] = items[2]
                stats_dict['status'] = items[3]
                stats_dict['ref'] = items[4]
                stats_dict['query_num'] = items[5]
                stats_dict['idx_num'] = items[6]
                stats_dict['open_time'] = items[7]
                stats_dict['path'] = items[8]
                servers_status.append(stats_dict)
            s.close()
        except Exception, e:
            pass
        return servers_status
    def get(self):
        host = self.get_argument("host")
        port = int(self.get_argument("port"))
        tag = self.get_argument("tag")
        db_infos =  self.db_info(host, port)
        self.render("dbinfo.html", servers=terminal_servers_conf, infos = db_infos, host = host, port = port, tag = tag)

class AjaxHandler(tornado.web.RequestHandler):
    def db_info(self, host, port):
        query_num = 0
        address = (host, port)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        timeout_usecs = 1500000
        s.settimeout(timeout_usecs / 1000000.0)
        try:
            s.connect(address)

            head = "info\r\n"
            ret = s.send(head)
            if ret != len(head) :
                s.close()
                return 0
            
            data = s.recv(4096)
            info_lst = data.split("\n")[2:]
            for info in info_lst:
                items = filter(lambda x: x, info.split(' '))
                if len(items) < 2:
                    continue
                query_num += int(items[5])
            s.close()
        except Exception, e:
            pass
        return query_num
    def get(self):
        host = self.get_argument("host")
        port = int(self.get_argument("port"))
        query_num =  self.db_info(host, port)
        out_str = "%d" %(query_num)
        self.write(out_str)

handlers = [
    (r"/", IndexHandler),
    (r"/dbinfo", DBHandler),
    (r"/ajax", AjaxHandler),
    (r"/controler", ControlHandler)
]

setting = dict(
    template_path=os.path.join(os.path.dirname(__file__),"pages"),
    static_path=os.path.join(os.path.dirname(__file__),"asserts"),
)
if __name__ == "__main__":
    tornado.options.parse_command_line()
    app = tornado.web.Application(handlers, **setting)
    http_server = tornado.httpserver.HTTPServer(app)
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
