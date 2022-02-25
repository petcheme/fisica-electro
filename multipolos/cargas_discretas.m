%%

% Este script obtiene el desarrollo multipolar al orden dipolar para un arreglo
% arbitrario de cargas. Muestra la solución exacta (fuera de la distribución)
% superpuesta con el desarrollo a primer y segundo orden. También analiza la
% contribución del término de segundo orden (dipolar) para entender de qué
% manera ayuda a mejorar la precisión.

% Fecha versión original: 2020-04-15

% Se puede realizar un gráfico en 2d del potencial. (Aunque hay que emprolijarlo).

function my_main()

    close all

    distrib.r = [ .5,  0 ;
                 -.25, 0 ;
                  0,   0 ];
    
    distrib.q = [ -1, 2, 3 ]';

    x = linspace(1,10,200);
    y = 0; % linspace(1,10,200);
    
    dmcd(distrib, x, y);

    return
end


function dmcd(distrib, x, y)

    % grafica la distribución
    figure
      plot(distrib.r(:,1), distrib.r(:,2), 'o', 'MarkerSize', 10)
      xlim([ min(distrib.r(:,1)), max(distrib.r(:,1)) ] + [ -1 1 ]*.2)
      ylim([ min(distrib.r(:,2)), max(distrib.r(:,2)) ] + [ -1 1 ]*.2)

    % obtiene los momentos monopolar y dipolar      
    M1 = sum(distrib.q);
    M2 = [ sum(distrib.q .* distrib.r(:,1)),  ...
           sum(distrib.q .* distrib.r(:,2)) ];
  
    % reserva espacio para guardar los resultados
    r_modulo = zeros(length(x), length(y));         % distancia al origen
    V  = r_modulo;                                  % potencial exacto
    V1 = r_modulo;                                  % potencial monopolo
    V2 = r_modulo;                                  % potencial dipolo
   
    % recorro cada punto campo
    for i = 1:length(x)
        for j = 1:length(y)
            
            % analizo el punto campo
            r_modulo(i, j) = sqrt(x(i).^2 + y(j).^2);     % distancia al origen
            r_versor = [ x(i), y(j) ] / r_modulo(i,j);    % dirección
    
            % calculo la contribución de cada carga en ese punto para el potencial exacto    
            for k = 1:length(distrib.q)
                dist = sqrt( (x(i) - distrib.r(k,1) ).^2 + (y(j) - distrib.r(k,2)).^2);
                V(i,j) = V(i,j) + distrib.q(k) / dist;
            end
            
            % hago lo mismo para los momentos
            V1(i,j) = M1 / r_modulo(i,j);
            V2(i,j) = M2 * r_versor' / r_modulo(i,j)^2;
            
        end
    end
       
	% sumo ambas contribuciones
    Vtot = V1 + V2
       
	% --- acá vienen los gráficos ---
	
	% gráficos 1d (no convienen si se analiza un dominio 2d)
    figure
      plot_fmt = '.'  # util para acomodar el gráfico según estemos trabajando en 1d o 2d
      
      subplot(1,2,1)
        hold all
        plot(r_modulo(:), V(:),    plot_fmt)
        plot(r_modulo(:), V1(:),   plot_fmt)
        plot(r_modulo(:), V2(:),   plot_fmt)
        plot(r_modulo(:), Vtot(:), plot_fmt)
        legend('V', 'Vmono', 'Vdip', 'Vmono+Vdip')

        xlabel('x')
        ylabel('V')
        xlim([0 11])
        ylim([0 4.1])
            
      subplot(1,2,2)
        hold all
        plot(r_modulo(:), 100*(V1(:)  -V(:)) ./ V(:), plot_fmt)
        plot(r_modulo(:), 100*(Vtot(:)-V(:)) ./ V(:), plot_fmt)
        legend('Emono%', 'Emono+dip%')
        plot([0,10],5*[1,1], 'k--')
        xlim([0 11])
        
	% gráfico 2d (solo si el dominio es 2d)
    if !(isscalar(x) || isscalar(y))
      figure
        subplot(1,3,1)
          imagesc(V)
          colorbar

        subplot(1,3,2)
          imagesc(V1)
          colorbar

        subplot(1,3,3)
          imagesc(V2)
          colorbar
    end
        
    return
end


