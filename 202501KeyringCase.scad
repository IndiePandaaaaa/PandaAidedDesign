// created by IndiePandaaaaa|Lukas
// encoding: utf-8

TOLERANCE = .15;
THICKNESS = 2;
$fn = $preview? 25:125;

KEY_LENGTH = 64.8;
KEY_WIDTH = 25.3;
KEY_RADIUS = 7.2;
KEY_HOLE = [6.2, 5.2, 5.2]; // diameter, X Pos, Y Pos

module case() {
  module key_shape(size_added=0) {
    circle_loc = [
      [KEY_RADIUS, KEY_RADIUS], 
      [KEY_LENGTH - KEY_RADIUS + size_added*2, KEY_RADIUS], 
      [KEY_LENGTH - KEY_RADIUS + size_added*2, KEY_WIDTH - KEY_RADIUS + size_added*2], 
      [KEY_RADIUS, KEY_WIDTH - KEY_RADIUS + size_added*2]
    ];
    
    translate([-size_added, -size_added]) union() {
      polygon([
        [0, KEY_RADIUS],
        [KEY_RADIUS, 0],
        [KEY_LENGTH - KEY_RADIUS + size_added*2, 0],
        [KEY_LENGTH + size_added*2, KEY_RADIUS],
        [KEY_LENGTH + size_added*2, KEY_WIDTH - KEY_RADIUS + size_added*2],
        [KEY_LENGTH - KEY_RADIUS + size_added*2, KEY_WIDTH + size_added*2],
        [KEY_RADIUS, KEY_WIDTH + size_added*2],
        [0, KEY_WIDTH - KEY_RADIUS + size_added*2],
      ]);

      for (i=[0:len(circle_loc) - 1]) {
        translate(circle_loc[i]) circle(r=KEY_RADIUS);
      }
    }
  }
  
  union() {
    linear_extrude(THICKNESS*2 + TOLERANCE) { // key border
      difference() {
        key_shape(size_added=THICKNESS+TOLERANCE);  // outer contour
        key_shape(size_added=0);  // inner contour
      }
    }
    linear_extrude(THICKNESS) {
      finger_hole = [18, 15, 3];
      difference() {
        key_shape(size_added=TOLERANCE*2); // outer contour
        translate([KEY_LENGTH/2 - finger_hole[0]/2, KEY_WIDTH/2 - finger_hole[1]/2]) minkowski() { // inner contour
          translate([finger_hole[2], finger_hole[2]]) square([finger_hole[0] - finger_hole[2]*2 - TOLERANCE, finger_hole[1] - finger_hole[2]*2 - TOLERANCE]);
          circle(r=KEY_RADIUS + TOLERANCE/2);
        }
        translate([KEY_HOLE[1], KEY_HOLE[2]]) circle(d=KEY_HOLE[0]);
      }
    }
  }
}

case();
