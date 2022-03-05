# %% Import:
import numpy as np
import control
import matplotlib.pyplot as plt

# %% Creating model:
num = np.poly([-3, -5])
den = np.poly([-2,-4,-6])
H = control.tf(num, den)

# %% Defining signals:
t0 = 0
t1 = 20
dt = 0.01
nt = int(t1/dt) + 1 # Number of points of sim time
t = np.linspace(t0, t1, nt)
u = np.ones(nt)

# %% Simulation:
(t, y) = control.forced_response(H, t, u, X0=0)

# %% Plotting:
plt.close('all')
fig_width_cm = 24
fig_height_cm = 18
plt.figure(1, figsize=(fig_width_cm/2.54, fig_height_cm/2.54))

plt.subplot(2, 1, 1)
plt.plot(t, u, 'green')
#plt.xlabel('t [s]')
plt.grid()
plt.legend(labels=('Input signal',))

plt.subplot(2, 1, 2)
plt.plot(t, y, 'blue')
plt.xlabel('t [s]')
plt.grid()
plt.legend(labels=('Output signal',))

plt.show()
