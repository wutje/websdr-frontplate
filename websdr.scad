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
extra=10;
D2H=29;
D2W=91;
D2D=3 + extra;

/* [frontplate] */
FH=60;
FW=120;
FD=2;
WIREHOLE_D=7;
STANDOFF_D=6;
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

module holes(width, height, d) {
    //if (0) 
    {
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
    }
    /*color("green") cube([width, height, 3], center=true);*/
}

module front_plate(wh) {
    translate([0, -DISPLAY_OFFSET, 0]) difference() {
        // Front plaat 
        color("grey") cube([FW, FH, FD], center=true);
        
        // Gat in de hoek tbv voeding
        translate([FW/2, -FH/2, -5]) cylinder(10, d=WIREHOLE_D); 

        // Text aan bovenkant
        translate([0, (FH + D2H)/4 + DISPLAY_OFFSET/2 - 1, 0.5])    
            //text is 2D!
            linear_extrude(FD)
                text("PA3DXI PD0JVG PA3WLE", size=5, halign="center", valign="center");
    };         
    // Pootjes
    dia = STANDOFF_D;
    //foffset = DISPLAY_OFFSET;
    translate([(DW-D2W)/2-DISP_X_CORRECTION - 1.5, 0,0]) {
    translate([+(PW/2-offset), +(PH/2-offset), -wh-FD/2]) difference() {cylinder(wh, d=dia); cylinder(wh+1, d=2.5);};
    translate([-(PW/2-offset), +(PH/2-offset), -wh-FD/2]) difference() {cylinder(wh, d=dia); cylinder(wh+1, d=2.5);};
    translate([+(PW/2-offset), -(PH/2-offset), -wh-FD/2]) difference() {cylinder(wh, d=dia); cylinder(wh+1, d=2.5);};
    translate([-(PW/2-offset), -(PH/2-offset), -wh-FD/2]) difference() {cylinder(wh, d=dia); cylinder(wh+1, d=2.5);};
    }
}

difference() 
{
    translate([0, 0, DD+PD/2+FD/2]) {
        difference() {
            front_plate(DD);

            margin = 2;
            holes_w = D2W;
            holes_h = FH-D2H-DISPLAY_OFFSET - 2*margin;
            translate([ 0, -(holes_h+D2H)/2-margin, 0])
                holes(holes_w, holes_h, AIRFLOW_HOLE_DIAMETER);
        }
    }
    translate([(DW-D2W)/2-DISP_X_CORRECTION- 1.5, 0,0])
        display_module();
}
    
if (0)
/* Tot 2.5 van de rand zit in de behuizing. */
translate([0, -DISPLAY_OFFSET, FD+DD]) difference() { 
    cube([FW, FH, 10], center=true);
    cube([FW-2.5, FH-2.5, 11], center=true);      
};

