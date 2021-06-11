@ECHO off
TITLE %~n0

SET "PYTHONPATH=D:\workspace\libs"

rem 直接运行
python 4.extends.py --port=8081

PAUSE
