// created by IndiePandaaaaa

$fn = 70;

tolerance = .15;
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

function t(para) = para + tolerance;

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

