// created by Lukas|@IndiePandaaaaa
// encoding: utf-8

use <202507MainboardTestBench.scad>
use <202306lBracket.scad>

$fn = $preview ? 25 : 75;

microATX = [0, 1, 2, 4, 5, 6, 7, 9, 10];

module hdd_plate() {
  module vibe_fix_cutout() {
    translate(v=[3.25, 0, -.1]) union() {
        translate(v=[-3.25, 0, 0]) {
          cylinder(h=3 + .2, r=7.8 / 2, center=false);
          translate(v=[0, 0, .8]) cylinder(h=2.3 + .1, r=10.5 / 2, center=false);
        }
        translate(v=[3.25, 0, 0]) cylinder(h=3 + .2, r=10.5 / 2, center=false);
      }
  }

  module hdd_mountings() {
    for (i = [0:3])
      translate(v=[i % 2 * 41.6, (i < 2 ? 0 : 1) * 27, 0]) rotate(a=180, v=[0, 0, i % 2]) vibe_fix_cutout();
  }

  module plate_case_mountings_M3() {
    for (i = [0:3])
      translate(v=[i % 2 * 37.5, (i < 2 ? 0 : 1) * 30, -.1]) cylinder(h=6 + .2, r=2.7 / 2, center=false);
  }

  // case plate
  depth = 42;
  screws_x = 7.5;
  difference() {
    union() {
      cube(size=[70, depth, 3], center=false);
      for (i = [0:1]) translate(v=[screws_x + 15 + i * 37.5, 0, 0]) cube(size=[10, depth, 6]);
    }
    translate(v=[screws_x, 7, 0]) hdd_mountings();
    translate(v=[screws_x + 15 + 5, 6, 0]) plate_case_mountings_M3();
  }

  // hdd stabilization plate
  translate(v=[0, depth + 8, 0]) difference() {
      cube(size=[57, depth, 3], center=false);
      translate(v=[screws_x, 7, 0]) hdd_mountings();
    }
}

mainboard_support_grid(mainboard=microATX, standoff_height=8, strap_height=3);

translate(v=[30, -120, 0]) hdd_plate();

translate(v=[120, -42, 0]) rotate(a=90, v=[0, -1, 0]) LBracket(screws=1, width=16.5, chamfer=1, screw_od=3.5, thickness=3.5, sides=0);
