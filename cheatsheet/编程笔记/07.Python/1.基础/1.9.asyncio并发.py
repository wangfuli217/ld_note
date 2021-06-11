使用asyncio的并发

Python之父开发了asyncio模块, 使用coroutine来处理并发, 并在python3.4中被加入进来.

# spinner_asyncio.py

# credits: Example by Luciano Ramalho inspired by
# Michele Simionato's multiprocessing example in the python-list:
# https://mail.python.org/pipermail/python-list/2009-February/538048.html

# BEGIN SPINNER_ASYNCIO
import asyncio
import itertools
import sys


@asyncio.coroutine  # <1> 可省略
def spin(msg):  # <2>
    write, flush = sys.stdout.write, sys.stdout.flush
    for char in itertools.cycle('|/-\\'):
        status = char + ' ' + msg
        write(status)
        flush()
        write('\x08' * len(status))
        try:
            yield from asyncio.sleep(.1)  # <3> 控制权交还给主事件流程
        except asyncio.CancelledError:  # <4>
            break
    write(' ' * len(status) + '\x08' * len(status))


@asyncio.coroutine
def slow_function():  # <5>
    # pretend waiting a long time for I/O
    yield from asyncio.sleep(3)  # <6> 控制权交还给主事件流程
    return 42


@asyncio.coroutine
def supervisor():  # <7>
    spinner = asyncio.async(spin('thinking!'))  # <8>
    print('spinner object:', spinner)  # <9>
    result = yield from slow_function()  # <10> 控制权交还给主事件流程
    spinner.cancel()  # <11>
    return result


def main():
    loop = asyncio.get_event_loop()  # <12> 主事件流程
    result = loop.run_until_complete(supervisor())  # <13>
    loop.close()
    print('Answer:', result)


if __name__ == '__main__':
    main()
# END SPINNER_ASYNCIO