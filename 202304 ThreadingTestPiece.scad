// created by IndiePandaaaaa | Lukas

// https://de.wikipedia.org/wiki/Kernloch
//  Gewinde	Steigung	Kernloch
//  M12     x1.75	10.2
//  M10	    x1.5	8.5
//  M8	    x1.25	6.8
//  M6	    x1	    5.0
//  M5	    x0.8	4.2
//  M4	    x0.7	3.3
//  M3	    x0.5	2.5

difference() {
    cube([17, 24, 10]);
    for (i = [0:2]) {
        translate([5, 5 + 7 * i, - 2]) {
            cylinder(15, d = 3.3, $fs = 0.1);
            translate([7, 0, 0])
                cylinder(15, d = 2.5, $fs = 0.1);
        }
    }
}