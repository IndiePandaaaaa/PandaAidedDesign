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

SCREW_LENGTH = 12;
SCREW_OD = 3.5;
SCREW_ID = 2.2;

FULLMODEL_DEPTH = SCREW_LENGTH + HDD_BOTTOM_SCREW_DEPTH + 54; // ~ 112 mm
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
            echo(10);
            echo((full_depth - starting_depth) / (bridging_width * 2));
            for (i = [0:((full_depth - starting_depth) / (bridging_width * 2) - 1)]) {
                polygon([
                        [starting_depth + bridging_width * 2 * i, z_height],
                        [starting_depth + bridging_width * 2 * i + bridging_width, z_height],
                        [starting_depth + bridging_width * 2 * i + bridging_width, z_height + height],
                        [starting_depth + bridging_width * 2 * i, z_height + height],
                    ]);
            }
        }
}

module Mounting(width, depth, height, distance, screw_id, for_cutout_only = false) {
    module ScrewHole(width, depth, height, screw_id, screws_per_socket = 2) {
        total_screws = screws_per_socket - 1;
        for (i = [0:total_screws]) {
            translate([width / 2, - 0.01, width / 2 + (height - screw_id - width) / total_screws * i])
                rotate([- 90, 0, 0])
                    cylinder(h = depth + 0.02, d = screw_id, center = false, $fs = 0.1);
        }
    }

    for (i = [0:1]) {
        translate([distance * i, 0, 0]) {
            if (!for_cutout_only) {
                difference() {
                    cube([width, depth, height]);
                    ScrewHole(width, depth, height, screw_id, screws_per_socket = 3);
                }
            } else {
                ScrewHole(width, depth, height, screw_id, screws_per_socket = 3);
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

        // to prepare the space for the screws later
        translate([0, 0, UBASE_THICKNESS])
            Mounting(SCREW_OD * 2.5, SCREW_LENGTH, FULLMODEL_HEIGHT - UBASE_THICKNESS, FAN_MOUNTING_DISTANCE, SCREW_ID,
            true);
    }
    translate([0, 0, UBASE_THICKNESS])
        Mounting(SCREW_OD * 2.5, SCREW_LENGTH, FULLMODEL_HEIGHT - UBASE_THICKNESS, FAN_MOUNTING_DISTANCE, SCREW_ID);
}
