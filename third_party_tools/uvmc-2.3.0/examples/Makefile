#-------------------------------------
DIRS = \
	commands \
	connections \
	converters \
	field_types \
	xlerate.connections \
	config_exts

BITS ?= 32

MAKEFILE ?= Makefile

all compile build sim check clean:
	#
	for i in $(DIRS); do \
		./test_drive.csh $$i $(MAKE) -f $(MAKEFILE) BITS=$(BITS) $@; \
	done
