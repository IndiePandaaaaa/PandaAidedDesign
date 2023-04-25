//$fs = 0.1; [size in mm] | $fa = 1; [degrees]
//$fn = 100; [defined faces]
// ,$fs=0.1,$fn=100
// ,$fs=fs,$fn=fn

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

FULLMODEL_DEPTH = HDD_BOTTOM_SCREW_DEPTH + 70; // ~ 112 mm
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
    translate([offset_x, - depth - bottom_screw_depth + 2, 0])
        cube([width, depth, height]);
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

module Mounting(width, depth, distance) {

}

union() {
    difference() {
        translate([0, FULLMODEL_DEPTH, 0]) rotate([90, 0, 0])
            UBase(FULLMODEL_DEPTH, FULLMODEL_HEIGHT, WIDTH_HDD + 2 * RUBBER_WIDTH_ADDITIONAL,
            TOLERANCE_HDD, UBASE_THICKNESS);

        translate([UBASE_THICKNESS + TOLERANCE_HDD / 2 + RUBBER_OD / 2, HDD_BOTTOM_SCREW_DEPTH + SCREW_LENGTH + 1, 0]) {
            BottomHoles(RUBBER_OD, RUBBER_OD_ID, UBASE_THICKNESS - RUBBER_HEIGHT_INTERNAL);
            ConnectorSpacer(HDD_SATA_CONNECTOR_WIDTH, HDD_SATA_CONNECTOR_CABLE_DEPTH, HDD_SATA_CONNECTOR_HEIGHT,
                HDD_SATA_CONNECTOR_POS_X - HDD_BOTTOM_SCREW_POS_X, HDD_BOTTOM_SCREW_DEPTH);
        }

        translate([FULLMODEL_WIDTH, 0, 0]) rotate([0, 0, 90])
            AirVent(FULLMODEL_HEIGHT - UBASE_THICKNESS * 2, SCREW_LENGTH + 1,
            FULLMODEL_HEIGHT, FULLMODEL_DEPTH, FULLMODEL_WIDTH, UBASE_THICKNESS);

    }
}
/*module UBase(width_drive, height_border, depth_bracket, bracket_thickness = 3, tolerance_hdd = 0.15) {
    linear_extrude(height = depth_bracket) {
        polygon([
                [0, 0],
                [width_drive + tolerance_hdd + bracket_thickness * 2, 0],
                [width_drive + tolerance_hdd + bracket_thickness * 2, height_border],
                [width_drive + tolerance_hdd + bracket_thickness * 1, height_border],
                [width_drive + tolerance_hdd + bracket_thickness * 1, bracket_thickness],
                [bracket_thickness * 1, bracket_thickness],
                [bracket_thickness * 1, height_border],
                [0, height_border],
            ]);
    }
}

module Posts(height, depth, width, post_depth, post_depth_self_threading, use_self_threading_screws = false) {
    distance_x = width;
    distance_y = depth - post_depth; // depth

    if (use_self_threading_screws) {
        distance_y = distance_y + (post_depth_self_threading - post_depth);
    }

    module post(post_normal, post_self_threading, self_threading = false) {
        linear_extrude(height = height) {
            if (!self_threading) {
                polygon([
                        [0, 0],
                        [0, post_normal],
                        [post_normal, post_normal],
                        [post_normal, 0],
                    ]);
            } else {
                polygon([
                        [0, 0],
                        [0, post_self_threading],
                        [post_normal, post_self_threading],
                        [post_normal, 0],
                    ]);
            }
        }
    }

    translate([0, 0, 0]) post(post_depth, post_depth_self_threading, use_self_threading_screws);
    translate([distance_x, 0, 0]) post(post_depth, post_depth_self_threading, use_self_threading_screws);
    translate([0, distance_y, 0]) post(post_depth, post_depth_self_threading, false);
    translate([distance_x, distance_y, 0]) post(post_depth, post_depth_self_threading, false);
}

center_ubase_offset = ((FAN_MOUNTING_DISTANCE + POST_DEPTH) - (WIDTH_HDD + TOLERANCE_HDD + UBASE_THICKNESS * 2))/2;
echo(((FAN_MOUNTING_DISTANCE + POST_DEPTH) - (WIDTH_HDD + TOLERANCE_HDD + UBASE_THICKNESS * 2))/2);
echo(((WIDTH_HDD + TOLERANCE_HDD + UBASE_THICKNESS * 2)));
echo(((WIDTH_HDD + TOLERANCE_HDD + UBASE_THICKNESS * 2))/2);
echo(((FAN_MOUNTING_DISTANCE + POST_DEPTH)));

// POST_DEPTH + (FAN_MOUNTING_DISTANCE - POST_DEPTH - WIDTH_HDD - TOLERANCE_HDD)/2;

Posts(FULLMODEL_HEIGHT, FULLMODEL_DEPTH, FAN_MOUNTING_DISTANCE, POST_DEPTH, POST_DEPTH_SCREW_IN, false);
translate([center_ubase_offset, FULLMODEL_DEPTH, STABILIZER_HEIGHT])
    rotate([90, 0, 0]) UBase(WIDTH_HDD, BORDER_HEIGHT, FULLMODEL_DEPTH, bracket_thickness = UBASE_THICKNESS,
    tolerance_hdd = TOLERANCE_HDD);*/

