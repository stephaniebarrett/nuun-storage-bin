include <lib/gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>

/* [Container Size] */
// number of bases along the x-axis.
gridx = 1;
// number of bases along the y-axis.
gridy = 1;
// bin height in # of 7mm increments.
gridz = 2;

/* [Container Style] */
// style of holes in the base
Hole_Style = 0; // [0:No holes, 1:Magnet holes only, 2: Magnet and screw holes; no printable slit, 3:Magnet and screw holes; with printable slit]

/* [NUUN Tube Options] */
// negative values will sink the tube into the bin, positive values are useless.
Elevation = -10;
// amount to rotate the tube by; recommended range is 0 - 20. Anything more will risk toppling over.
Rotation = 15;

/* [Quality] */
// rendering quality of curves
Level_of_Detail = 32; // [32:Low, 64:Medium, 128:High, 256:Ultra]
$fn = Level_of_Detail;

// Any variables defined below here will not be shown in the Customizer window.
module __Customizer_Limit__ () {}

gridz_define = 0;
enable_zsnap = true;
height_internal = 0;
length = 42;
style_lip = 2;
divx = 1;
divy = 1;
div_base_x = 1;
div_base_y = 1;
scoop = 0;
style_tab = 5;

h = height(gridz, gridz_define, style_lip, enable_zsnap);

union()
{
    gridfinityInit(gridx, gridy, h, height_internal, length)
    {
        for (x = [0:gridx-1])
        {
            for (y = [0:gridy-1])
            {
                cut_move(x, y, 1, 1)
                {
                      rotate([Rotation,0,0]) translate([0,0,Elevation]) cylinder(d=30, h=50);
                }
            }
        }
    }

    gridfinityBase(gridx, gridy, length, div_base_x, div_base_y, Hole_Style);
}