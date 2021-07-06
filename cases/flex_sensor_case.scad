/* micro:bit flex detect case
for micro:bit flex sensor board
dimensions: mm
dependencies: roundedcube at:
https://gist.github.com/groovenectar/92174cb1c98c1089347e
Matthew Oppenheim 2021 */
include <roundedcube_simple.scad>;
include <2_aaa_battery_pack_stand.scad>;

// make spheres and cylinders render smooth
$fn=100;
// dimensions of internal volume where the board sits
width_board = 60.5;
width_clearance = 1.5;
height_base_pcb_top_of_connector = 10.5;

width_internal = width_board + 2* width_clearance;
depth_internal = 36.0;
// wall thickness - multiple of 0.8mm
wall = 3.2;

// PCB thickness
pcb_thickness = 1.4;

// base clearance for soldering
base_clearance = 2.0;
x_offset = wall+width_clearance;
z_offset = wall+base_clearance+pcb_thickness;
height_internal = height_base_pcb_top_of_connector + base_clearance;

// flex sensor plug position
plug_x_offset = 24.0;
plug_x = 6.0;
plug_z = 8.0;

// variable resistor position
knob_x_offset = 41.0; 
knob_z = 14.0;
knob_x = 9.2;
knob_y = 7.0;

// retaining tabs
tab_width = 5.0;
tab_height = 1.25;
// fraction of total width from each end (need to avoid components on PCB)
tab_fraction_from_end = 0.15;

total_z = height_internal + 2*wall;
total_y = depth_internal + 2*wall;
total_width = width_board + 2*wall + 2*width_clearance;
// delta to allow clearance
delta = 0.2;

// side slots to allow the case to flex to get the board in
slot_height = 2;
// hole in side to allow case to open
strain_relief_rad = 4;
slot_depth = total_y*0.85;

text_height = 4.5;
line_spacing = 1;

module outer_envelope()
// roundedcube that envelopes all design
{
    color([0.5, 0.5, 0, 0.2])
    roundedcube_simple([total_width, total_y, total_z], false, 5);
}

module inner_hollow()
// volume that electronics occupies
{   
    // use delta to punch through front and rear faces
    translate([wall, wall, wall])
    cube([width_internal, depth_internal, height_internal]);
}

module back_panel_opening()
// back panel opening, to allow board to be inserted
{
    translate([wall, total_y-wall-delta, wall])
    cube([width_internal, wall+2*delta, height_internal]);
}

module outer_shell()
// outer envelope - inner hollow
{
    difference() {
        outer_envelope();
        inner_hollow();
        side_slots();
        strain_reliefs();
        sensor_plug_socket();
        variable_resistor_socket();
        variable_resistor_recess();
        back_panel_opening();
        engraving_mo();
        engraving_flex();
        engraving_top(top_text="sensor: top");
        engraving_base(base_text="sensor: base");
        engraving_battery_pack();
    }
}

module sensor_plug_socket() {
    // opening for sensor plug, prongs on bottom extend to base of pcb, so not translated above this
    translate([plug_x_offset+x_offset-4*delta, -delta, z_offset-pcb_thickness-4*delta]) {
        color([0 , 0, 1]) cube([plug_x+8*delta, wall+8*delta, plug_z+8*delta]);
    }
}

module variable_resistor_socket(){
        // variable resistor
    translate([knob_x_offset+x_offset-4*delta, -delta, wall+base_clearance+pcb_thickness-4*delta]) {
        color([0 , 0, 1]) cube([knob_x+8*delta, 4*delta+knob_y+wall, knob_z+4*delta]);
    }
}

module variable_resistor_recess(){
    // recessed hole to access variable resistor
    translate([knob_x_offset+x_offset+knob_x/2, wall+delta, wall+base_clearance+pcb_thickness-4*delta+knob_z/2])
    rotate([90,0,0])
    cylinder(h=wall+delta, r1=0.7*knob_x, r2=1.3*knob_x);
}

module top_tab(){
    // retaining tab for top of rear plate
    cube([tab_width, wall, tab_height]);
}

module base_tab(){
    // retaining tab for base of rear plate
    cube([tab_width, wall, tab_height+base_clearance+pcb_thickness]);
}

module back_panel_top_tabs(){
    // tabs along top of back panel
    translate([total_width*tab_fraction_from_end-tab_width/2, depth_internal+wall, total_z-tab_height-wall]) 
    top_tab();
    translate([total_width*(1-tab_fraction_from_end)-tab_width/2, depth_internal+wall, total_z-tab_height-wall]) 
    top_tab();
}

module side_slot(){
    // side slot to allow case to flex
    cube([wall+2*delta, slot_depth, slot_height]);
}

module side_slots(){
    // side slots to allow flexing to get case on
    translate([-delta, total_y-slot_depth+wall, total_z/2-slot_height/2]) side_slot(); 
    translate([-delta+total_width-wall, total_y-slot_depth+wall, total_z/2-slot_height/2]) side_slot(); 
}

module strain_relief(){
    // hole at end of side slots
    rotate([0, 90, 0])
    cylinder(h=wall+2*delta,r=strain_relief_rad);
}

module strain_reliefs(){
    // holes at end of side slots
    translate([-delta, total_y-slot_depth+wall, total_z/2]) strain_relief();
    translate([total_width-wall-delta, total_y-slot_depth+wall, total_z/2]) strain_relief();
}

module engraving_mo(){
    // Text to go on case base.
    //translate([wall, total_y/3, total_z-wall/3+delta])
    translate([wall+text_height, total_y/2, -delta])
    linear_extrude(wall/3) 
    mirror([0,1,0])
    text("mattoppenheim.com\/", size=text_height);    
}

module engraving_flex(){
    // Text to go on case base.
    //translate([wall, total_y/3-text_height-line_spacing, total_z-wall/3+delta])
    translate([wall+text_height, total_y/2+text_height+line_spacing, -delta])
    mirror([0,1,0])
    linear_extrude(wall/3) 
    text("flex", size=text_height);
}

module engraving_top(top_text){
    // Text to go on case top. 
    translate([wall+text_height, text_height+2*line_spacing, total_z-wall/3+delta])
    linear_extrude(wall/3) 
    text(top_text, size=text_height);
}

module engraving_base(base_text){
    // Text to go on case base. 
    translate([wall+text_height, text_height+5*line_spacing, -delta])
    linear_extrude(wall/3) 
    mirror([0,1,0])
    text(base_text, size=text_height);
}

module engraving_battery_pack(){
    // Text to go on case top - battery pack. 
    translate([wall+text_height, total_y-2*text_height-line_spacing, total_z-wall/3+delta])
    linear_extrude(wall/3) 
    text("battery pack holder", size=text_height);
}

// x offset for the battery pack
battery_pack_x = (total_width-pack_total_x)/2;

module battery_pack(){
    // Support for 2xaaa battery pack.
    translate([battery_pack_x, total_y-pack_y-wall-support_depth, total_z-support_depth])
    2_aaa_assembly();
}


module assembly()
// finished product
{
union(){
        outer_shell();
        back_panel_top_tabs();
        battery_pack();
//        back_panel_base_tabs();
    }
}

assembly();

