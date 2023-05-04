// created by IndiePandaaaaa | Lukas

function hexagon_get_inner_diameter(single_outer_diameter = 20) = tan(60) * (single_outer_diameter / 2);

function hexagon_inbetween_distance_x(single_outer_diameter = 20) = single_outer_diameter -
    hexagon_get_inner_diameter(single_outer_diameter);

function hexagon_get_y_inner_element_additional_height(single_outer_diameter = 20) = single_outer_diameter / 2 +
        hexagon_inbetween_distance_x(single_outer_diameter) * cos(30) + (single_outer_diameter / 2) * cos(60);

function hexagon_get_y_outer_element_height(single_outer_diameter = 20) = single_outer_diameter;

function hexagon_get_y_next_structure(single_outer_diameter = 20) = (single_outer_diameter / 2 * 3) +
            hexagon_inbetween_distance_x(single_outer_diameter) * cos(30) * 2;

function hexagon_get_y_element_height(single_outer_diameter = 20) =
    hexagon_get_y_outer_element_height(single_outer_diameter) +
    hexagon_get_y_inner_element_additional_height(single_outer_diameter);

function hexagon_get_x_element_count(width, single_outer_diameter = 20) = floor(width / single_outer_diameter);

function hexagon_get_y_element_count(depth, single_outer_diameter = 20) = floor(((depth -
    (hexagon_get_y_element_height(single_outer_diameter) - hexagon_get_y_next_structure(single_outer_diameter))) /
    hexagon_get_y_next_structure(single_outer_diameter)) * 2);

function hexagon_get_used_width(width, single_outer_diameter = 20) = single_outer_diameter *
    hexagon_get_x_element_count(width, single_outer_diameter) - hexagon_inbetween_distance_x(single_outer_diameter);

function hexagon_get_used_depth(depth, single_outer_diameter = 20) = round(hexagon_get_y_element_count(depth,
single_outer_diameter) / 2) * hexagon_get_y_outer_element_height(single_outer_diameter) +
        floor(hexagon_get_y_element_count(depth, single_outer_diameter) / 2) * (hexagon_get_y_next_structure(
    single_outer_diameter) - single_outer_diameter) +
            (hexagon_get_y_element_count(depth, single_outer_diameter) + 1) % 2 * (hexagon_get_y_element_height(
    single_outer_diameter) - hexagon_get_y_next_structure(single_outer_diameter));

module hexagon_pattern(width, depth, thickness, single_outer_diameter = 20, vertices = 6) {
    inner_diameter = hexagon_get_inner_diameter(single_outer_diameter);

    count_x = hexagon_get_x_element_count(width, single_outer_diameter);
    count_y = hexagon_get_y_element_count(depth, single_outer_diameter);

    angle = 360 / vertices * 1.5;

    for (y = [0:count_y - 1]) {
        for (x = [0:count_x - 1]) {

            if (y % 2 == 0) {
                translate([inner_diameter / 2 + single_outer_diameter * x, (single_outer_diameter / 2) + inner_diameter
                    * y, - 0.01]) {
                    linear_extrude(height = thickness + 0.02) {
                        rotate([0, 0, angle]) circle(d = single_outer_diameter, $fn = vertices);
                    }
                }
            } else if (x < count_x - 1) {
                translate([inner_diameter / 2 + single_outer_diameter * x + single_outer_diameter / 2,
                        (single_outer_diameter / 2) + inner_diameter * y, - 0.01]) {
                    linear_extrude(height = thickness + 0.02) {
                        rotate([0, 0, angle]) circle(d = single_outer_diameter, $fn = vertices);
                    }
                }
            }

        }
    }
}

width = 100;
depth = 100;
difference() {
    cube([width, depth, 3]);
    translate([(width - hexagon_get_used_width(width)) / 2, (depth - hexagon_get_used_depth(depth)) / 2, 0])
        hexagon_pattern(width, depth, 3);
}