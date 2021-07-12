/* Edge connector retainer for micro:bit expansion boards.
e.g. https://www.sparkfun.com/products/13988
 To stop the micro:bit from pulling out easily from the board.
 Designed to be used inside of cases, which keep the expansion board press fit against the connector and micro:bit.
 The 4mm holes on the micro:bit are half-exposed in the connector.
 The retainer plugs into these.
 Dimensions: mm
matthew oppenheim july 2021
*/
// make spheres and cylinders render smooth
$fn=100;
delta=0.2;
mbit_hole_dia = 4.0;
mbit_hole_exposure = 2.0;
//mbit_hole_spacing_x = 22.5+delta;
mbit_hole_spacing_x = 43.2+delta;
// effective hole diameter is a bit smaller for clearance
eff_hole_dia = mbit_hole_dia-delta;
connector_z_front = 3.5;
connector_z_rear = 2.0;
connector_y = 13.8;
wall = 2.0;
pcb_thickness = 1.4;
// depth below top plate that the plugs extend
total_plug_z = pcb_thickness+connector_z_front+wall+5*delta;
ret_total_x = mbit_hole_spacing_x+eff_hole_dia+2*delta;
top_plate_x = mbit_hole_spacing_x+eff_hole_dia+2*delta;
top_plate_y = connector_y + 2*delta;

module mbit_hole_plug(){
    // plug to fit into micro:bit 4mm hole
    r = mbit_hole_dia/2-delta;
    height = pcb_thickness;
    cylinder(r1=r, r2=r, h=height);
}

module mbit_hole_plug_support(){
    // support to join plug to top plate
    r = mbit_hole_dia/2;
    height = total_plug_z;
    rotate([0, 0, 90])
    translate([delta, 0 , wall])
    difference(){
        cylinder(r1=r, r2=r, h=height);
        translate([-3*delta,-r,-delta])
        cube([2*r, 2*r, height+2*delta]);
    }
}

module mbit_hole_plug_assembly(){
    // plug added to the end of the support
    mbit_hole_plug_support();
    translate([0, delta, 1.5*pcb_thickness-delta])
    mbit_hole_plug();
}

module plugs(){
    // plugs that go into exposed micro:bit hole semi-circles
    //translate([mbit_hole_dia/2, eff_hole_dia/2, -total_plug_z]){
    translate([mbit_hole_dia/2, 2*delta, -total_plug_z]){
    mbit_hole_plug_assembly();
    translate([mbit_hole_spacing_x, 0, 0])
    mbit_hole_plug_assembly();
    }
}


module top_cut_out(){
    // cut out front edge of top plate
    color([0, 1, 1])
    translate([eff_hole_dia+2*delta, -2.5*delta, -delta])
    cube([top_plate_x-2*eff_hole_dia-4*delta, 2*top_plate_y/3, wall+2*delta]);
}

module top_plate(){
    // The top plate goes across the top of the edge connector.
    difference(){
        cube([top_plate_x, top_plate_y, wall]);
        top_cut_out();
    }
}

module rear_plate(){
    // The rear plate clips over the rear of the edge connector.
    translate([0, top_plate_y, -connector_z_rear])
    cube([ret_total_x, wall, wall+connector_z_rear]);
}

module assembly(){
    color([0, 1, 0, 0.2]){
    union()
        plugs();
        top_plate();
    }
}

assembly();
rear_plate();
