use <Parts/Screw.scad>

thickness = 2.5;
screwSocketWidth = 14;
splitterWidth = 83.1 + 0.1; // for tolerance issues
chamfer = 1;

module Bracket() {
    linear_extrude(height = screwSocketWidth) {
        endWidth = (screwSocketWidth + thickness) * 2;
        polygon(points = [
                [0, 0],
                [screwSocketWidth + thickness, 0],
                [screwSocketWidth + thickness, 8.9],
                [screwSocketWidth + thickness + splitterWidth, 8.9],
                [screwSocketWidth + thickness + splitterWidth, 0],
                [endWidth + splitterWidth, 0],
                [endWidth + splitterWidth, thickness],
                [screwSocketWidth + thickness + splitterWidth + thickness, thickness],
                [screwSocketWidth + thickness + splitterWidth + thickness, 8.9 + thickness - chamfer],
                [screwSocketWidth + thickness + splitterWidth + thickness - chamfer, 8.9 + thickness],
                [screwSocketWidth + chamfer, 8.9 + thickness],
                [screwSocketWidth, 8.9 + thickness - chamfer],
                [screwSocketWidth, thickness],
                [0, thickness]
            ]);
    }
}
difference() {
    Bracket();
    translate([screwSocketWidth / 2, -thickness, screwSocketWidth / 2])
        rotate([- 90, 0, 0]) screw(3.5, 5, true);
    translate([screwSocketWidth + splitterWidth + thickness * 2, 0, 0])
        translate([screwSocketWidth / 2, -thickness, screwSocketWidth / 2])
            rotate([- 90, 0, 0]) screw(3.5, 5, true);
}


