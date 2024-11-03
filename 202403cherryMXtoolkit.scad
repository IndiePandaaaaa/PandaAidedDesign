// created by IndiePandaaaaa

tolerance = .15;
thickness = 2;
$fn = 70;

standard_width = 20;
standard_height = 10;

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

  difference() {
    translate([-standard_width / 2, -standard_width / 2, 0])
      cube([standard_width, standard_width, standard_height]);
  
    height_1 = standard_height - MX_case_additional_height;
    translate([-t(MX_case_width) / 2, -standard_width / 2, height_1])
      cube([t(MX_case_width), t(standard_width), standard_height]);
  
    height_2 = height_1 - t(MX_case_frame_height);
    translate([-t(MX_case_width) / 2, MX_case_pin_depth / 2, height_2])
      cube([t(MX_case_width), t(standard_width), standard_height]);
    translate([-t(MX_case_width) / 2, -standard_width - MX_case_pin_depth / 2, height_2])
      cube([t(MX_case_width), t(standard_width), standard_height]);
  
    height_3 = height_1 - MX_case_to_stem_height;
    translate([-t(stem_width) / 2, -standard_width / 2, height_3])
      cube([t(stem_width), t(standard_width), standard_height]);
    
    height_4 = height_3 - stem_pin_additional_height;
    translate([0, 0, height_4])
      cylinder(d = t(stem_pin_diameter), h = standard_height);
  }
}

module guide_plate_painting_socket() {
  location = [ [0, 0], [11.8, 0], [0, 9.2], [11.8, 9.2] ];
  size = 2.5;

  translate([-standard_width/2, -standard_width/2, 0]) difference() {
    cube([standard_width, standard_width, thickness]);
    translate([(standard_width - location[3][0])/2, (standard_width - location[3][1])/2, -.1]) for (i = [0:len(location)-1]) {
      translate([location[i][0], location[i][1], 0]) cylinder(d = size, h = thickness + .2);
    }
  }
}

module switch_assembly_socket() {
  pin_height = 3.5 + .1;
  pin_depth = 5.1 + .1;
  pin_width = 8.5;
  center_height = 3.1 + .1;
  center_od = 3.9 + .1;
  clip_width = 4.2;
  clip_height = 2;
  switch_sunk = 4.8;
  width = 14 + .1;

  translate([-standard_width/2, -standard_width/2, 0]) difference() {
    cube([standard_width, standard_width, standard_height]);

    translate([(standard_width - width)/2, -.1, standard_height - pin_height - switch_sunk]) {
      translate([(width - pin_width)/2, (standard_width - width)/2, 0]) cube([pin_width, pin_depth + .1, pin_height + standard_height]);
      translate([(width - center_od)/2, pin_depth + (standard_width - width)/2, pin_height - center_height]) {
        cube([center_od, center_od/2 + .1, center_height + standard_height]);
        translate([center_od/2, center_od/2, 0]) cylinder(d=center_od, h=center_height + standard_height);
      }
      translate([-(standard_width - width)/2 - .1, (standard_width - width)/2, pin_height]) {
        translate([(standard_width - width)/2, 0, 0]) cube([width, width, width]);
        for (i = [0:1]) {
          translate([0, (width - clip_width) * i, 0]) cube([standard_width + .2, clip_width, width]);
        }
        translate([(standard_width - clip_width)/2, -(standard_width - width)/2, clip_height -.5]) cube([clip_width, standard_width + .2, width]);
      }
    }
  }
}

//translate([0, 30, 0]) construction_socket();
//translate([0, 60, 0]) guide_plate_painting_socket();
translate([0, 0, 0]) switch_assembly_socket();
