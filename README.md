# Using a flex sensor as assistive technology

Setup instructions are at: [https://hardwaremonkey.github.io/microbit_flex/](https://hardwaremonkey.github.io/microbit_flex/)

Project details are at: [mattoppenheim.com/flex](mattoppenheim.com/flex)

A flex sensor is used to detect a small side ways hand or other joint movement. This detection is used to control switchable software. The device is for people who rely on communication software, but cannot use regular controls such as buttons or joysticks.

The system is split into two parts:

## Flex sensor board

The flex sensor is connected to the flex sensor board. The threshold can be adjusted using the two button on the micro:bit.

The amount that the flex sensor has to be bent to trigger a detection is adjusted using the A and B buttons on the microbit board. The faint LEDs indicate the trigger level. The bright LEDs indicate the amount of flex detected. When the number of bright LEDs exceeds the number of faint LEDs, a trigger work is sent from the microbit to the device it is connected to.

The A and B buttons on the switch board also adjust the threshold on the sensor board.

Different lengths of flex sensor have different resistances, so shift the 'zero point' shown on the LEDs. This can be compensated for using the blue potentiometer knob on the sensor board.

When the flex sensor is bent beyond the threshold, a trigger signal is sent to the switch board by radio.

## Flex switch board

The switch board connects to a 3.5mm two pole audio socket switch adapter, such as the JoyCable. This board receives a trigger signal from the sensor board by radio. The board then activates the switch adapter.

## micropython files

micro:bit micropython files are in the microbit_micropython directory. Install the relevant file onto each micro:bit.

## flex_detect v1

This directory contains code from the first prototype made and tested. Stored here for archive purposes.

There are two .hex files depending on the use scenario.

<b>flex_blinkm.hex</b> works with <b>flash_blinkm.py</b> to make a blinkm LED flash when the device is triggered. The .py file goes on the communication device. A blink(1) (<https://blink1.thingm.com/)> programmable LED is connected to the communication device. When a trigger is sent from the micro:bit board connected to a USB port on the communication device, the blink(1) flashes.

<b>flex_switch.hex</b> works with the home-made switch adapter cable connected to the communications device. Switch software needs to be running on the communication device to enable the trigger signals to control communication software.
