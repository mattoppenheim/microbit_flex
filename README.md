## Using a flex sensor as assistive technology

A flex sensor is used to detect a small side ways hand movement. The flex sensor is connected to a BBC micro:bit. The microbit is connected to the communication device either directly through a USB port or using a home-made switch adapter cable. Build instructions for the home-made switch adapter cable are here:

<https://www.seismicmatt.com/2019/06/24/using-the-microbit-to-control-switch-access-software/>

The amount that the flex sensor has to be bent to trigger a detection is adjusted using the A and B buttons on the microbit board. The faint LEDs indicate the trigger level. The bright LEDs indicate the amount of flex detected. When the number of bright LEDs exceeds the number of faint LEDs, a trigger work is sent from the microbit to the device it is connected to.

The .hex files contains the hex files to write to the microbit board. The contents of the .hex files can be viewed and edited online using the micro:bit block editor at:

<https://makecode.microbit.org/#editor>

There are two .hex files depending on the use scenario.

<b>flex_blinkm.hex</b> works with <b>flex_detect.py</b> to make a blinkm LED flash when the device is triggered. The .py file goes on the communication device. A blink(1) (<https://blink1.thingm.com/)> programmable LED is connected to the communication device. When a trigger is sent from the micro:bit board connected to a USB port on the communication device, the blink(1) flashes.

<b>flex_switch.hex</b> works with the home-made switch adapter cable connected to the communications device. Switch software needs to be running on the communication device to enable the trigger signals to control communication software.
