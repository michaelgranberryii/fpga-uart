# Project Title

Zybo Z7-10 FPGA SoC Development Board:  UART Controller and LEDs
## Description

In this project, a UART controller was created using VHDL and was tested on the Zybo Z7 10 FPGA board. The objective was to develop a controller that could receive a serial stream of data from a keyboard and display its binary representation on the board's four LEDs. The VHDL modules consisted of a register file, FIFO controller, FIFO, baud rate generator, UART receiver, UART transmitter, UART, and a top module to control the LEDs. Vivado is used for simulation, synthesizing, and implementing the VHDL code. Lastly, it's functionality was verified by typing various numbers on a keyboard and observed that the binary representation of the numbers was correctly displayed on the LEDs.

## Demo Video

[Demo on Youtube](https://youtu.be/IjOx7qobAYc)

## Dependencies

### Hardware

* [Zybo Z7-10 FPGA SoC Development Board](https://digilent.com/shop/zybo-z7-zynq-7000-arm-fpga-soc-development-board/?gad_source=1&gclid=Cj0KCQiAkeSsBhDUARIsAK3tiedDBNo96Tg5VWCeuEqzXgPKJSFg8GQ0qwLCV-v5TlTKltLerrQGLDkaAjBgEALw_wcB)
* [USBUART PMOD](https://digilent.com/shop/pmod-usbuart-usb-to-uart-interface/)

### Software

* [Xilinx Vivado](https://www.xilinx.com/products/design-tools/vivado.html)

## Author

* Michael Granberry
    * [@LinkedIn](https://www.linkedin.com/in/michaelgranberryii/)
    * [@GitHub](https://github.com/michaelgranberryii)
    * [Portfolio Website](https://www.michaelgranberryii.com/)

