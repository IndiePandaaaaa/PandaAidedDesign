// created by IndiePandaaaaa|Lukas 
// encoding: utf-8

// used: ruthex M4S and ruthex M3S

TOLERANCE = .15;
THICKNESS = 2;
$fn = $preview? 25:125;


module MetricInsert(OD, ID, height) {
  difference() {
    union() {
      cylinder(d=OD + THICKNESS*2 + TOLERANCE, h=THICKNESS);
      cylinder(d=OD, h=height + TOLERANCE);
    }
    translate([0, 0, -.1]) cylinder(d=ID, h=height + TOLERANCE + .2);
  }
}

module M3Insert(OD=5) { // used with ruthex M3S
  ID = 4;
  height = 4;

  MetricInsert(OD=OD, ID=ID, height=height);
}

module M4Insert(OD=7) {
  ID = 5.6;
  height = 4;

  MetricInsert(OD=OD, ID=ID, height=height);
}


M3Insert(5.3);
