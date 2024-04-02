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
        translate([0, 0, DD/2+PD/2])
            color("white") cube([DW, DH, DD], center=true);
        //Screen
        translate([-(DW-D2W)/2, -(DH-D2H)/2, D2D/2+DD+PD/2])
            color("black") cube([D2W, D2H, D2D], center=true);
    }
}

module holes(width, heigth) {
        d = AIRFLOW_HOLE_DIAMETER; //Diameter gaten lucht rooster + afstand tussen gaten
        x_margin = 1 * d;    
        x_rem = width - x_margin;
        x_width = (2 * d); 
        columns = floor(x_rem / x_width) - 1;
        //Voeg rest toe aan offset. Zodat marge links en rechts gelijk is
        x_offset = (x_margin + x_rem - (columns * x_width)) / 2;
        
        //echo(x_margin, x_rem, x_width, columns, x_offset);
    
        y_margin = 1 * d; // 0.5 diameter ruimte boven en onder
        y_rem = heigth - y_margin;
        rows = floor((y_rem) / d) - 1;
        //Voeg rest toe aan offset. Zodat boven en onder keurig verdeeld is
        y_offset = (y_margin + y_rem - rows * d) / 2;
    
        for(i = [0:columns]) {
            for(j = [0:rows]) {
                o = x_offset + i * x_width; 
                of = ((j % 2)==0) ? o : o + d;
                translate([of, y_offset + j * d, -5]) cylinder(10, d=d);
            }
        }
        color("green") cube([width, heigth, 3]);
}

module front_plate(wh) {
    foffset = DISPLAY_OFFSET;
    //foffset = 0;
    
    difference() {
        //Front plaat
        translate([0, -foffset, 0])
            //Sommige objecten vanuit center bouwen en andere niet
            //vind ik verwarrend en probeer ik te voorkomen.
            color("grey") cube([FW, FH, FD], center=true);
   
        translate([FW/2, -FH/2 -foffset, -5]) cylinder(10, d=WIREHOLE_D); 
    }
    // Pootjes
    dia = STANDOFF_D;
    translate([+(PW/2-offset), +(PH/2-offset), -wh-FD/2]) cylinder(wh, d=dia);
    translate([-(PW/2-offset), +(PH/2-offset), -wh-FD/2]) cylinder(wh, d=dia);
    translate([+(PW/2-offset), -(PH/2-offset), -wh-FD/2]) cylinder(wh, d=dia);
    translate([-(PW/2-offset), -(PH/2-offset), -wh-FD/2]) cylinder(wh, d=dia);

    translate([0, D2H/2+DISPLAY_OFFSET - 2, 0])    
        text("PA3DXI PD0JVG PA3WLE", size=5, halign="center", valign="top");
}

difference() {
    //Het is beter om een module te maken in het origin en dan pas later
    //te translaten naar waar hij in de assembly moet komen.
    translate([0, 0, DD+PD/2+FD/2]) {
        difference() {
        front_plate(DD);
      
        translate([ -(DW-D2W)/2 + -D2W/2,
                    -(DH-D2H)/2 + -D2H/2 - 4, //Keep 2mm clearance from top and bottom
                    0])
            holes(D2W, FH-D2H-DISPLAY_OFFSET - 4);
        }

       
    }
    //#display_module();
    
}