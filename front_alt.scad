/* [Stands] */
stand_x_dist = 108;
stand_y_dist = 29;
stand_height = 10;
stand_outer_diameter = 6;
stand_inner_diameter = 3;
/* [Window] */
cutout_x = 13.5;
cutout_y = 5.2;
cutout_width = 83;
cutout_height = 18.6;
/* [Front] */
front_width = 122;
front_height = 62;
front_thickness = 1.8;
// The depth of groove of the case in which the front rests
front_case_inset = 2;
cable_diameter = 4;
//Position of display wrt center
display_x_correction = -1;
//Position of display wrt center
display_y_correction = 7;
air_vent_width = cutout_width;
air_vent_height = 1;
air_vent_dist = 3;
air_vent_y = 6;
/* [PCB] */
pcb_thickness = 2;
/* [Misc] */
nozzle_diamater = 0.4; //[0.4, 0.6]
$fn=50;

module stand() {
    cylinder(d=stand_outer_diameter, h=stand_height);
    translate([0,0,2*-pcb_thickness])
        cylinder(d=stand_inner_diameter-nozzle_diamater/2, h=2*pcb_thickness);
}

module stands() {
    //center
    translate([-stand_x_dist/2, stand_y_dist/2, -stand_height])
    for(x=[0,stand_x_dist], y=[0,-stand_y_dist]) {
        translate([x, y, 0]) stand();
    }
}

module window_cutout() {
    //center
    translate([-stand_x_dist/2, stand_y_dist/2, -stand_height])
    //move window to proper position
    translate([cutout_x, -cutout_height-cutout_y, 0])
        // Hull to 'grow' cutout a bit for margin.
        hull() {
            // 'window'
            cube([cutout_width, cutout_height, stand_height + front_thickness + 1]);
            cube([nozzle_diamater/2,nozzle_diamater/2, nozzle_diamater/2]);
        }
}

module air_vents() {
    //center
    translate([-stand_x_dist/2, stand_y_dist/2-air_vent_y, -stand_height])
    //move window to proper position
    translate([cutout_x, -cutout_height-cutout_y, 0])
    translate([(cutout_width-air_vent_width)/2, 4, 0])
    for (i = [0:4]) {
        translate([0, -(air_vent_dist + air_vent_height)*i, stand_height])
            //slanted to prevent light leakage.
            rotate([60,0,0])
            translate([0, 0, -10/2])
            cube([air_vent_width, air_vent_height, 10]);
    }
}

module frontplate() {
    translate([-front_width/2, -front_height/2, 0]) {
        difference() {
            cube([front_width, front_height, front_thickness]);
            // compensate for case inset
            translate([-front_case_inset, front_case_inset, 0])
            //move to lower right corner
            translate([front_width, 0, -front_thickness])
                // Since the cutout for the cable is from the corner
                // the RADIUS of the cutout == DIAMETER of the cable
                cylinder(r=cable_diameter, h=front_thickness*10);
        }
    }
}

union() {
    stands();
    difference() {
        translate([-display_x_correction, -display_y_correction, 0])
            frontplate();
        window_cutout();
        air_vents();
    }
}
