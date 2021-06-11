#!/bin/sh
echo "start"
./cmd
#exec ./cmd
#后面步骤不会被执行
#exec sleep 5
#exec ./cmd.sh
echo "exit"
exit 1
	