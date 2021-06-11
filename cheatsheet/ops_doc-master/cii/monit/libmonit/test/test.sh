#!/bin/sh

PATH="$PATH:."
export PATH

StrTest && \
TimeTest && \
SystemTest && \
ListTest && \
LinkTest && \
StringBufferTest && \
DirTest && \
InputStreamTest && \
OutputStreamTest && \
FileTest && \
ExceptionTest && \
NetTest && \
CommandTest
