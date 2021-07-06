/* micro:bit flex detect case
for micro:bit flex sensor board
dimensions: mm
dependencies: roundedcube at:
https://gist.github.com/groovenectar/92174cb1c98c1089347e
flex_sensor_case.scad
Matthew Oppenheim 2021 */

include <flex_sensor_case.scad>;
include <Chamfer.scad>;
include <3_aaa_battery_pack_stand.scad>;

width_board = 60.7;
height_base_pcb_top_of_connector = 17.7;
connector_x = 23;
connector_width = 14.0;
connector_height = 14.0;
connector_depth = 14.2;

total_y = depth_internal + 2*wall;

// tab to retain board
base_tab_height = 11.0;

chamfer=wall+4*delta;

// base clearance for pin connector
base_clearance = 4.3;

// support for base of board
base_support_height = 5.0;
base_support_width = 15.0;
base_support_depth = 7.0;

// micro:bit connector at rear of PCB
PCB_connector_height = 8.8;

// support for top of board connector
top_support_height = height_internal-PCB_connector_height-base_support_height;
top_support_width = base_support_width;
top_support_depth = base_support_depth;

module chamfer_cube(){
    chamferCube([connector_width+2*chamfer, connector_depth, connector_height+2*chamfer], chamfers=[[1, 1, 1, 1], [0, 0, 0, 0], [1, 1, 1, 1]],ch=4);
}

module connector_opening(){
        // 3.5mm plug connector
    translate([connector_x+x_offset, -delta, wall+base_clearance+pcb_thickness]) 
    cube([connector_width, connector_depth+wall, connector_height]);
}

module connector_chamfer(){
    translate([connector_x+x_offset-chamfer, -connector_depth+chamfer, wall+base_clearance+pcb_thickness-chamfer])
    chamfer_cube();
}

//connector_chamfer();

module outer_shell()
// outer envelope - inner hollow
{
    difference() {
        outer_envelope();
        connector_opening();
        connector_chamfer();
        inner_hollow();
        side_slots();
        strain_reliefs();
        back_panel_opening();
        engraving_mo();
        engraving_flex();
        engraving_top(top_text="switch: top");
        engraving_base(base_text="switch: base");
        engraving_battery_pack();
    }
}

module base_support(){
    // base support for PCB connector
    cube([base_support_width, base_support_depth, base_support_height]);
}
module base_supports(){
    // supports for base of PCB connector
    translate([x_offset, total_y-base_support_depth-delta, wall ])
    base_support();
    translate([total_width-x_offset-base_support_width, total_y-base_support_depth-delta, wall ])
    base_support();
}

module top_support(){
    // top support for PCB connector
    cube([top_support_width, top_support_depth, top_support_height]);
}

module top_supports(){
    //supports for top of PCB connector
    translate([x_offset, total_y-top_support_depth-delta, total_z-wall-top_support_height])
    top_support();
    translate([total_width-x_offset-top_support_width, total_y-top_support_depth-delta, total_z-wall-top_support_height])
    top_support();
}

module top_tabs(){
    // retaining tab at top of back of case
    translate([total_width*tab_fraction_from_end-tab_width/2, depth_internal+wall-delta, total_z-tab_height-wall-top_support_height]) 
    top_tab();
    translate([total_width*(1-tab_fraction_from_end)-tab_width/2, depth_internal+wall-delta, total_z-tab_height-wall-top_support_height])
    top_tab();
}

module battery_pack(){
    // Support for 2xaaa battery pack.
    translate([battery_pack_x, total_y-pack_y-wall-support_depth, total_z-support_depth])
    3_aaa_assembly();
}

module assembly()
// finished product
{
union(){
        outer_shell();
        base_supports();
        top_supports();
        top_tabs();
        battery_pack();
    }
}
assembly();

