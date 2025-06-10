// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Variables/Threading.scad>

PARTS_SEPARATED = true;
THICKNESS = 2.5;
TOLERANCE = .1;
$fn = $preview ? 25 : 125;

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
          cylinder(h=drill_diameter, r=drill_diameter / 2 + THICKNESS, center=true);
          rotate(a=90, v=[1, 0, 0]) translate(v=[0, 0, drill_diameter / 2])
              cylinder(h=THICKNESS, r=2, center=false);
        }
        cylinder(h=drill_diameter + TOLERANCE * 2, r=drill_diameter / 2 + TOLERANCE, center=true);
        rotate(a=90, v=[1, 0, 0]) cylinder(h=drill_diameter, r=core_hole_M3() / 2, center=false);
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
                    translate(v=[0, 0, 35]) cylinder(h=65, r=drill_diameter / 2, center=false);
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

module orbital_sander_base(diameter) {
  // primarily made for makita DBO180 with 125 mm diameter
  id = diameter / (125 / 101.5);
  base_thickness = 10;
  plate_thickness = 3;
  holes = [
    // hole_count, hole_diameter, position_diameter, offset_angle
    [8, 12, 65.2, 0], // standard holes
    [8, 8, 82.5, 22.5],
    [8, 6, 57.5, 22.5],
    // [8, 6, 87.5, 0],
    [8, 6, 87.5, 7.5],
    [8, 6, 87.5, -7.5],
  ];

  module dust_holes(hole_count, hole_diameter, position_diameter, offset_angle, height = 0) {
    cylinder_height = height == 0 ? base_thickness : height;
    union() {
      for (i = [0:hole_count]) {
        rotate(a=360 / hole_count * i + offset_angle, v=[0, 0, 1]) {
          translate(v=[position_diameter / 2, 0, 0]) {
            cylinder(h=cylinder_height + .2, r=hole_diameter / 2, center=true);
          }
        }
      }
    }
  }

  translate(v=[0, 0, -(base_thickness - plate_thickness) / 2 + plate_thickness / 2]) {
    union() {
      intersection() {
        difference() {
          cylinder(h=base_thickness, r1=diameter / 2, r2=id / 2, center=true);

          // starting at 1 to use standard holes for locating
          for (k = [1:len(holes)]) {
            dust_holes(hole_count=holes[k][0], hole_diameter=holes[k][1], position_diameter=holes[k][2], offset_angle=holes[k][3]);
          }
        }
        translate(v=[0, 0, (base_thickness - plate_thickness) / 2]) {
          cylinder(h=plate_thickness, r=id / 2, center=true);
        }
      }
      translate(v=[0, 0, -1]) {
        dust_holes(hole_count=holes[0][0], hole_diameter=holes[0][1] - TOLERANCE, position_diameter=holes[0][2], offset_angle=holes[0][3], height=3);
      }
    }
  }
}

// perpendicular_angle(75, 50, ruler_depth = 10, ruler_mode = 0);
//pocket_holes();
orbital_sander_base(diameter=125);
