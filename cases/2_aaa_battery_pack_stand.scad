/* placement for 2xAAA battery pack, as used with micro:bit
Matthew Oppenheim 2021
dimensions: mm
*/

delta = 0.2;
pack_x = 63.0;
pack_y = 25.5;
pack_z = 15.6;
support_z = 10.0;
support_depth = 2.4;
pack_total_x = pack_x + 2*support_depth;
pack_total_y = pack_y + 2*support_depth;


module footprint_outline(){
    // raised edge around base of battery pack  
    difference(){
        color([0,0,1])
        cube([pack_total_x, pack_total_y, support_z]);
        translate([support_depth, support_depth, -delta])
        color([0,1,1,0.2])
        cube([pack_x, pack_y, support_z+2*delta]);
    }
}

//footprint_outline();
module x_cut_out(){
    translate([-delta,3*support_depth,-delta])
    cube([pack_total_x+2*delta, pack_y-4*support_depth, support_z+2*delta]);
} 

module y_cut_out(){
    translate([3*support_depth, -support_depth,-delta])
    cube([pack_x-4*support_depth, pack_y+4*support_depth, support_z+2*delta]);
}

module 2_aaa_assembly(){
    difference(){
        footprint_outline();
        x_cut_out();
        y_cut_out();
    }
}

//2_aaa_assembly();