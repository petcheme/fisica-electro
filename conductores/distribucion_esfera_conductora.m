%%

% Fecha original: 2018-04

% Este script resuelve, mediante un algoritmo genético, la distribución de carga
% en el borde de una esfera conductora, en presencia de un campo eléctrico
% constante y homogéneo. La distribución de cargas en el conductor debe ser tal
% que el campo eléctrico en su interior se anule. Para hallarla, el script 
% genera variaciones aleatorias sobre una distribución de cargas inicial, y
% luego evalúa cuál distribución se acerca más a cumplir la condición buscada.

% El conductor puede estar cargado o ser neutro. El algoritmo redistribuye la
% carga existente (no se genera nueva carga).

function distribucion_esfera_conductora
    % parametros
    L          = 29;              % que sea impar
    radius     = L/4;
    n_iter     = 5000;
    n_redist   = 10000;

    E_ext      = [ 1, 0 ];        % campo externo
    d_carga    = 1e-3;            % diferencial de carga para cada iteración
    Q_tot      = 10;              % carga total del conductor

    % armo el conductor
    M    = zeros(L);
    mask = M;

    x_coord = (1:L) - (L-1)/2 -1;
    y_coord = x_coord;

    [ X, Y ] = meshgrid(x_coord,y_coord);

    r_inner = radius-1;
    r_outer = radius;
    
      sel  = sqrt(X.^2 + Y.^2) <= r_outer & sqrt(X.^2 + Y.^2) > r_inner;
    M(sel) = 1;

         sel_mask  = sqrt(X.^2 + Y.^2) <= r_inner;
    mask(sel_mask) = 1;
    

    sel_idx = find(sel);
    
    figure
        subplot(1,2,1)
            imagesc(M)
        subplot(1,2,2)
            imagesc(mask)

    % --- aca empieza la papa ---

    n_cargas = sum(sel(:));

    if n_redist > n_cargas
        n_redist = n_cargas;
        warning('if n_redist > n_cargas -> n_redist = n_cargas')
    end

    % aca vamos a ir armando la configuración en cada iteracion
    M_cargas      = M;
    M_cargas(sel) = Q_tot / n_cargas;       % al comienzo la carga total está distribuida uniformemente

    for i = 1:n_iter

        fprintf('Iteracion %d. Calculando: ', i)
        % genero al azar una redistribución de cargas sobre la superficie del
        % conductor
        q_from = randi(n_cargas, [ n_redist, 1 ] );     % sitios que pierden carga
        q_to   = randi(n_cargas, [ n_redist, 1 ] );     % sitios que reciben carga

        % aplico la redistribucion
        M_cargas_new = M_cargas;
        M_cargas_new(sel_idx(q_from)) = M_cargas_new(sel_idx(q_from)) - d_carga;
        M_cargas_new(sel_idx(q_to))   = M_cargas_new(sel_idx(q_to))   + d_carga;

%         figure(100)
%             subplot(1,2,1)
%                 imagesc(M_cargas)
%             subplot(1,2,2)
%                 imagesc(M_cargas_new)
        
        if M_new_is_better(E_ext, M_cargas_new, M_cargas, mask, 'posta')
            M_cargas = M_cargas_new;
        end

    end

    figure
        imagesc(M_cargas)
    
    return
end


function z = M_new_is_better(E_ext, M_new, M_old, mask, control_str)

    switch control_str
        case 'random'
            z = rand > 0.5;

        case 'posta'
            [ E_old_x, E_old_y ] = calcular_E(M_old, mask);
            fprintf(' ')
            [ E_new_x, E_new_y ] = calcular_E(M_new, mask);
            
            % hay que calcular el campo en todos los puntos del interior, y
            % luego obtener el RMS, si se minimiza estamos
            aux = (E_ext(1) - E_new_x).^2 + (E_ext(2) - E_new_y).^2;
            E_rms_new = sqrt(mean(aux(:)));
            aux = (E_ext(1) - E_old_x).^2 + (E_ext(2) - E_old_y).^2;
            E_rms_old = sqrt(mean(aux(:)));
            
            if E_rms_new < E_rms_old
                z = true;
                fprintf(' => Aceptada!')
            else
                z = false;
            end
            
            fprintf('\n')
            
        otherwise
            error()
    end
    
    if z 
      fprintf('%g\n', E_rms_new)
    end

    return
end

function [ Ex, Ey ] = calcular_E (M, mask)

    L  = size(mask, 1);
    Ex = zeros(size(M));
    Ey = zeros(size(M));
    
    [ X, Y ] = meshgrid(1:L, 1:L);

    fprintf('[ ')
    step = 1;

    % seteo el contador de pasos para mostrar progreso en pantalla
    c = 1;
    C = length(find(mask)') * length(find(M)');
    
    % recorro los puntos campo
    for j = find(mask)'
        % recorro los puntos fuente
        for i = find(M)'
          
            % muestra progreso en pantalla
            if c/C > 0.1*step
                step = step+1;
                fprintf('*')
            end
                
            d = ((X(i) - X(j)) ^2 + (Y(i) - Y(j)) ^2)^(3/2);
            Ex(j) = Ex(j) + M(i) / d * (X(i) - X(j));
            Ey(j) = Ey(j) + M(i) / d * (Y(i) - Y(j));
            c = c + 1;
        end
    end

    fprintf( '* ]' )
    return
end
