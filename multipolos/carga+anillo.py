# -*- coding: utf-8 -*-
"""
Created on Mon Feb 21 11:37:41 2022

@author: Pablo E. Etchemendy

Este script estudia el desarrollo multipolar para dos distribuciones de carga:
i) un disco plano de carga homogénea q
ii) un anillo circular homogéneo y una carga puntual concéntrica al mismo, con
cargas iguales y opuestas 

La primera distribución tiene momento monopolar no nulo, por lo que vista
desde lejos se ve como una carga puntual. La segunda distribución es neutra y
su momento dipolar también es nulo, por lo que la aproximación al orden más
bajo requiere el término cuadrupolar.

Por simplicidad, se estudia el potencial a lo largo del eje de simetría del
sistema (llamado z). Para cada caso, se muestra la comparación de la solución
exacta con la solución al orden más bajo, en función de la distancia z. También
se muestra el error relativo de dicha aproximación. 

La solución exacta decae como z^-1 (caso i) o z^-3 (caso ii). Este
comportamiento es difícil de apreciar en la solución exacta a lo largo de z.
El desarrollo multipolar nos permite aproximar el campo en todo el espacio y
facilitar su interpretación.
"""

import numpy as np
import matplotlib.pyplot as plt

# parámetros del sistema
R = 10.              # radio del disco
q = 1.               # carga total del disco

# (realmente no es necesario modificarlos)


# defino el vector con los puntos del espacio que voy a estudiar
eje_z = np.linspace(start = 1, stop = 100, num = 10000)

# caso 1: disco de carga
V_exacto1 = 2*q / R**2 * (np.sqrt(eje_z**2 + R**2) - np.abs(eje_z))
V_aprox1  = q / np.abs(eje_z)

# caso 2: carga + anillo
V_exacto2 = q*(1 / np.abs(eje_z) - 1/np.sqrt(R**2 + eje_z**2))
V_aprox2  = 0.5*q*R**2 / np.abs(eje_z)**3

# notar que se usa módulo ya que z representa la distancia al origen, sin 
# importar su signo (así el potencial mantiene su simetría)

V_error1 = (V_aprox1 - V_exacto1) / V_exacto1
V_error2 = (V_aprox2 - V_exacto2) / V_exacto2

# realizo mis figuras
fig, ax = plt.subplots(ncols=3)

# caso 1
ax[0].plot(np.abs(eje_z) / R, V_exacto1, label='Exacto')
ax[0].plot(np.abs(eje_z) / R, V_aprox1,  label='1Polar')
ax[0].set_xscale('log')
ax[0].set_yscale('log')
ax[0].set_xlabel('z / R')
ax[0].set_ylabel('V / k')
ax[0].legend()
ax[0].grid(True)
ax[0].set_title('Disco')

# caso 2
ax[1].plot(np.abs(eje_z) / R, V_exacto2, label='Exacto')
ax[1].plot(np.abs(eje_z) / R, V_aprox2,  label='4Polar')
ax[1].set_xscale('log')
ax[1].set_yscale('log')
ax[1].set_xlabel('z / R')
ax[1].set_ylabel('V / k')
ax[1].legend()
ax[1].grid(True)
ax[1].set_title('Anillo + carga')

# error % para ambos casos
ax[2].plot(np.abs(eje_z) / R, V_error1*100, label='Disco')
ax[2].plot(np.abs(eje_z) / R, V_error2*100, label='Anillo')
ax[2].plot(np.abs(eje_z) / R, V_error1*0 + 1, color = 'grey')
# ax[2].set_xscale('log')
ax[2].set_yscale('log')
ax[2].set_xlabel('z / R')
ax[2].set_ylabel('Error %')
ax[2].legend()
ax[2].set_title('Error')

# acomodo la figura
fig.set_tight_layout(tight=True)
fig.set_size_inches(9,3)
fig.set_dpi(300)


# fig2, ax2 = plt.subplots()

# ax2.plot(eje_z / R, V_exacto1, label='Disco Exacto')
# ax2.plot(eje_z / R, V_aprox1,  label='1Polar')
# ax2.plot(eje_z / R, V_exacto2, label='Anillo Exacto')
# ax2.plot(eje_z / R, V_aprox2,  label='4Polar')
# ax2.set_xscale('log')
# ax2.set_yscale('log')
# ax2.set_xlabel('z / R')
# ax2.set_ylabel('Potencial')
# ax2.legend()


