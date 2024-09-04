// created by IndiePandaaaa
// encoding: utf-8

use <Variables/Threading.scad>

CHAMFER = .5;
TOLERANCE = .15;
$fn = 75;

module mounting_base(inner_width, inner_height, inner_height_offset, base_depth, material_thickness = 3, round_cutout = false) {
  full_width = material_thickness * 2 + inner_width + TOLERANCE;
  full_height = inner_height_offset + inner_height + TOLERANCE;

  height_offset = round_cutout ? inner_height_offset + (inner_width + TOLERANCE) / 2 : inner_height_offset;

  difference() {
    translate([-full_width / 2, base_depth, 0]) rotate([90, 0, 0]) linear_extrude(base_depth) {
      polygon([
        [0, 0],
        [full_width, 0],
        [full_width, full_height - CHAMFER],
        [full_width - CHAMFER, full_height],
        [full_width - material_thickness + CHAMFER, full_height],
        [full_width - material_thickness, full_height - CHAMFER],
        [full_width - material_thickness, height_offset],
        [material_thickness, height_offset],
        [material_thickness, full_height - CHAMFER],
        [material_thickness - CHAMFER, full_height],
        [CHAMFER, full_height],
        [0, full_height - CHAMFER],
      ]);
    }
    for (i = [0:1]) {
      translate([0, base_depth / 4 + base_depth / 2 * i, -.1]) cylinder(d = core_hole_M3(), h = height_offset * 1.5);
    }
    if (round_cutout) {
      translate([0, -.1, height_offset]) rotate([-90, 0, 0]) cylinder(d = inner_width + TOLERANCE, h = base_depth + .2);
    }
  }
}

mounting_base(5, 20, 3, 15, round_cutout = false);
