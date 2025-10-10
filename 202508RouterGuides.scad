// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

thickness = 3;
$fn = $preview ? 25 : 125;

transferBitHeight = 25; // bit cutting height
transferBitBearing = 5; // bit bearing height
transferBitOD = 16; // bit outer diameter
transferBit = [transferBitHeight, transferBitBearing, transferBitOD];
supportWidth = 42;

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

module ulatte_cutout() {
  difference() {
    union() {
      // guide
      cube(size=[10, 3, 22 + .1], center=false);
      translate(v=[10 - 2.5, 0, 0]) cube(size=[2.5, 30, 22 + .1], center=false);
      translate(v=[0, 0, 22]) cube(size=[70, 30, 3.5], center=false);
      translate(v=[0, 0, 22 + 3.5 - .1]) cube(size=[70, 3, 17.5 + .1], center=false);

      // wood sample
      translate(v=[-2.5, 3 + .2, 22 + 3.5 + .2]) color(c="brown", alpha=1.0) cube(size=[75, 50, 17.7], center=false);

      // wood support
      translate(v=[0, 36, 22]) cube(size=[70, 14, 3.5], center=false);
    }

    // screws
    for (i = [0:3]) {
      translate(v=[15 + (i % 2) * 40, 15 + (i < 2 ? 0 : 1) * 28, 22.1]) rotate(a=180, v=[0, 1, 0]) screw(diameter=3.5, length=16, cutout_sample=true);
    }
  }
}

// circular desk cable management guide:
circular_guide(diameter=60, depth=22.5 - 10, support_plate_height=24, min_depth=3);
//ulatte_cutout();
