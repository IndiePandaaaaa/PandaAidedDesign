module screw(diameter, length, cutout_sample = false, fs = 0.1, fa = 1) {
    //$fs = 0.1; [size in mm] | $fa = 1; [degrees]
    //$fn = 100; [defined faces]

    if (length < diameter) {
        echo("Screw is too short");
        length = diameter + 1;
        echo("New length is: ", length);
    }

    cone_height = diameter / 1.094;
    cone_diameter = diameter * 1.92;

    if (!cutout_sample) {
        translate([0, 0, - length])
            difference() {
                rotate_extrude(center = true, $fs = fs, $fn = fn) {
                    polygon([
                            [0, 0],
                            [diameter / 2, 0],
                            [diameter / 2, length - cone_height],
                            [(cone_diameter / 2), length],
                            [0, length],
                        ]);
                }

                // top cross part
                translate([0, 0, length + 0.1 - cone_height])
                    difference() {
                        rotate([0, 0, 45])
                            rotate_extrude(center = true, $fn = 4) {
                                polygon([
                                        [0, 0],
                                        [diameter * 1.4 / 2, 0],
                                        [cone_diameter / 2, cone_height],
                                        [0, cone_height],
                                    ]);
                            }
                        for (i = [0 : 1 : 3]) {
                            rotate([0, 0, 90 * i])
                                translate([diameter / 3.18 / 2, diameter / 3.18 / 2, - 0.1])
                                    cube(cone_height + 0.2);
                        }
                    }
            }
    } else {
        offset = 0.2;
        translate([0, 0, - length - offset / 2])
            rotate_extrude(center = true, $fs = fs, $fn = fn) {
                polygon([
                        [0, 0],
                        [(diameter + offset) / 2, 0],
                        [(diameter + offset) / 2, (length + offset) - (cone_height + offset)],
                        [(cone_diameter + offset) / 2, length + offset],
                        [0, length + offset],
                    ]);
            }
    }
}

screw(3.5, 20, true);