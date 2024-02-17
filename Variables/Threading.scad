// created by IndiePandaaaaa | Lukas

// source M3-M12: https://de.wikipedia.org/wiki/Kernloch
// source UNC14: https://www.thommel.de/de/artikel/werkzeuge,80,format-hsse-maschinengewindebohrer,3017680017/
// source UNC38:https://www.thommel.de/de/artikel/werkzeuge,80,format-hsse-maschinengewindebohrer,3017680021/

// UNC14 => UNC 1/4″ 20  |   UNC38 => UNC 3/8″ 16

core_holes = [
  ["M3", 2.5],
  ["M4", 3.3],
  ["M5", 4.2],
  ["M6", 5.0],
  ["M8", 6.8],
  ["M10", 8.5],
  ["M12", 10.2],
  ["UNC14", 5.1],
  ["UNC38", 8.0],
];

function core_hole(name) = core_holes[search([name], core_holes, num_returns_per_match = 1, index_col_num = 0)[0]][1];

function core_hole_M3() = core_hole("M3");

function core_hole_M4() = core_hole("M4");

function core_hole_M5() = core_hole("M5");

function core_hole_M6() = core_hole("M6");

function core_hole_M8() = core_hole("M8");

function core_hole_M10() = core_hole("M10");

function core_hole_M12() = core_hole("M12");

function core_hole_UNC14() = core_hole("UNC14");

function core_hole_UNC38() = core_hole("UNC38");