//module Base(depth, width, height, thickness,
//bottom_stabilzator = 3, chamfer = 1.5) {
//    rotate([0, 0, 0]) translate([0, 0, - depth])
//        linear_extrude(height = depth) {
//            polygon([
//                    [0, 0],
//                    [thickness, 0],
//                    [thickness, bottom_stabilzator - chamfer],
//                    [thickness + chamfer, bottom_stabilzator],
//                    [(width + thickness) / 4 * 1 - (thickness / 2) - chamfer, bottom_stabilzator],
//                    [(width + thickness) / 4 * 1 - (thickness / 2), bottom_stabilzator - chamfer],
//                    [(width + thickness) / 4 * 1 - (thickness / 2), 0],
//                    [(width + thickness) / 4 * 1 + (thickness / 2), 0],
//                    [(width + thickness) / 4 * 1 + (thickness / 2), bottom_stabilzator - chamfer],
//                    [(width + thickness) / 4 * 1 + (thickness / 2) + chamfer, bottom_stabilzator],
//                    [(width + thickness) / 4 * 2 - (thickness / 2) - chamfer, bottom_stabilzator],
//                    [(width + thickness) / 4 * 2 - (thickness / 2), bottom_stabilzator - chamfer],
//                    [(width + thickness) / 4 * 2 - (thickness / 2), 0],
//                    [(width + thickness) / 4 * 2 + (thickness / 2), 0],
//                    [(width + thickness) / 4 * 2 + (thickness / 2), bottom_stabilzator - chamfer],
//                    [(width + thickness) / 4 * 2 + (thickness / 2) + chamfer, bottom_stabilzator],
//                    [(width + thickness) / 4 * 3 - (thickness / 2) - chamfer, bottom_stabilzator],
//                    [(width + thickness) / 4 * 3 - (thickness / 2), bottom_stabilzator - chamfer],
//                    [(width + thickness) / 4 * 3 - (thickness / 2), 0],
//                    [(width + thickness) / 4 * 3 + (thickness / 2), 0],
//                    [(width + thickness) / 4 * 3 + (thickness / 2), bottom_stabilzator - chamfer],
//                    [(width + thickness) / 4 * 3 + (thickness / 2) + chamfer, bottom_stabilzator],
//                    [width - chamfer, bottom_stabilzator],
//                    [width, bottom_stabilzator - chamfer],
//                    [(width + thickness), 0],
//                    [width + thickness * 2, 0],
//                    [width + thickness * 2, height],
//                    [(width + thickness), height],
//                    [(width + thickness), thickness + bottom_stabilzator],
//                    [thickness, thickness + bottom_stabilzator],
//                    [thickness, height],
//                    [0, height],
//                ]);
//        }
//}
//
//module Mounting(width_hdd, height_bracket, thickness_bracket, thickness_mounting, bottom_stabilzator, width = 10) {
//
//    if (width < thickness_bracket) {
//        width = thickness_bracket;
//    }
//
//    linear_extrude(height = thickness_mounting) {
//        sata_connector_height = thickness_bracket + bottom_stabilzator + 10; // 10 mm = SATA connector height
//        polygon([
//                [0, 0],
//                [width, 0],
//                [width, sata_connector_height],
//                [width + width_hdd, sata_connector_height],
//                [width + width_hdd, 0],
//                [width * 2 + width_hdd, 0],
//                [width * 2 + width_hdd, height_bracket],
//                [0, height_bracket],
//            ]);
//    }
//}
//
//module bottom_screw_holes() {
//    // rubber socket diameter 10 mm cutout?
//    //
//
//    union() {
//    //    translate([0,0,0])
//	}
//}
//
//module HDD_Bracket(height_HDD, width_HDD, depth_HDD,
//THICKNESS = 3, THICKNESS_MOUNTING = 8, BRACKET_HIGHT = 27, STABILIZATOR_HEIGHT = 3, WIDTH_MOUNTING = 14) {
//
//    translate([0, 0, - THICKNESS_MOUNTING])
//        union() {
//            Mounting(width_hdd = width_HDD, thickness_mounting = THICKNESS_MOUNTING, thickness_bracket = THICKNESS + 3,
//            bottom_stabilzator = STABILIZATOR_HEIGHT, width = WIDTH_MOUNTING, height_bracket = BRACKET_HIGHT);
//
//            translate([WIDTH_MOUNTING - THICKNESS, 0, 0])
//                Base(75, width = width_HDD, height = BRACKET_HIGHT, thickness = THICKNESS, bottom_stabilzator =
//                STABILIZATOR_HEIGHT);
//        }
//}
//
////HDD_Bracket(height_HDD, width_HDD, depth_HDD);
