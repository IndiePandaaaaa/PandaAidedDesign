// created by IndiePandaaaaa|Lukas
// encoding: utf-8

THICKNESS = 3;
TOLERANCE = .15;
$fn = $preview ? 50 : 100;

VACUUM_OD = 34.2;
SPLITTED_PRINT = true;

module saw_base(backspace_shape=false, rotation=0, max_rotation=48) {
  module wood_stops(rotation_guide=false) {
    for (i=[0:1]) mirror([0, i, 0]) translate([0, -16/2, 0]) rotate([0, 0, 180 - (rotation_guide? max_rotation:0)]) difference() { // wood stops
      ws_size = [30, 140, 41];
      union() {
        cube(ws_size);
        if (rotation_guide)
          translate([-ws_size[1]+.1, 0, 0]) cube([ws_size[1], ws_size[1], ws_size[2]]);
      }
      translate([16.5, -.1, ws_size[2] - 16.3]) cube([ws_size[0], ws_size[1] + .2, ws_size[2]]);
      translate([3, 0, -.1]) rotate([0, 0, -(90-max_rotation)]) cube(45);
      translate([-.1, -.1, 27]) rotate([atan(14/33), 0, 0]) cube(45);
    }
  }

  module central_connect() {
    translate([0, 0, 0]) difference() { // backside cylinder, connecting the wood stops
      bs_cy_size = [75.5*2, 15.2, 58, 33];
      translate([0, 0, -.05]) cylinder(d=bs_cy_size[0], h=bs_cy_size[1]); 
      translate([0, 0, bs_cy_size[0]/2 + 7.6 + 2]) sphere(d=bs_cy_size[0]*1.19);
      translate([0, 0, -.1]) cylinder(r=bs_cy_size[3], h=bs_cy_size[1] + .2);
      translate([-.1, -bs_cy_size[0], -bs_cy_size[0]/4]) cube(bs_cy_size[0]*2);
    }
  }
  
  module rotating_base() {
    translate([0, 0, -40]) rotate([0, 0, rotation]) difference() {
      rb_size = [260, 40, 53.7, 2.5, 10, 35];
      union() { // rotating base
        cylinder(d=rb_size[0], h=rb_size[1]);
        translate([-100 + .1, 0, rb_size[1]]) {
          rotate([0, -90, 0]) cylinder(d2=90, d1=rb_size[2], h=33.8); // back cone
        }
      }
      translate([-rb_size[5], -rb_size[4]/2, rb_size[1] - rb_size[4] + .1]) cube([rb_size[0], rb_size[4], rb_size[4]]); // base saw blade cutout
    }
  }

  difference() {
    if (!backspace_shape) {
      union() {
        wood_stops();
        color("#aa4400") rotating_base();
        central_connect();
      }
    }

    cutout_height = 1;
    translate([0, 0, -cutout_height]) rotate([0, 0, rotation]) linear_extrude(cutout_height + .1) projection() difference() {
      intersection() {
        translate([0, 0, .1]) cylinder(d=260.1, h=.01);
        translate([-175, 0, 0]) cube(260, center=true);
      }
      union() {
        rotating_base();
        central_connect();
        wood_stops(true);

      }
    }
  }
  rb_size = [260, 40, 53.7, 2.5, 10, 35];
  translate([-100 -7.72 + rb_size[3], 0, -.018]) difference() {
    rotate([0, 45, 0]) cylinder(d=rb_size[2], h=5);
    translate([rb_size[3]*3+.3, rb_size[2]/2, rb_size[3]-1]) rotate([90, 0, 0]) cylinder(r=rb_size[3], h=rb_size[2]);
  }
}

module saw_head() {
  module saw_blade() {
    blade_size = [216, 5, 25, 260/2];
    union() {
      translate([blade_size[2], blade_size[1]/2, -2]) rotate([90, 0, 0]) {
        for (i = [0:1]) {translate([blade_size[3]*i, blade_size[0]/2, 0]) cylinder(d=blade_size[0], h=blade_size[1]);}
        cube([blade_size[3], blade_size[0], blade_size[1]]);
      }
    }
  }

  module saw_blade_case() {
    union() {
      sbc_size = [90, 51, 36.6, 95, 135-25, 57];
      translate([-sbc_size[4], -sbc_size[2]/2, 0]) {
        translate([0, 0, sbc_size[3]]) cube([sbc_size[0], sbc_size[1], sbc_size[0]]);
        translate([0, 0, sbc_size[5]]) cube([sbc_size[0], sbc_size[2], sbc_size[3]]);
      }
    }
  }

  translate([-3, 0, 0]) union() {
    color("#777777") saw_blade();
    color("#bbbbbb") saw_blade_case();
  }
}

module airchannels() {
  module sawblade_airchannel() {
    va_size = [20, 220, 100];
    translate([va_size[0]/2, 0, 216/2]) rotate([-90, -20 + 90, 0]) rotate_extrude(angle=120) {
      difference() {
        scale([va_size[1]/va_size[0], va_size[2]/va_size[0]]) circle(d=va_size[0]);
        rotate([0, 0, 180]) translate([0, -va_size[2]/2]) square([va_size[1], va_size[2]]);
      }
    }
    translate([-52, 0, 30]) rotate([0, -52, 0]) cylinder(d=va_size[0], h=va_size[2]/2);
    // todo top channelling arround the blade
    // todo channel bottom of blade to vacuum
  }

  module vacuum_airchannel() { // todo: channel on both sides?
    translate([-80, -15, 35]) {
      rotate([-100, 0, 7]) {
        cylinder(d=VACUUM_OD, h=50);
        scale([VACUUM_OD/10, VACUUM_OD/10, 1]) sphere(d=10);
      }
      translate([-6, 40, -8]) rotate([-90, 0, 0]) cylinder(d=VACUUM_OD, h=50);
    }
  }

  color("#7777ff") union() {
    sawblade_airchannel();
    vacuum_airchannel();
  }
}


difference() {
//union() {
  translate([-112, 0, -1.5]) {
    width = 80;
    //translate([0, -1.5/2, 0]) cube([76.5, 1.5, 65]); // testpiece
    translate([0, -width/2, 0]) cube([76, width, 55]);
  }
  union() {
    saw_base();
    saw_head();
    airchannels();
  }
}

