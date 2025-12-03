// created by IndiePandaaaaa|Lukas
// encoding: utf-8

TOLERANCE = .1;
THICKNESS = 1.5;
$fn = $preview ? 25 : 125;

module switch_plate(width, depth, switch_count, border = 2, with_bottom = false, rounded_edges = 0) {
  cherry_size = [14.05, 14.05, 9.2]; // Cherry MX 
  //  cherry_size = [13.8, 13.8, 5.5]; // Kailh Choc

  cherry_pin_support = [cherry_size[0] + 5, cherry_size[1] + 5, cherry_size[2] - .1];
  cherry_pin_support_rounded = [cherry_pin_support[0] - rounded_edges * 2, cherry_pin_support[1] - rounded_edges * 2, cherry_pin_support[2] - rounded_edges * 2];
  cherry_border = [cherry_pin_support[0] + border, cherry_pin_support[1] + border, 2];
  cherry_border_rounded = [cherry_border[0] - rounded_edges * 2, cherry_border[1] - rounded_edges * 2, cherry_border[2] - rounded_edges * 2];

  module switch_socket() {
    difference() {
      union() {
        if (rounded_edges > 0) {
          translate(v=[-cherry_border_rounded[0] / 2, -cherry_border_rounded[1] / 2, 0]) {
            linear_extrude(height=cherry_size[2] - rounded_edges * 2, center=false, convexity=10, twist=0, slices=20, scale=1.0) {
              minkowski() {
                polygon(points=[[0, 0], [cherry_border_rounded[0], 0], [cherry_border_rounded[0], cherry_border_rounded[1]], [0, cherry_border_rounded[1]]]);
                circle(r=rounded_edges);
              }
            }
          }

          translate([-cherry_border_rounded[0] / 2, -cherry_border_rounded[1] / 2, cherry_size[2] - 2]) cube(cherry_border_rounded);
          translate([-cherry_pin_support_rounded[0] / 2, -cherry_pin_support_rounded[1] / 2, 0]) cube(cherry_pin_support_rounded);

          if (with_bottom) {
            translate(v=[-cherry_pin_support_rounded[0] / 2, -cherry_pin_support_rounded[1] / 2, -1.5]) {
              minkowski() {
                cube(size=[cherry_pin_support_rounded[0], cherry_pin_support_rounded[1], 2], center=false);
                sphere(r=rounded_edges);
              }
            }
          }
        } else {
          translate([-cherry_border[0] / 2, -cherry_border[1] / 2, cherry_size[2] - 2]) cube(cherry_border);
          translate([-cherry_pin_support[0] / 2, -cherry_pin_support[1] / 2, 0]) cube(cherry_pin_support);
        }
      }
      union() {
        translate([-cherry_size[0] / 2, -cherry_size[1] / 2, -.1]) cube([cherry_size[0], cherry_size[1], cherry_size[2] + .2]);
        translate([-cherry_size[0] / 2 - 1, -cherry_size[1] / 2 - 1, -.1]) cube([cherry_size[0] + 2, cherry_size[1] + 2, cherry_size[2] - 1.65 + .1]);
      }
    }
  }

  sockets_per_column = floor(depth / cherry_border[0]);
  columns = floor((switch_count / sockets_per_column) + .9);

  for (x = [0:columns - 1]) {
    for (y = [0:sockets_per_column - 1]) {
      translate([cherry_border[0] / 2 + cherry_border[0] * x, cherry_border[1] / 2 + cherry_border[1] * y, 0]) switch_socket();
    }
  }

  echo("width: ", columns * cherry_border[0]);
}

// FIX: add plate without rounded edges to connect switch plates with more than 1 switch.
switch_plate(width=210, depth=145, switch_count=12);
//switch_plate(width=30, depth=30, switch_count=1, border=0, with_bottom=true, rounded_edges=.5);
