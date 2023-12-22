#!/bin/bash

# Script to export OpenSCAD files into .stl and .png
# Copyright (C) 2023 Stephanie Barrett (https://github.com/stephaniebarrett)
# Last revised 21/12/2023

# Usage: generate.sh [-i|o|x|y|z|s|e|r|q|h]
#
# Options:
#  -i arg     The input .scad file.
#  -o arg     The output path/filename.
#  -x arg     The number of Gridfinity bases along the x-axis. Default: 1.
#  -y arg     The number of Gridfinity bases along the y-axis. Default: 1.
#  -z arg     The bin height in number of 7mm increments. Default: 2.
#  -s arg     Style of the holes in the base (0: No holes, 1: Magnet holes only, 2: Magnet and screw holes; no printable slit, 3: Magnet and screw holes; with printable slit). Default: 0.
#  -e arg     Elevation of the tube into the base. Negative values will sink the tube into the bin, positive values are useless. Default: -10.
#  -r arg     Rotation of the tube; recommended rage is 0 - 20. Anything more will risk toppling over on smaller bases. Default: 15.
#  -q arg     Quality of the model's curves (32:Low, 64:Medium, 128:High, 256:Ultra). Default: 32
#  -h         Print this help.

gridx=1;
gridy=1;
gridz=2;
style=0;
elevation=-10;
rotation=0;
quality=64;
input="main.scad"
output="export/main"
openscad="/usr/bin/openscad";

usage()
{
    echo
    echo "Usage: generate.sh [-i|o|x|y|z|s|e|r|q|h]"
    echo "  -i arg     The input .scad file."
    echo "  -o arg     The output path/filename."
    echo "  -x arg     The number of Gridfinity bases along the x-axis. Default: 1."
    echo "  -y arg     The number of Gridfinity bases along the y-axis. Default: 1."
    echo "  -z arg     The bin height in number of 7mm increments. Default: 2."
    echo "  -s arg     Style of the holes in the base (0: No holes, 1: Magnet holes only, 2: Magnet and screw holes; no printable slit, 3: Magnet and screw holes; with printable slit). Default: 0."
    echo "  -e arg     Elevation of the tube into the base. Negative values will sink the tube into the bin, positive values are useless. Default: -10."
    echo "  -r arg     Rotation of the tube; recommended rage is 0 - 20. Anything more will risk toppling over on smaller bases. Default: 15."
    echo "  -q arg     Quality of the model's curves (32:Low, 64:Medium, 128:High, 256:Ultra). Default: 32"
    echo "  -h         Print this help."
    echo
    exit 1
}

while getopts i:o:x:y:z:s:e:r:q:h: flag
do
    case "${flag}" in
        i) input=${OPTARG};;
        o) output=${OPTARG};;
        x) gridx=${OPTARG};;
        y) gridy=${OPTARG};;
        z) gridz=${OPTARG};;
        s) style=${OPTARG};;
        e) elevation=${OPTARG};;
        r) rotation=${OPTARG};;
        q) quality=${OPTARG};;
        h) usage;;
        ?) usage;;
    esac
done

stl=$output'.stl'
png=$output'.png'

echo "Rendering ${input} into ${stl} and ${png}."

openscad -o $stl -D gridx=$gridx -D gridy=$gridy -D gridz=$gridz -D Hole_Style=$style -D Elevation=$elevation -D Rotation=$rotation -D Level_of_Detail=$quality $input
openscad -o $png -D gridx=$gridx -D gridy=$gridy -D gridz=$gridz -D Hole_Style=$style -D Elevation=$elevation -D Rotation=$rotation -D Level_of_Detail=$quality --autocenter --viewall $input
