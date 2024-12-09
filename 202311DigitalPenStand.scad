// created by IndiePandaaaaa|Lukas
TOLERANCE = 0.2; // to the pen
THICKNESS = 2.5;
CHAMFER = 1;
$fn = 75;

PEN_DIAMETER_LARGE = 12;
PEN_DIAMETER_SMALL = 3.3;
PEN_TIP_HEIGHT = 12; // distance between the large and small diameter in height

PEN_STAND_ANGLE = 25; // 42 or more tends to flip

PEN_STAND_ADDITIONAL_RADIUS = 14;
PEN_STAND_ADDITIONAL_HEIGHT = 3;

full_diameter = PEN_DIAMETER_LARGE + TOLERANCE + PEN_STAND_ADDITIONAL_RADIUS * 2;
pen_stand_height = PEN_TIP_HEIGHT + PEN_STAND_ADDITIONAL_HEIGHT * 4;

module socket(od, id) {
  C = [0, 0];
  B = [od, 0];
  A = [0, -sin(PEN_STAND_ANGLE) * od];
  intersection() {
    difference() {
      translate([0, 0, -od]) cylinder(d = od, h = od * 2);
      translate([0, 0, -od]) cylinder(d = id, h = od);
    }
    translate([-od / 2, od / 2, 0]) rotate([90, 0, 0]) {
      linear_extrude(od) {
        polygon([A, B, C]);
      }
    }
  }
}

difference() {
  union() {
    rotate_extrude() {
      polygon([
          [PEN_DIAMETER_LARGE / 2 + TOLERANCE / 2, 0],
          [PEN_DIAMETER_LARGE / 2 + TOLERANCE / 2 + PEN_STAND_ADDITIONAL_RADIUS, 0],
          [PEN_DIAMETER_LARGE / 2 + TOLERANCE / 2 + PEN_STAND_ADDITIONAL_RADIUS, pen_stand_height - CHAMFER],
          [PEN_DIAMETER_LARGE / 2 + TOLERANCE / 2 + PEN_STAND_ADDITIONAL_RADIUS - CHAMFER, pen_stand_height],
          [PEN_DIAMETER_LARGE / 2 + TOLERANCE / 2 + PEN_STAND_ADDITIONAL_HEIGHT / 2, pen_stand_height],
          [PEN_DIAMETER_LARGE / 2 + TOLERANCE / 2, PEN_TIP_HEIGHT + PEN_STAND_ADDITIONAL_HEIGHT],
          [PEN_DIAMETER_SMALL / 2 + TOLERANCE / 2, PEN_STAND_ADDITIONAL_HEIGHT * 2],
          [PEN_DIAMETER_SMALL / 2 + TOLERANCE / 2, PEN_STAND_ADDITIONAL_HEIGHT],
          [PEN_DIAMETER_LARGE / 2, PEN_STAND_ADDITIONAL_HEIGHT],
          [PEN_DIAMETER_LARGE / 2, 0],
        ]);
    }
    socket(full_diameter, PEN_DIAMETER_LARGE);
  }
  union() {
    translate([0, 0, THICKNESS / 2])
      difference() {
        cylinder(d = full_diameter - THICKNESS * 1.5, h = pen_stand_height);
        cylinder(d = PEN_DIAMETER_LARGE * 1.5, h = pen_stand_height);
      }
    translate([0, 0, THICKNESS]) socket(full_diameter - THICKNESS * 1.5, PEN_DIAMETER_LARGE * 1.5);
  }
}
