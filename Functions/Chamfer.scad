module chamfer(position, width, height) {
  function hypo(distance) = (distance^2 * 2)^0.5;
  color("#00bbbb") translate(position) rotate([0, 0, 90]) translate([-width, -0.01, 0]) difference() {
    translate([0, 0, -0.01]) cube([width + 0.02, width + 0.02, height + 0.02]);
    translate([0, 0, -0.02]) rotate([0, 0, 45]) cube(hypo(width + 0.02));
  }
}