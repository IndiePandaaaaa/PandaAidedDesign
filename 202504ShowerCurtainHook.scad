// created by IndiePandaaaaa|Lukas
// encoding: utf-8

TOLERANCE = .12;
THICKNESS = 2.5;
$fn = $preview ? 25 : 125;

// shower curtain rod diameter 25.05 mm

module base_model()
{
    rod_part_id = 31.1;
    rod_part_diameter = 8.2;
    rod_part_angle = 300;

    hook_part_depth = 5.9;
    hook_part_thickness = 2.1;

    union()
    {
        rotate(a = [ 0, 0, 90 + (360 - rod_part_angle) / 2 ]) union()
        {
            rotate_extrude(angle = rod_part_angle, convexity = 2)
            {
                translate(v = [ (rod_part_id + rod_part_diameter) / 2, 0 ]) circle(r = rod_part_diameter / 2);
            }
            for (i = [0:1])
            {
                rotate([ 0, 0, (-360 + rod_part_angle) * i ])
                    translate(v = [ (rod_part_id + rod_part_diameter) / 2, 0, 0 ]) sphere(r = rod_part_diameter / 2);
            }
        }

        union()
        {

            translate(v = [ 6.25 / 2, -19 - rod_part_diameter / 2, -hook_part_depth / 2 ])
                rotate(a = [ 0, 0, (-360 + rod_part_angle) / 4 ]) translate(v = [ 0, -18, 0 ])
                    linear_extrude(height = hook_part_depth, center = false, convexity = 10, twist = 0, slices = 20,
                                   scale = 1.0) union()
            {
                // part I
                translate(v = [ hook_part_thickness + 6.25 / 2, 8.75 ]) rotate(a = [ 0, 0, (360 - rod_part_angle) / 2 ])
                    translate(v = [ -hook_part_thickness, 0 ])
                        square(size = [ hook_part_thickness, 15 ], center = false);
                // part II
                translate(v = [ 6.25 / 2, 0 ]) square(size = [ hook_part_thickness, 8.75 ], center = false);
                // part III
                difference()
                {
                    circle(r = 10.3 / 2);
                    circle(r = 6.25 / 2);
                    translate(v = [ -10, 0 ]) square(size = [ 20, 20 ]);
                }
                // part IV
                translate(v = [ -10.3 / 2, 0 ]) square(size = [ hook_part_thickness, 8.5 ]);
            }
        }
    }
}

module slim()
{
    rod_part_id = 32;
    rod_part_diameter = 8.2;
    rod_part_angle = 275;
    rod_part_thickness = 3.25;

    hook_part_depth = 5.9;
    hook_part_thickness = 2.1;

    union()
    {
        rotate(a = [ 0, 0, 90 + (360 - rod_part_angle) / 2 ]) union()
        {
            rotate_extrude(angle = rod_part_angle, convexity = 2)
            {
                translate(v = [ (rod_part_id + rod_part_diameter) / 2, 0 ])
                    square(size = [ rod_part_thickness, hook_part_depth ], center = false);
            }
        }

        union()
        {

            translate(v = [ 6.25 / 2, -20 - rod_part_diameter / 2, 0 ])
                rotate(a = [ 0, 0, (-360 + rod_part_angle) / 4 ]) translate(v = [ 0, -18, 0 ])
                    linear_extrude(height = hook_part_depth, center = false, convexity = 10, twist = 0, slices = 20,
                                   scale = 1.0) union()
            {
                // part I
                translate(v = [ hook_part_thickness + 6.25 / 2, 8.75 ]) rotate(a = [ 0, 0, (360 - rod_part_angle) / 2 ])
                    translate(v = [ -hook_part_thickness, 0 ])
                        square(size = [ hook_part_thickness, 15 ], center = false);
                // part II
                translate(v = [ 6.25 / 2, 0 ]) square(size = [ hook_part_thickness, 8.75 ], center = false);
                // part III
                difference()
                {
                    circle(r = 10.3 / 2);
                    circle(r = 6.25 / 2);
                    translate(v = [ -10, 0 ]) square(size = [ 20, 20 ]);
                }
                // part IV
                translate(v = [ -10.3 / 2, 0 ]) square(size = [ hook_part_thickness, 7 ]);

                // part V
                translate(v = [ -3, 17 ]) rotate(a = [ 0, 0, 60 ]) circle(r = 5, $fn = 3);
            }

            for (i = [0:1])
            {
                mirror(v = [ i, 0, 0 ]) translate(v = [ -16.9, rod_part_id - 16, 0 ]) linear_extrude(
                    height = hook_part_depth, center = false, convexity = 10, twist = 0, slices = 20, scale = 1.0)
                {
                    rotate(a = [ 0, 0, -40 ]) polygon(points = [
                        [ 0, 0 ],
                        [ rod_part_thickness, 0 ],
                        [ rod_part_thickness, 10 ],
                        [ rod_part_thickness + 3, 12.5 ],
                        [ 0, 15 ],
                    ]);
                }
            }
        }
    }
}

slim();
