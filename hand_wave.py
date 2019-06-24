''' Locate microbit and connect. Flash blink1m when gesture is detected. 
Dependencies: blink1 command line tool. '''

import os
import serial
import serial.tools.list_ports as list_ports
import subprocess
import time

BLINK1_PATH = '/mnt/data/downloads/blink/blink1-tool'
COLOUR_ON = '0xff,0xff,0x00'
PID_MICROBIT = 516
VID_MICROBIT = 3368
TIMEOUT = 0.1
TRIGGER = 'wave'

def find_comport(pid, vid, baud):
    ''' return a serial port '''
    ser_port = serial.Serial(timeout = TIMEOUT)
    ser_port.baudrate = baud
    ports = list(list_ports.comports())
    print('scanning ports')
    for p in ports:
        print('pid: {} vid: {}'.format(p.pid, p.vid))
        if (p.pid == pid) and (p.vid == vid):
            print('found target device pid: {} vid: {} port: {}'.format(p.pid, p.vid, p.device))
            ser_port.port = str(p.device)
            return ser_port
    return None


def flash(command=BLINK1_PATH, on=COLOUR_ON, duration=500, repeat=1):
    ''' Flash the blink1. '''
    print('flashing')
    command_path = os.path.abspath(command)
    arglist = [command_path,'--rgb', COLOUR_ON, '--blink', str(repeat)]
    subprocess.Popen(args=arglist, shell=False)         
    

def detect_gesture(line):
    print('{} microbit: {}'.format(time.strftime("%H:%M:%S"), line))
    if(line.strip() == TRIGGER):
        print('wave detected')
        return True
    return False
        
                       
def main():
    print('looking for microbit')
    ser_micro = find_comport(PID_MICROBIT, VID_MICROBIT, 115200)
    if not ser_micro:
        print('microbit not found\nplug it in and run this script again')
        return       
    print('opening and monitoring microbit port')
    ser_micro.open()
    while True:
        line = ser_micro.readline().decode('utf-8')
        if line:  # If it isn't a blank line
            if(detect_gesture(line)):
                flash(repeat=1, duration=500)
        time.sleep(0.01)
    ser_micro.close()
                       

if __name__ == '__main__':
    main()
    print('exiting')

    
