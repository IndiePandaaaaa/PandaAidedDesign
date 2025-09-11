// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

thickness = 3;
$fn = $preview ? 25 : 125;

transferBit = [25, 5, 16]; // [cutting bit height, bearing height, bit diameter]
supportWidth = 42;

uLatte = [44, 24];

// TODO: Maße uLatte in das Modell schreiben als Text
// TODO: Ausleger für Zwingenmontage

// DACHLATTEN-INTERSECTION
//union() {
//  //  cube(size=[uLatte[0] + supportWidth * 2, uLatte[0] + supportWidth * 2, thickness], center=true);
//  color(c="brown", alpha=1.0) cube(size=[uLatte[0], uLatte[0] + supportWidth * 2 + .2, uLatte[1]], center=true);
//  color(c="darkgrey", alpha=1.0) {
//    translate(v=[0, 0, uLatte[1] / 4 + .1]) cube(size=[uLatte[0] + transferBit[2], uLatte[0], uLatte[1] / 2 + .2], center=true);
//    translate(v=[0, 0, (uLatte[1] + transferBit[0]) / 2]) cube(size=[uLatte[0] + transferBit[2], uLatte[0], uLatte[1] + transferBit[0]], center=true);
//  }
//}

module circular_guide(diameter, depth, support_plate_height, min_depth = 3) {
  remaining_height = transferBit[0] + transferBit[1] - 3;

  difference() {
    union() {
      cylinder(h=remaining_height, r=diameter / 2 + thickness, center=false);
      for (i = [0:3])
        rotate(a=360 / 8 * i, v=[0, 0, 1]) translate(v=[0, 0, (remaining_height - 2) / 2]) cube(size=[diameter + thickness * 2 + 50, 14, remaining_height - 2], center=true);
    }
    if (support_plate_height != 0) {
      translate(v=[0, 0, remaining_height - support_plate_height]) difference() {
          cylinder(h=support_plate_height, r=diameter / 2 + 75, center=false);
          translate(v=[0, 0, -.1]) cylinder(h=support_plate_height + .2, r=diameter / 2 + thickness, center=false);
        }
    }
    translate(v=[0, 0, -.1]) color(c="red", alpha=1.0) cylinder(h=remaining_height + .2, r=diameter / 2, center=false);

    for (i = [0:7])
      rotate(a=360 / 8 * i, v=[0, 0, 1]) rotate(a=180, v=[1, 0, 0]) translate(v=[(diameter + thickness * 2 + 50) / 2 - 7, 0, 0]) screw(diameter=3.5, length=20, cutout_sample=true);
  }
}

circular_guide(diameter=59, depth=22.5 - 10, support_plate_height=24, min_depth=3);
translate(v=[0, 0, 40]) circular_guide(diameter=22.5, depth=22.5 - 10, support_plate_height=24, min_depth=3);
