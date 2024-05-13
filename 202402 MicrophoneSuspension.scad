// created by IndiePandaaaaa

use <Variables/Threading.scad>

TOLERANCE = .15;
THICKNESS = 4;
$fn = 100;

CORD_OD = 4.5;
CORD_HOLES = 16;

MIC_ARM_THREAING_OD = 5.5;
FLOATING_SPACE = 15;

MICROPHONE_OD = 42;

function interface_od(mic_diameter, depth = 14) = mic_diameter + depth * 2;

function base_id(mic_diameter, floating_space, depth = 14) = interface_od(mic_diameter, depth) + floating_space * 2;

module suspension_base(cord_od, cord_holes, mounting_screw_od, mic_diameter = 70, depth = 14, mounting_nut_od = 27, material_thickness = 3, tolerance = .15) {
  id = base_id(mic_diameter, depth);
  width = cord_od * 3 + mounting_screw_od;
  thickness_mounting = material_thickness * 2;

  difference() {
    union() {
      difference() {
        cylinder(d = id + width * 2, h = thickness_mounting);
        translate([0, 0, material_thickness]) cylinder(d = id + width * 2 - material_thickness * 3, h = material_thickness + .1);
      }

      rotate([0, 0, 90]) translate([id / 2 + width - mounting_screw_od, 0, 0]) {
        cylinder(d = mounting_nut_od, h = thickness_mounting);
      }
    }

    translate([0, 0, -.1]) cylinder(d = id, h = material_thickness + .2);

    rotate([0, 0, 90]) translate([id / 2 + width - mounting_screw_od, 0, -.1])
      cylinder(d = mounting_screw_od, h = material_thickness * 2 + .2);
    
    for (i = [1 : cord_holes]) {
      rotate([0, 0, 360 / cord_holes * (i + .5)]) translate([id / 2 + cord_od, 0, -.1]) cylinder(d = cord_od, h = material_thickness * 2 + .2);
    }
  }
}

module interface_base(microphone_od, cord_holes, cord_od, depth = 14, thickness = 3, tolerance = .15) {
  difference() {
    cylinder(d = interface_od(microphone_od, depth), h = thickness);
    translate([0, 0, -.1]) cylinder(d = microphone_od, h = thickness + .2);
    
    for (i = [1 : cord_holes]) {
      rotate([0, 0, 360 / cord_holes * i])
        translate([interface_od(microphone_od, depth) / 2 - cord_od, 0, -.1]) 
          cylinder(d = cord_od, h = thickness + .2);
    }
  }
}

module interface_yeti_x(cord_od, cord_holes, mic_diameter = 70, material_width = 14, material_thickness = 3, tolerance = .15) {
  mic_screw_diameter = 6.5;
  mic_screw_offset = 45;
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

        translate([material_thickness / 2, width / 2 - core_hole("M3"), -.1]) cylinder(d = core_hole("M3"), h = mic_screw_offset - 20);
        translate([material_thickness / 2, -width / 2 + core_hole("M3"), -.1]) cylinder(d = core_hole("M3"), h = mic_screw_offset - 20);
      }
    }
  }

  difference() {
    interface_base(mic_diameter, cord_holes, cord_od, material_width, material_thickness, tolerance);
    
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

module interface_threaded38(cord_od, cord_holes, mic_diameter, depth = 14, thickness = 3, tolerance = .15) {

  interface_base(mic_diameter, cord_holes, cord_od, depth, thickness, tolerance);
}


suspension_base(CORD_OD, CORD_HOLES, MIC_ARM_THREAING_OD, mic_diameter = MICROPHONE_OD, material_thickness = THICKNESS, tolerance = TOLERANCE);
//interface_yeti_x(CORD_OD, CORD_HOLES, mic_diameter = MICROPHONE_OD, material_thickness = THICKNESS);
interface_threaded38(CORD_OD, CORD_HOLES, mic_diameter = MICROPHONE_OD, thickness = THICKNESS);
