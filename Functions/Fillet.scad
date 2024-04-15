module fillet(position, radius, height, fs=0.1, fa=1) {
	color("#00dd00") translate(position) translate([-radius, -radius, 0]) difference() {
		translate([0,0,-0.01]) cube([radius+0.02, radius+0.02, height+0.02]);
		translate([0,0,0.02]) cylinder(height*2, radius, radius, true, $fs=fs, $fa=fa);
	}
}

module fillet_rectangle(radius, width, depth, thickness, $fn = 75) {
  position = [ [0, 0], [width, 0], [width, depth], [0, depth] ];

  module single_edge(radius, thickness) {
    difference() {
      translate([-.1, -.1, -.1]) cube([radius + .1, radius + .1, thickness + .2]);
      translate([radius, radius, -.2]) cylinder(r = radius, h = thickness + .4);
    }
  }

  union() {
    for (i = [0 : 3]) {
      translate([position[i][0], position[i][1], 0]) 
        rotate([0, 0, 90 * i]) 
          single_edge(radius, thickness);
    }
  }
}
