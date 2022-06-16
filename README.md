# KiCad Template
For KiCad *Version: 5.99.0-76a6177eb7, release build*

## Directory Structure
| directory  | content                                                              |
|------------|----------------------------------------------------------------------|
| source     | KiCad source files                                                   |
| production | fabrication files (Gerber, BOM, placement)                           |
| exports    | schematic and layout plots, board 3D model                           |
| datasheets | component datasheets                                                 |
| assets     | board setups, component 3D models, logos, board 3D renderings        |
| scripts    | BOM export plugins, miscellaneous helper scripts for file conversion |

## Usage
Click [![Use this template](https://img.shields.io/badge/-Use_this_template-green.svg)](https://github.com/cyber-murmel/kicad-template/generate) to create a new repository and clone it to your machine. Then enter the repository and rename the source files.

```shell
PROJECT_NAME=my-cool-project

rename kicad-template $PROJECT_NAME source/*.kicad_*
sed -i -e "s/kicad-template/$PROJECT_NAME/g" source/*.kicad_*

git commit -am "renamed source files"
```

