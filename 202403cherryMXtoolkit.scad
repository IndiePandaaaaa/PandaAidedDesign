// created by IndiePandaaaaa

$fn = 70;

tolerance = .15;

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
  full_width = 20;
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

module cutout_guide_activation_distance_reduce() {
  cutter_blade_width = .4;
  thickness = 2;
  border = 2;

  paper_width = 2;
  paper_length = 3;
  elements = 21;

  full_length = elements * paper_width + border * 2;
  full_width = 7 + paper_length;

  difference() {
    cube([full_length, full_width, thickness]);

    translate([border, 0, 0]) for (i = [0:elements]) {
      translate([-t(cutter_blade_width)/2 + paper_width * i, -.1, -.1]) cube([t(cutter_blade_width), paper_length + .1, thickness + .2]);
    }

    for (i = [0:1]) {
      translate([-.1 + i * (.2 + full_length - border), -.1, -.1]) cube([border, paper_length + .1, thickness + .2]);

      translate([border, t(paper_length) + (full_width - t(paper_length) - t(cutter_blade_width)) / 2, -.1]) 
        cube([full_length - border * 2, t(cutter_blade_width), thickness + .2]);
    } 
  }
}

translate([-20, 0, 0]) construction_socket();
cutout_guide_activation_distance_reduce();
