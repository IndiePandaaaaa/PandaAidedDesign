// created by IndiePandaaaaa | Lukas

$fn=50;

function cone_diameter(diameter)=diameter * 2;

function cone_diameter_cutout(diameter)=diameter * 2 + 0.5;

function cone_height(diameter)=diameter * 0.75;

module screw(diameter, length=12, cutout_sample=false) {
  module base_model(diameter, length, cone_height, cone_diameter, offset=0) {
    rotate_extrude() {
      polygon([
          [0, 0],
          [(diameter + offset) / 2, 0],
          [(diameter + offset) / 2, (length + offset) - (cone_height + offset)],
          [(cone_diameter + offset) / 2, length + offset],
          [0, length + offset],
        ]);
    }
  }

  if (length < diameter) {
    echo("Screw is too short");
    length=diameter + 5;
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
                polygon([
                    [0, 0],
                    [diameter * 1.4 / 2, 0],
                    [cone_diameter(diameter) / 3, cone_height(diameter) - diameter / 2],
                    [0, cone_height(diameter) - diameter / 2],
                  ]);
              }
            for (i=[0 : 1 : 3]) {
              rotate([0, 0, 90 * i])
                translate([diameter / 3.18 / 2, diameter / 3.18 / 2, 0]) cube(cone_height(diameter));
            }
          }
      }
  } else {
    offset=0;
    diameter=cone_diameter_cutout(diameter) / 2;  // is duplicated by function, used to reduce error
    translate([0, 0, -length - offset / 2]) {
      base_model(diameter, length, cone_height(diameter), cone_diameter(diameter), offset);
      translate([0, 0, length]) cylinder(r=diameter, h=50);
    }
  }
}

module screw_corehole(diameter_screw, diameter_core, unthreaded_length, length=12) {
  union() {
    screw(diameter=diameter_screw, length=unthreaded_length, cutout_sample=true);
    translate([0, 0, -length]) cylinder(d=diameter_core, h=length - unthreaded_length + .1);
  }
}

module screw_with_nut(screw_length, diameter, square_channel=false, tolerance=.1) {
  function od(width) = ((width/2) / cos(30)) * 2; // calculates nut diameter from given width
  nut_thickness=[0.8, 1.6, 2.4, 3.2, 4, 5, 5.5, 6.5];
  nut_width=[2.5, 4, 5.5, 7.1, 8.1, 10.1, 11.1, 13.1];

  if (!(0 < diameter && diameter <= 8 && diameter == round(diameter))) {
    echo("module is only defined for integer values from M1 to M8.");
  } else {
    union() {
      if (!square_channel) {
        screw(diameter=diameter, length=screw_length, cutout_sample=true);

        translate([0, 0, -(screw_length*2 - nut_thickness[diameter - 1])]) 
          cylinder(d=od(nut_width[diameter - 1]) + tolerance, h=screw_length, $fn=6);

      } else {
        screw(diameter=diameter, length=screw_length + diameter, cutout_sample=true);
        translate([-od(nut_width[diameter - 1])/2 - tolerance, -(nut_width[diameter - 1]/2), -(screw_length)]) 
          cube([od(nut_width[diameter - 1]) + screw_length, nut_width[diameter - 1] + tolerance, nut_thickness[diameter - 1] + tolerance]);
      }
    }
  }
}

translate([ 0, 0, 0]) screw(diameter=3.5, length=12, cutout_sample=false);
translate([20, 0, 0]) screw_corehole(diameter_screw=3, diameter_core=2.5, unthreaded_length=15, length=20);
translate([40, 0, 0]) screw_with_nut(screw_length=30, diameter=4, square_channel=false, tolerance=.1);
