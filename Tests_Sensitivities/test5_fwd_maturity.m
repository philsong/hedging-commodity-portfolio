%    Fichier test3_fwd_maturity.m
%   Script de tests des valeurs d'erreur pour le future en fonction des
%   valeurs de la maturité.
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
order_l = 12;


%MATURITY
A = zeros(19,8);
A(1,1)=3;
A(1,2)=6;
A(1,3)=9;
A(1,4)=12;
A(1,5)=15;
A(1,6)=18;
A(1,7)=21;
A(1,8)=24;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TABLEAU DES VARIATION DES L'APPROXIMATION POUR LES MATURITES 3, 6, 9, 12,
% 15, 18, 21 ET 24 MOIS
T_maturity = 3/12;
for j=0:1:7
      
    eps = -4;
    for i=0:1:16

        approx_var = calc_future_variations2(F_0_T, alpha, sigma,...
                                       time_, T_maturity, eps, order_l);                              
        var = calc_future_t_T(time_, T_maturity, alpha, sigma, eps,F_0_T) - F_0_T;
        error = approx_var - var;
        
        A(3+i,j+1)=abs(error);
        
        eps = eps + 0.5; 

    end
    
    T_maturity = T_maturity + 3/12;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AFFICHAGE DU TABLEAU POUR LES DIFFERENTS ORDRE ...
f = figure('Position',[200 200 715 348]);
cnames = {'Error','Error','Error','Error','Error', 'Error', 'Error'};
rnames = {'Maturity', 'Shock Value', '-4','-3.5','-3','-2.5','-2','-1.5','-1','0.5','0','0.5','1','1.5', '2','2.5', '3','3.5', '4'};
figure(1), t = uitable('Parent',f,'Data',A,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[0 0 715 350]);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PLOT DES VARIATIONS DE L'APPROXIMATION POUR DIFFERENTS MATURITES
Maturity = zeros(1,8);
Maturity(1,1)=3;
Maturity(1,2)=6;
Maturity(1,3)=9;
Maturity(1,4)=12;
Maturity(1,5)=15;
Maturity(1,6)=18;
Maturity(1,7)=21;
Maturity(1,8)=24;

Error = zeros(1,8);
eps = -4;
for j=1:1:5

    T_maturity = 3/12;
    for i=1:1:8

        y = calc_future_variations2(F_0_T, alpha, sigma,...
                                       time_, T_maturity, eps, order_l);                               
        v = calc_future_t_T(time_, T_maturity, alpha, sigma, eps,F_0_T) - F_0_T;
        h = y - v;
        
        Error(1,i)=abs(h);
        T_maturity = T_maturity + 3/12;
    end
    axis([3 24 1e-15 1e-13]);
    str = sprintf('Shock = %d',eps);
    figure(2), plot(Maturity,Error,'DisplayName',str);
    hold all
    eps = eps + 2;
end
ylabel('Error');
xlabel('Maturity');
title('Variation of the error with the maturity for the futures');
legend('show')
