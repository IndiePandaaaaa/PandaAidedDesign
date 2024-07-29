// created by IndiePandaaaaa

use <Variables/Threading.scad>
use <Logo/logo.scad>

TOLERANCE = .15;
THICKNESS = 4;
$fn = 100;

THREAD_14_INCH = 6.4;  // Elgato Wave Mic Arm LP
THREAD_38_INCH = 9.6;  // Rode PSA-1 Threading

CORD_OD = 4.5;
CORD_HOLES = 8;

MIC_ARM_THREAING_OD = 5.5;
FLOATING_SPACE = 10;

MICROPHONE_OD = 35;

function interface_od(mic_diameter) = mic_diameter + (CORD_OD + CORD_OD * 1.25) * 2;

function base_id(mic_diameter, floating_space) = interface_od(mic_diameter) + floating_space * 2;

module suspension_base(cord_od, cord_holes, id, mounting_screw_od, mic_diameter = 70, depth = 14, mounting_nut_od = 27, material_thickness = 3, wall_thickness = 2.5, tolerance = .15) {
  width = cord_od * 2 + mounting_screw_od;
  height = width * 0.75;
  thickness_mounting = material_thickness * 2;

  difference() {
    union() {
      rotate_extrude() {
        translate([id / 2, 0, 0]) difference() {
          polygon([
            [0, 0],
            [width - 1, 0],
            [width, 1.5],
            [width, height - .5],
            [width - .5, height],
            [width - wall_thickness, height],
            [0, material_thickness],
          ]);
          translate([0, width + (material_thickness - wall_thickness)]) circle(width - wall_thickness);
        }
      }

      rotate([0, 0, 90]) translate([id / 2 + width - mounting_screw_od, 0, 0]) {
        cylinder(d = mounting_nut_od, h = height + .1);
      }
    }
    
    rotate([0, 0, 90]) translate([id / 2 + width - mounting_screw_od, 0, -.1])
      cylinder(d = mounting_screw_od, h = width + .2);
    
    for (i = [1 : cord_holes]) {
      rotate([0, 0, 360 / cord_holes * (i + .5)]) translate([id / 2, 0, material_thickness / 2]) 
        rotate([90, 45, 0]) rotate_extrude(angle = 150) {
          translate([cord_od * 1.25, 0, 0]) circle(d = cord_od + 0.5);
        }
    }
  }
}

module interface_base(microphone_od, cord_holes, cord_od, thickness = 3, tolerance = .15, hollow = true) {
  difference() {
    cylinder(d = interface_od(microphone_od), h = thickness);

    if (hollow)
      translate([0, 0, -.1]) cylinder(d = microphone_od, h = thickness + .2);
    
    for (i = [1 : cord_holes]) {
      rotate([0, 0, 360 / cord_holes * i])
        translate([interface_od(microphone_od) / 2, 0, thickness / 2]) 
          rotate([90, 60, 0]) rotate_extrude(angle = 120) {
          translate([-cord_od * 1.25, 0, 0]) circle(d = cord_od + 0.5);
        }
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

module interface_threaded38(cord_od, cord_holes, mic_diameter, thickness = 3, tolerance = .15) {
  screw_head_od = 16.1;
  screw_head_height = 6.1;
  screw_thread_od = 9.4;
  mounting_screws = 2;
  mounting_height_offset = 1.5;
  mounting_screw_head_height = 2.1;

  difference() {
    union() {
      interface_base(mic_diameter, cord_holes, cord_od, thickness, tolerance, hollow = false);
      translate([0, 0, thickness + mounting_height_offset]) cylinder(d = mic_diameter, h = thickness);
    }
    
    translate([0, 0, thickness / 2]) {
      cylinder(d = screw_head_od + tolerance, h = screw_head_height, $fn = 6);
      cylinder(d = screw_thread_od + tolerance, h = thickness * 5);
    }

    for (i = [0:mounting_screws]) {
      rotate([0, 0, 360 / mounting_screws * i]) translate([mic_diameter / 2 - cord_od, 0, -.1]) {
        cylinder(d = core_hole("M3"), h = thickness * 3);
        translate([0, 0, thickness + tolerance]) cylinder(d = 3.5, h = thickness * 3);
        translate([0, 0, thickness + mounting_height_offset + mounting_screw_head_height])
          cylinder(d1 = core_hole("M3"), d2 = 6, h = mounting_screw_head_height);
      }
    }
    translate([-10.5, -10.5, -.1]) generate_logo(21, 21, 1);
  }

  // mic standoff protection for treaded insert
  mic_protect_height = [12, 10];
  for (i = [0:len(mic_protect_height) - 1]) {
    translate([0, 0, 12 + 15 * i]) difference() {
      cylinder(d = 21, h = mic_protect_height[i]);
      translate([0, 0, -.1]) cylinder(d = screw_thread_od, h = mic_protect_height[i] + .2);
    }
  }
}


suspension_base(CORD_OD, CORD_HOLES, base_id(MICROPHONE_OD, FLOATING_SPACE), THREAD_38_INCH, mic_diameter = MICROPHONE_OD, material_thickness = THICKNESS, tolerance = TOLERANCE);
//interface_yeti_x(CORD_OD, CORD_HOLES, mic_diameter = MICROPHONE_OD, material_thickness = THICKNESS);
interface_threaded38(CORD_OD, CORD_HOLES, mic_diameter = MICROPHONE_OD, thickness = THICKNESS);
