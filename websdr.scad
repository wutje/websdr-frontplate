/* [front] */
FH=60;
FW=120;
FD=1;

/* [PCB dims] */
PH=37;
PW=116;
PD=2;
//holes
offset=3;

/* [Display] */
DH=32;
DW=96.25;
DD=8;

/* [Display screen] */
// set to something big so you can diff it with the front
extra=20;
D2H=29;
D2W=91;
D2D=3 + extra;

// detail circles
$fn=20;

module display_module() {
    difference() {
        // PCB
        color("green") cube([PW, PH, PD], center=true);
        // Gaatjes
        translate([+(PW/2-offset), +(PH/2-offset),-5]) cylinder(10, d=3);
        translate([-(PW/2-offset), +(PH/2-offset),-5]) cylinder(10, d=3);
        translate([+(PW/2-offset), -(PH/2-offset),-5]) cylinder(10, d=3);
        translate([-(PW/2-offset), -(PH/2-offset),-5]) cylinder(10, d=3);
    }

    //Display Module
    translate([1, 0.5, 0]) { //net even off center
        //Base
        translate([0, 0, DD/2+PD])
            color("white") cube([DW, DH, DD], center=true);
        //Screen
        translate([-(DW-D2W)/2, -(DH-D2H)/2, D2D/2+DD+PD])
            color("black") cube([D2W, D2H, D2D], center=true);
    }
}

module front_plate() {
    wh = DD + PD; //Afstand tussen front plaat en PCB aka werkhoogte
    foffset = (FH - DH) / 4; //Front plaat offset tov scherm
    
    difference() {
        //Front plaat
        translate([0, -foffset, wh])
            color("grey") cube([FW, FH, FD], center=true);

        d = 3.2; //Diameter gaten lucht rooster + afstand tussen gaten
        nr_holes = (D2W - (1 * d)) / (d * 2);
        
        //Gaatjes voor lucht rooster
        for(i = [0:nr_holes]) {
            display_x = 1 + -(DW-D2W)/2 + -D2W/2;
            display_y = 0.5 + -(DH-D2H)/2 + -D2H/2;
            o = display_x + (i * (2 * d)) + d; 
            h = display_y - 2; //mm below display;
            translate([o,     h -1 * d, wh + -5]) cylinder(10, d=d);
            translate([o + d, h -2 * d, wh + -5]) cylinder(10, d=d);      
            translate([o,     h -3 * d, wh + -5]) cylinder(10, d=d);
            translate([o + d, h -4 * d, wh + -5]) cylinder(10, d=d);
        }
    
        wirehole = 7;
        translate([FW/2, -FH/2 -foffset, wh + -5]) cylinder(10, d=wirehole); 
 
    }
    // Pootjes
    dia = 7;
    translate([+(PW/2-offset), +(PH/2-offset),0]) cylinder(wh, d=dia);
    translate([-(PW/2-offset), +(PH/2-offset),0]) cylinder(wh, d=dia);
    translate([+(PW/2-offset), -(PH/2-offset),0]) cylinder(wh, d=dia);
    translate([-(PW/2-offset), -(PH/2-offset),0]) cylinder(wh, d=dia);



}
display_module();
front_plate();
