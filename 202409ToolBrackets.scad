// created by IndiePandaaaa
// encoding: utf-8
use <Variables/Threading.scad>

CHAMFER = .5;
TOLERANCE = .2;
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

module nut_plate() {
  nuts = [11.6, 11.6, 11.6, 11.6, 11.8, 11.8, 12.8, 13.7, 15.7, 15.8, 16.8];

}
//mounting_base(inner_width, inner_height, inner_height_offset, base_depth, round_cutout = false) 

brackets = [
  [4, 6.2, 22, 8.5, 20, false, "wolfcraft 80x200"],
  [2, 17.5, 17.5, 4, 14, false, "bosch ht 8"],
  [2, 6.7, 16.5, 8.5, 14, false, "workzone feile"],
  [2, 4.3, 16.5, 3.5, 14, false, "wisent feile"],
  [1, 9.7, 20, 4, 42, false, "schleifpapier"],
  [1, 23.5, 10, 24, 20, true, "säge griff"],
  [1, 5.9, 6, 4, 20, true, "säge bügel"],
  [1, 13.2, 15, 34, 14, true, "hammer metall"],
  [1, 14.3, 15, 32, 14, true, "hammer griff"],
  [1, 26.2, 10.5, 5, 20, false, "maßband"],
  [2, 4.5, 5, 10.5, 14, true, "holzsäge"],
];

mirror([1, 0, 0]) for (i = [0:len(brackets)-1]) {
  translate([0, 30 * i, 0]) {
    thickness = 3;
    rotate([0, 180, 0]) translate([brackets[i][1] + thickness, 0, 0]) text(brackets[i][6]);
    rotate([0, 0, brackets[i][6] == "schleifpapier" ? -90 : 0]) for (j = [0:brackets[i][0]-1]) {
      translate([(brackets[i][1] + thickness * 2 + 5) * j, 0, 0]) 
        mounting_base(brackets[i][1], brackets[i][2], brackets[i][3], brackets[i][4], round_cutout = brackets[i][5]);
    }
  }
}
