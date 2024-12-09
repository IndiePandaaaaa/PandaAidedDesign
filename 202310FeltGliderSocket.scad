// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>;

THICKNESS = 3.0;
TOLERANCE = 0.1;
CHAMFER = 1.5;
SCREW_OD = 3.5;
$fn = 75;

POST_WIDTH = 53;
FELTGLIDER_OD = 22;

WITH_OFFSET_PLATE = true;
OFFSET_PLATE_THICKNESS = 3.1;

module plate_square_offset(width, thickness, chamfer = 1) {
  translate([0, thickness + 7, 0]) rotate([90, 0, 0]) linear_extrude(thickness) {
    polygon([
        [0, chamfer],
        [chamfer, 0],
        [width - chamfer, 0],
        [width, chamfer],
        [width, width - chamfer],
        [width - chamfer, width],
        [chamfer, width],
        [0, width - chamfer],
      ]);
  }
}

module plate_square_chamfered(width, thickness, chamfer = 1) {
  intersection() {
    linear_extrude(width) {
      polygon([
          [0, chamfer],
          [chamfer, 0],
          [width - chamfer, 0],
          [width, chamfer],
          [width, thickness],
          [0, thickness],
        ]);
    }
    translate([0, thickness, 0]) rotate([90, 0, 0]) linear_extrude(thickness) {
      polygon([
          [0, chamfer],
          [chamfer, 0],
          [width - chamfer, 0],
          [width, chamfer],
          [width, width - chamfer],
          [width - chamfer, width],
          [chamfer, width],
          [0, width - chamfer],
        ]);
    }
  }

}

difference() {
  translate([0, POST_WIDTH, 0]) rotate([90, 0, 0]) {
    union() {
      intersection() {
        plate_square_chamfered(POST_WIDTH, THICKNESS, CHAMFER);
        translate([0, 0, POST_WIDTH]) rotate([0, 90, 0]) plate_square_chamfered(POST_WIDTH, THICKNESS, CHAMFER);
      }
      if (WITH_OFFSET_PLATE) {
        plate_square_offset(POST_WIDTH, OFFSET_PLATE_THICKNESS, CHAMFER);
      }
    }
  }

  usable_width = POST_WIDTH - CHAMFER * 2;
  feldglider_size = FELTGLIDER_OD + 1 ;
  edge_offset = (usable_width - feldglider_size * 2) / 2 + feldglider_size / 2;
  for (x = [0:1]) {
    for (y = [0:1]) {
      translate([edge_offset + (POST_WIDTH - edge_offset * 2) * x, edge_offset + (POST_WIDTH - edge_offset * 2
      ) * y, 0]) cylinder(h = 0.7, d = FELTGLIDER_OD);
    }
  }
  translate([POST_WIDTH / 2, POST_WIDTH / 2, 0]) rotate([0, 180, 0]) screw(SCREW_OD, 12, true);
}

