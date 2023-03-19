module screw(diameter, length, cutout_sample = false, fs = 0.1, fa = 1) {
    //$fs = 0.1; [size in mm] | $fa = 1; [degrees]
    //$fn = 100; [defined faces]

    module base_model(diameter, length, cone_height, cone_diameter, offset = 0, fs = 0.1, fa = 1) {
        rotate_extrude($fs = fs) {
            polygon([
                    [0, 0],
                    [(diameter + offset) / 2, 0],
                    [(diameter + offset) / 2, (length + offset) - (cone_height + offset)],
                    [(cone_diameter + offset) / 2, length + offset],
                    [0, length + offset],
                ]);
        }
    }

    if (length < diameter) {
        echo("Screw is too short");
        length = diameter + 1;
        echo("New length is: ", length);
    }

    cone_height = diameter;
    cone_diameter = diameter * 1.92;

    if (!cutout_sample) {
        translate([0, 0, - length])
            difference() {
                base_model(diameter, length, cone_height, cone_diameter);

                // top cross part
                translate([0, 0, length + 0.1 - (cone_height - diameter / 2)])
                    difference() {
                        rotate([0, 0, 45])
                            rotate_extrude($fn = 4) {
                                polygon([
                                        [0, 0],
                                        [diameter * 1.4 / 2, 0],
                                        [cone_diameter / 2, cone_height - diameter / 2],
                                        [0, cone_height - diameter / 2],
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
        translate([0, 0, - length - offset / 2])
            base_model(diameter, length, cone_height, cone_diameter, offset = 0.2);
    }
}

screw(3.5, 12);