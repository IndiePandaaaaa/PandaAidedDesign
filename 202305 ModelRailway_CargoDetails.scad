// created by IndiePandaaaaa | Lukas

ramp_depth = 30;
ramp_height_material_thickness = 3;
ramp_height_difference = 15;
ramp_width = 65;

lprofile_length = 42;
lprofile_height = 1.5;
lprofile_width = 2.5;
lprofile_thickness = 1;

module LProfile(length, width, height, thickness) {
    linear_extrude(length) {
        polygon([
                [0, 0],
                [thickness, 0],
                [thickness, height - thickness],
                [width, height - thickness],
                [width, height],
                [0, height],
            ]);
    }

}

// ramp adapter
linear_extrude(ramp_depth) {
    polygon([
            [0, ramp_height_difference + ramp_height_material_thickness],
            [ramp_width, ramp_height_material_thickness],
            [ramp_width, 0],
        ]);
}

translate([ramp_width + 5, 0, 0]) {
    LProfile(lprofile_length, lprofile_width, lprofile_height, lprofile_thickness);
    translate([5, 0, 0]) LProfile(lprofile_length, 2, 1, 0.7);
    translate([10, 0, 0]) LProfile(lprofile_length, 1.5, 1.5, 0.7);
    translate([15, 0, 0]) LProfile(lprofile_length, 1.5, 1, 0.7);
}

