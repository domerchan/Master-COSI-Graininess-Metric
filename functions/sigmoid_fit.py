# -*- coding: utf-8 -*-
"""
Fit of Sigmoid function to results from psychophysical experiments.

Created on Thu Jun 27 13:32:04 2024

@author: Doménica Alejandra Merchán García
"""

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.optimize import curve_fit

def func(x,a,b):
    return 1-(1/(1+np.exp(-a*(x-b))))

x = [0,0.331709704,0.434725747,0.522208436,0.571628899,0.64855796,0.74402591,0.795560639,0.845924148,0.980563677,1.015749475,1.056083705,1.116426914,1.194090057,1.250686031,1.612254933]
y = [1,0.9386652604,0.8656678642,0.7846354322,0.7092818524,0.6472969652,0.532828878,0.5135576553,0.4870427848,0.3859383714,0.3561897912,0.3109327366,0.2321011268,0.2495092546,0.1751242508,0.06807921484]

plt.plot(x,y, 'bo', label='data')

popt, pcov = curve_fit(func, x, y)
print(popt)
plt.plot(x, func(x, *popt), 'r-', label='fit: a=%5.2f, b=%5.2f' % tuple(popt))
plt.xlabel('x')
plt.ylabel('y')
plt.legend()
plt.show()