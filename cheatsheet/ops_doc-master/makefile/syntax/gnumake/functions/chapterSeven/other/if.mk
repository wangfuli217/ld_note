
result := $(if $(DEBUG),foo,bar)

all :
	echo "result = $(result)"
