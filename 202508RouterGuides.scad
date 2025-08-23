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

union() {
  //  cube(size=[uLatte[0] + supportWidth * 2, uLatte[0] + supportWidth * 2, thickness], center=true);
  color(c="brown", alpha=1.0) cube(size=[uLatte[0], uLatte[0] + supportWidth * 2 + .2, uLatte[1]], center=true);
  color(c="darkgrey", alpha=1.0) {
    translate(v=[0, 0, uLatte[1] / 4 + .1]) cube(size=[uLatte[0] + transferBit[2], uLatte[0], uLatte[1] / 2 + .2], center=true);
    translate(v=[0, 0, (uLatte[1] + transferBit[0]) / 2]) cube(size=[uLatte[0] + transferBit[2], uLatte[0], uLatte[1] + transferBit[0]], center=true);
  }
}
