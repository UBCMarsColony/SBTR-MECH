# data_aq.py: Receives numerical data through the serial port and
#              graphs it live using matplotlib. Also saves the values
#              into a file "data.csv". Samples values every 0.5 seconds.
#
# Make sure that you:
# - Have python and matplotlib installed on your machine
# - Have only one number, in string format, being sent to the serial port
#    at a time, and that each value ends with a newline (\n) or return (\r)
#    character

import math
import sys
import time
import matplotlib.animation as animation
import matplotlib.pyplot as plt
import numpy as np
import serial

# change the scale of the matplotlib plot
xsize = 50
lower_x = 300
upper_x = 400

# configure the serial port
ser = serial.Serial(
    port='COM3',  # Change as needed
    baudrate=9600, # may need to change baudrate
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_TWO,
    bytesize=serial.EIGHTBITS
)
ser.isOpen()

# open "data.csv" file for writing data into
f = open("data.csv", "w")


# forever loop for data acquisition
def data_gen():
    t = data_gen.t
    while True:
        # get the next line from the serial port
        strin = ser.readline().decode('utf-8')
        # increment the time variable by 0.5
        t += 0.5
        raw_data = float(strin)
        val = (raw_data)
        yield t, val

        # write the data to the file
        if t >= 0:
            f.write(str(val) + "," + str(t) + "\n")


# add the new data and update the plot
def run(data):
    # update the data
    t, y = data
    if t > -0.5:
        xdata.append(t)
        ydata.append(y)
        if t > xsize:  # Scroll to the left.
            ax.set_xlim(t - xsize, t)
        line.set_data(xdata, ydata)

    return line,


# upon closing the plot
def on_close_figure(event):
    f.close()
    sys.exit(0)


# initialize variables for plot
data_gen.t = -1
fig = plt.figure()
fig.canvas.mpl_connect('close_event', on_close_figure)
ax = fig.add_subplot(111)
line, = ax.plot([], [], lw=2)
ax.set_ylim(lower_x, upper_x)
ax.set_xlim(0, xsize)
ax.grid()
xdata, ydata = [], []

# Important: Although blit=True makes graphing faster, we need blit=False to prevent
# spurious lines to appear when resizing the stripchart.
ani = animation.FuncAnimation(fig, run, data_gen, blit=False, interval=100, repeat=False)
plt.show()
