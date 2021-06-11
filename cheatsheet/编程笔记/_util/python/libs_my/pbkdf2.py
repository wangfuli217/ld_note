﻿#!python
# -*- coding:utf-8 -*-
'''
密码算法(每次生成不一样)，兼容py2及py3
Created on 2016/4/22
Updated on 2016/4/22
@author: Holemar
'''
import sys
import codecs
import hashlib
import hmac
from struct import Struct
from random import SystemRandom
from itertools import starmap
from operator import xor


_pack_int = Struct('>I').pack
_sys_rng = SystemRandom()
_builtin_safe_str_cmp = getattr(hmac, 'compare_digest', None)
SALT_CHARS = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
range_type = range
string_types = (str, )
text_type = str
DEFAULT_PBKDF2_ITERATIONS = 1000
izip = zip
PY2 = sys.version_info[0] == 2
try:
    unicode
except NameError:
    unicode = str


def _find_hashlib_algorithms():
    algos = getattr(hashlib, 'algorithms', None)
    if algos is None:
        algos = ('md5', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512')
    rv = {}
    for algo in algos:
        func = getattr(hashlib, algo, None)
        if func is not None:
            rv[algo] = func
    return rv

defaultencoding = sys.getdefaultencoding()
_has_native_pbkdf2 = hasattr(hashlib, 'pbkdf2_hmac')
_hash_funcs = _find_hashlib_algorithms()
try:
    _bytes_type = (bytes, bytearray, memoryview)
except:
    _bytes_type = (bytes, bytearray)


def to_bytes(x, charset=defaultencoding, errors='strict'):
    if x is None:
        return None
    if isinstance(x, _bytes_type):  # noqa
        return bytes(x)
    if isinstance(x, (str, unicode)):
        return x.encode(charset, errors)
    raise TypeError('Expected bytes')


def to_native(x, charset=defaultencoding, errors='strict'):
    if x is None or isinstance(x, str):
        return x
    return x.decode(charset, errors)


def pbkdf2_hex(data, salt, iterations=DEFAULT_PBKDF2_ITERATIONS, keylen=None, hashfunc=None):
    """Like :func:`pbkdf2_bin`, but returns a hex-encoded string.
    .. versionadded:: 0.9
    :param data: the data to derive.
    :param salt: the salt for the derivation.
    :param iterations: the number of iterations.
    :param keylen: the length of the resulting key.  If not provided,
                   the digest size will be used.
    :param hashfunc: the hash function to use.  This can either be the
                     string name of a known hash function, or a function
                     from the hashlib module.  Defaults to sha1.
    """
    rv = pbkdf2_bin(data, salt, iterations, keylen, hashfunc)
    return to_native(codecs.encode(rv, 'hex_codec'))


def pbkdf2_bin(data, salt, iterations=DEFAULT_PBKDF2_ITERATIONS, keylen=None, hashfunc=None):
    """Returns a binary digest for the PBKDF2 hash algorithm of `data`
    with the given `salt`. It iterates `iterations` times and produces a
    key of `keylen` bytes. By default, SHA-1 is used as hash function;
    a different hashlib `hashfunc` can be provided.
    .. versionadded:: 0.9
    :param data: the data to derive.
    :param salt: the salt for the derivation.
    :param iterations: the number of iterations.
    :param keylen: the length of the resulting key.  If not provided
                   the digest size will be used.
    :param hashfunc: the hash function to use.  This can either be the
                     string name of a known hash function or a function
                     from the hashlib module.  Defaults to sha1.
    """
    if isinstance(hashfunc, string_types):
        hashfunc = _hash_funcs[hashfunc]
    elif not hashfunc:
        hashfunc = hashlib.sha1
    data = to_bytes(data)
    salt = to_bytes(salt)

    # If we're on Python with pbkdf2_hmac we can try to use it for
    # compatible digests.
    if _has_native_pbkdf2:
        _test_hash = hashfunc()
        if hasattr(_test_hash, 'name') and \
           _test_hash.name in _hash_funcs:
            return hashlib.pbkdf2_hmac(_test_hash.name,
                                       data, salt, iterations,
                                       keylen)

    mac = hmac.HMAC(data, None, hashfunc)
    if not keylen:
        keylen = mac.digest_size

    def _pseudorandom(x, mac=mac):
        h = mac.copy()
        h.update(x)
        return bytearray(h.digest())
    buf = bytearray()
    for block in range_type(1, -(-keylen // mac.digest_size) + 1):
        rv = u = _pseudorandom(salt + _pack_int(block))
        for i in range_type(iterations - 1):
            u = _pseudorandom(bytes(u))
            rv = bytearray(starmap(xor, izip(rv, u)))
        buf.extend(rv)
    return bytes(buf[:keylen])


def _hash_internal(method, salt, password):
    """Internal password hash helper.  Supports plaintext without salt,
    unsalted and salted passwords.  In case salted passwords are used
    hmac is used.
    """
    if method == 'plain':
        return password, method

    if isinstance(password, text_type):
        password = password.encode('utf-8')

    if method.startswith('pbkdf2:'):
        args = method[7:].split(':')
        if len(args) not in (1, 2):
            raise ValueError('Invalid number of arguments for PBKDF2')
        method = args.pop(0)
        iterations = args and int(args[0] or 0) or DEFAULT_PBKDF2_ITERATIONS
        is_pbkdf2 = True
        actual_method = 'pbkdf2:%s:%d' % (method, iterations)
    else:
        is_pbkdf2 = False
        actual_method = method

    hash_func = _hash_funcs.get(method)
    if hash_func is None:
        raise TypeError('invalid method %r' % method)

    if is_pbkdf2:
        if not salt:
            raise ValueError('Salt is required for PBKDF2')
        rv = pbkdf2_hex(password, salt, iterations,
                        hashfunc=hash_func)
    elif salt:
        if isinstance(salt, text_type):
            salt = salt.encode('utf-8')
        rv = hmac.HMAC(salt, password, hash_func).hexdigest()
    else:
        h = hash_func()
        h.update(password)
        rv = h.hexdigest()
    return rv, actual_method


def safe_str_cmp(a, b):
    """This function compares strings in somewhat constant time.  This
    requires that the length of at least one string is known in advance.
    Returns `True` if the two strings are equal, or `False` if they are not.
    .. versionadded:: 0.7
    """
    if isinstance(a, text_type):
        a = a.encode('utf-8')
    if isinstance(b, text_type):
        b = b.encode('utf-8')

    if _builtin_safe_str_cmp is not None:
        return _builtin_safe_str_cmp(a, b)

    if len(a) != len(b):
        return False

    rv = 0
    if PY2:
        for x, y in izip(a, b):
            rv |= ord(x) ^ ord(y)
    else:
        for x, y in izip(a, b):
            rv |= x ^ y

    return rv == 0


def gen_salt(length):
    """Generate a random string of SALT_CHARS with specified ``length``."""
    if length <= 0:
        raise ValueError('Salt length must be positive')
    return ''.join(_sys_rng.choice(SALT_CHARS) for _ in range_type(length))


def generate_password_hash(password, method='pbkdf2:md5', salt_length=8):
    """Hash a password with the given method and salt with a string of
    the given length. The format of the string returned includes the method
    that was used so that :func:`check_password_hash` can check the hash.
    The format for the hashed string looks like this::
        method$salt$hash
    This method can **not** generate unsalted passwords but it is possible
    to set param method='plain' in order to enforce plaintext passwords.
    If a salt is used, hmac is used internally to salt the password.
    If PBKDF2 is wanted it can be enabled by setting the method to
    ``pbkdf2:method:iterations`` where iterations is optional::
        pbkdf2:sha1:2000$salt$hash
        pbkdf2:sha1$salt$hash
    :param password: the password to hash.
    :param method: the hash method to use (one that hashlib supports). Can
                   optionally be in the format ``pbkdf2:<method>[:iterations]``
                   to enable PBKDF2.
    :param salt_length: the length of the salt in letters.
    """
    salt = method != 'plain' and gen_salt(salt_length) or ''
    h, actual_method = _hash_internal(method, salt, password)
    #return '%s$%s$%s' % (actual_method, salt, h)
    return '%s$%s' % ( salt, h)


def check_password_hash(pwhash, password, method='pbkdf2:md5'):
    """check a password against a given salted and hashed password value.
    In order to support unsalted legacy passwords this method supports
    plain text passwords, md5 and sha1 hashes (both salted and unsalted).
    Returns `True` if the password matched, `False` otherwise.
    :param pwhash: a hashed string like returned by
                   :func:`generate_password_hash`.
    :param password: the plaintext password to compare against the hash.
    """
    #if pwhash.count('$') < 2:
    if pwhash.count('$') != 1:
        return False
    #method, salt, hashval = pwhash.split('$', 2)
    salt, hashval = pwhash.split('$', 1)
    return safe_str_cmp(_hash_internal(method + ':1000', salt, password)[0], hashval)


if __name__ == "__main__":
    password = '1515@#E$$@#ghfgh()_=154484*4616'
    # 遍历所有算法
    algos = ('md5', 'sha1', 'sha224', 'sha256', 'sha384', 'sha512')
    for algo in algos:
        pwhash = generate_password_hash(password, method='pbkdf2:' + algo)
        check = check_password_hash(pwhash, password, method='pbkdf2:' + algo) # True
        print( algo, check, pwhash )


