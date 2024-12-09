// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

$fn = 75;

module cool_frame(pi_version = 3) {
  module frame_shape(pi_version, length = 82.5, mounting_screw_od = 3.5) {
    // todo: integrate pi_version == 5
    height = pi_version == 3 ? 2 : 3.6;

    difference() {
      union() {
        translate([0, length, 0]) rotate([90, 0, 0]) linear_extrude(length) {
          polygon([
              [0, 0],
              [80, 0],
              [80, 35],
              [73, 35],
              [73, 32],
              [77, 28],
              [77, 5.5],
              [74.5, 3],
              [70, 3],
              [70, 3 + height],
              [58, 3 + height],
              [58, 3],
              [22, 3],
              [22, 3 + height],
              [10, 3 + height],
              [10, 3],
              [5.5, 3],
              [3, 5.5],
              [3, 28],
              [7, 32],
              [7, 35],
              [0, 35],
            ]);
        }
        translate([10, length - .1, 0]) for (i = [0:1]) {
          translate([48 * i, 0, 0]) cube([12, mounting_screw_od * 4, 3 + height]);
        }
      }

      // pi_version to identify the frame version
      translate([.5, 14, 7]) rotate([90, 0, 270]) linear_extrude(.5 + .1) {
        text(str(pi_version), font = "LiberationMono");
      }
      translate([80 + .1, 14, 7]) rotate([90, 0, 270]) mirror([1, 0, 0]) translate([-8.32, 0, 0]) linear_extrude(.5 + .1
      ) {
        text(str(pi_version), font = "LiberationMono");
      }

      // cutout mounting screw in bottom plate
      translate([80 / 2, 5, 3.1]) {
        screw(mounting_screw_od, 12, true);
        translate([0, -5.1, 0]) scale([1, 1002, 1]) difference() {
          size = 12;
          screw(mounting_screw_od, size - 2, true);
          translate([-size / 2, .005, -size + .1]) cube(size);
          translate([-size / 2, -.005 - size, -size + .1]) cube(size);
        }
      }

      // mounting screws
      translate([10 + 6, length + mounting_screw_od * 2 + 1, 3 + height + .1]) for (i = [0:1]) {
        translate([48 * i, 0, 0]) screw(mounting_screw_od, 12, true);
      }
    }
  }

  module pi_mounting() {
    locations = [[0, 0], [49, 0], [0, 58], [49, 58]];

    translate([(80 - 49) / 2, 18, -.1]) for (i = [0:len(locations) - 1]) {
      translate([locations[i][0], locations[i][1], 0]) union() {
        cylinder(d = 6, 3.5 + .1);
        cylinder(d = 3, 12);
      }
    }
  }

  module fan_mounting() {
    locations = [[0, 0], [0, 71.5]];
    cable_tie_width = 2.7;
    border_offset = (80 - 71.5) / 2 - cable_tie_width / 2;

    translate([border_offset, border_offset, 35 + 2]) {
      for (x = [0:1]) {
        for (y = [0:len(locations) - 1]) {
          translate([3.75 + 67 * x, locations[y][1], 0]) mirror([x, 0, 0]) rotate([0, 180 + 45, 0]) cube([1.5,
            cable_tie_width, 12]);
        }
      }
    }
  }

  union() {
    difference() {
      frame_shape(pi_version);
      pi_mounting();
      fan_mounting();

      // IO and fan cutout/cutoff
      translate([-.1, 15, 7]) {
        cube([85, 80, 35 - 7 * 2]);
        translate([0, 65, 20]) cube([85, 30, 10]);
      }
    }
  }
}

cool_frame(3);
translate([0, 100, 0]) cool_frame(4);
