// created by IndiePandaaaaa|Lukas
// encoding: utf-8

TOLERANCE = .15;
THICKNESS = 2;
$fn = $preview? 25:125;

KEY_LENGTH = 64.8;
KEY_WIDTH = 25.3;
KEY_RADIUS = 7.2;
KEY_HOLE = [6.2, 6, 5]; // diameter, X Pos, Y Pos

module case() {
  union() {
    linear_extrude(THICKNESS*2 + TOLERANCE) { // key border
      difference() {
        minkowski() {  // outer contour
          square([KEY_WIDTH - KEY_RADIUS - TOLERANCE + THICKNESS, KEY_LENGTH - KEY_RADIUS - TOLERANCE + THICKNESS], center=true);
          circle(r=KEY_RADIUS + TOLERANCE/2 + THICKNESS);
        }
        minkowski() {  // inner contour
          square([KEY_WIDTH - KEY_RADIUS - TOLERANCE, KEY_LENGTH - KEY_RADIUS - TOLERANCE], center=true);
          circle(r=KEY_RADIUS + TOLERANCE/2);
        }
      }
    }
    translate([0, 0, -THICKNESS]) linear_extrude(THICKNESS + TOLERANCE) {
      difference() {
        minkowski() { // outer contour
          square([KEY_WIDTH - KEY_RADIUS - TOLERANCE + THICKNESS, KEY_LENGTH - KEY_RADIUS - TOLERANCE + THICKNESS], center=true);
          circle(r=KEY_RADIUS + TOLERANCE/2 + THICKNESS);
        }
        minkowski() { // inner contour
          square([18 - 3 - TOLERANCE, 18 - 3 - TOLERANCE], center=true);
          circle(r=KEY_RADIUS + TOLERANCE/2);
        }
        translate([-KEY_WIDTH/2 - KEY_HOLE[0]/2 + KEY_HOLE[2], KEY_LENGTH/2 + KEY_HOLE[0]/2 - KEY_HOLE[1]]) circle(d=KEY_HOLE[0]);
      }
    }
  }
}

case();
