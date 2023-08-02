// created by IndiePandaaaaa | Lukas

function as_width() = 42.1;

function as_heigth() = 8;

module arca_swiss(depth=50) {
    linear_extrude(depth) {
        polygon([
                [1.5, 0],
                [as_width() - 1.5, 0],
                [as_width() - 1.5, 0.7],
                [as_width() - 4.5, 4.2],
                [as_width(), 4.2],
                [as_width(), as_heigth()],
                [0, as_heigth()],
                [0, 4.2],
                [4.5, 4.2],
                [1.5, 0.7],
            ]);
    }
}

arca_swiss(50);