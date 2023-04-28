// created by IndiePandaaaaa | Lukas

// HDD IronWolf 20TB 3,5″
//height_HDD = 26.1;
//width_HDD = 101.85;
//depth_HDD = 146.99;

MODEL_TOLERANCE = 0.15;
TOLERANCE_HDD = 1;

UBASE_THICKNESS = 4;
POST_DEPTH = 7;
POST_DEPTH_SCREW_IN = 16;

WIDTH_HDD = 101.5;
HEIGHT_HDD = 26.5;
FAN_MOUNTING_DISTANCE = 105; // 105 mm is the distance between screws for an 120 mm fan

HDD_BOTTOM_SCREW_DEPTH = 41.3;
HDD_BOTTOM_SCREW_POS_X = 3.2;
HDD_SATA_CONNECTOR_WIDTH = 53;
HDD_SATA_CONNECTOR_POS_X = 7.8;
HDD_SATA_CONNECTOR_HEIGHT = 9;
HDD_SATA_CONNECTOR_CABLE_DEPTH = 39.5;

RUBBER_HEIGHT = 2.3;
RUBBER_WIDTH_ADDITIONAL = 1.3;
RUBBER_HEIGHT_INTERNAL = 1.5;
RUBBER_OD = 10;
RUBBER_OD_ID = 6.2;

SCREW_LENGTH = 12 + 2;  // additionally 2mm for less tolerance issues with threading
SCREW_SOCKET_WIDTH = 10;

FULLMODEL_DEPTH = SCREW_LENGTH + HDD_BOTTOM_SCREW_DEPTH + 55; // ~ 112 mm
FULLMODEL_HEIGHT = HEIGHT_HDD + UBASE_THICKNESS + RUBBER_HEIGHT + 0.5; // ~ 34 mm total height
FULLMODEL_WIDTH = UBASE_THICKNESS * 2 + TOLERANCE_HDD * 2 + WIDTH_HDD;

module UBase(depth, height, hdd_width, hdd_tolerance, thickness, tolerance = 0.1) {
    linear_extrude(height = depth) {
        polygon([
                [0, 0],
                [thickness / 2, 0],
                [thickness / 2, thickness / 2],
                [thickness, thickness / 2],
                [thickness, 0],
                [thickness + hdd_tolerance * 2 + hdd_width, 0],
                [thickness + hdd_tolerance * 2 + hdd_width, thickness / 2],
                [thickness + hdd_tolerance * 2 + hdd_width + thickness / 2, thickness / 2],
                [thickness + hdd_tolerance * 2 + hdd_width + thickness / 2, 0],
                [thickness + hdd_tolerance * 2 + hdd_width + thickness, 0],
                [thickness + hdd_tolerance * 2 + hdd_width + thickness, height],
                [thickness + hdd_tolerance * 2 + hdd_width + thickness / 2 - tolerance / 2, height],
                [thickness + hdd_tolerance * 2 + hdd_width + thickness / 2 - tolerance / 2, height + thickness / 2 -
                tolerance],
                [thickness + hdd_tolerance * 2 + hdd_width + tolerance / 2, height + thickness / 2 - tolerance],
                [thickness + hdd_tolerance * 2 + hdd_width + tolerance / 2, thickness],
                [thickness - tolerance / 2, thickness],
                [thickness - tolerance / 2, height + thickness / 2 - tolerance],
                [thickness / 2 + tolerance / 2, height + thickness / 2 - tolerance],
                [thickness / 2 + tolerance / 2, height],
                [0, height],
            ]);
    }
}

module BottomHoles(rubber_od, rubber_od_id, cutout_height) {
    height = 12;
    hdd_screw_width = 95.25;
    hdd_screw_depth = 44.45;
    module Hole(rubber_od, rubber_od_id, height, cutout_height) {
        translate([0, 0, height / 2])
            cylinder(height, d = rubber_od_id, $fs = 0.4, center = true);
        translate([0, 0, - height / 2 + cutout_height])
            cylinder(height, d = rubber_od, $fs = 0.4, center = true);
        translate([0, - rubber_od_id / 4 * 1, - height / 2 + cutout_height])
            cylinder(height, d = rubber_od, $fs = 0.4, center = true);
        translate([0, - rubber_od_id / 4 * 2, - height / 2 + cutout_height])
            cylinder(height, d = rubber_od, $fs = 0.4, center = true);
        translate([0, - rubber_od_id / 4 * 3, - height / 2 + cutout_height])
            cylinder(height, d = rubber_od, $fs = 0.4, center = true);
        translate([0, - rubber_od_id / 4 * 4, - height / 2 + cutout_height])
            cylinder(height, d = rubber_od, $fs = 0.4, center = true);
        translate([0, - rubber_od_id, height / 2])
            cylinder(height, d = rubber_od, $fs = 0.4, center = true);
    }
    translate([0, 0, 0]) Hole(rubber_od, rubber_od_id, height, cutout_height);
    translate([0, hdd_screw_depth, 0]) Hole(rubber_od, rubber_od_id, height, cutout_height);
    translate([hdd_screw_width, 0, 0]) Hole(rubber_od, rubber_od_id, height, cutout_height);
    translate([hdd_screw_width, hdd_screw_depth, 0]) Hole(rubber_od, rubber_od_id, height, cutout_height);
}

module ConnectorSpacer(width, depth, height, offset_x, bottom_screw_depth) {
    translate([offset_x, - depth - bottom_screw_depth + 2, - 0.01])
        cube([width, depth, height + 0.01]);
}

