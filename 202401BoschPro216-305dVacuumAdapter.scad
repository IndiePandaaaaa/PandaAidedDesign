// created by IndiePandaaaaa|Lukas
// encoding: utf-8

THICKNESS = 3;
TOLERANCE = .15;
$fn = $preview ? 50 : 100;

VACUUM_OD = 34.2;
SPLITTED_PRINT = true;

//#CENTRAL_CIRCLE_HEIGHT = 17;
//#CENTRAL_CIRCLE_OVERLAP = 12;
//#CENTRAL_CIRCLE_CONE_DISTANCE = 25.6;
//#CONE_ID = 55;
//#CONE_OD = 89.6;
//#CONE_HEIGHT = 35;
//#CONE_DEPTH = 15;
//#SAW_BLADE_OD_WIDTH = 7;
//#SAW_BLADE_ID_WIDTH = 30;
//#SAW_BLADE_OD = 216;
//#SAW_BLADE_OFFSET = SAW_BLADE_OD/2 - (75 - CENTRAL_CIRCLE_OVERLAP) + 30;
//#
//#OUTER_WIDTH = CONE_ID * 1.5;  // max 115
//#INNER_WIDTH = 22;
//#DEPTH = 75 + CONE_DEPTH;
//#HEIGHT = 60;
//#
//#VACCUM_HEIGHT = HEIGHT - (VACUUM_OD/2 + THICKNESS);
//#
//#union() {
//#  translate([OUTER_WIDTH/2, 0, 0]) union() color("#424242") {  // base
//#    rotate([-90, 0, 0]) difference() {
//#      cylinder(d1=INNER_WIDTH, d2=OUTER_WIDTH, h=DEPTH);
//#      translate([-CONE_OD, 0, -DEPTH]) cube(CONE_OD * DEPTH);
//#    }
//#    translate([-INNER_WIDTH/2, 0, .1]) cube([INNER_WIDTH, DEPTH, HEIGHT]); // central block collecting dust from blade
//#//    translate([0, DEPTH/2, VACCUM_HEIGHT]) rotate([0, 90, 0]) cylinder(d=VACUUM_OD + THICKNESS * 2 + TOLERANCE,h=OUTER_WIDTH/2); // vacuum port
//#  }
//#
//#/*  // vacuum air channel
//#  translate([(OUTER_WIDTH + INNER_WIDTH)/2, DEPTH/2, VACCUM_HEIGHT - .1]) rotate([0, 90, 0]) 
//#    cylinder(d=VACUUM_OD + TOLERANCE, h=OUTER_WIDTH + .2); // vacuum port inner hole
//#  translate([OUTER_WIDTH/2 - SAW_BLADE_OD_WIDTH/2, DEPTH/2 - THICKNESS, VACCUM_HEIGHT + THICKNESS]) rotate([0, 90, 0]) cylinder(d=25, h=OUTER_WIDTH);
//#  translate([OUTER_WIDTH/2 - SAW_BLADE_OD_WIDTH/2, DEPTH/2, VACCUM_HEIGHT - TOLERANCE/2]) rotate([0, 90, 0]) 
//#    cylinder(d1=25, d2=VACUUM_OD + TOLERANCE*2, h=INNER_WIDTH*.68); */
//#
//#  // saw blade
//#  translate([(OUTER_WIDTH - SAW_BLADE_OD_WIDTH)/2, -SAW_BLADE_OFFSET, SAW_BLADE_OD/2 - 2]) rotate([0, 90, 0]) {
//#    cylinder(d=SAW_BLADE_OD, h=SAW_BLADE_OD_WIDTH);
//#  }
//#
//#  // machine base circle cutout
//#  translate([0, -.1, -.1]) cube([OUTER_WIDTH, CENTRAL_CIRCLE_OVERLAP + .1, CENTRAL_CIRCLE_HEIGHT + .1]);
//#
//#  // machine base back cone cutout
//#  translate([OUTER_WIDTH/2, DEPTH - CONE_DEPTH, 0]) rotate([-90, 0, 0]) cylinder(d1=CONE_ID, d2=CONE_OD, h=CONE_HEIGHT);
//#
//#/*  if (SPLITTED_PRINT) {  // screws and central cut
//#    pos = [ [5, 5], [32, 38] ];
//#    translate([(OUTER_WIDTH - SAW_BLADE_OD_WIDTH)/2, -.1, -.1]) cube([.1, DEPTH + .2, HEIGHT + .2]);
//#    for (i = [0:len(pos)-1]) {
//#      translate([(OUTER_WIDTH - INNER_WIDTH - .2)/2, pos[i][0], CENTRAL_CIRCLE_HEIGHT + pos[i][1]]) rotate([0, 90, 0]) union() {
//#        cylinder(d=2.5, h=20);
//#        cylinder(d=3.2, h=(INNER_WIDTH - SAW_BLADE_OD_WIDTH + .3)/2);
//#        cylinder(d1=6, d2=3.2, h=2.2);
//#      }
//#    }
//#  }*/
//#}

