''' Flex detector.
Reads analog input pin to measure how much a flex sensor is bent.
When the bend is beyond an adjustable limit, a 'flex' message is sent by the radio.
The adjustable limit is shown as faint LEDs on the micro:bit.
Flex needs to be relaxed below the threshold before another 'flex' message can be sent.
As the flex increases, more LEDs are lit brightly.
The threshold is the number of LEDs that need to 'go bright' to activate a flex detection.
Matthew Oppenheim
v1.0 June 2021 '''

from microbit import Image, button_a, button_b, display, pin1, sleep
import radio

# Intensity of the LEDs
BRIGHT = '9'
FAINT = '4'
# How many LEDs to turn on or off per button push
INCREMENT = 1
LEDS = 25
# maximum number of LEDs that can be used as a threshold
MAX_THRESH = 25
# set how bright the threshold LEDs are
THRESH_BRIGHT = '5'
# number of samples to smooth over
SAMPLES = 5
# default number of LEDs to light to trigger a detection
THRESHOLD = 13
# where we store the last number of threshold LEDs to light
THRESH_FILE = 'thresh_val.txt'
radio.config(address=0x101000, group=45, channel=2, data_rate=radio.RATE_1MBIT)
print('flex detector')


def adc_to_leds(adc_value):
    ''' Convert adc reading to number of LEDs to light. '''
    # flex_adc is a value from 0 to 1023, flex_leds is from 0 to 25
    return int((adc_value * 25)/1023)


def decrease_sensitivity(threshold, inc):
    display.show('-')
    threshold = limit(threshold-inc, MAX_THRESH)
    sleep(250)
    return threshold


def flex_detected():
    ''' Handle a flex detection. '''
    print('*** flex detected ***')
    display.show(Image.CHESSBOARD)
    radio.send('flex')
    sleep(200)


def initialise_list():
    list = [0] * SAMPLES
    return list


def increase_sensitivity(threshold, inc):
    display.show('+')
    threshold = limit(threshold+inc, MAX_THRESH)
    sleep(250)
    return threshold


def leds_string2(bright, faint):
    ''' return led string '''
    bright = limit(bright, LEDS)
    faint = limit(faint, LEDS)
    if faint <= bright:
        faint = 0
    leds_string = BRIGHT*bright + FAINT*(faint-bright) + \
        '0' * (LEDS-(bright+faint))
    leds_string = ":".join(leds_string[i:i+5]
                           for i in range(0, len(leds_string), 5))
    leds_image = Image(leds_string + ':')
    return leds_image


def limit(val, limit):
    ''' limit <val> between 0 and <limit>'''
    if val > limit:
        val = limit
    if val < 0:
        val = 0
    return int(val)


def read_file(filename):
    with open(filename, 'r') as my_file:
        read_value = my_file.read()
        return read_value


def smooth(list):
    ''' Return the average of <list>. '''
    average = sum(list)/len(list)
    return average


def write_file(filename, value):
    with open(filename, 'w') as my_file:
        my_file.write(str(value))
        my_file.close()


def main():
    # flag used to prevent multiple 'flex' signals being sent for a single trigger
    flat_signal_needed =  0
    # store flex values in list for smoothing
    flex_list = initialise_list()
    radio.on()
    # read saved threshold value
    try:
        thresh = int(read_file(THRESH_FILE))
        print('threshold from file: {}'.format(thresh))
    except Exception as e:
        print('couldn\'t find threshold file: {} {}'.format(THRESH_FILE, e))
        thresh = THRESHOLD
        write_file(THRESH_FILE, THRESHOLD)
        print('created threshold file with value: {}'.format(THRESHOLD))
    while True:
        incoming = radio.receive()
        flex_adc = pin1.read_analog()
        # append flex_adc to a list which is smoothed
        flex_list.pop(0)
        flex_list.append(flex_adc)
        flex_adc = smooth(flex_list)
        # flex_adc is a value from 0 to 1023, flex_leds is from 0 to 25
        flex_leds = adc_to_leds(flex_adc)
        if flex_leds > thresh and flat_signal_needed == 0:
            flex_detected()
            flat_signal_needed = 1
        if flex_leds <= thresh: 
            flat_signal_needed = 0
        if (button_a.was_pressed() and not(button_b.was_pressed())) or incoming == 'decrease':
            thresh = (decrease_sensitivity(thresh, INCREMENT))
            write_file(THRESH_FILE, thresh)
            print('threshold: {}'.format(thresh))
        if (button_b.was_pressed() and not(button_a.was_pressed())) or incoming == 'increase':
            thresh = (increase_sensitivity(thresh, INCREMENT))
            write_file(THRESH_FILE, thresh)
            print('threshold: {}'.format(thresh))
        if (button_a.is_pressed() and button_b.is_pressed()):
            flex_detected()
            sleep(250)
        display.show(leds_string2(flex_leds, thresh))
        sleep(10)


main()