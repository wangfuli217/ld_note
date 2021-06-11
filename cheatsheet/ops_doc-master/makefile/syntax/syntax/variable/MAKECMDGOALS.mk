# 终极目标列表
# MAKECMDGOALS
# 注意:此变量仅用在特殊的场合(比如判断),在 Makeifle 中不要对它进行重新定义!
# 例如:
sources = foo.c bar.c
ifneq ($(MAKECMDGOALS),clean)
include $(sources:.c=.d)
endif
# 上例的功能是避免"make clean"时make试图重建所有.d文件的过程