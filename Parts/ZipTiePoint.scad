module ziptiepoint(width = 2.5, depth = 2, cutout_sample = false) {

    module cutout(width, depth) {
        part_height = 2 * (depth / tan(42)) + (depth * 1.25);
        // cutout for ziptie
        translate([0, - part_height / 2, - width / 2])
            linear_extrude(height = width + 0.15) {
                polygon([
                        [0, 0],
                        [depth, depth / tan(42)],
                        [depth, depth / tan(42) + 2.5],
                        [0, part_height],
                    ]);
            }
    }

    if (cutout_sample) {
        cutout(width, depth);
    } else {
        rotate([90, 0, 180])
            cutout(width, depth);
    }
}