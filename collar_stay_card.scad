// text
line1 = "github.com/";
line2 = "reeserich";

// font
font = "Helvetica:style=Bold";

// fontsize
fontsize = 10;

// text depth
text_depth = 0.6;

// space between lines of text
line_space = 2;

// collar stay length
collar_stay_length=57.15; // default 6.35 mm (2.25 in)

//collar stay width
collar_stay_width=6.35; // default 6.35 mm (0.25 in)

// collar stay fillet radius
collar_stay_r=2; // default 6.35 mm (0.25 in)

// collar stay point length
point=15; // default 15 mm

// length of card (largest axis)
card_length=85.6; // default 85.6 mm (3.37 in)

// width of card (smaller axis)
card_width=54; // default 54 mm (0.25 in)

// card fillet radius
card_r = 2; // default 6.35 mm (0.25 in)

// thickness of whole shebang
card_thick=1; // default 1 mm (0.039 in)

// gap thickness
gap=1; // default 1 mm (0.039 in)

// edge thickness
edge_thick=5; // default 5 mm (0.20 in)

module rounded_square(x,y,z,r)
{
    
    hull()
    {
        translate([r,r,0]) cylinder(h=z,r=r,$fn=360);
        translate([-r+x,r,0]) cylinder(h=z,r=r,$fn=360);
        translate([r,-r+y,0]) cylinder(h=z,r=r,,$fn=360);
        translate([-r+x,-r+y,0]) cylinder(h=z,r=r,$fn=360);
    }
}

module collar_stay(length,width,z,r ,point)
{
    delta=r;
    
    hull()
    {
        translate([0,0,0]) cylinder(h=z,r=width/2,$fn=360);
        translate([length-point,-width/2+r,0]) cylinder(h=z,r=r,$fn=360);
        translate([length-point,width/2-r,0]) cylinder(h=z,r=r,$fn=360);
        translate([length,0,0]) cylinder(h=z,r=r,$fn=360);
    }
}

module collar_stay_hole(length,z,pad)
{
    linear_extrude(z) 
    {
        offset(r=pad,$fn=360) polygon([[0,-0.0001],[0,0.0001],
        [length,0.000001],
        [length,-0.0000001]]);
    }
}

module tab(total_depth, tab_depth, tab_width, tab_length)
{
    rotate([0, 90, 0])
    rotate([0, 0, 90]){
        linear_extrude(tab_length)
        {
            polygon([[0,0], [0,total_depth], [tab_width, tab_depth], [tab_width,0]]);
        }
    }
}


difference() {
    union() {
        difference()
        {
            rounded_square(x=card_length, y=card_width, z=card_thick, r=card_r);
            union(){
                // bottom hole
                translate([collar_stay_width,collar_stay_width,-0.1])
                collar_stay_hole(length=collar_stay_length, z=1.5*card_thick, pad=collar_stay_width/2+gap);
                // top hole
                translate([collar_stay_width,edge_thick+collar_stay_width*2,-0.1])
                collar_stay_hole(length=collar_stay_length, z=1.5*card_thick, pad=collar_stay_width/2+gap);
            }
        }

        // bottom collar stay
        translate([collar_stay_length+collar_stay_width,collar_stay_width,0])
        collar_stay(length=-collar_stay_length, width=collar_stay_width, z=card_thick, r=collar_stay_r, point=-point);

        // top collar stay
        translate([collar_stay_width,edge_thick+collar_stay_width*2,0])
        collar_stay(length=collar_stay_length, width=collar_stay_width, z=card_thick, r=collar_stay_r, point=point);

        // tabs (bottom)
        translate([collar_stay_width+collar_stay_length*0.8,collar_stay_width/2-gap,0])
        tab(total_depth=card_thick, tab_depth=0.4, tab_width=gap, tab_length=1);

        translate([collar_stay_width+point*1.8,collar_stay_width*1.5+gap,0])
        rotate([0, 0, 180])
        tab(total_depth=card_thick, tab_depth=0.4, tab_width=gap, tab_length=1);

        // tabs (top)
        // rotate([0, 0, 180])

        translate([collar_stay_length+collar_stay_width-point*1.8,edge_thick+collar_stay_width*2-collar_stay_width/2-gap,0])
        tab(total_depth=card_thick, tab_depth=0.4, tab_width=gap, tab_length=1);

        translate([collar_stay_length+collar_stay_width-collar_stay_length*0.8,edge_thick+collar_stay_width*2.5+gap,0])
        rotate([0, 0, 180])
        tab(total_depth=card_thick, tab_depth=0.4, tab_width=gap, tab_length=1);
    }

    translate([card_length-edge_thick, card_width-edge_thick,card_thick-text_depth]) 
    linear_extrude(1.5*card_thick)
    {
        text(line1, size = fontsize, font = font, halign = "right", valign = "top", spacing=0.95);
        translate([0,-fontsize-line_space,0])
        text(line2, size = fontsize, font = font, halign = "right", valign = "top", spacing=0.95);
    }
}