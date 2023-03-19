size = 2;
margin = 2;
dx = 170;
dy = 120;

edge = "";
mask = "";

module striped_square(size = 1, length = 1, num_stripes = 2) {
    color("teal")
        for(stripe = [1:num_stripes]) {
            if((stripe % 2) == 1) {
                polygon([[stripe-1, 0], [stripe,0], [0, stripe], [0,stripe-1]]*size/num_stripes);
            }
        }
    color("green")
        for(stripe = [num_stripes:length*num_stripes]) {
            if((stripe % 2) == 1) {
                polygon([[stripe-1, 0], [stripe,0], [stripe-num_stripes, num_stripes], [stripe-1-num_stripes,num_stripes]]*size/num_stripes);
            }
        }
    color("turquoise")
        for(stripe = [length*num_stripes:(length+1)*num_stripes]) {
            if((stripe % 2) == 1) {
                polygon([[length*num_stripes, stripe-length*num_stripes-1], [length*num_stripes,stripe-length*num_stripes], [stripe-num_stripes, num_stripes], [stripe-num_stripes-1,num_stripes]]*size/num_stripes);
            }
        }
}

module houndstooth(size = 1, dx = 2, dy = 2) {
    nx = ceil((dx/size) / 2);
    ny = ceil((dy/size) / 2);

    union() {
        for (y = [0: ny-1]) {
            translate(([0, y] * size * 2))
                striped_square(size, 2*nx, 2);
        }

        for (x = [0: nx-1]) {
            translate(
                ([x, 0] * size * 2)
              + ([1, 2*ny] * size)
            )
                mirror([1, 1])
                   striped_square(size, 2*ny, 2);
        }
    }
}

difference() {
    intersection() {
        translate([-25,-25]) {
            import(edge);
        }
        houndstooth(size, dx, dy);
    }
    offset(r=margin) {
        translate([-25,-25]) {
            import(mask);
        }
    }
}
