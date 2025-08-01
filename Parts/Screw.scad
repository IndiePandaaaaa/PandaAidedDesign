// created by IndiePandaaaaa | Lukas

TOLERANCE = .1;
$fn = $preview ? 30 : 75;

// metric standards                          M1   M2   M3   M4   M5 M6 M7   M8   M9  M10
function SCREW_METRIC_COREHOLE(standard) = [.75, 1.6, 2.5, 3.3, 4.2, 5, 6, 6.8, 7.8, 8.5][standard - 1];
function SCREW_METRIC_BOREHOLE(standard) = [0, 0, 3.4, 4.5, 5.5, 6.6, 0, 9, 0, 11][standard - 1];
function SCREW_METRIC_COUNTERSUNK_HEIGHT(standard) = [0, 0, 1.7, 2.3, 2.8, 3.3, 0, 4.4, 0, 5.5][standard - 1];
function SCREW_METRIC_COUNTERSUNK_OD(standard) = standard * 2;

module SCREW_METRIC_COUNTERSUNK(standard, length, unthreaded_length = 0, borehole_length = 0, tolerance = .15) {
  if (SCREW_METRIC_COREHOLE(standard=standard) == 0) echo("ERROR: SCREW_METRIC_COREHOLE value has not been set yet.");
  if (SCREW_METRIC_BOREHOLE(standard=standard) == 0) echo("ERROR: SCREW_METRIC_BOREHOLE value has not been set yet.");
  if (SCREW_METRIC_COUNTERSUNK_HEIGHT(standard=standard) == 0) echo("ERROR: SCREW_METRIC_COUNTERSUNK_HEIGHT value has not been set yet.");

  union() {
    translate(v=[0, 0, -.1]) {
      cylinder(h=.2 + borehole_length, d=SCREW_METRIC_COUNTERSUNK_OD(standard) + tolerance, center=false);
      translate(v=[0, 0, -SCREW_METRIC_COUNTERSUNK_HEIGHT(standard)]) {
        cylinder(h=SCREW_METRIC_COUNTERSUNK_HEIGHT(standard), d2=SCREW_METRIC_COUNTERSUNK_OD(standard) + tolerance, d1=SCREW_METRIC_BOREHOLE(standard) + tolerance, center=false);
        translate(v=[0, 0, -.1]) cylinder(h=.1, d=SCREW_METRIC_BOREHOLE(standard) + tolerance, center=false);
      }
    }
    translate(v=[0, 0, -length]) cylinder(h=length, d=SCREW_METRIC_COREHOLE(standard) + tolerance, center=false);

    // unthreaded part
    translate(v=[0, 0, -.1 - SCREW_METRIC_COUNTERSUNK_HEIGHT(standard) - unthreaded_length]) cylinder(h=unthreaded_length + .1, d=SCREW_METRIC_BOREHOLE(standard) + tolerance, center=false);
  }
}

// TODO: module metric cylindric head screws

// TODO: module metric rounded head screws

function SCREW_WOOD_COREHOLE(diameter) = diameter * 0.75;
function SCREW_WOOD_BOREHOLE(diameter) = diameter * 1.25;
function SCREW_WOOD_COUNTERSUNK_HEIGHT(diameter) = diameter * 0.75;

module SCREW_WOOD_COUNTERSUNK(diameter, length, unthreaded_length = 0, tolerance = .15) {
  if (SCREW_METRIC_COREHOLE(standard=standard) == 0) echo("ERROR: SCREW_METRIC_COREHOLE value has not been set yet.");
  if (SCREW_METRIC_BOREHOLE(standard=standard) == 0) echo("ERROR: SCREW_METRIC_BOREHOLE value has not been set yet.");
  if (SCREW_METRIC_COUNTERSUNK_HEIGHT(standard=standard) == 0) echo("ERROR: SCREW_METRIC_COUNTERSUNK_HEIGHT value has not been set yet.");

  // TODO: add module for wood screws 
  union(){}
}

// TODO: module wood cylindric head screws

// TODO: module wood rounded head screws