module AirVent(height, starting_depth, full_height, full_depth, full_width, ubase_thickness, bridging_width = 2) {
    vent_depth = full_width + ubase_thickness;
    z_height = (full_height - height) / 2;
    translate([0, vent_depth - ubase_thickness, 0]) rotate([90, 0, 0])
        linear_extrude(height = vent_depth) {
            for (i = [0:floor((full_depth - starting_depth) / (bridging_width * 2) - 2)]) {// -2 for more stability
                polygon([
                        [starting_depth + bridging_width * 2 * i, z_height],
                        [starting_depth + bridging_width * 2 * i + bridging_width, z_height],
                        [starting_depth + bridging_width * 2 * i + bridging_width, z_height + height],
                        [starting_depth + bridging_width * 2 * i, z_height + height],
                    ]);
            }
        }
}

module Mounting(width, depth, height, distance, for_cutout_only = false) {
    module ScrewHole(width_mounting, depth_mounting, height_mounting) {
        // https://de.wikipedia.org/wiki/Kernloch
        //  Gewinde	Steigung	Kernloch (core hole)
        //  M4	    x0.7	3.3
        //  M3	    x0.5	2.5
        for (i = [0:2]) {
            translate([width_mounting / 2, - 0.01, height_mounting / 3 / 2 + height_mounting / 3 * i]) {
                rotate([- 90, 0, 0]) {
                    if (i == 1) {// hole for M3 threading
                        cylinder(h = depth_mounting + 0.02, d = 2.5, center = false, $fs = 0.1);
                    } else {// holes for M4 threading
                        cylinder(h = depth_mounting + 0.02, d = 3.3, center = false, $fs = 0.1);
                    }
                }
            }
        }
    }

    for (i = [0:1]) {
        translate([distance * i, 0, 0]) {
            if (!for_cutout_only) {
                difference() {
                    cube([width, depth, height]);
                    ScrewHole(width, depth, height);
                }
            } else {
                ScrewHole(width, depth, height);
            }
        }
    }
}

module HexPattern(thickness, start_pos_x, start_pos_y, full_depth, full_width, single_hexagon_od = 20) {
    inner_radius = tan(60) * (single_hexagon_od / 2);

    count_x = floor((full_width - start_pos_x * 2) / inner_radius);

    // inner_radius * 2 is used but single_hexagon_od is needed to consider the strips inbetween
    distance_x = ((full_width - start_pos_x * 2) - (count_x * single_hexagon_od));

    count_y = round((full_depth - start_pos_y) / (inner_radius + single_hexagon_od));

    for (y = [0:count_y - 1]) {
        for (x = [0:count_x - 1]) {
            translate([(start_pos_x + distance_x + single_hexagon_od / 2) + single_hexagon_od * x,
                    (start_pos_y + single_hexagon_od / 2) + inner_radius * 2 * y, - 0.01]) {
                linear_extrude(height = thickness + 0.02) {
                    rotate([0, 0, 90]) {
                        circle(d = single_hexagon_od, $fn = 6);
                    }
                }
                if (x < count_x - 1 && y < floor((full_depth - start_pos_y) / (inner_radius + single_hexagon_od))) {
                    translate([single_hexagon_od / 2, inner_radius, 0]) {
                        linear_extrude(height = thickness + 0.02) {
                            rotate([0, 0, 90]) {
                                circle(d = single_hexagon_od, $fn = 6);
                            }
                        }
                    }
                }
            }
        }
    }
}

union() {
    difference() {
        translate([0, FULLMODEL_DEPTH, 0]) rotate([90, 0, 0])
            UBase(FULLMODEL_DEPTH, FULLMODEL_HEIGHT, WIDTH_HDD + 2 * RUBBER_WIDTH_ADDITIONAL,
            TOLERANCE_HDD, UBASE_THICKNESS);

        translate([UBASE_THICKNESS + TOLERANCE_HDD / 2 + RUBBER_OD / 2, HDD_BOTTOM_SCREW_DEPTH + SCREW_LENGTH + 2, 0
            ]) {
            BottomHoles(RUBBER_OD, RUBBER_OD_ID, UBASE_THICKNESS - RUBBER_HEIGHT_INTERNAL);
            ConnectorSpacer(HDD_SATA_CONNECTOR_WIDTH, HDD_SATA_CONNECTOR_CABLE_DEPTH, HDD_SATA_CONNECTOR_HEIGHT,
                HDD_SATA_CONNECTOR_POS_X - HDD_BOTTOM_SCREW_POS_X, HDD_BOTTOM_SCREW_DEPTH);
        }

        translate([FULLMODEL_WIDTH, 0, 0]) rotate([0, 0, 90])
            AirVent(FULLMODEL_HEIGHT - UBASE_THICKNESS * 2, SCREW_LENGTH + 2,
            FULLMODEL_HEIGHT, FULLMODEL_DEPTH, FULLMODEL_WIDTH, UBASE_THICKNESS);

        HexPattern(UBASE_THICKNESS, UBASE_THICKNESS + TOLERANCE_HDD + RUBBER_OD, SCREW_LENGTH + 7,
        FULLMODEL_DEPTH, FULLMODEL_WIDTH, 19);

        // to prepare the space for the screws later
        translate([0, 0, UBASE_THICKNESS])
            Mounting(SCREW_SOCKET_WIDTH, SCREW_LENGTH, FULLMODEL_HEIGHT - UBASE_THICKNESS, FAN_MOUNTING_DISTANCE, true);
    }
    translate([0, 0, UBASE_THICKNESS])
        Mounting(SCREW_SOCKET_WIDTH, SCREW_LENGTH, FULLMODEL_HEIGHT - UBASE_THICKNESS, FAN_MOUNTING_DISTANCE);
}