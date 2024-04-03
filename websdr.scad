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

/* [frontplate] */
FH=60;
FW=120;
FD=1;
WIREHOLE_D=7;
STANDOFF_D=7;
AIRFLOW_HOLE_DIAMETER=3.2;
//Front plaat offset tov scherm 25% vanaf bovenkant
//Midden is onhandig ivm rooster gaten
DISPLAY_OFFSET = (FH - DH) * 0.25; 
DISP_X_CORRECTION = 1;

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
    translate([DISP_X_CORRECTION, 0.5, 0]) { //net even off center
        //Base
        translate([0, 0, DD/2+PD/2])
            color("white") cube([DW, DH, DD], center=true);
        //Screen
        translate([-(DW-D2W)/2, -(DH-D2H)/2, D2D/2+DD+PD/2])
            color("black") cube([D2W, D2H, D2D], center=true);
    }
}
module holes(width, height) {
    d = AIRFLOW_HOLE_DIAMETER;
    // -2 to leave margin at both sides
    cols = floor(width/d - 2);
    rows = floor(height/d - 2);

    translate([-(cols*d)/2, -(rows*d)/2, 0]) // bring to center
        for(j = [0:rows]) {
            for(i = [0:cols]) {
                //On even rows leave out even cols
                //On odd rows leave out odd cols
                if(i%2 != j%2)
                    translate([i*d,j*d,0])
                        cylinder(10, d=d, center=true);
            }
        }
    /*color("green") cube([width, height, 3], center=true);*/
}

module front_plate(wh) {
    foffset = DISPLAY_OFFSET;

    difference() {
        //Front plaat
        translate([0, -foffset, 0])
            color("grey") cube([FW, FH, FD], center=true);

        translate([FW/2, -FH/2 -foffset, -5]) cylinder(10, d=WIREHOLE_D); 

        translate([0, D2H/2+DISPLAY_OFFSET - 2, 0])    
            //text is 2D!
            linear_extrude(FD)
                text("PA3DXI PD0JVG PA3WLE", size=5, halign="center", valign="top");
    }
    // Pootjes
    dia = STANDOFF_D;
    translate([+(PW/2-offset), +(PH/2-offset), -wh-FD/2]) cylinder(wh, d=dia);
    translate([-(PW/2-offset), +(PH/2-offset), -wh-FD/2]) cylinder(wh, d=dia);
    translate([+(PW/2-offset), -(PH/2-offset), -wh-FD/2]) cylinder(wh, d=dia);
    translate([-(PW/2-offset), -(PH/2-offset), -wh-FD/2]) cylinder(wh, d=dia);
}

difference() {
    translate([0, 0, DD+PD/2+FD/2]) {
        difference() {
            front_plate(DD);

            margin = 2;
            holes_w = D2W;
            holes_h = FH-D2H-DISPLAY_OFFSET - 2*margin;
            translate([ 0, -(holes_h+D2H)/2-margin, 0])
                holes(holes_w, holes_h);
        }
    }
    translate([(DW-D2W)/2-DISP_X_CORRECTION, 0,0])
        display_module();
}
