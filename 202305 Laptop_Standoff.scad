// created by IndiePandaaaaa | Lukas

use <Structures/Hexagon.scad>

MODEL_TOLERANCE = 0.5;
PRINTER_SHEET_WIDTH = 200;

// Laptop Reference: Dell Inspiron 16 Plus 7610
laptop_width = 355;
laptop_rubber_higher_width = 7.2;
laptop_rubber_lower_width = 3.3;
laptop_rubber_height = 4.6;

standoff_width = laptop_width / 3 * 1.5;
standoff_count = 4;
standoff_height = 21;
standoff_brick_width = 16;
standoff_bottom_height = 3.5;

width_between = (standoff_width - (standoff_brick_width * standoff_count)) / (standoff_count - 1);

rubber_bottom_thickness = 0.5;
rubber_wall_thickness = 1;

chamfer = 3;

if (standoff_width > PRINTER_SHEET_WIDTH) {
    standoff_width = PRINTER_SHEET_WIDTH;
}

difference() {
    translate([0, standoff_width]) rotate([90, 0, 0])
        linear_extrude(standoff_width) {
            polygon([
                    [0, 0],
                    [standoff_height, 0],
                    [standoff_height, standoff_height],
                    [standoff_height - (standoff_height - laptop_rubber_higher_width - MODEL_TOLERANCE) / 2,
                        standoff_height - 0],
                    [standoff_height - (standoff_height - laptop_rubber_lower_width - MODEL_TOLERANCE) / 2,
                        standoff_height - laptop_rubber_height / 2],
                    [(standoff_height - laptop_rubber_lower_width - MODEL_TOLERANCE) / 2,
                        standoff_height - laptop_rubber_height / 2],
                    [(standoff_height - laptop_rubber_higher_width - MODEL_TOLERANCE) / 2, standoff_height],
                    [0, standoff_height],
                ]);
        }

    for (i = [1:standoff_count - 1]) {
        translate([0, standoff_brick_width + (width_between + standoff_brick_width) * (i - 1), standoff_bottom_height])
            {
                hex_depth = standoff_height - 4;
                hex_od = hex_depth / 2;
                translate([standoff_height - (standoff_height - hexagon_get_used_depth(hex_depth, hex_od)) / 2,
                        (width_between - hexagon_get_used_width(width_between, hex_od)) / 2,
                    - standoff_bottom_height])
                    //cube([standoff_height / 2, width_between, standoff_height]);
                    rotate([0, 0, 90])
                        hexagon_pattern(width_between, hex_depth, standoff_height, hex_od);

                rotate([90, 0, 90]) {
                    linear_extrude(standoff_height) {
                        polygon([
                                [0, chamfer * 2],
                                [chamfer, 0],
                                [width_between - chamfer, 0],
                                [width_between, chamfer * 2],
                                [width_between, standoff_height],
                                [0, standoff_height],
                            ]);
                    }
                }
            }
    }

    for (i = [1:standoff_count]) {
        translate([rubber_wall_thickness, rubber_wall_thickness + (width_between + standoff_brick_width) * (i - 1), 0])
            cube([standoff_height - rubber_wall_thickness * 2, standoff_brick_width - rubber_wall_thickness * 2,
                rubber_bottom_thickness]);
    }
}

