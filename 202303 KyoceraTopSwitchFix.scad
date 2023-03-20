use <Parts/ZipTiePoint.scad>

height = 8.9;
width = 14.5;
depth = 7.2;

union() {
    difference() {
        cube([width, depth, height]);
        translate([width / 2, 0, height / 2])
            rotate([90, 0, 90])
                ziptiepoint(cutout_sample = true);
    }
    translate([width / 2, 0, height / 2])
        rotate([90, 0, 90])
            ziptiepoint(cutout_sample = false);
}