# KiCad Template
For KiCad *Version: 6.0.5, release build*

[TL;DR](README.md#tldr)

## Directory Structure
| directory  | content                                                              |
|------------|----------------------------------------------------------------------|
| source     | KiCad project directories                                            |
| production | fabrication files (Gerber, BOM, placement)                           |
| exports    | schematic and layout plots, board 3D model and renderings            |
| datasheets | component datasheets                                                 |
| assets     | board setups, component 3D models, logos                             |
| scripts    | BOM export plugins, miscellaneous helper scripts for file conversion |

## Usage
Click [![Use this template](https://img.shields.io/badge/-Use_this_template-green.svg)](https://github.com/cyber-murmel/kicad-template/generate) to create a new repository and clone it to your machine.

### Customizing the Template (optional)
If your project consists of multiple designs, which all should adhere to the same design rules, you can modify the [template](source/template/) first, before creating projects based on it.
You can read more about this in the [Customizing the Project](README.md#customizing-the-project-optional) section, since the template is essentially also just a project.

Afterwards commit the changes to your template.
```shell
git add source/template/
git commit -m "customized template"
```

### Creating a Project
Enter the repository, copy the [template](source/template/), rename the source files and change the project name in the files.

```shell
PROJECT_NAME="my-cool-project"

cp --recursive source/template/ source/"${PROJECT_NAME}"/
rename "template" "${PROJECT_NAME}" source/"${PROJECT_NAME}"/*
sed -i -e "s/template/${PROJECT_NAME}/g" source/"${PROJECT_NAME}"/"${PROJECT_NAME}".*
```

### Customizing the Project (optional)
Start KiCad and open the project you just created.

The template makes use of *Text Variables*. You can edit these in the Schematic or PCB Editor. Go to **File > Schematic Setup > Project > Text Variables** or **File > Board Setup > Text & Graphics > Text Variables** respectively. In there you can change properties like project ID, revision, author and company name. These then automatically get updated throughout all file and changes for example the info box in the corner of each document.

You can also import predefined board setups. In the PCB Editor go to **File > Board Setup** and click *Import Settings from Another Board* in the lower left corner. You can import from on of the [board setups that are part of this repository](assets/board%20setups/) or any other project of yours.
Select which parts to import. Selecting all should be ok in most cases.

### Create Initial Commit for Your Project
It's a good idea to commit all relevant changes to the project, starting with an initial commit .
```shell
git add source/${PROJECT_NAME}/
git commit -m "Initial commit for ${PROJECT_NAME}"
```

## TL;DR
```shell
PROJECT_NAME="my-cool-project"

git clone https://github.com/cyber-murmel/kicad-template.git "${PROJECT_NAME}"
cd "${PROJECT_NAME}"

cp --recursive source/template/ source/"${PROJECT_NAME}"/
rename "template" "${PROJECT_NAME}" source/"${PROJECT_NAME}"/*
sed -i -e "s/template/${PROJECT_NAME}/g" source/"${PROJECT_NAME}"/"${PROJECT_NAME}".*

git add source/${PROJECT_NAME}/
git commit -m "Initial commit for ${PROJECT_NAME}"
```
