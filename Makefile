#
# required host packages:
#     sudo apt install libusb-dev libusb-1.0-0-dev
#
# Environment variables:
# 	USER_FLAGS - allows to pass additonal compiler flags like
#                This allows to create different binaries
#   BUILD_DIR  - directory where output are placed
#   CC - compiler
#   CFLAGS
#   LD_FLAGS
#   INCLUDE

ARCH = x86

CC = gcc

# toolchain libs/includes (use default host includes)
#LD_FLAGS = ${LD_FLAGS}
INCLUDE =  -I/usr/include/libusb-1.0

# compile options
CFLAGS = -O2

#---------------------------------------------------------------------------------------------------

TARGET_DFU = dfu-util
SOURCES_DFU = dfu.c dfu_file.c dfu_file.h dfu_load.c dfu_util.c dfuse.c dfuse_mem.c quirks.c main.c

TARGET_SUFFIX = dfu-suffix
SOURCES_SUFFIX = suffix.c dfu_file.c

TARGET_PREFIX = dfu-prefix
SOURCES_PREFIX = prefix.c dfu_file.c

.PHONY = all clean ${TARGET_DFU} ${TARGET_SUFFIX} ${TARGET_PREFIX}

all: ${TARGET_DFU} ${TARGET_SUFFIX} ${TARGET_PREFIX}


${TARGET_DFU}: ${SOURCES_DFU}
	@echo ">>> building $@"
	@${CC} ${INCLUDE} ${LD_FLAGS} ${SOURCES_DFU} -DHAVE_CONFIG_H -lusb-1.0 -o $@

${TARGET_SUFFIX}: ${SOURCES_SUFFIX}
	@echo ">>> building $@"
	@${CC} ${INCLUDE} ${LD_FLAGS} ${SOURCES_SUFFIX} -DHAVE_CONFIG_H  -o $@

${TARGET_PREFIX}: ${SOURCES_PREFIX}
	@echo ">>> building $@"
	@${CC} ${INCLUDE} ${LD_FLAGS} ${SOURCES_PREFIX} -DHAVE_CONFIG_H  -o $@

clean:
	@echo ">>> cleaning"
	rm -rf ${TARGET_DFU} ${TARGET_SUFFIX} ${TARGET_PREFIX}
