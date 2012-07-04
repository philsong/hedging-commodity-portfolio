%    Fichier test7_spot_rho.m
%   Script de tests des valeurs d'erreur pour le future en fonction des
%   valeurs de la variables rho.
%           -----------------


close all
clc

format('shortE')
addpath ('../model_functions');
addpath ('../spot_sens_func');
addpath ('../defined_functions');
addpath ('../future_sens_func');

F_0_T = 100;
S_0 = 100;
alpha = 0.34;
sigma = 0.31;
dt = 7/360;
time_ = 1/24;
T_maturity = 3/12;
e_dot = 4; 
e_2dot = 4;

%ORDER
A = zeros(19,7);
rho = 1;
for i=1:7
    A(1,i)= rho;
    rho = rho/100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TABLEAU DES VARIATION DES L'APPROXIMATION POUR LES RHO
rho = 1;
for j=0:1:6
    
    order_l = calc_Order_l2(alpha, sigma, time_, T_maturity, F_0_T, 'Spot', rho, e_dot, e_2dot);
    
    eps = -4;
    for i=0:1:16

        approx_var = calc_spot_change2(F_0_T, alpha, sigma, time_, S_0, eps, order_l);                                  
        var = calc_spot_t(time_, alpha, sigma, eps,F_0_T) - S_0;        
        error = approx_var - var;
        
        A(3+i,j+1)=abs(error);
        
        eps = eps + 0.5; 

    end
    
    rho = rho/100;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AFFICHAGE DU TABLEAU POUR LES DIFFERENTS RHO ...
f = figure('Position',[200 200 640 348]);
cnames = {'Error','Error','Error','Error','Error', 'Error', 'Error'};
rnames = {'Rho', 'Shock Value', '-4','-3.5','-3','-2.5','-2','-1.5','-1','0.5','0','0.5','1','1.5', '2','2.5', '3','3.5', '4'};
figure(1), t = uitable('Parent',f,'Data',A,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[0 0 640 350]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DES VARIATIONS DE L'APPROXIMATION POUR DIFFERENTS RHO
Rho = zeros(1,14);
rho = 1;
for i=1:14
    Rho(1,i)= rho;
    rho = rho/10;
end

Error = zeros(1,14);
eps = -4;
for j=1:5
    
    rho = 1;
    for i=1:14

        order_l = calc_Order_l2(alpha, sigma, time_, T_maturity, F_0_T, 'Spot', rho, e_dot, e_2dot);
    
        y = calc_spot_change2(F_0_T, alpha, sigma, time_, S_0, eps, order_l);                                  
        v = calc_spot_t(time_, alpha, sigma, eps,F_0_T) - S_0;        
        h = y - v;
        
        Error(1,i)=abs(h);
        rho = rho/10;

    end
    axis([-1e00 -1e-12 1e-15 1e01]);
    str = sprintf('Shock = %d',eps);
    figure(2), loglog(-Rho,Error,'DisplayName',str);
    hold all
    eps = eps + 2;
end
ylabel('Error');
xlabel('Rho');
title('Variation of the error with the value of rho for the spot');
legend('show')


