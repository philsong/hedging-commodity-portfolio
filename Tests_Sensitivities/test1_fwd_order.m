%    Fichier test1_fwd_order.m
%   Script de tests des valeurs d'erreur pour le future en fonction des
%   valeurs de l'ordre de l'approximation.
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

%ORDER
A = zeros(19,7);
Order = 1;
for i=1:7
    A(1,i) = Order;
    Order = Order+2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TABLEAU DES VARIATION DES L'APPROXIMATION POUR LES ORDRES 1, 3, 5, 7,
% 9, 11 et 13
order_l = 1;
for j=0:1:6
      
    eps = -4;
    for i=0:1:16

        approx_var = calc_future_variations2(F_0_T, alpha, sigma,...
                                       time_, T_maturity, eps, order_l);                               
        var = calc_future_t_T(time_, T_maturity, alpha, sigma, eps,F_0_T) - F_0_T;
        error = approx_var - var;
        
        A(3+i,j+1)=abs(error);
        
        eps = eps + 0.5; 
    end   
    order_l = order_l + 2;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AFFICHAGE DU TABLEAU POUR LES DIFFERENTS ORDRE ...
f = figure('Position',[200 200 638 348]);
cnames = {'Error','Error','Error','Error','Error', 'Error', 'Error'};
rnames = {'Order', 'Shock Value', '-4','-3.5','-3','-2.5','-2','-1.5','-1','0.5','0','0.5','1','1.5', '2','2.5', '3','3.5', '4'};
figure(1), t = uitable('Parent',f,'Data',A,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[0 0 640 350]);

        
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DES VARIATIONS DE L'APPROXIMATION POUR DIFFERENTS ORDRES
Order = zeros(1,14);
for i=1:14
    Order(1,i)=i;
end

eps = -4;
for i=1:5
    order_l = 1;
    Error = zeros(1,14);
    for i=1:14
            y = calc_future_variations2(F_0_T, alpha, sigma,...
                                           time_, T_maturity, eps, order_l);                               
            v = calc_future_t_T(time_, T_maturity, alpha, sigma, eps,F_0_T) - F_0_T;
            h = y - v;

            Error(1,order_l)=abs(h);
            order_l = order_l+1;
    end

    axis([1 14 1e-15 1e01]);
    str = sprintf('Shock = %d',eps);
    figure(2), semilogy(Order,Error,'DisplayName',str);
    hold all
    eps = eps + 2;
end
ylabel('Error');
xlabel('Order');
title('Variation of the error with the order for the futures');
legend('show')

