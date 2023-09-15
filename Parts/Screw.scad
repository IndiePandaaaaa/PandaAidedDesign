// created by IndiePandaaaaa | Lukas

$fn = 50;

function cone_diameter(diameter) = diameter * 2;

function cone_diameter_cutout(diameter) = diameter * 2 + 0.25;

function cone_height(diameter) = diameter * 0.75;

module screw(diameter, length, cutout_sample = false) {

    module base_model(diameter, length, cone_height, cone_diameter, offset = 0) {
        rotate_extrude() {
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

    if (!cutout_sample) {
        translate([0, 0, - length])
            difference() {
                base_model(diameter, length, cone_height(diameter), cone_diameter(diameter));

                // top cross part
                translate([0, 0, length - (cone_height(diameter) - diameter / 2)])
                    difference() {
                        rotate([0, 0, 45])
                            rotate_extrude() {
                                polygon([
                                        [0, 0],
                                        [diameter * 1.4 / 2, 0],
                                        [cone_diameter(diameter) / 3, cone_height(diameter) - diameter / 2],
                                        [0, cone_height(diameter) - diameter / 2],
                                    ]);
                            }
                        for (i = [0 : 1 : 3]) {
                            rotate([0, 0, 90 * i])
                                translate([diameter / 3.18 / 2, diameter / 3.18 / 2, 0])
                                    cube(cone_height(diameter));
                        }
                    }
            }
    } else {
        offset = 0;
        diameter = diameter + 0.25;
        translate([0, 0, - length - offset / 2])
            base_model(diameter, length, cone_height(diameter), cone_diameter(diameter), offset);
    }
}

screw(3.5, 12);