// added by IndiePandaaaaa|Lukas

module Schuko2D()
{
    union()
    {
        difference()
        {
            circle(r = 36.5 / 2);
            square(size = [ 17.5, 50 ], center = true);
            square(size = [ 50, 3.5 ], center = true);
        }
        square(size = [ 32.3, 10 ], center = true);
        square(size = [ 17.6, 31.8 ], center = true);
        square(size = [ 4.2, 36.5 ], center = true);
    }
}

module Schuko3D(height)
{
    linear_extrude(height = height, center = true, convexity = 10, twist = 0, slices = 20, scale = 1.0) Schuko2D();
}