function cone_diameter(diameter) = diameter * 2;
function cone_diameter_cutout(diameter) = diameter * 2 + 0.5;
function cone_height(diameter) = diameter * 0.75;

module screw(diameter, length = 12, cutout_sample = false) {
  module base_model(diameter, length, cone_height, cone_diameter, offset = 0) {
    rotate_extrude() {
      polygon(
        [
          [0, 0],
          [(diameter + offset) / 2, 0],
          [(diameter + offset) / 2, (length + offset) - (cone_height + offset)],
          [(cone_diameter + offset) / 2, length + offset],
          [0, length + offset],
        ]
      );
    }
  }

  if (length < diameter) {
    echo("Screw is too short");
    length = diameter + 5;
    echo("New length is: ", length);
  }

  if (!cutout_sample) {
    translate([0, 0, -length])
      difference() {
        base_model(diameter, length, cone_height(diameter), cone_diameter(diameter));

        // top cross part
        translate([0, 0, length - (cone_height(diameter) - diameter / 2) + .1])
          difference() {
            rotate([0, 0, 45])
              rotate_extrude() {
                polygon(
                  [
                    [0, 0],
                    [diameter * 1.4 / 2, 0],
                    [cone_diameter(diameter) / 3, cone_height(diameter) - diameter / 2],
                    [0, cone_height(diameter) - diameter / 2],
                  ]
                );
              }
            for (i = [0:1:3]) {
              rotate([0, 0, 90 * i])
                translate([diameter / 3.18 / 2, diameter / 3.18 / 2, 0]) cube(cone_height(diameter));
            }
          }
      }
  } else {
    offset = 0;
    diameter = cone_diameter_cutout(diameter) / 2; // is duplicated by function, used to reduce error
    translate([0, 0, -length - offset / 2]) {
      base_model(diameter, length, cone_height(diameter), cone_diameter(diameter), offset);
      translate([0, 0, length - .005]) cylinder(r=diameter, h=50);
    }
  }
}

module screw_corehole(diameter_screw, diameter_core, unthreaded_length, length = 12) {
  union() {
    screw(diameter=diameter_screw, length=unthreaded_length, cutout_sample=true);
    translate([0, 0, -length]) cylinder(d=diameter_core, h=length - unthreaded_length + .1);
  }
}

module screw_with_nut(screw_length, diameter, square_channel = false, tolerance = .1) {
  function od(width) = ( (width / 2) / cos(30)) * 2; // calculates nut diameter from given width
  nut_thickness = [0.8, 1.6, 2.4, 3.2, 4, 5, 5.5, 6.5];
  nut_width = [2.5, 4, 5.5, 7.1, 8.1, 10.1, 11.1, 13.1];

  if (!(0 < diameter && diameter <= 8 && diameter == round(diameter))) {
    echo("module is only defined for integer values from M1 to M8.");
  } else {
    union() {
      if (!square_channel) {
        screw(diameter=diameter, length=screw_length, cutout_sample=true);

        translate([0, 0, -(screw_length * 2 - nut_thickness[diameter - 1])])
          cylinder(d=od(nut_width[diameter - 1]) + tolerance, h=screw_length, $fn=6);
      } else {
        screw(diameter=diameter, length=screw_length + diameter, cutout_sample=true);
        translate([-od(nut_width[diameter - 1]) / 2 - tolerance, -(nut_width[diameter - 1] / 2), -(screw_length)])
          cube([od(nut_width[diameter - 1]) + screw_length, nut_width[diameter - 1] + tolerance, nut_thickness[diameter - 1] + tolerance]);
      }
    }
  }
}

translate(v=[0, 0, 0]) screw(diameter=3.5, length=12, cutout_sample=false);
translate(v=[20, 0, 0]) screw_corehole(diameter_screw=3, diameter_core=2.5, unthreaded_length=15, length=20);
translate(v=[40, 0, 0]) screw_with_nut(screw_length=30, diameter=4, square_channel=false, tolerance=.1);
translate(v=[60, 0, 0]) SCREW_METRIC_COUNTERSUNK(standard=3, length=12, unthreaded_length=5, borehole_length=5);
