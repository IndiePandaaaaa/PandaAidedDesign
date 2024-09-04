// created by IndiePandaaaaa

// original [mm]
thickness = 1.5;
depth = 12.2;
innerHeight = 7.1;
//innerWidth = 22.3;

// optimizations:
innerWidth = 24.5;
chamfer = 0.5;
chamferPyramid = 0.5;

module pyra(chamferPyra = 0.25) {
    polyhedron(
    points = [
        // INNER FACE
            [thickness, thickness + chamfer, chamferPyra], //0
            [thickness + chamfer, thickness, chamferPyra], //1
            [thickness + innerWidth - chamfer, thickness, chamferPyra], //2
            [thickness + innerWidth, thickness + chamfer, chamferPyra], //3
            [thickness + innerWidth, thickness + innerHeight - chamfer, chamferPyra], //4
            [thickness + innerWidth - chamfer, thickness + innerHeight, chamferPyra], //5
            [thickness + chamfer, thickness + innerHeight, chamferPyra], //6
            [thickness, thickness + innerHeight - chamfer, chamferPyra], //7
        // OUTER FACE
            [thickness - chamferPyra, thickness + chamfer, - 0.01], //8
            [thickness + chamfer, thickness - chamferPyra, - 0.01], //9
            [thickness + innerWidth - chamfer, thickness - chamferPyra, - 0.01], //10
            [thickness + innerWidth + chamferPyra, thickness + chamfer, - 0.01], //11
            [thickness + innerWidth + chamferPyra, thickness + innerHeight - chamfer, - 0.01], //12
            [thickness + innerWidth - chamfer, thickness + innerHeight + chamferPyra, - 0.01], //13
            [thickness + chamfer, thickness + innerHeight + chamferPyra, - 0.01], //14
            [thickness - chamferPyra, thickness + innerHeight - chamfer, - 0.01], //15
        ],
    faces = [
            [7, 6, 5, 4, 3, 2, 1, 0], //0
            [0, 1, 9, 8], //1
            [1, 2, 10, 9], //2
            [2, 3, 11, 10], //3
            [3, 4, 12, 11], //4
            [4, 5, 13, 12], //5
            [5, 6, 14, 13], //6
            [6, 7, 15, 14], //7
            [7, 0, 8, 15], //8
            [8, 9, 10, 11, 12, 13, 14, 15], //9
        ]
    );
}

intersection() {
    difference() {
        linear_extrude(height = depth) {
            difference() {
                outer_chamfer = chamfer + thickness - 0.25;
                polygon([
                        [0, outer_chamfer / 2 * 3],
                        [outer_chamfer / 2, outer_chamfer / 2],
                        [outer_chamfer / 2 * 3, 0],
                        [thickness * 2 + innerWidth - outer_chamfer / 2 * 3, 0],
                        [thickness * 2 + innerWidth - outer_chamfer / 2, outer_chamfer / 2],
                        [thickness * 2 + innerWidth, outer_chamfer / 2 * 3],
                        [thickness * 2 + innerWidth, thickness * 2 + innerHeight - outer_chamfer / 2 * 3],
                        [thickness * 2 + innerWidth - outer_chamfer / 2, thickness * 2 + innerHeight - outer_chamfer / 2
                        ],
                        [thickness * 2 + innerWidth - outer_chamfer / 2 * 3, thickness * 2 + innerHeight],
                        [outer_chamfer / 2 * 3, thickness * 2 + innerHeight],
                        [outer_chamfer / 2, thickness * 2 + innerHeight - outer_chamfer / 2],
                        [0, thickness * 2 + innerHeight - outer_chamfer / 2 * 3],
                    ]);
                polygon([
                        [thickness, thickness + chamfer],
                        [thickness + chamfer, thickness],
                        [thickness + innerWidth - chamfer, thickness],
                        [thickness + innerWidth, thickness + chamfer],
                        [thickness + innerWidth, thickness + innerHeight - chamfer],
                        [thickness + innerWidth - chamfer, thickness + innerHeight],
                        [thickness + chamfer, thickness + innerHeight],
                        [thickness, thickness + innerHeight - chamfer],
                    ]);
            }
        }
        pyra(chamferPyramid);
        translate([innerWidth + thickness * 2, 0, depth])
            rotate([0, 180, 0]) pyra(chamferPyramid);
    }
    rotate([0, 90, 0]) translate([- depth, 0, 0]) {
        linear_extrude(innerWidth + thickness * 2) {
            polygon([
                    [0, chamfer],
                    [chamfer, 0],
                    [depth - chamfer, 0],
                    [depth, chamfer],
                    [depth, innerHeight + thickness * 2 - chamfer],
                    [depth - chamfer, innerHeight + thickness * 2],
                    [chamfer, innerHeight + thickness * 2],
                    [0, innerHeight + thickness * 2 - chamfer],
                ]);
        }
    }
    rotate([- 90, 0, 0]) translate([0, - depth, 0]) {
        linear_extrude(innerHeight + thickness * 2) {
            polygon([
                    [0, chamfer],
                    [chamfer, 0],
                    [innerWidth + 2 * thickness - chamfer, 0],
                    [innerWidth + 2 * thickness, chamfer],
                    [innerWidth + 2 * thickness, depth - chamfer],
                    [innerWidth + 2 * thickness - chamfer, depth],
                    [chamfer, depth],
                    [0, depth - chamfer],
                ]);
        }
    }
}


