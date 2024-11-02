// created by IndiePandaaaaa

$fn = 70;

tolerance = .15;
thickness = 2;
standard_width = 20;

function t(para) = para + tolerance;

module construction_socket() {
  stem_pin_diameter = 2.0;
  stem_pin_additional_height = 1.7;
  stem_width = 8.7;
  MX_case_to_stem_height = 1.9;
  MX_case_frame_height = 4.6;
  MX_case_width = 14.5;
  MX_case_pin_depth = 6.5;
  MX_case_additional_height = 3;
  full_width = standard_width;
  full_height = 10;

  difference() {
    translate([-full_width / 2, -full_width / 2, 0])
      cube([full_width, full_width, full_height]);
  
    height_1 = full_height - MX_case_additional_height;
    translate([-t(MX_case_width) / 2, -full_width / 2, height_1])
      cube([t(MX_case_width), t(full_width), full_height]);
  
    height_2 = height_1 - t(MX_case_frame_height);
    translate([-t(MX_case_width) / 2, MX_case_pin_depth / 2, height_2])
      cube([t(MX_case_width), t(full_width), full_height]);
    translate([-t(MX_case_width) / 2, -full_width - MX_case_pin_depth / 2, height_2])
      cube([t(MX_case_width), t(full_width), full_height]);
  
    height_3 = height_1 - MX_case_to_stem_height;
    translate([-t(stem_width) / 2, -full_width / 2, height_3])
      cube([t(stem_width), t(full_width), full_height]);
    
    height_4 = height_3 - stem_pin_additional_height;
    translate([0, 0, height_4])
      cylinder(d = t(stem_pin_diameter), h = full_height);
  }
}

module guide_plate_painting_socket() {
  location = [ [0, 0], [13, 0], [0, 9.2], [13, 9.2] ];
  size = 2.5;

  translate([-standard_width/2, -standard_width/2, 0]) difference() {
    cube([standard_width, standard_width, thickness]);
    translate([(standard_width-location[3][0])/2, (standard_width-location[3][1])/2, -.1]) for (i = [0:len(location)-1]) {
      translate([location[i][0], location[i][1], 0]) cylinder(d = size, h = thickness + .2);
    }
  }
}

translate([0, 42, 0]) construction_socket();
translate([0, 0, 0]) guide_plate_painting_socket();
