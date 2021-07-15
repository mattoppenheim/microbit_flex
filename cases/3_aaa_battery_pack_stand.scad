/* placement for 2xAAA battery pack, as used with micro:bit
Matthew Oppenheim 2021
dimensions: mm
*/

include <2_aaa_battery_pack_stand.scad>;
pack_y = 37.0; 

module 3_aaa_assembly(){
    2_aaa_assembly();
}

//3_aaa_assembly();