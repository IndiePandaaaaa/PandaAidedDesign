// created by IndiePandaaaaa
// encoding: utf-8

use <Screw.scad>

$fn = $preview ? 25 : 75;

module split_with_screw(screw_standard, screw_count, material_thickness, material_width, cut_thickness = .1) {
  distance_factor = 3;
  width_split = distance_factor * screw_count * screw_standard + .2;
  bottom_height = material_thickness * 0.7;

  translate(v=[0, 0, bottom_height * 0]) {
    union() {
      // planes
      cube(size=[width_split + .2, material_width + .2, cut_thickness], center=true);
      translate(v=[-(width_split + .1) / 2, 0, -(bottom_height + .2) / 2]) cube(size=[cut_thickness, material_width + .2, bottom_height + .2], center=true);
      translate(v=[(width_split + .1) / 2, 0, (bottom_height + .2) / 2]) cube(size=[cut_thickness, material_width + .2, bottom_height + .2], center=true);

      // screws
      for (i = [0:screw_count - 1]) {
        translate(v=[-( (width_split - .2) / 2 - distance_factor / 2 * screw_standard) + i * screw_standard * distance_factor, 0, bottom_height - .5 / 2]) {
          screw_metric_countersunk(
            standard=screw_standard,
            length=material_thickness + .5,
            unthreaded_length=material_thickness - bottom_height,
            borehole_length=material_thickness,
            tolerance=.15
          );
        }
      }
    }
  }
}

split_with_screw(screw_standard=3, screw_count=2, material_thickness=5, material_width=7, cut_thickness=.1);
