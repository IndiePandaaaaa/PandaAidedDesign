// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Variables/Threading.scad>
use <Parts/Screw.scad>

PARTS_SEPARATED = true;
THICKNESS = 2.5;
TOLERANCE = .1;
$fa = $preview ? 10 : .01; // add to smaller circles: , $fn=$preview ? 20 : 50

VACUUM_OD = 34.2;

module perpendicular_angle(width, depth, ruler_depth = 13, ruler_mode = 2.5) {
  // ruler_mode: 10 => cm; 5 => cm, 5 mm; 2.5 => cm, 2.5 mm; 1 => cm, mm; 0 => no ruler
  module ruler(width, mode, mirrored = false) {
    module marker(mode, label, mirrored = false) {
      width = 0.5;
      depth = 0.2 + TOLERANCE;
      length = [2.5, 1.5, 1];
      text_size = 5;

      translate([-width / 2, -length[mode], -depth + TOLERANCE]) {
        cube([width, length[mode], depth]);

        if (label != 0) {
          // 0: no label
          translate([0, -text_size - 1.75, 0]) linear_extrude(depth) {
              mirror(([mirrored ? 1 : 0, 0, 0]))
                text(str(label), size=text_size, font="RecMonoCasualNerdFont", halign="center");
            }
        }
      }
    }

    if (mode != 0) {
      for (i = [0:width - 1]) {
        translate([i, 0, 0]) {
          if (i % 10 == 0) {
            marker(0, i / 10, mirrored=mirrored);
          } else if (mode <= 5 && i % mode == 0) {
            marker(1, 0); // 0 means no label
          } else if (mode <= 2.5 && (i % 10 == 2 || i % 10 == 7)) {
            translate([.5, 0, 0]) marker(2, 0);
          }
        }
      }
    }
  }

  translate([-THICKNESS, 0, 0]) union() {
      translate([0, 0, -(10) / 2]) cube([THICKNESS, depth, 10 + THICKNESS]);

      translate([THICKNESS, 0, 0]) difference() {
          linear_extrude(THICKNESS) {
            polygon(
              [
                [0, 0],
                [5, 0],
                [5, depth - ruler_depth],
                [width + TOLERANCE, depth - ruler_depth],
                [width + TOLERANCE, depth],
                [0, depth],
              ]
            );
          }
          for (i = [0:1])
            translate([0, depth, THICKNESS * i]) ruler(width, ruler_mode, mirrored=i == 0 ? true : false);
        }
    }
}

module pocket_holes(drill_diameter = 7.5, board_thickness = 24) {
  //    drill_diameter_adapter_od = (drill_diameter / 2 + THICKNESS) * 2;
  angle = 15;

  module drill_limiter() {
    translate(v=[0, 0, drill_diameter / 2]) difference() {
        union() {
          cylinder(h=drill_diameter, r=drill_diameter / 2 + THICKNESS, center=true, $fn=$preview ? 20 : 50);
          rotate(a=90, v=[1, 0, 0]) translate(v=[0, 0, drill_diameter / 2])
              cylinder(h=THICKNESS, r=2, center=false, $fn=$preview ? 20 : 50);
        }
        cylinder(h=drill_diameter + TOLERANCE * 2, r=drill_diameter / 2 + TOLERANCE, center=true, $fn=$preview ? 20 : 50);
        rotate(a=90, v=[1, 0, 0]) cylinder(h=drill_diameter, r=core_hole_M3() / 2, center=false, $fn=$preview ? 20 : 50);
      }
  }

  //    module drill_diameter_adapter(height = 25)
  //    {
  //        difference()
  //        {
  //            union()
  //            {
  //                cylinder(h = height, r = drill_diameter_adapter_od / 2, center = false);
  //                translate(v = [ 0, 0, height - THICKNESS / 2 ])
  //                    cylinder(h = THICKNESS / 2, r = drill_diameter / 2 + THICKNESS * 2, center = false);
  //            }
  //            translate(v = [ 0, 0, -.1 ])
  //                cylinder(h = height + .2, r = drill_diameter / 2 + TOLERANCE * 2, center = false);
  //        }
  //    }

