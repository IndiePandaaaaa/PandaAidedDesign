// created by Lukas|@IndiePandaaaaa
// encoding: utf-8

use <Screw.scad>

$fn = $preview ? 25 : 75;

function split_screw_material_height(screw_standard, material_thickness, unthreaded = .5) =
  material_thickness > screw_metric_countersunk_height(screw_standard) + screw_standard + unthreaded ?
    material_thickness
  : screw_metric_countersunk_height(screw_standard) + screw_standard + unthreaded;

function split_screw_distance(screw_standard) = screw_standard * 3;
function split_width(screw_standard, screw_count) = split_screw_distance(screw_standard) * screw_count + .2;

module split_with_screw_support(screw_standard, screw_count, material_thickness, material_width) {
  support_height = split_screw_material_height(screw_standard=screw_standard, material_thickness=material_thickness);
  support_width = split_width(screw_standard=screw_standard, screw_count=screw_count);

  translate(v=[0, 0, support_height / 2]) cube(size=[material_width, support_width + 1, support_height], center=true);
}

module split_with_screw(screw_standard, screw_count, material_thickness, material_width, cut_thickness = .1) {
  sts_distance = split_screw_distance(screw_standard); // sts = screw to screw

  width = split_width(screw_standard, screw_count);
  height = split_screw_material_height(screw_standard, material_thickness) + .2;

  bottom_split_height = height - screw_metric_countersunk_height(screw_standard) - .5;
  top_split_height = height - bottom_split_height;

  screw_length_unthreaded = height - bottom_split_height - screw_metric_countersunk_height(screw_standard);
  screw_pos_first = -(width - .2) / 2 + sts_distance / 2;

  echo("SplitToPrint: material height", height);

  translate(v=[0, 0, bottom_split_height]) {
    union() {
      // planes
      cube(size=[width, material_width + .2, cut_thickness], center=true);
      translate(v=[-width / 2, 0, -bottom_split_height / 2])
        cube(size=[cut_thickness, material_width + .2, bottom_split_height + .1], center=true);
      translate(v=[width / 2, 0, top_split_height / 2])
        cube(size=[cut_thickness, material_width + .2, top_split_height + .1], center=true);

      // screws
      for (i = [0:screw_count - 1]) {
        translate(v=[screw_pos_first + i * sts_distance, 0, top_split_height + .1])
          screw_metric_countersunk(standard=screw_standard, length=height + .1, unthreaded_length=screw_length_unthreaded, borehole_length=height, tolerance=.15);
      }
    }
  }
}

split_with_screw(screw_standard=3, screw_count=1, material_thickness=3, material_width=7, cut_thickness=.1);