module saw_base(backspace_shape=false, rotation=0, max_rotation=48) {
  module wood_stops(rotation_guide=false) {
    for (i=[0:1]) mirror([0, i, 0]) translate([0, -16/2, 0]) rotate([0, 0, 180 - (rotation_guide? max_rotation:0)]) difference() { // wood stops
      ws_size = [30, 140, 41];
      union() {
        cube(ws_size);
        if (rotation_guide)
          translate([-ws_size[1]+.1, 0, 0]) cube([ws_size[1], ws_size[1], ws_size[2]]);
      }
      translate([16.5, -.1, ws_size[2] - 16.3]) cube([ws_size[0], ws_size[1] + .2, ws_size[2]]);
      translate([3, 0, -.1]) rotate([0, 0, -(90-max_rotation)]) cube(45);
      translate([-.1, -.1, 27]) rotate([atan(14/33), 0, 0]) cube(45);
    }
  }

  module central_connect() {
    difference() { // backside cylinder, connecting the wood stops
      bs_cy_size = [74*2, 15.2, 58, 34];
      cylinder(d=bs_cy_size[0], h=bs_cy_size[1]); 
      translate([0, 0, -.1]) cylinder(r2=bs_cy_size[2], r1=bs_cy_size[3], h=bs_cy_size[1] + .2);
      translate([-.1, -bs_cy_size[0]/2, -.1]) cube(bs_cy_size[0]);
    }
  }
  
  module rotating_base() {
    translate([0, 0, -40]) rotate([0, 0, rotation]) union() { // rotating base
      rb_size = [260, 40];
      cylinder(d=rb_size[0], h=rb_size[1]);
      translate([-100 + .1, 0, rb_size[1]]) rotate([0, -90, 0]) cylinder(d2=90, d1=53.7, h=33.8); // back cone
    }
  }

  difference() {
    if (!backspace_shape) {
      union() {
        wood_stops();
        rotating_base();
        central_connect();
      }
    }

    cutout_height = 1;
    translate([0, 0, -cutout_height]) rotate([0, 0, rotation]) linear_extrude(cutout_height + .1) projection() difference() {
      intersection() {
        translate([0, 0, .1]) cylinder(d=260.1, h=cutout_height);
        translate([-175, 0, 0]) cube(260, center=true);
      }
      union() {
        rotating_base();
        central_connect();
        wood_stops(true);
      }
    }
  }
}

module saw_head() {
  module saw_blade() {
    blade_size = [216, 5, 25, 260/2];
    union() {
      translate([blade_size[2], blade_size[1]/2, -2]) rotate([90, 0, 0]) {
        for (i = [0:1]) {translate([blade_size[3]*i, blade_size[0]/2, 0]) cylinder(d=blade_size[0], h=blade_size[1]);}
        cube([blade_size[3], blade_size[0], blade_size[1]]);
      }
    }
  }

  saw_blade();
}
difference() { // testpiece
//  translate([-115, 1, -1.5]) rotate([90, 0, 0]) cube([90, 42, 2]);
  color("#005555") saw_base(false);
}

color("#777777") saw_head();

