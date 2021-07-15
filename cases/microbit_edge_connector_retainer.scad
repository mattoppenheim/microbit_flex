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
// spacing for using outer holes on the micro:bit - holes 1 and 5
//mbit_hole_spacing_x = 43.2+delta;
// spacing for using inner three holes on the micro:bit - holes 2 and 4
mbit_hole_spacing_x = 22.9+delta;
// effective hole diameter is a bit smaller for clearance
eff_hole_dia = mbit_hole_dia-delta;
connector_z_front = 3.6;
connector_z_rear = 2.0;
connector_y = 13.5;
wall = 2.0;
pcb_thickness = 1.4;
// depth below top plate that the plugs extend
total_plug_z = pcb_thickness+connector_z_front+2*delta;
total_support_z = connector_z_front+wall+2*delta;
ret_total_x = mbit_hole_spacing_x+eff_hole_dia+2*delta;
top_plate_x = mbit_hole_spacing_x+eff_hole_dia+2*delta;
// deltas to allow the plastic to flex and clip over connector
top_plate_y = connector_y + 4*delta;

module mbit_hole_plug(){
    // plug to fit into micro:bit 4mm hole
    r = (mbit_hole_dia-delta)/2;
    height = pcb_thickness;
    cylinder(r1=r, r2=r, h=height);
}

module mbit_hole_plug_support(){
    // support to join plug to top plate
    height = total_support_z;
    support_x = mbit_hole_dia;
    support_y = support_x;
    translate([-support_x/2, -support_y , -total_support_z+wall])
    cube([support_x, support_y, height]);
}

module mbit_hole_plug_assembly(){
    // plug added to the end of the support
    mbit_hole_plug_support();
    translate([0, 0, -total_plug_z])
    mbit_hole_plug();
}

module mbit_hole_plug_assemblies(){
    // plugs that go into exposed micro:bit hole semi-circles
    //translate([mbit_hole_dia/2, eff_hole_dia/2, -total_plug_z]){
    translate([mbit_hole_dia/2, 0, 0]){
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
        mbit_hole_plug_assemblies();
        top_plate();
    }
}

assembly();
rear_plate();
