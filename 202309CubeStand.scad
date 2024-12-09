// Created by IndiePandaaaaa|Lukas

TOLERANCE = 0.1;
THICKNESS = 1.5;

HEIGHT = 7;
WIDTH = 14;

SIZE = WIDTH * 4 / 3;

module pyramid(size = 30) {
  cylinder(d1 = size, d2 = 0, h = size, $fn = 3);
}

difference() {
  pyramid(SIZE);
  translate([0, 0, HEIGHT]) pyramid(SIZE);
  translate([0, 0, -THICKNESS]) pyramid(SIZE);
}