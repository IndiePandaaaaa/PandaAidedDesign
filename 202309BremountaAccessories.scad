// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>
use <Shapes/Schuko.scad>

MODEL_TOLERANCE = 0.1;
MODEL_THICKNESS = 3.5;
$fn = $preview ? 25 : 125;

PLATE_DEPTH = 59; // Bremounta

BREMOUNTA_SCREW_DIST = 50;
BREMOUNTA_SCREW_OD = 6;
BREMOUNTA_SCREW_HOLE_ID = 6.5;
BREMOUNTA_SCREW_HOLE_OD = BREMOUNTA_SCREW_HOLE_ID + 1;
BREMOUNTA_SCREW_HOLE_OD_DEPTH = 1;

WOOD_BOARD_THICKNESS = 9;
WOOD_BOARD_WIDTH = 28;
WOOD_BOARD_SCREW_DIST = WOOD_BOARD_WIDTH - 3.5 * 2;
WOOD_SCREWIN_THICKNESS = 18;

module LBracket_short()
{
    SOCKET_WIDTH = 18;
    PLATE_DEPTH_LBRACKET = PLATE_DEPTH + 2;
    PLATE_SCREW_OD = 5;

    difference()
    {
        union()
        {
            cube([ SOCKET_WIDTH, MODEL_THICKNESS, PLATE_DEPTH_LBRACKET + MODEL_TOLERANCE + MODEL_THICKNESS ]);
            cube([ SOCKET_WIDTH, WOOD_SCREWIN_THICKNESS, MODEL_THICKNESS ]);
        }
        translate([ SOCKET_WIDTH / 2, WOOD_SCREWIN_THICKNESS / 2, MODEL_THICKNESS ]) rotate([ 0, 0, 90 ])
            screw(PLATE_SCREW_OD, 12, true);

        for (i = [0:1])
        {
            translate([ SOCKET_WIDTH / 2, 0, BREMOUNTA_SCREW_OD * 1.25 + MODEL_TOLERANCE + BREMOUNTA_SCREW_DIST * i ])
            {
                rotate([ 90, 0, 0 ])
                {
                    screw(BREMOUNTA_SCREW_OD, 12, true);
                    translate([ 0, 0, -MODEL_THICKNESS ])
                        cylinder(d = BREMOUNTA_SCREW_HOLE_OD, h = BREMOUNTA_SCREW_HOLE_OD_DEPTH);
                }
            }
        }
    }
}

module BremountaPlate()
{
    SOCKET_WIDTH = 14;
    PLATE_DEPTH_BPLATE = PLATE_DEPTH + 5;
    PLATE_WIDTH = 21 + SOCKET_WIDTH;
    PLATE_SCREW_OD = 3.5;
    difference()
    {
        union()
        {
            cube([ PLATE_WIDTH, PLATE_DEPTH_BPLATE, MODEL_THICKNESS ]);
            cube([ SOCKET_WIDTH, PLATE_DEPTH_BPLATE, WOOD_BOARD_THICKNESS ]);
            translate([ 0, PLATE_DEPTH_BPLATE / 5, 0 ])
                cube([ SOCKET_WIDTH * 1.75, PLATE_DEPTH_BPLATE / 5 * 3, WOOD_BOARD_THICKNESS ]);
        }
        for (i = [0:1])
        {
            translate(
                [ SOCKET_WIDTH / 2, (PLATE_DEPTH_BPLATE - BREMOUNTA_SCREW_DIST) / 2 + BREMOUNTA_SCREW_DIST * i, 0 ])
            {
                translate([ 0, 0, WOOD_BOARD_THICKNESS - BREMOUNTA_SCREW_HOLE_OD_DEPTH ])
                    cylinder(d = BREMOUNTA_SCREW_HOLE_OD, h = BREMOUNTA_SCREW_HOLE_OD_DEPTH);
                rotate([ 180, 0, 0 ]) screw(BREMOUNTA_SCREW_OD, 30, true);
                translate([ PLATE_WIDTH - SOCKET_WIDTH, 0, PLATE_SCREW_OD ]) screw(PLATE_SCREW_OD, 12, true);
            }
            if (WOOD_BOARD_THICKNESS > PLATE_SCREW_OD * 2)
            {
                translate([
                    SOCKET_WIDTH * 1.75, (PLATE_DEPTH_BPLATE - WOOD_BOARD_SCREW_DIST) / 2 + WOOD_BOARD_SCREW_DIST * i,
                    WOOD_BOARD_THICKNESS / 2
                ]) rotate([ 0, 90, 0 ])
                {
                    screw(PLATE_SCREW_OD, 35, true);
                    cylinder(d = PLATE_SCREW_OD * 2, h = PLATE_WIDTH);
                }
            }
        }
    }
}

module SchukoReferencePlate()
{
    thickness = 2.5;
    union()
    {
        translate(v = [ 0, 0, 5 + thickness ]) Schuko3D(height = 10.1);
        translate(v = [ -PLATE_DEPTH / 2, -52 / 2, 0 ]) cube(size = [ PLATE_DEPTH, 52, thickness ], center = false);
    }
}
translate(v = [ 0, 0, 0 ]) SchukoReferencePlate();
translate(v = [ 70, 0, 0 ]) BremountaPlate();
translate(v = [ 40, 0, 0 ]) LBracket_short();
