using PorousMaterials

xtal_filename = ARGS[1]
grid_filename = ARGS[2]

xtal = Crystal(xtal_filename)
grid = grid(grid_filename)
ids_keep = falses(xtal.atoms.n)

for i in 1:xtal.atoms.n
    x  = Cart(xtal.atoms.cords)
    xf = Frac(x, grid.box)

    if all(xf.<1.0) && all(xf.>0.0)
        ids_keep[i] = true
    end
end

write_cif(xtal.atoms[ids_keep])
write_vtk(grid.box)
