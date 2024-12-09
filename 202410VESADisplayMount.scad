// created by IndiePandaaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>
use <Functions/Fillet.scad>

TOLERANCE = .1;
THICKNESS = 3;
$fn = 75;

// M4 Screws
M4HEADOD = 7.2;
M4HEADHEIGHT = 4.5;
M4OD = 4.0;

// Wood Screws
SCREWOD = 3.5;


VESA = 100;

module vesa_plate(vesa_standard, frame_width = 12) {
  frame_thickness = M4HEADHEIGHT + THICKNESS + TOLERANCE;
  frame_mounting_width = frame_width * 1.25;
  frame_mounting_diff = (frame_mounting_width - frame_width) / 2;
  monitor_screws = [[0, 0], [0, vesa_standard], [vesa_standard, 0], [vesa_standard, vesa_standard]];
  wood_screws = [[frame_mounting_width / 2, 0], [vesa_standard - frame_mounting_width / 2, 0],
      [0, vesa_standard - frame_mounting_width / 2], [vesa_standard, vesa_standard - frame_mounting_width / 2]];


  module wood_screw() {
    screw(SCREWOD + TOLERANCE, frame_thickness + .2, true);
    translate([0, 0, -.1]) cylinder(d = cone_diameter_cutout(SCREWOD), h = frame_thickness);
  }

  difference() {
    linear_extrude(frame_thickness) {
      frame_circle_distance = cos(45) * vesa_standard;
      mounting_screws = [[frame_mounting_width / 2, frame_mounting_diff / 2],
          [vesa_standard - frame_mounting_width / 2, frame_mounting_diff / 2],
          [-vesa_standard + frame_mounting_width / 2, frame_mounting_diff / 2],
          [-vesa_standard + frame_mounting_width / 2, vesa_standard - frame_mounting_diff / 2]];

      translate([-vesa_standard / 2, -vesa_standard / 2])
        for (i = [0:len(monitor_screws) - 1]) {translate([monitor_screws[i][0], monitor_screws[i][1]]) circle(d =
        frame_width);}

      rotate([0, 0, 45]) polygon([
          [-frame_circle_distance, frame_width / 2],
          [-frame_circle_distance, -frame_width / 2],
          [-frame_width / 2, -frame_width / 2],
          [-frame_width / 2, -frame_circle_distance],
          [frame_width / 2, -frame_circle_distance],
          [frame_width / 2, -frame_width / 2],
          [frame_circle_distance, -frame_width / 2],
          [frame_circle_distance, frame_width / 2],
          [frame_width / 2, frame_width / 2],
          [frame_width / 2, frame_circle_distance],
          [-frame_width / 2, frame_circle_distance],
          [-frame_width / 2, frame_width / 2],
        ]);

      translate([-vesa_standard / 2, -vesa_standard / 2]) for (i = [0:len(mounting_screws) - 1]) {
        rotate([0, 0, i > 1 ? -90 : 0]) translate([mounting_screws[i][0], mounting_screws[i][1]])
          square([frame_mounting_width, frame_width + frame_mounting_diff], center = true);
      }

      square(frame_width * 2, center = true);
    }

    translate([-vesa_standard / 2, -vesa_standard / 2, 0]) {
      for (i = [0:len(monitor_screws) - 1]) {
        translate([monitor_screws[i][0], monitor_screws[i][1], -.1]) {
          cylinder(d = M4OD, h = frame_thickness + .2);
          cylinder(d = M4HEADOD, h = M4HEADHEIGHT + .1);
        }
      }

      for (i = [0:len(wood_screws) - 1]) {
        translate([wood_screws[i][0], wood_screws[i][1], frame_thickness - 1]) {
          wood_screw();
          rotate([0, -90, 90]) linear_extrude(12) {projection() rotate([0, 90, 0]) wood_screw();}
        }
      }
    }
  }
}


vesa_plate(VESA);

