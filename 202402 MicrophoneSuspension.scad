// created by IndiePandaaaaa

use <Variables/Threading.scad>

TOLERANCE = .15;
THICKNESS = 4;
$fn = 100;

CORD_OD = 4.5;
CORD_HOLES = 16;

BASE_ID = 120;
MOUNTING_SCREW_OD = 5.5;

module interface_yeti_x(cord_od, cord_holes, material_width = 14, material_thickness = 3, tolerance = .15) {
  mic_diameter = 70;
  mic_screw_diameter = 6.5;
  mic_screw_offset = 35;
  width_mic_brackets = material_width + tolerance;
  side_bracket_mounting_width = core_hole("M3") * 5 + material_width;
  side_bracket_mounting_thickness = 5;
  material_thickness_screw = 2;

  module side_bracket(width, mic_hole, height, mounting_width_screw, tolerance = .15, material_thickness = 5) {
    mounting_offset = (70 - 66.9) / 2;
    mounting_diameter = 12.25;

    union() {
      difference() {
        union() {
          translate([0, -width/2, 0]) cube([material_thickness, width, height - width / 2]);
          translate([0, 0, height - width / 2]) rotate([0, 90, 0]) cylinder(d = width, h = material_thickness);
          translate([- mounting_offset, 0, height - width / 2]) 
            rotate([0, 90, 0]) cylinder(d1 = mounting_diameter, d2 = width, h = mounting_offset);
        }

        translate([-.1 - mounting_offset, 0, height - width / 2])
          rotate([0, 90, 0]) cylinder(d = mic_hole, h = material_thickness + mounting_offset + .2);

        translate([material_thickness / 2, width / 2 - core_hole("M3"), -.1]) cylinder(d = core_hole("M3"), h = 15);
        translate([material_thickness / 2, -width / 2 + core_hole("M3"), -.1]) cylinder(d = core_hole("M3"), h = 15);
      }
    }
  }

  difference() {
    cylinder(d = mic_diameter + material_width * 2, h = material_thickness);
    translate([0, 0, -.05]) cylinder(d = mic_diameter, h = material_thickness + .1);
    
    for (i = [1 : cord_holes]) {
      rotate([0, 0, 360 / cord_holes * i])
        translate([mic_diameter / 2 + material_width - cord_od, 0, -.05]) 
          cylinder(d = cord_od, h = material_thickness + .1);
    }

    translate([mic_diameter / 2 - width_mic_brackets + side_bracket_mounting_thickness + tolerance, - (width_mic_brackets + tolerance) / 2 , material_thickness_screw])
      cube(width_mic_brackets + tolerance);

    translate([mic_diameter / 2 + core_hole("M3"), -width_mic_brackets / 2 + core_hole("M3"), -.1]) {
      cylinder(d = 3, h = material_thickness + .2);
      translate([0, width_mic_brackets - core_hole("M3") * 2, 0])
        cylinder(d = 3, h = material_thickness + .2);
    }

    rotate([0, 0, 180]) { 
      translate([mic_diameter / 2 - width_mic_brackets + side_bracket_mounting_thickness + tolerance, - (width_mic_brackets + tolerance) / 2, material_thickness_screw]) 
        cube(width_mic_brackets + tolerance);

      translate([mic_diameter / 2 + core_hole("M3"), -width_mic_brackets / 2 + core_hole("M3"), -.1]) {
        cylinder(d = 3, h = material_thickness + .2);
        translate([0, width_mic_brackets - core_hole("M3") * 2, 0])
          cylinder(d = 3, h = material_thickness + .2);
      }
    }
  }

  translate([mic_diameter / 2, 0, material_thickness_screw + tolerance])
    side_bracket(width_mic_brackets, mic_screw_diameter, mic_screw_offset, side_bracket_mounting_width, material_thickness = side_bracket_mounting_thickness);
  rotate([0, 0, 180]) translate([mic_diameter / 2, 0, material_thickness_screw + tolerance])
    side_bracket(width_mic_brackets, mic_screw_diameter, mic_screw_offset, side_bracket_mounting_width, material_thickness = side_bracket_mounting_thickness);
}

module suspension_base(cord_od, cord_holes, id, mounting_screw_od, material_thickness = 3, tolerance = .15) {
  width = cord_od * 3 + mounting_screw_od;

  difference() {
    union() {
      cylinder(d = id + width * 2, h = material_thickness);
      rotate([0, 0, 90]) translate([id / 2 + width - mounting_screw_od, 0, 0]) scale([1, 30.5 / (mounting_screw_od * 2), 1])
        cylinder(d = mounting_screw_od * 2, h = material_thickness * 2);
    }

    translate([0, 0, -.1]) cylinder(d = id, h = material_thickness + .2);

    rotate([0, 0, 90]) translate([id / 2 + width - mounting_screw_od, 0, -.1])
      cylinder(d = mounting_screw_od, h = material_thickness * 2 + .2);
    
    for (i = [1 : cord_holes]) {
      rotate([0, 0, 360 / cord_holes * (i + .5)]) translate([id / 2 + cord_od, 0, -.1]) cylinder(d = cord_od, h = material_thickness + .2);
    }
  }
}

interface_yeti_x(CORD_OD, CORD_HOLES, material_thickness = THICKNESS);

suspension_base(CORD_OD, CORD_HOLES, BASE_ID, MOUNTING_SCREW_OD, THICKNESS, TOLERANCE);
