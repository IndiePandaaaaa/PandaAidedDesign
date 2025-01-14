// created by IndiePandaaaaa
// encoding: utf-8

use <Variables/Threading.scad>

TOLERANCE = .1;
THICKNESS = 2.5;
CHAMFER = 1;
$fn = $preview? 25:125;


// model for reference: Logitech Logi ERGO M575

mouse_size = [86, 118];
hole_od = 12;
hole_depth = 5;

angle = 5;
tilt = 30;

union() {
  height = tan(tilt) * mouse_size[0];
  width = mouse_size[0] + ((mouse_size[1]/2)/tan(angle));

  union() {
    intersection() {
      rotate([0, 0, angle]) translate([-mouse_size[0] / 2, -mouse_size[1] / 2, 0]) linear_extrude(height) {
        import("./Shapes/LogiErgoM575.svg");
      }
  
      translate([-mouse_size[1] / 2, mouse_size[1]/2 + .2, 0]) rotate([90, 0, 0]) linear_extrude(mouse_size[1] + .2) {
        polygon([
            [0, 0],
            [mouse_size[1], 0],
            [0, height],
          ]);
      }
    }
    // todo: fix position of locator position
    // todo: add anti slip pads to the bottom
    rotate([0, 0, angle]) translate([-width/3, 0, height/2]) rotate([0, tilt, 0]) cylinder(d=core_hole_M5(), h=20);
  }
}
