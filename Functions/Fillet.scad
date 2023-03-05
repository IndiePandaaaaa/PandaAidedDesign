module fillet(position, radius, height, fs=0.1, fa=1) {
	color("#00dd00") translate(position) translate([-radius, -radius, 0]) difference() {
		translate([0,0,-0.01]) cube([radius+0.02, radius+0.02, height+0.02]);
		translate([0,0,0.02]) cylinder(height*2, radius, radius, true, $fs=fs, $fa=fa);
	}
}