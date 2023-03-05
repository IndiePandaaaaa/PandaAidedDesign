use <Functions/Fillet.scad>
use <Functions/Chamfer.scad>
use <Parts/Screw.scad>

width = 80;
depth = 20;
height = 3;
sc_len = 8;

// BRACKET
color("orange") difference() {
	translate([0,0,height/2]) cube([width, depth, height], true);
	translate([-(width/2-depth/2),0,-sc_len+height]) screw(3.5, sc_len, false);
	translate([(width/2-depth/2),0,-sc_len+height]) screw(3.5, sc_len, false);
	
	for (i = [0:2:3]) {
		rotate([0, 0, 90*i]) fillet([width/2, depth/2, 0], depth/2, height);
		rotate([0, 0, 90*(i+1)]) fillet([depth/2, width/2, 0], depth/2, height);
	}
}













