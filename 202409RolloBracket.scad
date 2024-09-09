// created by IndiePandaaaaa
// encoding: utf-8
$fn=75;

outer_height = 35.6;
outer_radius = 11.5;
outer_axis_offset = 17.5;
axis_od = 7.9;
axis_id = 5.2;
axis_cubes = 1.5;
axis_depth = 7;
base_thickness = 3.4;
base_depth = 16.9;
thickness = 7.7;

union(){
  translate([outer_axis_offset + outer_radius, 0, 0]) difference() {
    scale([1, 1.07, 1]) cylinder(r=outer_radius, h=thickness);
    translate([-outer_height, -outer_height / 2, -.1])
      cube(outer_height + .1);
  }
  translate([0, -outer_height/2, 0]) linear_extrude(thickness) {
    triangle = (outer_height - outer_radius * 2) / 2;
    polygon([
      [0, 0],
      [outer_radius, 0],
      [outer_radius + outer_axis_offset + axis_od / 2, triangle],
      [outer_radius + outer_axis_offset + axis_od / 2, outer_height - triangle],
      [outer_radius, outer_height],
      [0, outer_height],
    ]);
  }
  translate([-base_thickness, -outer_height / 2, 0]) 
    cube([base_thickness + .1, outer_height, base_depth]);
  translate([outer_radius + outer_axis_offset, 0, thickness - .1]) union() {
    difference() {
      cylinder(d=axis_od, h=axis_depth);
      translate([0, 0, -.1]) cylinder(d=axis_id, h=axis_depth + .2);
    }
    for (i = [0:8-1]) {
      rotate([0, 0, 45 * i])
        translate([axis_od/2 -.2, -axis_cubes/2, 0]) 
          cube([axis_cubes, axis_cubes, axis_depth]);
    }
  }
}
