// created by IndiePandaaaaa
// encoding: utf-8

$fn = 75;

VICE_PART = false;
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
  
  module bending_plate(diameter, radius, size, plate_height, angle, for_vice, thickness, tolerance) {
    difference() {
      cube([size, size, plate_height]);
      for (i = [0:len(angle) - 1]) {
        translate([border_offset(radius, diameter) + diameter * 1.25 * i,
          border_offset(radius, diameter) + diameter * i, thickness + diameter / 2]) 
          stacked_tube(diameter + tolerance, radius, angle[i], height = plate_height - thickness);
      }
    }
  }

  module perpendicular_only(diameter, radius, size, plate_height, angle, thickness, tolerance) {
    difference() {
      cube([size, size, plate_height]);

      translate([size - radius * 1.875, size - radius * 1.875, thickness + diameter / 2])
        stacked_tube(diameter + tolerance, radius, angle, height = plate_height - thickness);

      translate([-radius * 1.75, -radius * 1.75, -.1]) cube([size, size, plate_height + .2]);
      /*
      distance = radius * 1.5;
      cube([size, size, plate_height]);

      translate([size - distance, size - distance, thickness + diameter / 2])
        stacked_tube(diameter + tolerance, radius, angle, height = plate_height - thickness);

      translate([-distance * 0.75, -distance * 0.75, -.1]) cube([size, size, plate_height + .2]);
      */
    }
  }

  function border_offset(radius, diameter) = radius;

  plate_height = for_vice ? thickness + diameter * 0.48 : thickness + diameter * 0.75;
  size = (border_offset(radius, diameter) * 2 / 3 + diameter * 1.25) * len(angle);
  
  for (m = [0:for_vice ? 1 : 0]) {
    difference() {
      mirror([m, 0, 0]) translate([5 * m, 0, 0]) {
        bending_plate(diameter, radius, size, plate_height, angle, for_vice, thickness, tolerance);
      }

      translate([1 - (radius + 4) * m, 2, plate_height - 1.5]) linear_extrude(1.6) {
        text(str(radius), size = radius / 2, font = "FiraCode Nerd Font:style=Retina");
      }
    }
  }
  translate([0, 0, 20]) perpendicular_only(diameter, radius, size, plate_height, 90, thickness, tolerance);
}

bending_guide(TUBE_DIAMETER, radius = BEND_RADIUS, for_vice = VICE_PART);
