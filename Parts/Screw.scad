module screw(diameter, length, cross=true, fs=0.1, fa=1) {
	//$fs = 0.1; [size in mm] | $fa = 1; [degrees]
	//$fn = 100; [defined faces]
	
	if (diameter > length) {
		echo("Screw is too short");
		diameter = length+1;
		echo("New diameter is: ", diameter);
	}
	
	hole = diameter+0.5;
	cone_hight = diameter-1;
	if (cone_hight < 0) {
		cone_hight = 1;
	}
	translate([0,0,0.01]) color("silver") difference() {
		union() {
			translate([0,0,length-cone_hight]) cylinder(cone_hight, hole, hole+cone_hight, $fs = fs, $fa = fa);
			cylinder(length, hole, hole, $fs = fs, $fa = fa);
		}
		if (cross) {
			translate([0,0,length-hole+0.01+1]) rotate([0,0,45]) difference() {
				rotate([0, 0,  45]) cylinder(hole-1, 2,hole+cone_hight-0.5,$fn=4);
				for (i = [0 : 1 : 3]) {
					rotate([0, 0, 90*i]) translate([diameter/2.5, diameter/2.5, -0.1]) cube(hole+0.2);
				}
			}
		}
	}
}