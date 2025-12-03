// created by IndiePandaaaaa|Lukas
// encoding: utf-8

// use <Structures/Spring.scad>
use <Libraries/pschatzmann_openscad-models/SpringsLib.scad>

TOLERANCE = .1;
THICKNESS = 2.5;
$fn = $preview ? 25 : 125;

// metaBOX midi inner size
mbox_width = 379;
mbox_depth = 267;

// linear_extrude(height=10, center=true, convexity=10, twist=360, scale=1.0)
//   translate([3, 0, 0]) square(size=[15, 15], center=false);

spring(d=30, dBottom=2, dTop=4, windings=1.25, height=3, steps=5);
