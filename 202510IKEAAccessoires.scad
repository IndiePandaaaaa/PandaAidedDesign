// created by IndiePandaaaaa|Lukas

THICKNESS = 2.5;
TOLERANCE = .15;
$fn = 75;

module platsa_side_hook(width_inside = 2, hook_width = 4.7) {
  HOOK_WIDTH_INSIDE = width_inside;
  PLATSA_SIDE_WALL_OFFSET = 25.7; // 25.7 for side hook, 42.5 for door closing
  PLATSA_MOUNTING_WIDTH = hook_width - TOLERANCE;
  PLATSA_MOUNTING_DEPTH = 19.2;

  linear_extrude(PLATSA_MOUNTING_WIDTH) {
    polygon(
      [
        [0, 0],
        [THICKNESS * 2 + HOOK_WIDTH_INSIDE, 0],
        [THICKNESS * 2 + HOOK_WIDTH_INSIDE, PLATSA_MOUNTING_DEPTH],
        [THICKNESS * 2 + HOOK_WIDTH_INSIDE + PLATSA_SIDE_WALL_OFFSET, PLATSA_MOUNTING_DEPTH],
        [THICKNESS * 2 + HOOK_WIDTH_INSIDE + PLATSA_SIDE_WALL_OFFSET, 0],
        [THICKNESS * 2 + HOOK_WIDTH_INSIDE + PLATSA_SIDE_WALL_OFFSET + PLATSA_MOUNTING_WIDTH, 0],
        [
          THICKNESS * 2 + HOOK_WIDTH_INSIDE + PLATSA_SIDE_WALL_OFFSET + PLATSA_MOUNTING_WIDTH,
          PLATSA_MOUNTING_DEPTH + THICKNESS,
        ],
        [THICKNESS + HOOK_WIDTH_INSIDE, PLATSA_MOUNTING_DEPTH + THICKNESS],
        [THICKNESS + HOOK_WIDTH_INSIDE, THICKNESS],
        [THICKNESS, THICKNESS],
        [THICKNESS, THICKNESS + HOOK_WIDTH_INSIDE],
        [0, THICKNESS + HOOK_WIDTH_INSIDE],
      ]
    );
  }
}

module sortera_bag_clamp(width, height, depth, material_thickness = 2) {
  // inspired by: https://www.printables.com/model/1419004-ikea-sortera-trash-bag-holder-frame
  
  module twoD_edge_rounded(thickness, inner_radius) {
    difference() {
      circle(r=inner_radius + thickness);
      circle(r=inner_radius);
      
      for (i=[0:2]) {
        rotate(90 + 90*i) square(inner_radius+thickness+1);
      }
    }
  }

  linear_extrude(height=depth, center=false, convexity=10, twist=0, slices=20, scale=1.0) {
    twoD_edge_rounded(material_thickness, 3);
  }
}

// TODO: add little hook on one side, chest material thickness 2.2 mm
sortera_bag_clamp(width=19.2, height=45, depth=.1, material_thickness=2.5);
