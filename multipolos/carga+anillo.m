%%

clear variables
close all

clc

aa

z = linspace(1, 50, 10000);

R = 10;

Vexacto = 1 ./ z - 1 ./ sqrt(R^2 + z.^2);
Vaprox  = R^2 / 2 ./ z.^ 3;

figure
    hold all
    plot(z, Vexacto)
    plot(z, Vaprox)
    set(gca, 'YScale', 'log')
    xlabel('z')
    ylabel('V')
    legend('Vexacto', 'Vcuadru')
    xlim([0, 50])
    
error_porcentual = 100*(Vaprox - Vexacto) ./ Vexacto;
    
figure
    plot(z, error_porcentual)
    set(gca, 'YScale', 'log')
    xlabel('z')
    ylabel('Error %')
    