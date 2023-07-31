// created by IndiePandaaaaa | Lukas

module arca_swiss(depth=50) {
    linear_extrude(depth) {
        width = 42.1;
        height = 8;
        polygon([
                [1.5, 0],
                [width - 1.5, 0],
                [width - 1.5, 0.7],
                [width - 4.5, 4.2],
                [width, 4.2],
                [width, height],
                [0, height],
                [0, 4.2],
                [4.5, 4.2],
                [1.5, 0.7],
            ]);
    }
}

arca_swiss(50);