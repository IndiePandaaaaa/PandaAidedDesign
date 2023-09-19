// created by IndiePandaaaaa | Lukas

use <Parts/Screw.scad>

SCREWS = 1;  // per width
WIDTH = 18; // width of the bracket

module LBracket(screws, width, chamfer = 1, screw_od = 3.5, thickness = 3.5) {
    width_needed = (cone_diameter_cutout(screw_od) + 1 * 2 + thickness) * screws + thickness;

    if (width < width_needed) {
        echo("GIVEN WIDTH IS TOO SMALL!");
        echo("=> CHANGING WIDTH TO: ", width_needed);
    }
    width_used = width < width_needed ? width_needed:width;

    sides = cone_diameter_cutout(screw_od) + 1 * 2 + chamfer * 3 + thickness;
    solidifier = screws + 1;
    width_inbetween = (width_used - thickness * solidifier) / screws;

    difference() {
        union() {
            linear_extrude(width_used) {
                polygon([
                        [0, 0],
                        [thickness, 0],
                        [thickness, sides - thickness - chamfer],
                        [thickness + chamfer, sides - thickness],
                        [sides, sides - thickness],
                        [sides, sides],
                        [chamfer, sides],
                        [0, sides - chamfer],
                    ]);
            }

            for (i = [1:solidifier]) {
                offset_z_solidifier = width_inbetween * (i - 1) + thickness * (i - 1);
                translate([chamfer, 0, offset_z_solidifier])
                    cube([sides - chamfer, sides - chamfer, thickness]);
            }
        }
        cube_size = sides * 1.2 > width_used ? sides * 1.2:width_used;
        translate([thickness - chamfer * 1.25, - chamfer / 2, - chamfer / 2]) rotate([0, 0, - 45])
            cube(cube_size + chamfer);

        for (i = [0:screws - 1]) {
            offset_z_screw = thickness + width_inbetween / 2 + (thickness + width_inbetween) * i;
            rotation = [[0, 90, 0], [0, 90, - 90]];
            translation = [[thickness, (sides - thickness) / 2, offset_z_screw],
                    [thickness + (sides - thickness) / 2, sides - thickness, offset_z_screw]];

            if (screws == 1 || screws == 2) {
                translate(translation[(i + 1) % 2]) rotate(rotation[(i + 1) % 2])
                    screw(screw_od, thickness * 2, true);
            }

            translate(translation[i % 2]) rotate(rotation[i % 2]) screw(screw_od, thickness * 2, true);
        }
    }
}

LBracket(SCREWS, WIDTH);
