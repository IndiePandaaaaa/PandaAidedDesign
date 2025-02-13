// created by IndiePandaaaaa|Lukas

THICKNESS = 2.5;
TOLERANCE = .15;
$fn = 75;

HOOK_WIDTH_INSIDE = 2;
PLATSA_SIDE_WALL_OFFSET = 25.7; // 25.7 for side hook, 42.5 for door closing
PLATSA_MOUNTING_WIDTH = 4.7 - TOLERANCE;
PLATSA_MOUNTING_DEPTH = 19.2;

linear_extrude(PLATSA_MOUNTING_WIDTH) {
  polygon([
      [0, 0],
      [THICKNESS * 2 + HOOK_WIDTH_INSIDE, 0],
      [THICKNESS * 2 + HOOK_WIDTH_INSIDE, PLATSA_MOUNTING_DEPTH],
      [THICKNESS * 2 + HOOK_WIDTH_INSIDE + PLATSA_SIDE_WALL_OFFSET, PLATSA_MOUNTING_DEPTH],
      [THICKNESS * 2 + HOOK_WIDTH_INSIDE + PLATSA_SIDE_WALL_OFFSET, 0],
      [THICKNESS * 2 + HOOK_WIDTH_INSIDE + PLATSA_SIDE_WALL_OFFSET + PLATSA_MOUNTING_WIDTH, 0],
      [THICKNESS * 2 + HOOK_WIDTH_INSIDE + PLATSA_SIDE_WALL_OFFSET + PLATSA_MOUNTING_WIDTH, PLATSA_MOUNTING_DEPTH +
      THICKNESS],
      [THICKNESS + HOOK_WIDTH_INSIDE, PLATSA_MOUNTING_DEPTH + THICKNESS],
      [THICKNESS + HOOK_WIDTH_INSIDE, THICKNESS],
      [THICKNESS, THICKNESS],
      [THICKNESS, THICKNESS + HOOK_WIDTH_INSIDE],
      [0, THICKNESS + HOOK_WIDTH_INSIDE],
    ]);
}
