# -*- coding: utf-8 -*-
"""
Created on Fri Feb 25 14:44:48 2022

@author: Pablo E. Etchemendy
"""

import numpy as np
import matplotlib.pyplot as plt


# ¿Cómo funciona el desarrollo de Taylor del potencial para grandes
# distancias, aka, desarrollo multipolar? En este caso, el desarrollo es más
# exacto cuando r tiende a infinito (ya que el desarrollo esta hecho alrededor
# de x = 1/r = 0). El potencial exacto coincide con el desarrollo monopolar a
# medida que r -> Inf, y si necesitamos el desarrollo para distancias más
# cercanas a la distribucion, es necesario agregar términos de mayor orden,
# tantos como querramos o necesitemos (en primer lugar el dipolar, luego el
# cuadrupolar, octopolar, etc.)

# distribucion 1d, no neutra

# cargas:
q1 = -1;
q2 = 3;
q3 = 1;

# posiciones:
x1 = -1;
x2 = 0;
x3 = 1;

# otro ejemplo
# # cargas:
# q1 = -1;
# q2 = 2;
# q3 = 3;

# # posiciones:
# x1 = .5;
# x2 = -.25;
# x3 = 0;

# distancias a lo largo de un eje (trabajamos en 1d)
eje_r = np.linspace(start=1.1, stop=100, num=10000)


# -- acá empieza la cosa --

# pot. exacto
V = q1 / np.abs(eje_r - x1) + \
    q2 / np.abs(eje_r - x2) + \
    q3 / np.abs(eje_r - x3)

# desarrollo multipolar
q  = q1 + q2 + q3           # carga total
M1 = q / np.abs(eje_r)      # monopolar

P  = q1*x1 + q2*x2 + q3*x3  # momento dipolar
M2 = M1 + P / eje_r**2      # monopolar + dipolar

# armo la figura
fig, ax = plt.subplots(ncols=2)

# potencial
ax[0].plot(eje_r, V,  label='Exacto')
ax[0].plot(eje_r, M1, label='Monopolar')
ax[0].plot(eje_r, M2, label='Dipolar')
ax[0].set_yscale('log')
ax[0].set_xlim(left   = 1, right =10)
ax[0].set_ylim(bottom =.3, top   =20)
ax[0].legend()

ax[0].set_title('Potencial')
ax[0].set_xlabel('r')
ax[0].set_ylabel('V')


# error % (muestra las diferencias con mayor claridad)
ax[1].plot(eje_r, np.abs((M1 - V)/V), label='Monopolar')
ax[1].plot(eje_r, np.abs((M2 - V)/V), label='Mono+dipolar')
ax[1].legend()
ax[1].set_xscale('log')    
ax[1].set_yscale('log')

ax[1].set_title('Error')
ax[1].set_xlabel('E %')
ax[1].set_ylabel('V')


# tamaño de la figura
fig.set_tight_layout(tight=True)
fig.set_size_inches(7,3.3)
fig.set_dpi(300)