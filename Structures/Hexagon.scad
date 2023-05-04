// created by IndiePandaaaaa | Lukas

function hexagon_get_inner_diameter(single_outer_diameter = 20) = tan(60) * (single_outer_diameter / 2);

function hexagon_inbetween_distance_x(single_outer_diameter = 20) = single_outer_diameter - hexagon_get_inner_diameter(
single_outer_diameter);

function hexagon_get_y_next_structure(single_outer_diameter = 20) = (single_outer_diameter / 2 * 3) +
            hexagon_inbetween_distance_x(single_outer_diameter) * cos(30) * 2;

function hexagon_get_y_element_height(single_outer_diameter = 20) = single_outer_diameter / 2 * 3 +
        hexagon_inbetween_distance_x(single_outer_diameter) * cos(30) + (single_outer_diameter / 2) * cos(30);

function hexagon_get_x_element_count(width, single_outer_diameter = 20) = floor(width / single_outer_diameter);

function hexagon_get_y_element_count(depth, single_outer_diameter = 20) = ((depth - (hexagon_get_y_element_height(
single_outer_diameter) - hexagon_get_y_next_structure(single_outer_diameter))) / hexagon_get_y_next_structure(
single_outer_diameter)) * 2;

function hexagon_get_used_width(width, single_outer_diameter = 20) = single_outer_diameter * hexagon_get_x_element_count
(width, single_outer_diameter) - hexagon_inbetween_distance_x(single_outer_diameter);

//function hexagon_get_used_depth(depth, single_outer_diameter = 20) = hexagon_get_y_next_structure(single_outer_diameter)
//    * (floor(depth / hexagon_get_y_next_structure(single_outer_diameter))) + (hexagon_inbetween_distance_x(single_outer_diameter)) * cos(30);

function hexagon_get_used_depth(depth, single_outer_diameter = 20) = (hexagon_get_y_element_count(depth,
single_outer_diameter) - 1) * hexagon_get_y_next_structure(single_outer_diameter) + hexagon_get_y_element_height(
single_outer_diameter);

module hexagon_pattern(width, depth, thickness, single_outer_diameter = 20) {
    inner_diameter = hexagon_get_inner_diameter(single_outer_diameter);

    count_x = hexagon_get_x_element_count(width, single_outer_diameter);
    count_y = hexagon_get_y_element_count(depth, single_outer_diameter);

    echo("count 1: ", hexagon_get_y_element_count(depth, single_outer_diameter));
    echo("count 2: ", hexagon_get_y_element_height(single_outer_diameter));
    echo("count 3: ", depth - hexagon_get_y_element_height(single_outer_diameter));
    echo("count 4: ", hexagon_get_y_next_structure(single_outer_diameter));
    echo("count 5: ", ((depth - hexagon_get_y_element_height(single_outer_diameter)) / hexagon_get_y_next_structure(
    single_outer_diameter)));

    for (y = [0:count_y - 1]) {
        for (x = [0:count_x - 1]) {

            if (y % 2 == 0) {
                translate([inner_diameter / 2 + single_outer_diameter * x, (single_outer_diameter / 2) + inner_diameter
                    * y, - 0.01]) {
                    linear_extrude(height = thickness + 0.02) {
                        rotate([0, 0, 90]) circle(d = single_outer_diameter, $fn = 6);
                    }
                }
            } else if (x < count_x - 1 && y % 2 == 1) {
                translate([inner_diameter / 2 + single_outer_diameter * x + single_outer_diameter / 2, (
                    single_outer_diameter / 2) + inner_diameter * y, - 0.01]) {
                    linear_extrude(height = thickness + 0.02) {
                        rotate([0, 0, 90]) circle(d = single_outer_diameter, $fn = 6);
                    }
                }
            }

        }
    }
}

width = 100;
depth = 142;
difference() {
    cube([width, depth, 3]);
    translate([(width - hexagon_get_used_width(width)) / 2, (depth - hexagon_get_used_depth(depth)) / 2 * 0, 0])
        hexagon_pattern(width, depth, 3);
}
echo("next element depth: ", hexagon_get_y_next_structure());
echo("element depth: ", hexagon_get_y_element_height());
echo("used depth: ", hexagon_get_used_depth(depth));
echo("model depth: ", depth);