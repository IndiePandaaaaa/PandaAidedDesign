//$fs = 0.1; [size in mm] | $fa = 1; [degrees]
//$fn = 100; [defined faces]
// ,$fs=0.1,$fn=100

use <Parts/Screw.scad>

height=85;
diaWheel=height/1.25;
wdhAxis=diaWheel/1.25;
socket_diameter=8;

module wheelPair(wheel_diameter,axis_width,fs=0.1,fn=100) {
	wheel_width=wheel_diameter/5;
	axis_diameter=wheel_diameter/3.5;
	
	if (axis_diameter > wheel_diameter) {
		echo("Diameter Axis > Diameter Wheel!");
		axis_diameter = wheel_diameter;
	}
	translate([-axis_width/2,0,0]) rotate([0,90,0]) union() {
		cylinder(wheel_width,d=wheel_diameter,$fs=fs,$fn=fn);
		cylinder(axis_width,d=axis_diameter,$fs=fs,$fn=fn);
		translate([0,0,axis_width-wheel_width]) cylinder(wheel_width,d=wheel_diameter,$fs=fs,$fn=fn);
	}
}

module mudguard(wheel_diameter,axis_width,socket_diameter,offset_space,guard_thickness,fs=0.1,fn=100) {
	wheel_width=wheel_diameter/5;
	axis_diameter=wheel_diameter/3.5;
	
	wheel_diameter_offset=wheel_diameter+offset_space*2;
	axis_diameter_offset=axis_diameter+offset_space*2;
	guard_diameter=wheel_diameter_offset+guard_thickness*2;
	
	socket_id=wheel_diameter/4;
	socket_od_thickness=socket_id/4;
	socket_od=socket_id+offset_space*2+socket_od_thickness;
	
	wheel_width_offset=wheel_width+offset_space*2;
	axis_width_offset=axis_width+offset_space*2;
	guard_width=axis_width-offset_space*2;
	
	socket_y_position=-wheel_diameter/2+socket_od/2+1;
	socket_z_position=axis_diameter_offset/2;
	
	socket_height=guard_diameter/2-socket_z_position+offset_space;

	difference() {
		union() {
			difference() {
				translate([-guard_width/2,0,0]) rotate([0,90,0]) cylinder(guard_width,d=guard_diameter,true,$fs=fs,$fn=fn); // GUARD
				translate([0,0,-guard_diameter/2-4]) cube([guard_diameter,guard_diameter,guard_diameter],true);
				wheelPair(wheel_diameter_offset,axis_width_offset);
				wheelPair(wheel_diameter_offset,axis_width_offset-offset_space*2);
			}
			translate([0,socket_y_position,socket_z_position]) cylinder(socket_height,d=socket_od+offset_space*2+2,true,$fs=fs,$fn=fn);
		}
		union() {
			translate([0,socket_y_position,socket_z_position]) cylinder(socket_height+offset_space*2,d=socket_id+offset_space*2,true,$fs=fs,$fn=fn);
			translate([0,socket_y_position,socket_z_position]) cylinder(socket_id+offset_space*2,d=socket_od+offset_space*2,true,$fs=fs,$fn=fn);
		}
	}
	union() {
		translate([0,socket_y_position,socket_z_position+offset_space]) cylinder(socket_height+11.5+2,d=socket_diameter,true,$fs=fs,$fn=fn);
		translate([0,socket_y_position,socket_z_position+offset_space]) cylinder(socket_height,d=socket_id+offset_space,true,$fs=fs,$fn=fn);
		translate([0,socket_y_position,socket_z_position+offset_space]) cylinder(socket_id,d=socket_od+offset_space,true,$fs=fs,$fn=fn);
		translate([0,socket_y_position,socket_z_position+socket_height+offset_space]) cylinder(2,d=socket_od+offset_space,true,$fs=fs,$fn=fn);
	}
}
difference() {
	union() {
		mudguard(diaWheel,wdhAxis,socket_diameter,0.5,2);
		wheelPair(diaWheel,wdhAxis);
	}
	sc_len=40;
	translate([wdhAxis/2-sc_len+1,0,0]) union() {
		translate([sc_len-3.5,0,0]) rotate([0,90,0]) screw(3.5,2.5,false);
		translate([sc_len-4.5,0,0]) rotate([0,90,0]) screw(2.5,1.5,false);
		rotate([0,90,0]) screw(2,sc_len-4,false);
	}
	sCube=diaWheel*2;
	//color("white") translate([sCube/2,0,0]) cube([sCube,sCube*2,sCube*2],true);
}
