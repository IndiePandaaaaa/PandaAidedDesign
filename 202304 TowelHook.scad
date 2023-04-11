// created by IndiePandaaaaa | Lukas

width = 30;
height = width;
pole_diameter = 20; // diameter of the pole
wall_offset = 15;
hook_width = 20;

module towel_hook(width, height, pole_diameter, wall_offset, hook_width, material_strength = 3, socket = 5, chamfer =
2.5) {
    pole_dia = pole_diameter + 2; // diameter of the pole with additional offset
    mat_strength = material_strength;

    module hook_width_removal(width) {
        linear_extrude(height = width) {
            polygon([
                    [wall_offset, 0],
                    [wall_offset + pole_dia + mat_strength - chamfer, socket - chamfer],
                    [wall_offset + pole_dia + mat_strength, socket],
                    [wall_offset + pole_dia + mat_strength, socket + mat_strength + pole_dia / 3 * 2 - chamfer],
                    [wall_offset + pole_dia + mat_strength - chamfer, socket + mat_strength + pole_dia / 3 * 2],
                    [wall_offset + pole_dia, socket + mat_strength + pole_dia / 3 * 2],
                    [wall_offset + pole_dia, socket + mat_strength + chamfer],
                    [wall_offset + pole_dia - chamfer, socket + mat_strength],
                    [wall_offset + chamfer, socket + mat_strength],
                    [wall_offset, socket + mat_strength + chamfer],
                ]);
        }
    }

    difference() {
        linear_extrude(height = width) {
            difference() {
                polygon([
                        [0, 0],
                        [wall_offset, 0],
                        [wall_offset + pole_dia + mat_strength - chamfer, socket - chamfer],
                        [wall_offset + pole_dia + mat_strength, socket],
                        [wall_offset + pole_dia + mat_strength, socket + mat_strength + pole_dia / 3 * 2 - chamfer],
                        [wall_offset + pole_dia + mat_strength - chamfer, socket + mat_strength + pole_dia / 3 * 2],
                        [wall_offset + pole_dia, socket + mat_strength + pole_dia / 3 * 2],
                        [wall_offset + pole_dia, socket + mat_strength + chamfer],
                        [wall_offset + pole_dia - chamfer, socket + mat_strength],
                        [wall_offset + chamfer, socket + mat_strength],
                        [wall_offset, socket + mat_strength + chamfer],
                        [wall_offset, socket + mat_strength + pole_dia / 3 * 2],
                        [mat_strength, height],
                        [0, height],
                    ]);
                polygon([
                        [mat_strength, mat_strength],
                        [wall_offset - mat_strength * 1.5, mat_strength + socket],
                        [wall_offset - mat_strength * 1.5, socket + pole_dia / 3 * 2],
                        [mat_strength, height - socket],
                    ]);
            }
        }

        removal = (width - hook_width) / 2;
        hook_width_removal(removal);
        translate([0, 0, hook_width + removal])
            hook_width_removal(removal);
    }
}

towel_hook(width, height, pole_diameter, wall_offset, hook_width);