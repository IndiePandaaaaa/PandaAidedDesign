// created by IndiePandaaaaa | Lukas

THICKNESS = 3;
TOLERANCE = 0.1;
CT_WIDTH = 2.5 + 0.2; // CT_WIDTH = cable tie width
$fn = 75;

USBPLUG_WIDTH = 9.1;
USBPLUG_DEPTH = 5.5;
USBPLUG_HEIGHT = 16.5;
USBPLUG_CABLE_HEIGHT = 6;

SOCKET_DEPTH = 12;

USBCABLE_SHAPE = "ROUNDED"; // "SQUARE" || "ROUNDED"  // fixme: implement square|rounded

module cable_model(width, depth, height, cable_height, tolerance = 0.1) {
  translate([-(depth + tolerance) / 2, 0, 0])
    union() {
      translate([0, (depth + tolerance) / 2, 0])
        cube([depth + tolerance, width - depth + tolerance, height]);

      translate([(depth + tolerance) / 2, (depth) / 2, 0]) {
        cylinder(h = height, d = depth + tolerance);
        translate([0, width - (depth), 0]) cylinder(h = height, d = depth + tolerance);

        // cable
        translate([0, (width - (depth)) / 2, 0]) cylinder(h = height + cable_height, d = depth + tolerance);
      }
    }
}

difference() {
  cube([SOCKET_DEPTH, USBPLUG_WIDTH, USBPLUG_HEIGHT + USBPLUG_CABLE_HEIGHT]);
  cable_model(USBPLUG_WIDTH, USBPLUG_DEPTH, USBPLUG_HEIGHT, USBPLUG_CABLE_HEIGHT);

  translate([SOCKET_DEPTH / 3, -USBPLUG_WIDTH / 2, 0]) {
    translate([0, 0, (USBPLUG_HEIGHT + USBPLUG_CABLE_HEIGHT) / 5])
      cube([1.5, USBPLUG_WIDTH * 2, CT_WIDTH]);
    translate([0, 0, USBPLUG_HEIGHT + (USBPLUG_CABLE_HEIGHT - CT_WIDTH) / 2])
      cube([1.5, USBPLUG_WIDTH * 2, CT_WIDTH]);
  }
}