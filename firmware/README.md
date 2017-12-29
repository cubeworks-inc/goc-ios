Firmware for GOC-IOS
====================

Impliments the ICE protocol for a simpler device


Getting Started
---------------

You need to program new boards before they will do anything.
Should only need to do this step once.

(Assuming Ubuntu)

  - Go to https://www.segger.com/downloads/jlink#J-LinkSoftwareAndDocumentationPack - Download J-Link Software and Documentation pack for linux, 64-bit DEB installer
  - Install J-Link
  - Install ARM gcc compiler by running "sudo apt-get install gcc-arm-none-eabi"
  - Run "git clone https://github.com/cubeworks-inc/goc-ios" - Go to /goc-ios/firmware
  - Run “git submodule init”
  - Run “git submodule update”
  - Run "make" to build
  - Plug in JTAG programmer, ensure switch on programming board is set to 3v3
  - While holding the spring-loaded jtag programmer in, run `make flash`
  - Unplug JTAG from board (you can leave the programmer plugged into the PC, no harm)
  - Plug Squall into USB connection
  - Squall setup is done


Using the Board
---------------

To flash LEDs for GOC:

  - Make sure python 2.7 is installed
  - Run “pip install m3” to install python m3 package
  - Or check for any update by running “pip install --upgrade m3”
  - Run “m3_ice -y goc message A5 01010101”

