// created by IndiePandaaaaa | Lukas

function ziptie_point_height(ziptie_depth = 2) = ((ziptie_depth / tan(42)) * 2) + (ziptie_depth * 1.25);

module ziptiepoint(width = 2.5, depth = 2, cutout = false) {
  module cutout_sample(width, depth) {
    chamfer = 0.35;
    io_height = (depth) / tan(42);
    middle_height = depth * 1.25;

    // cutout for ziptie
    translate([0, -(2 * io_height + middle_height) / 2, -width / 2])
      linear_extrude(width + 0.15) {
        polygon([
            [0, 0],
            [chamfer - chamfer / 2, 0],
            [chamfer + chamfer / 2, chamfer / 2],
            [depth - chamfer, io_height - chamfer],
            [depth, io_height + chamfer],
            [depth, io_height + middle_height - chamfer],
            [depth - chamfer, io_height + middle_height + chamfer],
            [chamfer + chamfer / 2, 2 * io_height + middle_height - chamfer / 2],
            [chamfer - chamfer / 2, 2 * io_height + middle_height],
            [0, 2 * io_height + middle_height],
          ]);
      }
  }

  if (cutout) {
    cutout_sample(width, depth);
  } else {
    rotate([90, 0, 180])
      cutout_sample(width, depth);
  }
}

ziptiepoint(cutout = true);
