# Chubby Hat
A PCB that turns the [Colorlight 5A-75B](https://www.aliexpress.com/item/32728519290.html)
into an easy to use development platform for cheap.
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
| hooks      | git hooks, for example for automatic documentation export            |

### Version 0.1.0

- USB to JTAG via STM32 or FTDI
- two 3x Pmod ports

<img src="https://cdn.hackaday.io/images/9076851603034279197.JPEG" width="75%">

### Version 0.2.0


- USB to JTAG via extra dev board or on-board RP2040
- three 2x Pmod ports

<img src="exports/renderings/chubby-hat_top.png" width="75%">
<img src="exports/renderings/chubby-hat_bottom.png" width="75%">

## Automation
This repository contains a Makefile that automates PDF and Gerber export, as
well as PCB art pattern creation.

### Requirements
Apart from [KiCad 7](#kicad-version) this requires some additional software.

The Makefile calls a Python script that makes use of [sexptdata](https://pypi.org/project/sexpdata/) to parse KiCad files.
Install [Poetry](https://python-poetry.org/) and run `poetry shell` followed by `poetry install` in the root of this repositoryto set up a virtual environment with the required package(s). To re-enter this environment, simply run `poetry shell` in the root of this repository.

For PDF export you need to install [Poppler](https://poppler.freedesktop.org/).
Gerber export requires [zip](https://infozip.sourceforge.net/).
Pattern creation is implemented with [OpenSCAD](https://openscad.org/).

#### Nix(OS)
If you are using the Nix package manager, you can enter a development environment
with KiCad and all other software by running `nix-shell` in the root of this
repository.

### Export
To export all PDFs and Gerbers, simply run
```shell
make
```
PDFs and Gerbers are exported automatically when you `git commit`, if you have
[Git Hooks](#installing-git-hooks-optional) set up.

### Pattern
To recreate the pattern, first remove the pattern from the board and save it,
then run
```shell
make pattern
```
Add the new pattern graphic to the board.

### Installing Git Hooks (optional)
The [hooks](hooks) directory contains client-side [git hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks).
Currently only the pre-commit hook is used to automatically export plots.

To enable the hooks locally, run the following in the root of the repository.
```shell
git config core.hooksPath ./hooks
```

## KiCad Version
```
Version: 7.0.1, release build

Libraries:
	wxWidgets 3.2.2
	FreeType 2.12.1
	HarfBuzz 6.0.0
	FontConfig 2.14.0
	libcurl/7.87.0 OpenSSL/3.0.8 zlib/1.2.13 brotli/1.0.9 zstd/1.5.2 libidn2/2.3.2 libssh2/1.10.0 nghttp2/1.51.0

Platform: , 64 bit, Little endian, wxBase, , wayland

Build Info:
	Date: Jan  1 1980 00:00:00
	wxWidgets: 3.2.2 (wchar_t,wx containers) GTK+ 0.0
	Boost: 1.79.0
	OCC: 7.6.2
	Curl: 7.87.0
	ngspice: 37
	Compiler: GCC 12.2.0 with C++ ABI 1017

Build settings:
	KICAD_USE_EGL=ON
	KICAD_SPICE=ON
```
