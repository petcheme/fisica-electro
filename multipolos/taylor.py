# -*- coding: utf-8 -*-
"""
Created on Fri Feb 25 14:35:48 2022

@author: Pablo E. Etchemendy
"""

import numpy as np
import matplotlib.pyplot as plt

# ¿CÓmo funciona un desarrollo de Taylor? Construímos una serie alrededor de
# x = 0, y comparamos su exactitud a diferentes órdenes. La exactitud aumenta
# a medida que nos acercamos a x = 0; si, en cambio, nos alejamos de x = 0, y
# queremos mantener el margen de error, es necesario agregar mas terminos,
# tantos como querramos o necesitemos.

# Fecha original: 2020-04

# armo el eje x
eje_x = np.linspace(start = -2*np.pi, stop =2*np.pi, num=10000)

# obtengo la función y los primeros términos de su desarrollo
eje_y = np.sin(eje_x)
p1 = np.cos(0) * eje_x
p3 = p1 - np.cos(0) * eje_x**3 / 3/2
p5 = p3 + np.cos(0) * eje_x**5 / 5/4/3/2

# armo la figura
fig, ax = plt.subplots()

# función
ax.plot(eje_x, eje_y, label='sen(x)')
ax.plot(eje_x, p1, label='p1')
ax.plot(eje_x, p3, label='p3')
ax.plot(eje_x, p5, label='p5')

# nombres
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.legend()
    
# límites
ax.set_ylim(bottom=-1.2, top=1.2)

# acomodo la figura
fig.set_tight_layout(tight=True)
fig.set_size_inches(6,3)
fig.set_dpi(300)



