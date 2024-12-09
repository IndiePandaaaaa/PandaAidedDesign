// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

THICKNESS = 3.0;
TOLERANCE = 0.1;
CHAMFER = 1.5;
SCREW_OD = 3.5;
$fn = 75;

HEIGTH = 30; // Proxxon MB200 table
WIDTH = 100;
DEPTH = 42;
MOUNT_DEPTH = 30;

linear_extrude(WIDTH) {
  polygon([
      [0, 0],
      [DEPTH + MOUNT_DEPTH, 0],
      [DEPTH + MOUNT_DEPTH, THICKNESS],
      [DEPTH, THICKNESS],
      [DEPTH, HEIGTH],
      [0, HEIGTH],
    ]);
}