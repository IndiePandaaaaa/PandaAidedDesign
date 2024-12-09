// created by IndiePandaaaaa | Lukas
// encoding: utf-8

use <Parts/Screw.scad>

SCREWS = 3;  // per width
WIDTH = 42.5; // width of the bracket
SIDES = 0; // new height

module LBracket(screws, width, chamfer = 1, screw_od = 3.5, thickness = 3.5, sides=0) {
  width_needed = (cone_diameter_cutout(screw_od) + 1 * 2 + thickness) * screws + thickness;
  sides_needed = cone_diameter_cutout(screw_od) + 2 + chamfer * 3 + thickness;

  if (width < width_needed) {
    echo("GIVEN WIDTH IS TOO SMALL!");
    echo("=> CHANGING WIDTH TO: ", width_needed);

    linear_extrude(1) {
      translate([screw_od * 7, 0, 0]) text("width changed! (review log)", 15);
    }
  }
  width_used = width < width_needed ? width_needed:width;

  sides_used = sides < sides_needed ? sides_needed:sides; 
  solidifier = screws + 1;
  width_inbetween = (width_used - thickness * solidifier) / screws;

  difference() {
    union() {
      linear_extrude(width_used) {
        polygon([
            [0, 0],
            [thickness, 0],
            [thickness, sides_used - thickness - chamfer],
            [thickness + chamfer, sides_used - thickness],
            [sides_used, sides_used - thickness],
            [sides_used, sides_used],
            [chamfer, sides_used],
            [0, sides_used - chamfer],
          ]);
      }

      for (i = [1:solidifier]) {
        offset_z_solidifier = width_inbetween * (i - 1) + thickness * (i - 1);
        translate([chamfer, 0, offset_z_solidifier])
          cube([sides_used - chamfer, sides_used - chamfer, thickness]);
      }
    }
    cube_size = sides_used * width_used;
    translate([thickness - chamfer * 1.25, -chamfer / 2, -chamfer / 2]) rotate([0, 0, -45])
      cube(cube_size + chamfer);

    for (i = [0:screws - 1]) {
      offset_z_screw = thickness + width_inbetween / 2 + (thickness + width_inbetween) * i;
      rotation = [[0, 90, 0], [0, 90, -90]];
      translation = [[thickness, (sides_used - thickness) / 2, offset_z_screw],
          [thickness + (sides_used - thickness) / 2, sides_used - thickness, offset_z_screw]];

      if (screws == 1 || screws == 2) {
        translate(translation[(i + 1) % 2]) rotate(rotation[(i + 1) % 2])
          screw(screw_od, thickness * 2, true);
      }

      translate(translation[i % 2]) rotate(rotation[i % 2]) screw(screw_od, thickness * 2, true);
    }
  }
}

LBracket(SCREWS, WIDTH, sides=SIDES);
