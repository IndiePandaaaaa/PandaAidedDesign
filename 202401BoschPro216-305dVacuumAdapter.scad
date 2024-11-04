// created by IndiePandaaaaa|Lukas
// encoding: utf-8

THICKNESS = 3;
TOLERANCE = .15;
$fn = $preview ? 50 : 100;

VACUUM_OD = 34.2;

CENTRAL_CIRCLE_HEIGHT = 17;
CENTRAL_CIRCLE_OVERLAP = 12;
CONE_ID = 52.5;
CONE_OD = 89;
CONE_HEIGHT = 35;
CONE_DEPTH = 15;
SAW_BLADE_OD_WIDTH = 7;
SAW_BLADE_ID_WIDTH = 30;
SAW_BLADE_OD = 216;
SAW_BLADE_OFFSET = SAW_BLADE_OD/2 - (75 - CENTRAL_CIRCLE_OVERLAP) + 30;

OUTER_WIDTH = CONE_ID * 1.5;  // max 115
INNER_WIDTH = 22;
DEPTH = 25.5 + CONE_DEPTH;
HEIGHT = 65 + CENTRAL_CIRCLE_HEIGHT;

difference() {
  translate([OUTER_WIDTH/2, 0, 0]) union() color("#424242") {  // base
    rotate([-90, 0, 0]) difference() {
      cylinder(d1=INNER_WIDTH, d2=OUTER_WIDTH, h=DEPTH);
      translate([0, CONE_OD/2, 0]) cube(CONE_OD + .2, center=true);
    }
    translate([-INNER_WIDTH/2, 0, .1]) cube([INNER_WIDTH, DEPTH, HEIGHT]); // central block collecting dust from blade
    translate([0, DEPTH/2, HEIGHT/2]) rotate([0, 90, 0]) cylinder(d=VACUUM_OD + THICKNESS * 2 + TOLERANCE,h=OUTER_WIDTH/2); // vacuum port
    translate([INNER_WIDTH/2, 15, 50]) rotate([0, 90, 0]) cylinder(d1=47.5, d2=20, h=INNER_WIDTH);
  }
  translate([(OUTER_WIDTH + INNER_WIDTH)/2, DEPTH/2, HEIGHT/2 - .1]) rotate([0, 90, 0]) 
    cylinder(d=VACUUM_OD + TOLERANCE, h=OUTER_WIDTH + .2); // vacuum port inner hole

  translate([OUTER_WIDTH/2 - SAW_BLADE_OD_WIDTH/2, DEPTH/2 - THICKNESS, HEIGHT/2 + THICKNESS]) rotate([0, 90, 0]) cylinder(d=25, h=OUTER_WIDTH);
  translate([OUTER_WIDTH/2 - SAW_BLADE_OD_WIDTH/2, DEPTH/2, HEIGHT/2 - TOLERANCE/2]) rotate([0, 90, 0]) 
    cylinder(d1=25, d2=VACUUM_OD + TOLERANCE*2, h=INNER_WIDTH*.68);

  translate([(OUTER_WIDTH - SAW_BLADE_ID_WIDTH)/2, -SAW_BLADE_OFFSET, SAW_BLADE_OD/2 - 2]) rotate([0, 90, 0]) rotate_extrude(angle = 90) { // saw blade
    polygon([ [0, 0], [SAW_BLADE_OD/2 + TOLERANCE, (SAW_BLADE_ID_WIDTH - SAW_BLADE_OD_WIDTH + TOLERANCE)/2],
      [SAW_BLADE_OD/2 + TOLERANCE, (SAW_BLADE_ID_WIDTH + SAW_BLADE_OD_WIDTH + TOLERANCE)/2], [0, SAW_BLADE_ID_WIDTH], ]);
  }

  translate([(OUTER_WIDTH - DEPTH*1.5)/2, 0, HEIGHT]) rotate([-30, 0, 0]) cube(DEPTH * 1.5); // angle for original vacuum
  translate([0, -.1, -.1]) cube([OUTER_WIDTH, CENTRAL_CIRCLE_OVERLAP + .1, CENTRAL_CIRCLE_HEIGHT + .1]); // cutout saw base
  translate([OUTER_WIDTH/2, DEPTH - CONE_DEPTH, 0]) rotate([-90, 0, 0]) cylinder(d1=CONE_ID, d2=CONE_OD, h=CONE_HEIGHT); // back cone
  translate([0, -OUTER_WIDTH, 0]) cube(OUTER_WIDTH); // front cutoff
  translate([(OUTER_WIDTH - INNER_WIDTH * 2 - .2)/2, 0, HEIGHT - INNER_WIDTH/1.5]) rotate([30, 0, 0]) cube(INNER_WIDTH * 2 + .2); // top cutoff
  translate([(OUTER_WIDTH - INNER_WIDTH * 2 - .2)/2, DEPTH, HEIGHT - INNER_WIDTH*1.5]) rotate([15, 0, 0]) cube(INNER_WIDTH * 2 + .2);
}

