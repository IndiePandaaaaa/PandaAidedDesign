// created by IndiePandaaaaa | Lukas

module hexagon_pattern(thickness, width, depth, single_outer_diameter = 20) {
    inner_radius = tan(60) * (single_outer_diameter / 2);

    count_x = round(width / single_outer_diameter);

    echo("IR: ", inner_radius);

    // inner_radius * 2 is used but single_hexagon_od is needed to consider the strips inbetween
    distance_x = (width - (count_x * single_outer_diameter)) / 2;

    count_y = round(depth / (inner_radius + single_outer_diameter));

    for (y = [0:count_y - 1]) {
        for (x = [0:count_x - 1]) {
            translate([inner_radius / 2 + single_outer_diameter * x,
                    (single_outer_diameter / 2) + inner_radius * 2 * y, - 0.01]) {
                linear_extrude(height = thickness + 0.02) {
                    rotate([0, 0, 90]) {
                        circle(d = single_outer_diameter, $fn = 6);
                    }
                }
                if (x < count_x - 1 && y < floor(depth / (inner_radius + single_outer_diameter))) {
                    translate([single_outer_diameter / 2, inner_radius, 0]) {
                        linear_extrude(height = thickness + 0.02) {
                            rotate([0, 0, 90]) {
                                circle(d = single_outer_diameter, $fn = 6);
                            }
                        }
                    }
                }
            }
        }
    }
}

// hexagon_pattern(3, 100, 130);