# Illustrates the Betrand paradox with a triangle in circle.
# See, for example, the Wikipedia article:
# https://en.wikipedia.org/wiki/Bertrand_paradox_(probability)
# Author: H. Paul Keeler, 2019.

import numpy as np;  # NumPy package for arrays, random number generation, etc
import matplotlib.pyplot as plt  # for plotting
from matplotlib import collections  as mc  # for plotting line segments

plt.close('all');  # close all figures

r = 1;  # circle radius
x0 = 0;
y0 = 0;  # centre of circle

# points for circle
t = np.linspace(0, 2 * np.pi, 200);
xp = r * np.cos(t);
yp = r * np.sin(t);

# angles of triangle corners
thetaTri1 = 2 * np.pi * np.random.rand(1);
thetaTri2 = thetaTri1 + 2 * np.pi / 3;
thetaTri3 = thetaTri1 - 2 * np.pi / 3;
# points for equalateral triangle
xTri1 = x0 + r * np.cos(thetaTri1);
yTri1 = x0 + r * np.sin(thetaTri1);
xTri2 = x0 + r * np.cos(thetaTri2);
yTri2 = x0 + r * np.sin(thetaTri2);
xTri3 = x0 + r * np.cos(thetaTri3);
yTri3 = x0 + r * np.sin(thetaTri3);

# angles of chords
thetaChord1 = 2 * np.pi * np.random.rand(1);
thetaChord2 = 2 * np.pi * np.random.rand(1);
# points chord
xChord1 = x0 + r * np.cos(thetaChord1);
yChord1 = x0 + r * np.sin(thetaChord1);
xChord2 = x0 + r * np.cos(thetaChord2);
yChord2 = x0 + r * np.sin(thetaChord2);

# Plotting
# draw circle
plt.plot(x0 + xp, y0 + yp, 'k', linewidth=2);
plt.axis('equal');
plt.autoscale(enable=True, axis='x', tight=True)
plt.axis('off');

# draw triangle
plt.plot([xTri1, xTri2], [yTri1, yTri2], 'k', linewidth=2);
plt.plot([xTri2, xTri3], [yTri2, yTri3], 'k', linewidth=2);
plt.plot([xTri3, xTri1], [yTri3, yTri1], 'k', linewidth=2);

# draw chord
plt.plot([xChord1, xChord2], [yChord1, yChord2], 'r', linewidth=2);
