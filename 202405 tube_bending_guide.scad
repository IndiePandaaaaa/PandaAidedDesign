// created by IndiePandaaaaa
// encoding: utf-8

$fn = 75;

VICE_PART = true;
TUBE_DIAMETER = 14;
BEND_RADIUS = 14;

module bending_guide(diameter, radius, angle = [90, 60, 45], for_vice = false, thickness = 2.5, tolerance = .2) {
  module tube(diameter, radius, angle, size = 100) {
    union() {
      rotate_extrude(angle = angle) {
        translate([radius, 0, 0]) circle(d = diameter);
      }

      translate([radius, .1, 0]) rotate([90, 0, 0])
        cylinder(d = diameter, h = size);
      rotate([0, 0, angle]) translate([radius, size - .1, 0]) rotate([90, 0, 0]) 
        cylinder(d = diameter, h = size);
    }
  }

  module stacked_tube(diameter, radius, angle, height, size = 100) {
    height_distance = 0.5;

    union() {
      for (i = [0:height / height_distance]) {
        translate([0, 0, height_distance * i])
          tube(diameter, radius, angle, size);
      }
    }
  }
  
  module bending_plate(diameter, radius, angle, for_vice, thickness, tolerance) {
    difference() {
      cube([size, size, plate_height]);
      for (i = [0:len(angle) - 1]) {
        translate([border_offset(radius, diameter) + diameter * 1.25 * i,
          border_offset(radius, diameter) + diameter * i, thickness + diameter / 2]) 
          stacked_tube(diameter + tolerance, radius, angle[i], height = plate_height - thickness);
      }
    }
  }

  function border_offset(radius, diameter) = radius;

  plate_height = for_vice ? thickness + diameter * 0.48 : thickness + diameter * 2 / 3;
  size = (border_offset(radius, diameter) * 2 / 3 + diameter * 1.25) * len(angle);


  
  for (m = [0:for_vice ? 1 : 0]) {
    difference() {
      mirror([m, 0, 0]) translate([5 * m, 0, 0]) {
        bending_plate(diameter, radius, angle, for_vice, thickness, tolerance);
      }

      translate([1 - (radius + 4) * m, 2, plate_height - 1.5]) linear_extrude(1.6) {
        text(str(radius), size = radius / 2, font = "FiraCode Nerd Font:style=Retina");
      }
    }
  }
}

bending_guide(TUBE_DIAMETER, radius = BEND_RADIUS, for_vice = VICE_PART);
