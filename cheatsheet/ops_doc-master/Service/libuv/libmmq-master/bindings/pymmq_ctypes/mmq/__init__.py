import os
import sys
from ctypes import *
from ctypes.util import find_library



def find_dll():
    search_names = ['mmq', 'libmmq', 'libmmq.dll', 'libmmq.so', 'libmmq.dylib']
    lib_path = None
    for lib_name in search_names:
        lib_path = find_library(lib_name)
        if lib_path is None:
            full_path = os.path.join(os.getcwd(), lib_name)
            if os.path.isfile(full_path):
                lib_path = full_path
        if lib_path is None:
            full_path = os.path.join(os.path.dirname(__file__), lib_name)
            if os.path.isfile(full_path):
                lib_path = full_path

        if lib_path is not None:
            break

    if lib_path is None:
        raise ImportError("Could not find the MMQ DLL shared library")
    
    return lib_path

try:
    _ = CDLL(find_dll())
except OSError:
    raise ImportError("Could not load the MMQ DLL shared library")
    


class Peer():
    FLAG_HOST = 1
    
    def __init__(self):
        p = _.mmq_peer_create()
        if not p:
            raise Exception("MMQ Error: mmq_peer_create failed")
            
        self._peer = cast(p, c_void_p)
    
    def connect(self, connection_str, flags=0):
        r = _.mmq_peer_connect(self._peer, connection_str, flags)
        if r:
            raise Exception("MMQ Error: mmq_peer_connect failed")
        _.mmq_peer_run(self._peer)
        
    def subscribe(self, topic):
        _.mmq_peer_run(self._peer)
        _.mmq_peer_subscribe(self._peer, topic)
        _.mmq_peer_run(self._peer)
        
    def unsubscribe(self, topic):
        _.mmq_peer_run(self._peer)
        _.mmq_peer_unsubscribe(self._peer, topic)
        _.mmq_peer_run(self._peer)
        
    def publish(self, topic, message):
        message = bytes(message) 
        message = create_string_buffer(message, len(message))
        msg = _.mmq_msg_create(message, len(message.raw))
        _.mmq_peer_run(self._peer)
        _.mmq_peer_publish(self._peer, topic, msg)
        _.mmq_peer_run(self._peer)
    
    def get_message(self):
        _.mmq_peer_run(self._peer)
        msg = _.mmq_peer_get_msg(self._peer)
        if msg == 0:
            return None
            
        size = c_ulong(_.mmq_msg_get_size(msg)).value
        msg_data = create_string_buffer("", size)
        memmove(msg_data, cast(_.mmq_msg_get_data(msg), c_char_p), size)
        _.mmq_msg_close(byref(cast(msg, c_void_p)))
        message = msg_data.raw
        return message
    
    def get_messages(self):
        _.mmq_peer_run(self._peer)
        msg = _.mmq_peer_get_msg(self._peer)
        while msg:
            size = c_ulong(_.mmq_msg_get_size(msg)).value
            msg_data = create_string_buffer("", size)
            memmove(msg_data, cast(_.mmq_msg_get_data(msg), c_char_p), size)
            _.mmq_msg_close(byref(cast(msg, c_void_p)))
            yield msg_data.raw
            msg = _.mmq_peer_get_msg(self._peer)
            
    def __del__(self):
        _.mmq_peer_close(byref(self._peer))
    
    