// created by IndiePandaaaaa|Lukas
// encoding: utf-8

TOLERANCE = .1;
THICKNESS = 1.5;
$fn = $preview? 25:125;

module switch_plate(width, height, switch_count, border=2) {
  cherry_size = [14.05, 14.05, 9.2];
  cherry_pin_support = [cherry_size[0] + 5, cherry_size[1] + 5, cherry_size[2] - .1];
  cherry_border = [cherry_pin_support[0] + border, cherry_pin_support[1] + border, 2];

  module switch_socket() {
    difference() {
      union() {
        translate([-cherry_border[0]/2, -cherry_border[1]/2, cherry_size[2] - 2]) cube(cherry_border);
        translate([-cherry_pin_support[0]/2, -cherry_pin_support[1]/2, 0]) cube(cherry_pin_support);
      }
      union() {
        translate([-cherry_size[0]/2, -cherry_size[1]/2, 0]) cube(cherry_size);
        translate([-cherry_size[0]/2 - 1, -cherry_size[1]/2 - 1, 0]) cube([cherry_size[0] + 2, cherry_size[1] + 2, cherry_size[2] - 1.65]);
      }
    }
  }

  sockets_per_column = floor(height / cherry_border[0]);
  columns = floor((switch_count / sockets_per_column) + .9);

  for (x=[0:columns - 1]) {
    for (y=[0:sockets_per_column - 1]) {
      translate([cherry_border[0]/2 + cherry_border[0] * x, cherry_border[1]/2 + cherry_border[1] * y, 0]) switch_socket();
    }
  }

  echo("width: ", columns * cherry_border[0]);
}

switch_plate(210, 145, 46);
