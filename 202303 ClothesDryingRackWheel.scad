//$fs = 0.1; [size in mm] | $fa = 1; [degrees]
//$fn = 100; [defined faces]
// ,$fs=0.1,$fn=100

diaWheel = 37.5;
diaAxis = 11;
wdhWheel = 7.5;
wdhAxis = wdhWheel*2+13.5;

module pairOfWheel(dWheel,dAxis,wWheel,wAxis,fs=0.1,fn=100) {
	translate([-wAxis/2,0,0]) rotate([0,90,0]) union() {
		cylinder(wWheel,d=dWheel,$fs=fs,$fn=fn);
		cylinder(wAxis,d=diaAxis,$fs=fs,$fn=fn);
		translate([0,0,wAxis-wWheel]) cylinder(wWheel,d=dWheel,$fs=fs,$fn=fn);
	}
}

module mudguard(wAxis,dWheel,fs=0.1,fn=100) {
	dWeelOffset = dWheel+4;
	difference() {
		translate([-wdhAxis/2,0,0]) rotate([0,90,0]) cylinder(wdhAxis,d=dWeelOffset,true,$fs=fs,$fn=fn);
		translate([0,0,-dWeelOffset/2]) cube([dWeelOffset,dWeelOffset,dWeelOffset],true,$fs=fs,$fn=fn);
		
	}
}

mudguard(wdhAxis,diaWheel);
//pairOfWheel(diaWheel,diaAxis,wdhWheel,wdhAxis);

