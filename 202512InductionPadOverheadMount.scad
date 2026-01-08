// created by IndiePandaaaaa
// encoding: utf-8

use <202310UniversalBoardBracket.scad>
use <Parts/Screw.scad>

THICKNESS = 2.5;
TOLERANCE = .15;
$fn = $preview ? 25 : 125;

wood_size = [17.4, 35.1];

induction_pad = [90.8, 10.4]; // IKEA LIVBOJ (Type: E2311-C)
//induction_pad = [55.9, 5.7]; // JSAUX Magnetic Wireless Charger (Type: WP1501)

iphone = [78, 12.2, 5]; // 12 + case
sony = [78.8, 12.8, 3]; // xperia 1 VI + case

module board_mount(width = 30, height = 60) {
  union() {
    translate(v=[0, 0, width + 5]) difference() {
        vertical_mount(width=width, height=height, board_thickness=23.8);
        for (i = [0:1])
          translate(v=[15, 3.2, 10 + (i * 20)]) rotate(a=-90, v=[1, 0, 0]) screw(3.5, 12, true);
      }

    difference() {
      cube(size=[width, 3.5, width], center=false);
      translate(v=[15, 3.2, 15]) rotate(a=-90, v=[1, 0, 0]) screw(3.5, 12, true);
    }
  }
}

module induction_pad_mount(depth = 30, angle = 20, cutout_sample = false) {
  mount_width = THICKNESS * 2 + TOLERANCE + wood_size[0];

  //rotate(a=angle, v=[0, 0, -1])
  difference() {
    translate(v=[-THICKNESS - .1, 0, -depth / 2]) linear_extrude(height=depth) {
        union() {
          translate(v=[0, -cos(angle) * mount_width / 2, 0]) union() {
              rotate(a=angle, v=[0, 0, 1]) translate(v=[-(THICKNESS * 2 + TOLERANCE + wood_size[1]), 0]) difference() {
                    square(size=[TOLERANCE + THICKNESS * 2 + wood_size[1], mount_width], center=false);
                    translate(v=[THICKNESS + TOLERANCE / 2, THICKNESS + TOLERANCE / 2]) square(size=[TOLERANCE + wood_size[1], TOLERANCE + wood_size[0]], center=false);
                  }

              polygon(
                points=[
                  [0, 0],
                  [0, cos(angle) * mount_width],
                  [-sin(angle) * mount_width, cos(angle) * mount_width],
                ]
              );
            }

          // INDUCTIONPAD_BRACKET
          translate(v=[0, -(induction_pad[0] + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + THICKNESS * 2) / 2]) polygon(
              [
                [0, 0],
                [THICKNESS * 2 + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[1], 0],
                [THICKNESS * 2 + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[1], 1],
                [THICKNESS + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[1], 5 + THICKNESS],
                [THICKNESS + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[1], THICKNESS * 2 + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[0] - 5 - THICKNESS],
                [THICKNESS * 2 + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[1], THICKNESS * 2 + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[0] - 1],
                [THICKNESS * 2 + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[1], THICKNESS * 2 + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[0]],
                [0, THICKNESS * 2 + (cutout_sample ? TOLERANCE * 2 : TOLERANCE) + induction_pad[0]],
              ]
            );
        }
      }
    if (!cutout_sample) {
      rotate(a=90, v=[0, 1, 0]) cylinder(h=induction_pad[1] + TOLERANCE, d=induction_pad[0] + TOLERANCE, center=false);
    }
  }
}

module phone_mount(depth = 50, angle = 30, phone_width, phone_thickness, phone_border) {
  for (i = [0:1]) {
    mirror(v=[0, i, 0]) translate(v=[-.05, 0, 0]) difference() {
          translate(v=[-THICKNESS * 2, -(induction_pad[0] + TOLERANCE) / 2 - THICKNESS * 2, -depth / 2]) {
            // induction pad claw
            cube(size=[THICKNESS * 4 + TOLERANCE + induction_pad[1], 10, depth], center=false);
            // phone claw
            translate(v=[THICKNESS * 2 + TOLERANCE + induction_pad[1] - .1, (induction_pad[0] - phone_width) / 2 + THICKNESS, 0])
              cube(size=[phone_thickness + TOLERANCE + THICKNESS, THICKNESS + phone_border, depth], center=false);
          }
          induction_pad_mount(depth=depth + 1, angle=angle, cutout_sample=true);
          translate(v=[induction_pad[1] + TOLERANCE, -(phone_width + TOLERANCE) / 2, -(depth + 1) / 2])
            cube(size=[phone_thickness + TOLERANCE, phone_width + TOLERANCE, depth + 1], center=false);
        }
  }
}
mount_angle = 0;

translate(v=[0, 100, 0]) board_mount();
color(c="orange", alpha=1.0) translate(v=[0, 0, 0]) induction_pad_mount(depth=50, angle=mount_angle, cutout_sample=false);
translate(v=[0, 0, 0]) phone_mount(depth=50, angle=mount_angle, phone_width=iphone[0], phone_thickness=iphone[1], phone_border=iphone[2]);
