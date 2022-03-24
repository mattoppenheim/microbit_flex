''' Flex message receiver - activate switch.
Interacts with a micro:bit attached to a flex sensor. 
Receives a 'flex' message from the micro:bit connected to the flex sensor:
Connects the two poles of a 3.5mm jack plug to activate a switch.
Matthew Oppenheim
v1.0 June 2021 '''


from microbit import Image, button_a, button_b, display, pin0, pin16, sleep
import radio

radio.config(address=0x101000, group=45, channel=2, data_rate=radio.RATE_1MBIT)
print("flex receive started")
display.show(Image.DIAMOND)
radio.on()


def decrease_sensitivity():
    ''' Send message to decrease sensitivity. '''
    display.show("-")
    radio.send("decrease")
    pause()


def flex_detected():
    ''' Close and open the switch and change display. '''
    print("flex")
    switch_close()
    display.show(Image.CHESSBOARD)
    pause()
    switch_open()


def increase_sensitivity():
    ''' Send message to increase sensitivity. '''
    display.show("+")
    radio.send("increase")
    pause()
    
    
def pause():
    ''' Pause and clear display. '''
    sleep(100)
    display.show(Image.DIAMOND)


def switch_close():
    ''' Set both switch pins to ground. '''
    pin0.write_digital(0)
    pin16.write_digital(0)


def switch_open():
    ''' Set one switch pin to high and one low. '''
    pin0.write_digital(0)
    pin16.write_digital(1)


def main():
    # set switch open
    switch_open()
    while True:
        if button_b.was_pressed() and not(button_a.was_pressed()):
            increase_sensitivity()
        if button_a.was_pressed() and not(button_b.was_pressed()):
            decrease_sensitivity()
        if button_a.is_pressed() and (button_b.is_pressed()):
            flex_detected()
            sleep(250);
        incoming = radio.receive()
        sleep(10)
        if (incoming == "flex"):
            flex_detected()


main()
