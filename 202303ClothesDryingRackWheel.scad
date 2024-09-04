//$fs = 0.1; [size in mm] | $fa = 1; [degrees]
//$fn = 100; [defined faces]
// ,$fs=0.1,$fn=100
// ,$fs=fs,$fn=fn

use <Parts/Screw.scad>

height = 85;  //46.875
diaWheel = height / 1.25;
wdhAxis = diaWheel / 1.25;
socket_diameter = 8;

module regular_polygon(order = 4, r = 1) {
    angles = [for (i = [0:order - 1]) i * (360 / order)];
    coords = [for (th = angles) [r * cos(th), r * sin(th)]];
    polygon(coords);
}

module wheelPair(wheel_diameter, axis_width, cutout_sample = false, fs = 0.1, fn = 100) {
    inner_offset = 0.1;
    wheel_width = wheel_diameter / 5;
    axis_diameter = wheel_diameter / 3.5;

    if (axis_diameter > wheel_diameter) {
        echo("Diameter Axis > Diameter Wheel!");
        axis_diameter = wheel_diameter;
    }

    module wheel_polygon(wheel_width, wheel_diameter) {
        polygon([
                [0, 0],
                [wheel_width / 3 * 1, 0],
                [wheel_width / 3 * 1, wheel_width / 3 * 2],
                [wheel_width / 3 * 2, wheel_width / 3 * 2],
                [wheel_width / 3 * 2, wheel_width / 3 * 1],
                [wheel_width / 3 * 3, wheel_width / 3 * 1],
                [wheel_width / 3 * 3, wheel_diameter / 2],
                [wheel_width / 3 * 0, wheel_diameter / 2],
            ]);
    }

    module axis_half(wheel_width, axis_width, axis_diameter, inner_offset, cutout_sample = false) {
        if (!cutout_sample) {
            difference() {
                rotate_extrude($fs = fs, $fn = fn) {
                    rotate([0, 0, 90])
                        polygon([
                                [wheel_width / 3 * 1 + inner_offset, 0],
                                [wheel_width / 3 * 1 + inner_offset, wheel_width / 3 * 1 - inner_offset],
                                [wheel_width / 3 * 2 - inner_offset, wheel_width / 3 * 1.5 - inner_offset],
                                [wheel_width / 3 * 2 - inner_offset, wheel_width / 3 * 1 - inner_offset],
                                [wheel_width / 3 * 3 + inner_offset, wheel_width / 3 * 1 - inner_offset],
                                [wheel_width / 3 * 3 + inner_offset, axis_diameter / 2],
                                [axis_width / 2, axis_diameter / 2],
                                [axis_width / 2, 0],
                            ]);
                }
                translate([- axis_diameter / 2, - wheel_width / 3 / 2, inner_offset])
                    cube([axis_diameter, wheel_width / 3, wheel_width]);
                rotate([0, 0, 90])
                    translate([- axis_diameter / 2, - wheel_width / 4 / 2, inner_offset])
                        cube([axis_diameter, wheel_width / 4, wheel_width]);
            }
        } else {
            rotate_extrude($fs = fs, $fn = fn) {
                rotate([0, 0, 90])
                    polygon([
                            [0, 0],
                            [0, axis_diameter / 2],
                            [axis_width / 2 + 0.1, axis_diameter / 2],
                            [axis_width / 2 + 0.1, 0],
                        ]);
            }
        }

    }
    translate([- axis_width / 2, 0, 0])
        rotate([0, 90, 0])
            union() {
                rotate_extrude($fs = fs, $fn = fn) {
                    rotate([0, 0, 90])
                        union() {
                            wheel_polygon(wheel_width, wheel_diameter);
                            translate([axis_width, 0, 0])
                                mirror([90, 0, 0]) {
                                    wheel_polygon(wheel_width, wheel_diameter);
                                }
                        }
                }
                rotate([0, 0, 90])
                    union() {
                        axis_half(wheel_width, axis_width, axis_diameter, inner_offset, cutout_sample = cutout_sample);
                        translate([0, 0, axis_width])
                            mirror([0, 0, 90]) {
                                axis_half(wheel_width, axis_width, axis_diameter, inner_offset, cutout_sample =
                                cutout_sample);
                            }
                    }
            }
}

module mudguard(wheel_diameter, axis_width, socket_diameter, offset_space, guard_thickness, fs = 0.1, fn = 100) {
    wheel_width = wheel_diameter / 5;
    axis_diameter = wheel_diameter / 3.5;

    wheel_diameter_offset = wheel_diameter + offset_space * 2;
    axis_diameter_offset = axis_diameter + offset_space * 2;
    guard_diameter = wheel_diameter_offset + guard_thickness * 2;

    socket_id = wheel_diameter / 4;
    socket_od_thickness = socket_id / 4;
    socket_od = socket_id + offset_space * 2 + socket_od_thickness;

    wheel_width_offset = wheel_width + offset_space * 2;
    axis_width_offset = axis_width + offset_space * 2;
    guard_width = axis_width - offset_space * 2;

    socket_y_position = - wheel_diameter / 2 + socket_od / 2 + 1;
    socket_z_position = axis_diameter_offset / 2;

    socket_height = guard_diameter / 2 - socket_z_position + offset_space;

    difference() {
        union() {
            difference() {
                union() {
                    difference() {
                        translate([- guard_width / 2, 0, 0])
                            rotate([0, 90, 0])
                                cylinder(guard_width, d = guard_diameter, true, $fs = fs, $fn = fn); // GUARD
                    }
                    translate([0, socket_y_position, socket_z_position])
                        cylinder(socket_height, d = socket_od + offset_space * 2 + 2, true, $fs = fs, $fn = fn);
                }
                union() {
                    translate([0, socket_y_position, socket_z_position])
                        cylinder(socket_height + offset_space * 2, d = socket_id + offset_space * 2, true, $fs = fs, $fn
                        = fn);
                    translate([0, socket_y_position, socket_z_position])
                        cylinder(socket_id + offset_space * 2, d = socket_od + offset_space, true, $fs = fs, $fn = fn);
                }
            }
            union() {
                translate([0, socket_y_position, socket_z_position + offset_space])
                    cylinder(socket_height + 11.5 + 2, d = socket_diameter, true, $fs = fs, $fn = fn);
                translate([0, socket_y_position, socket_z_position + offset_space])
                    cylinder(socket_height, d = socket_id + offset_space, true, $fs = fs, $fn = fn);
                translate([0, socket_y_position, socket_z_position + offset_space])
                    cylinder(socket_id, d = socket_od + offset_space * 0, true, $fs = fs, $fn = fn);
                translate([0, socket_y_position, socket_z_position + socket_height + offset_space]) cylinder(2, d =
                    socket_od +
                    offset_space, true, $fs = fs, $fn = fn);
            }
        }
        translate([0, 0, - guard_diameter / 2 - axis_diameter / 4])
            cube([guard_diameter, guard_diameter, guard_diameter], true);
        wheelPair(wheel_diameter_offset, axis_width_offset, cutout_sample = true);
        wheelPair(wheel_diameter_offset, axis_width_offset - offset_space * 2, cutout_sample = true);
    }
}

union() {
    mudguard(diaWheel, wdhAxis, socket_diameter, 0.5, 2);
    wheelPair(diaWheel, wdhAxis);
}
