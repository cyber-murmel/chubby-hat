# Chubby Hat
A PCB that turns the [Colorlight 5A-75B](https://www.aliexpress.com/item/32728519290.html) into an easy to use development platform for cheap.
This project ist based on [q3k/chubby75](https://github.com/q3k/chubby75/tree/master/5a-75b).

Read more on [<img src="https://hackaday.io/favicon.ico" width="12em"> hackaday.io](https://hackaday.io/project/174032-chubby-hat).

## Directory Structure
| directory  | content                                                              |
|------------|----------------------------------------------------------------------|
| source     | KiCad project directories                                            |
| production | fabrication files (Gerber, BOM, placement)                           |
| exports    | schematic and layout plots, board 3D model and renderings            |
| datasheets | component datasheets                                                 |
| assets     | board setups, component 3D models, logos                             |
| scripts    | BOM export plugins, miscellaneous helper scripts for file conversion |

### Version 0.1.0

- USB to JTAG via STM32 or FTDI
- two 3x Pmod ports

<img src="https://cdn.hackaday.io/images/9076851603034279197.JPEG" width="75%">

### Version 0.2.0


- USB to JTAG via extra dev board or on-board RP2040
- three 2x Pmod ports
  
<img src="exports/renderings/chubby-hat_top.png" width="75%">
<img src="exports/renderings/chubby-hat_bottom.png" width="75%">
