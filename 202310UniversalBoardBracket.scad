// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

THICKNESS = 3.5;
TOLERANCE = 0.1;
CHAMFER = 1.5;
SCREW_OD = 3.5;
$fn = 75;

BOARD_THICKNESS = 20.8;
MOUNT_HEIGHT = 20;

module top_mount()
{
    rotate([ 90, 0, 90 ]) difference()
    {
        linear_extrude(SCREW_OD * 4)
        {
            polygon([
                [ 0, CHAMFER ],
                [ CHAMFER, 0 ],
                [ THICKNESS, 0 ],
                [ THICKNESS, BOARD_THICKNESS ],
                [ THICKNESS + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS ],
                [ THICKNESS + BOARD_THICKNESS + TOLERANCE, 0 ],
                [ THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE - CHAMFER, 0 ],
                [ THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, CHAMFER ],
                [ THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + THICKNESS ],
                [ THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + THICKNESS + MOUNT_HEIGHT ],
                [ THICKNESS + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + THICKNESS + MOUNT_HEIGHT ],
                [ THICKNESS + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + THICKNESS ],
                [ CHAMFER, BOARD_THICKNESS + THICKNESS ],
                [ 0, BOARD_THICKNESS + THICKNESS - CHAMFER ],
            ]);
        }
        translate([
            THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, BOARD_THICKNESS + MOUNT_HEIGHT + THICKNESS - SCREW_OD * 2,
            SCREW_OD * 2
        ]) rotate([ 0, 90, 0 ]) screw(SCREW_OD, 12, true);
    }
}

module vertical_mount(width = 28.5, height = 58.5)
{
    rotate([ 90, 0, 90 ]) linear_extrude(width)
    {
        polygon([
            [ 0, 0 ],
            [ THICKNESS, 0 ],
            [ THICKNESS, height ],
            [ THICKNESS + BOARD_THICKNESS + TOLERANCE, height ],
            [ THICKNESS + BOARD_THICKNESS + TOLERANCE, height - MOUNT_HEIGHT ],
            [ THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE - CHAMFER, height - MOUNT_HEIGHT ],
            [ THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, height - MOUNT_HEIGHT + CHAMFER ],
            [ THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE, height + THICKNESS - CHAMFER ],
            [ THICKNESS * 2 + BOARD_THICKNESS + TOLERANCE - CHAMFER, height + THICKNESS ],
            [ 0, height + THICKNESS ],
        ]);
    }
}

module bottle_holder(diameter = 19)
{
    size = diameter + THICKNESS * 2 + TOLERANCE;
    union()
    {
        vertical_mount(width = size, height = diameter * 1.5);
        translate([ 0, -size + THICKNESS, 0 ]) cube([ size, size, THICKNESS ]);
        translate(v = [ size / 2, -size / 2 + THICKNESS, diameter ]) difference()
        {
            cube(size = [ size, size, diameter * .25 ], center = true);
            cube(size = [ diameter + TOLERANCE, diameter + TOLERANCE, diameter ], center = true);
        }
    }
}

// translate([ 10, 0, 0 ]) top_mount();
// translate([ 40, 0, 0 ]) vertical_mount();
bottle_holder();