  module pocket_hole_jig(width = 42, height = 23) {
    difference() {
      union() {
        jig_height = drill_diameter + THICKNESS * 2;
        translate(v=[0, 0, height - .5]) cube(size=[width, width, 4], center=false);
        translate(v=[0, 0, height / 2 - jig_height / 2]) rotate(a=angle, v=[1, 0, 0])
            cube(size=[width, 70, jig_height], center=false);
        translate(v=[width / 2, width, height])
          cylinder(h=20, r=VACUUM_OD / 2 + THICKNESS + TOLERANCE, center=false);
      }
      translate(v=[(width / 2), 0, height / 2]) union() {

          for (i = [0:1]) {
            color(c="grey", alpha=1.0) rotate(a=-90 + angle, v=[1, 0, 0])
                translate(v=[-width / 2 + width / 4 + width / 2 * i, 0, -height]) union() {
                    cylinder(h=35, r=3.5 / 2, center=false);
                    translate(v=[0, 0, 35]) cylinder(h=65, r=drill_diameter / 2, center=false, $fn=$preview ? 20 : 50);
                  }
          }
          translate(v=[0, width, 15]) cylinder(h=50, r=VACUUM_OD / 2 + TOLERANCE, center=false);
          translate(v=[-(width / 2), 0, -12]) color(c="blue", alpha=1.0)
              cube(size=[width, 100, height], center=false);
          rotate(a=-90, v=[0, 0, 1]) translate(v=[0, -100 + (width / 2), -12])
              color(c="green", alpha=1.0) cube(size=[width, 100, height], center=false);
        }
    }
  }
  translate(v=[50, 0, 0]) drill_limiter();
  translate(v=[0, 0, 0]) pocket_hole_jig();
}

module router_guide_batten_channel(cutting_width, cutting_depth, wood_width, wood_height, router_bit_cutting_height = 25, router_bit_diameter = 16, thickness = 3, screw_od = 3.5) {
  additional_border = screw_od * 4;
  additional_height_for_router_bit = router_bit_cutting_height + 3 - cutting_depth / 3;
  additional_width_for_router_bit = wood_width + TOLERANCE + router_bit_diameter;

  difference() {
    union() {
      translate(v=[0, 0, thickness / 2 + wood_height + additional_height_for_router_bit]) difference() {
          cube(size=[additional_border * 2 + additional_width_for_router_bit + thickness * 2 + TOLERANCE * 2, additional_border * 2 + cutting_width + thickness * 2 + TOLERANCE * 2, thickness], center=true);
          cube(size=[additional_width_for_router_bit + TOLERANCE * 2, cutting_width + TOLERANCE * 2, thickness + 1], center=true);
        }
      translate(v=[0, 0, additional_height_for_router_bit / 2 + wood_height + TOLERANCE]) difference() {
          cube(size=[additional_width_for_router_bit + TOLERANCE * 2 + thickness * 2, cutting_width + TOLERANCE * 2 + THICKNESS * 2, additional_height_for_router_bit], center=true);
          cube(size=[additional_width_for_router_bit + TOLERANCE * 2, cutting_width + TOLERANCE * 2, additional_height_for_router_bit + 1], center=true);
        }

      // vice helper
      union() {
        translate(v=[additional_width_for_router_bit / 2 + thickness + TOLERANCE * 2, -70 / 2, 0])
          cube(size=[64 - 44 - thickness - TOLERANCE - router_bit_diameter / 2, 70, wood_height + additional_height_for_router_bit - TOLERANCE], center=false);
        translate(v=[additional_width_for_router_bit / 2 + TOLERANCE - router_bit_diameter / 2, -(cutting_width + TOLERANCE * 2 + THICKNESS * 2) / 2, 0])
          cube(size=[thickness + TOLERANCE + router_bit_diameter / 2, cutting_width + TOLERANCE * 2 + THICKNESS * 2, wood_height], center=false);
      }
    }

    // wood screws 
    color(c="red", alpha=1.0) union() {
        for (x = [0:1])
          for (y = [0:1])
            translate(v=[(additional_width_for_router_bit / 2 - additional_border / 2) - (additional_width_for_router_bit - additional_border) * x, additional_border / 2 + thickness + cutting_width / 2 - (additional_border + thickness * 2 + cutting_width) * y, wood_height + additional_height_for_router_bit + thickness]) {
              screw(diameter=screw_od, length=12, cutout_sample=true);
            }
      }

    // plastic screws
    color(c="blue", alpha=1.0) union() {
        for (y = [0:1])
          translate(v=[additional_width_for_router_bit / 2 + additional_border / 2 + .5, additional_border / 2 + thickness + cutting_width / 2 - (additional_border + thickness * 2 + cutting_width) * y, wood_height + additional_height_for_router_bit + thickness]) {
            screw(diameter=3, length=3, cutout_sample=true);
            translate(v=[0, 0, -thickness - 50]) cylinder(h=50, d=2.7, center=false, $fn=50);
          }
      }
  }
}

// perpendicular_angle(75, 50, ruler_depth = 10, ruler_mode = 0);
// pocket_holes();
router_guide_batten_channel(cutting_width=24, cutting_depth=12, wood_width=44, wood_height=24);
