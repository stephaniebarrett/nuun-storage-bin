#!/bin/bash

# Script to export OpenSCAD files into .stl and .png
# Copyright (C) 2023 Stephanie Barrett (https://github.com/stephaniebarrett)
# Last revised 22/12/2023

# Usage: generate.sh [-i|o|x|y|z|s|e|r|q|h] | [--all]
#
# Options:
#  -i arg     The input .scad file. Default: main.scad
#  -o arg     The output path. Default: export/
#  -x arg     The number of Gridfinity bases along the x-axis. Default: 1.
#  -y arg     The number of Gridfinity bases along the y-axis. Default: 1.
#  -z arg     The bin height in number of 7mm increments. Default: 2.
#  -s arg     Style of the holes in the base (0: No holes, 1: Magnet holes only, 2: Magnet and screw holes; no printable slit, 3: Magnet and screw holes; with printable slit). Default: 0.
#  -e arg     Elevation of the tube into the base. Negative values will sink the tube into the bin, positive values are useless. Default: -10.
#  -r arg     Rotation of the tube; recommended rage is 0 - 20. Anything more will risk toppling over on smaller bases. Default: 15.
#  -q arg     Quality of the model's curves (32:Low, 64:Medium, 128:High, 256:Ultra). Default: 32
#  -h         Print this help.
#  --all      If the first argument is --all, every combination from 1x1 0º to 5x5 20º in 5º increments will be created in a separate process (very CPU and memory intensive) using main.scad and all other parameters will be ignored.

openscad="/usr/bin/openscad"

usage()
{
    echo
    echo "Usage: generate.sh [-i|o|x|y|z|s|e|r|q|h] | [--all]"
    echo "  -i arg     The input .scad file. Default: main.scad"
    echo "  -o arg     The output path. Default export/"
    echo "  -x arg     The number of Gridfinity bases along the x-axis. Default: 1."
    echo "  -y arg     The number of Gridfinity bases along the y-axis. Default: 1."
    echo "  -z arg     The bin height in number of 7mm increments. Default: 2."
    echo "  -s arg     Style of the holes in the base (0: No holes, 1: Magnet holes only, 2: Magnet and screw holes; no printable slit, 3: Magnet and screw holes; with printable slit). Default: 0."
    echo "  -e arg     Elevation of the tube into the base. Negative values will sink the tube into the bin, positive values are useless. Default: -10."
    echo "  -r arg     Rotation of the tube; recommended rage is 0 - 20. Anything more will risk toppling over on smaller bases. Default: 15."
    echo "  -q arg     Quality of the model's curves (32:Low, 64:Medium, 128:High, 256:Ultra). Default: 32"
    echo "  -h         Print this help."
    echo "  --all      If the first argument is --all, every combination from 1x1 0 to 5x5 20 will be created in a separate process (very CPU and memory intensive) using main.scad and all other parameters will be ignored."
    echo
    exit 1
}

generate_all()
{
    for angle in {0..20..5}
    do
        for x in {1..5}
        do
            for y in {1..5}
            do
                mkdir -p 'export/'$angle'_degrees'
                filename='export/'$angle'_degrees/'$x'x'$y'r'$angle'.stl'
                openscad -o $filename -D gridx=$x -D gridy=$y -D Rotation=$angle -D Level_of_Detail=$256 main.scad &
            done
        done
    done
    wait
}


if [ "$1" = "--all" ]
then
    generate_all
else
    gridx=1
    gridy=1
    gridz=2
    style=0
    elevation=-10
    rotation=0
    quality=64
    input="main.scad"
    output="export"

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

    filename=$gridx'x'$gridy'r'$rotation
    stl=$output'/'$filename'.stl'
    png=$output'/'$filename'.png'

    echo "Rendering ${input} into ${stl} and ${png}."

    openscad -o $stl -D gridx=$gridx -D gridy=$gridy -D gridz=$gridz -D Hole_Style=$style -D Elevation=$elevation -D Rotation=$rotation -D Level_of_Detail=$quality $input &
    openscad -o $png -D gridx=$gridx -D gridy=$gridy -D gridz=$gridz -D Hole_Style=$style -D Elevation=$elevation -D Rotation=$rotation -D Level_of_Detail=$quality --autocenter --viewall --imgsize 1024,1024 $input &
    wait
fi

