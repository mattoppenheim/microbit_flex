# Flex setup instructions

## System overview

The flex system consists of two parts - the sensor module and the switch connector module.
The participant uses the flex sensor which is attached to the sensor module.
When the bend sensor is flexed beyond an adjustable threshold, a radio signal is sent to the switch module.
The switch module connects to a switch adapter cable.
This receives the radio signal from the sensor board and activates the switch adapter cable.
The switch adapter cable sends a switch signal to the attached communication device.
Both of these are made from a BBC micro:bit board slotted into a small expansion board.
The micro:bit has a yellow 'kittenbot' cover while the expansion board is housed in a 3d printed case.
The micro:bit can be easily pulled out of the expansion board. Just plug it back in if this happens.

### Flex sensor module

The flex sensor plugs into the flex sensor module board using a keyed connector.
The amount that the flex sensor needs to be bent to send a switch trigger to the switch board is shown on the micro:bit as faint LEDs. The amount that the flex sensor is bent is shown as bright LEDs. Once there are more bright LEDs than faint LEDs, a bend event is registered by the micro:bit in the flex sensor module.
A radio signal is then sent from this micro:bit to the micro:bit that is part of the switch module. 

### Switch module

The switch module connects with the switch adapter cable using the audio plug. When a trigger signal is received from the sensor module, the switch module acts to send a switch signal through the switch adapter cable to the attached communication device. A JoyAdpater cable was used for testing.

## Safety

The BBC micro:bit was designed to be safe to use in education with 11-12 year-olds, so has safety designed in.

Normal safety practice should be followed with the AAA batteries if they are used – keep them dry.

It is best practice to use the AAA battery pack with the flex sensor board instead of the USB connection.

## Operating instructions

### Summary

Place the flex sensor on the participant.
Set the amount of bend needed to create a trigger signal.
Connect the switch board to a switch adapter cable connected to the communication device.

### Flex sensor board

The board is powered using either a 2xAAA battery pack or from the USB socket. Both of these connectors are on the micro:bit board. Both power sources can be plugged at the same time.

### Switch board

This board is powered using either a 3xAAA battery pack or from the USB socket. I tend to use the USB socket as the board is next to the communication device which usually has a spare USB socket available to power it from.

# Troubleshooting

Check that the micro:bit is plugged in to the expansion board the correct way up. The battery packs sit on the top of the expansion board case. The LEDs and buttons on the micro:bit should point up.

If you are using an untested triple AAA battery pack with the switch board, check that the polarity of the connector is correct.
Take off the kittenbot cover from the micro:bit and look at the battery pack connector socket on the micro:bit.
The polarity signs are printed on the circuit board. Some off the shelf battery packs have the polarity the wrong way around.
This will not damage the board - it will not work though! I use a small screwdriver blade to pull up the plastic latch on the back of the connector above each crimped pin, pull out each crimped pin, then swap over which hole each one goes to in the connector.
