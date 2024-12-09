// created by IndiePandaaaaa | Lukas

use <Structures/Hexagon.scad>

MODEL_TOLERANCE = 0.5;
THICKNESS = 2.5;
PRINTER_SHEET_WIDTH = 200;

module passive_standoff() {
  // Laptop Reference: Dell Inspiron 16 Plus 7610
  laptop_width = 355;
  laptop_rubber_higher_width = 7.2;
  laptop_rubber_lower_width = 3.3;
  laptop_rubber_height = 4.6;

  standoff_width = laptop_width / 3 * 1.5;
  standoff_count = 4;
  standoff_height = 21;
  standoff_brick_width = 16;
  standoff_bottom_height = 3.5;

  width_between = (standoff_width - (standoff_brick_width * standoff_count)) / (standoff_count - 1);

  rubber_bottom_thickness = 0.75;
  rubber_wall_thickness = 1;

  chamfer = 3;

  if (standoff_width > PRINTER_SHEET_WIDTH) {
    standoff_width = PRINTER_SHEET_WIDTH;
  }

  difference() {
    translate([0, standoff_width]) rotate([90, 0, 0])
      linear_extrude(standoff_width) {
        polygon([
            [0, 0],
            [standoff_height, 0],
            [standoff_height, standoff_height],
            [standoff_height - (standoff_height - laptop_rubber_higher_width - MODEL_TOLERANCE) / 2,
              standoff_height - 0],
            [standoff_height - (standoff_height - laptop_rubber_lower_width - MODEL_TOLERANCE) / 2,
              standoff_height - laptop_rubber_height / 2],
            [(standoff_height - laptop_rubber_lower_width - MODEL_TOLERANCE) / 2,
              standoff_height - laptop_rubber_height / 2],
            [(standoff_height - laptop_rubber_higher_width - MODEL_TOLERANCE) / 2, standoff_height],
            [0, standoff_height],
          ]);
      }

    for (i = [1:standoff_count - 1]) {
      translate([0, standoff_brick_width + (width_between + standoff_brick_width) * (i - 1), standoff_bottom_height]) {
        hex_depth = standoff_height - 4;
        hex_od = hex_depth / 2;
        translate([standoff_height - (standoff_height - hexagon_get_used_depth(hex_depth, hex_od)) / 2,
            (width_between - hexagon_get_used_width(width_between, hex_od)) / 2, -standoff_bottom_height])
          rotate([0, 0, 90]) hexagon_pattern(width_between, hex_depth, standoff_height, hex_od);

        rotate([90, 0, 90]) translate([0, 0, -.1]) {
          linear_extrude(standoff_height + .2) {
            polygon([
                [0, chamfer * 2],
                [chamfer, 0],
                [width_between - chamfer, 0],
                [width_between, chamfer * 2],
                [width_between, standoff_height],
                [0, standoff_height],
              ]);
          }
        }
      }
    }

    for (i = [1:standoff_count]) {
      translate([rubber_wall_thickness, rubber_wall_thickness + (width_between + standoff_brick_width) * (i - 1), 0])
        cube([standoff_height - rubber_wall_thickness * 2, standoff_brick_width - rubber_wall_thickness * 2,
          rubber_bottom_thickness]);
    }
  }
}

module active_standoff(fan_diameter = 80, thickness = 1.5) {
  // Reference: Dell Inspiron 16 Plus 7610
  fan_distance = 250;
  rubber_distance = 65;
  fan_distance_back = 90;
  rubber_depth_l = 10;
  rubber_depth_s = 5;
  rubber_height = 5.8;

  wood_size = [44, 24];
  air_channel_od = wood_size[1] - 5;
  air_channel_id = air_channel_od - thickness * 2;
  $fn = 100;

  module air_channel() {
    module channel_shape(inner_only = false) {
      rotate([0, 0, 90]) translate([fan_diameter / 2, -air_channel_od / 2, 0]) difference() {
        if (!inner_only) {
          union() {
            translate([-fan_diameter / 2 + air_channel_od / 2, 0, 0]) circle(d = air_channel_od);
            square([fan_diameter - air_channel_od, air_channel_od], center = true);
            translate([fan_diameter / 2 - air_channel_od / 2, 0, 0]) circle(d = air_channel_od);
          }
        }
        union() {
          translate([-fan_diameter / 2 + air_channel_od / 2, 0, 0]) circle(d = air_channel_id);
          square([fan_diameter - air_channel_od, air_channel_id], center = true);
          translate([fan_diameter / 2 - air_channel_od / 2, 0, 0]) circle(d = air_channel_id);
        }
      }
    }

    module air_hopper(angle = 45, display_max_angle = 125) {
      alpha = 180 - display_max_angle;
      DB = cos(angle) * fan_diameter; // basic side 2
      DC = sqrt((fan_diameter^2 - DB^2)); // height
      AD = DC / tan(alpha); // basic side 1
      AB = AD + DB;

      translate([-fan_diameter / 2, air_channel_od / 2, 0]) rotate([0, -90, 180]) {
        union() {
          linear_extrude(fan_diameter) {
            polygon([
                [0, 0],
                [AB, 0],
                [AD, DC],
              ]);
          }
          color("red") rotate([-90, 0, -90]) linear_extrude(fan_diameter + .2) {channel_shape(true);}
        }
      }
    }

    union() {
      translate([fan_diameter / 2, -air_channel_od / 2, air_channel_od - .1]) rotate([0, 0, 90])
        linear_extrude(rubber_distance + .1) {channel_shape();}
      translate([-fan_diameter / 2, -air_channel_od / 2, air_channel_od]) rotate([0, 90, 0]) rotate_extrude(angle = 90)
        {
          channel_shape();
        }
      air_hopper();
    }
    // todo: screw-in bracket for dachlatte
    // todo: trichter for fan
    // todo: fan mount with treading/nuts
  }

  for (i = [0:1]) {
    mirror([0, 0, 0]) translate([0, 0, 0]) {
      air_channel();
    }
  }
}

active_standoff();
