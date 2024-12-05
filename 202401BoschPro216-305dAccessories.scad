// created by IndiePandaaaaa|Lukas
// encoding: utf-8

use <Parts/Screw.scad>

// made for Bosch Professional 216-305d
// model number: 1 609 B07 675

THICKNESS = 3;
TOLERANCE = .1;
CHAMFER = 1.5;
$fn = $preview ? 50 : 100;

// workpiece stop x-axis (measurements from the original workpiece support)
WORKPIECESUPPORT_WIDTH = 148;
WORKPIECESUPPORT_HOOK_DISTANCE = 92.2;
WORKPIECESUPPORT_HEIGHT = 88.1;

// vacuum adapter
VACUUM_OD = 34.2;
SPLITTED_PRINT = true;

module workpiece_stop() {
workpiecestop_width = WORKPIECESUPPORT_WIDTH;
workpiecestop_height = 70;
workpiecestop_hook_distance = WORKPIECESUPPORT_HOOK_DISTANCE;

hook_width = 11.1;
hook_depth = 6.8;
hook_height = 12.3;
base_material_thickness = 2.3;

  module bosch_hook() {
    top_thickness = 1.6;
    hollow_depth = 2.85;
    hollow_height = 5.3;
    inner_piece_width = 7.5;
    translate([- base_material_thickness, hook_width, 0]) rotate([90, 0, 0]) union() {
      linear_extrude(hook_width) {
         polygon([
          [0, 0],
          [base_material_thickness, 0],
          [base_material_thickness, hook_height - top_thickness],
          [base_material_thickness + hollow_depth, hook_height - top_thickness],
          [base_material_thickness + hollow_depth, 0],
          [base_material_thickness + hook_depth, 0],
          [base_material_thickness + hook_depth, hook_height],
          [0, hook_height],
        ]);
      }
      translate([hook_depth, hook_height, hook_width]) rotate([0, 90, 180]) linear_extrude(hook_depth) {
        distance_to_center = (hook_width - inner_piece_width) / 2;
        polygon([
          [0, 0],
          [distance_to_center, 0],
          [distance_to_center, hook_height - hollow_height],
          [distance_to_center + inner_piece_width, hook_height - hollow_height],
          [distance_to_center + inner_piece_width, 0],
        ]);
      }
    }
  }

  translate([0, THICKNESS + hook_depth, -14 - hook_height]) rotate([0, 0, -90]) union() {
    translate([THICKNESS, - ((workpiecestop_hook_distance + hook_width * 2) - workpiecestop_width) / 2, 14]) {
        bosch_hook();
        translate([0, workpiecestop_hook_distance + hook_width, 0]) bosch_hook();
    }
    cube([THICKNESS, workpiecestop_width, workpiecestop_height]);
  }
}

module vacuum_adapter(vacuum_diameter) {
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
        translate([0, 0, bs_cy_size[0]/2 + 29 + 3]) sphere(d=bs_cy_size[0]*1.45);
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
        translate([-rb_size[5] + 20, -rb_size[4]/2, rb_size[1] - rb_size[4] + .1]) cube([rb_size[0], rb_size[4], rb_size[4]]); // base saw blade cutout
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
      va_size = [214.95, 83.75];
      difference() {
        union() {
          difference() {
            translate([0, 0, va_size[0]/2]) scale([1, 0.75, 1]) sphere(va_size[0]/2);
            translate([0, 0, 250/2 + 40]) cube(250, center=true);
          }
          translate([0, 0, 42]) scale([1, 0.75, 20/va_size[1]]) sphere(va_size[1]);
          translate([0, -48/2, 40]) rotate([0, 0, 90]) cube([48, 80, 20]);
        }
        translate([250/2 - .1, 0, 0]) cube(250, center=true);
      }
      difference() {
        translate([-60, 0, 40 + 40]) scale([1, .5, 1]) sphere(52);
        translate([-60, 0, 50 + 70]) cube(120, center=true);
      }
    }
  
    module vacuum_airchannel() {
      airchannel_od = 37;
      translate([-70, -15, 43.5]) {
        rotate([-100, 0, 15]) {
          cylinder(d=airchannel_od, h=50);
          scale([airchannel_od/10, airchannel_od/10, 1]) sphere(d=10);
        }
        translate([-12, 40, -8]) rotate([-90, 0, 0]) {
          cylinder(d=airchannel_od, h=45);
          translate([0, 0, 55 - (.05 + 10)]) cylinder(d=vacuum_diameter, h=15);
        }
      }
    }
  
    color("#7777ff") union() {
      sawblade_airchannel();
      vacuum_airchannel();
    }
  }
  
  module mounting_screws() {
    // core hole M3 = 2.5;
    od = [3, 2.5];

    //screw_corehole(diameter_screw=3, diameter_core=2.5, unthreaded_length=15, length=20);

    color("#222222") union() {
      for (i = [0:1]) {
        // top back: mounting accessories
        translate([-116, 30 - 60*i, 67]) rotate([90, 0, -90]) screw_corehole(diameter_screw=od[0], diameter_core=od[1], unthreaded_length=3.9, length=20);

        // vacuum diameter exchange
        translate([-60 - 45*i, 75, 22 + 25*i]) rotate([-90, 0, 0]) screw_corehole(diameter_screw=od[0], diameter_core=od[1], unthreaded_length=5, length=20);

        // cone exchange
        translate([-100, -30, 30]) rotate([90, 0, -90]) screw_corehole(diameter_screw=od[0], diameter_core=od[1], unthreaded_length=5, length=20);
      }
    }
  }

  module split_walls() {
    thickness_walls = .05;
    
    // back cut away
    translate([-68, 60 + thickness_walls + 10, -2]) rotate([0, 0, -90]) cube([111, thickness_walls, 80]);

    // cone cutout for exchange
    translate([-95.05, 40, -2]) rotate([0, 0, -90]) cube([81, thickness_walls, 40]);
    translate([-95, 40, 38]) rotate([90, 0, -90]) cube([81, thickness_walls, 18]);
    translate([-95, 40, 38]) rotate([90, 90, -90]) cube([40, thickness_walls, 18]);
  }

  module adapter() {
    width = 80;
    height = 58 + 20;
    height_offset = 17;
    color("#ff7777") translate([0, -width/2, 0]) union() {
      linear_extrude(height) {
        polygon([
          [0, 0],
          [42.5, (width - 58)/2],
          [80, -40],
          [82, -40],
          [82, 120],
          [80, 120],
          [42, (width + 58)/2],
          [0, width],
        ]);
      }
      translate([0, 0, height_offset]) cube([60, width, height - height_offset]);
      translate([45, -20, 30]) cube([25, 40, 20]);
      translate([0, 0, height_offset]) cube([75, 110, 40]);
      translate([0, 110.1, height_offset]) cube([60, 10, 40]);

      // todo disconnectable parts due to turning the saw
    }
  }

  //difference() {
  union() {
    translate([-112, 0, -1.5]) {
      adapter();
    }
    union() {
      saw_base();
      saw_head();
      airchannels();
      mounting_screws();

      if (SPLITTED_PRINT) {
        split_walls();
      }
    }
  }
}

//translate([0, 150, 0]) workpiece_stop();
vacuum_adapter(VACUUM_OD);
