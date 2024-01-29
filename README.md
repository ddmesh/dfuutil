# dfu-util

**Licensed**: gpl-3.0 / GNU General Public License v3.0
Copyright 2005-2009 Weston Schmidt, Harald Welte and OpenMoko Inc.
Copyright 2010-2016 Tormod Volden and Stefan Schmidt
Copyright 2023 Stephan Enderlein
This program is Free Software and has ABSOLUTELY NO WARRANTY

This version v1.0 (ddmesh) extends and improves the previous version dfu-util v0.9 with following:
- fix dfu-util stm32 chip detection to avoid 35s timeout for gigadevices
- add new options to overwrite number of flash sectors/pages and their size.
  This is needed for Gigadevices MCU that signal invalid values via USB descriptors.
	This allows erase/flash specific pages instead of running a mass erase.
- add progress bar also when erasing flash pages to give user a feedback.
- replace complicated make/build system with simple makefile (tested on ubuntu 22.04)


## Building binaries

**Requirement** is a working build environment for x86 and/or cross compiling.<br/>
When using crosscompiling the variable BUILD_ROOT must point to build root

**Compiling**<br/>
 <pre>
 sudo apt install libusb-dev libusb-1.0-0-dev
 make
 </pre>

## Usage
~~~
> dfu-util -h
Usage: dfu-util [options] ...
  -h --help			              Print this help message
  -V --version			          Print the version number
  -v --verbose			          Print verbose debug statements
  -l --list			              List currently attached DFU capable devices
  -e --detach			            Detach currently attached DFU capable devices
  -E --detach-delay seconds	  Time to wait before reopening a device after detach
  -d --device <vendor>:<product>[,<vendor_dfu>:<product_dfu>]
                              Specify Vendor/Product ID(s) of DFU device
  -p --path <bus-port. ... .port>
                              Specify path to DFU device
  -c --cfg <config_nr>		    Specify the Configuration of DFU device
  -i --intf <intf_nr>		      Specify the DFU Interface number
  -S --serial <serial_string>[,<serial_string_dfu>]
                              Specify Serial String of DFU device
  -a --alt <alt>		          Specify the Altsetting of the DFU Interface
                              by name or by number
  -t --transfer-size <size>	  Specify the number of bytes per USB Transfer
  -U --upload <file>		      Read firmware from device into <file>
  -Z --upload-size <bytes>	  Specify the expected upload size in bytes
  -D --download <file>		    Write firmware from <file> into device
  -R --reset			            Issue USB Reset signalling once we are finished
  -s --dfuse-address <address>	ST DfuSe mode, specify target address for
                              raw file download or upload. Not applicable for
                              DfuSe file (.dfu) downloads
  -N --flash-sectors <number>	Specify the number of flash sectors
  -P --flash-page_size <size>	Specify the size of one flash page in bytes
~~~

Newly added options are _-N_ and _-P_ to overwrite any information of USB descriptors.

Example 1:
~~~sh
dfu-util -a 0 -s 0x08000000:leave -N 128 -P 1024 -D firmware.bin
~~~

Example 2:
~~~sh
# extract first 32kbyte of image
dd if=complete_image.bin of=firmware.bin bs=1024 count=32

# extract last 1k sector  (config)
dd if=complete_image.bin of=config.bin bs=1024 count=1 skip=127

# mass-erase (very fast) and flash 32kbyte only and omit 'leave' to stay in dfu mode
dfu-util -a 0 -s 0x08000000:mass-erase:force -N 128 -P 1024 -D firmware.bin

# flash config at specific flash address (last 1k sector) and leave dfu (starts application)
dfu-util -a 0 -s 0x0801fc00:leave:no-erase -N 128 -P 1024 -D config.bin
~~~
