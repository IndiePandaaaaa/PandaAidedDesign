// created by IndiePandaaaaa

TOLERANCE = .1;
THICKNESS = 2.5;
CHAMFER = 1;
$fn = 75;

// model for reference: Logitech Logi ERGO M575

mouse_size = [86.4, 118];
hole_od = 12;
hole_depth = 5;

angle = 30;
tilt = 30;

union() {
  width = sin(angle)*mouse_size[1] + cos(angle)*mouse_size[0] - (angle == 30 ? 42 : angle == 60 ? 32 : 0); // fixme: angle why *sad panda noises*
  height = tan(tilt)*width;
  intersection() {
    rotate([0, 0, angle]) translate([-mouse_size[0]/2, -mouse_size[1]/2, 0]) linear_extrude(height) {
      import("./Shapes/LogiErgoM575.svg");
    }
  
    translate([-width/2, mouse_size[1], 0]) rotate([90, 0, 0]) linear_extrude(mouse_size[1]*2) {
      polygon([
        [0, 0],
        [width, 0],
        [0, height],
      ]);
    }
  }

  translate([-width/3+8, -7, height-14]) rotate([0, tilt, 0]) cylinder(d=hole_od, h=hole_depth + .1);
}
