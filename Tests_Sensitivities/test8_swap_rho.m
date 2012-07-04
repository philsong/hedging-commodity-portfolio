%    Fichier test8_swap_rho.m
%   Script de tests des valeurs d'erreur pour le swap en fonction des
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
alpha = 0.34;
sigma = 0.31;

Nb_Swap = 3; % M le nbre d'échanges différents (échange de flux)
Months = 3;
T_maturity = Months/12;
time_ = 1/24 ; % Instant t où on procède l'évaluation

t_k = zeros(Nb_Swap,1); % Date d'échange des flux
for i = 1 :  Nb_Swap
    t_k(i) = T_maturity*i;
end

K = F_0_T / Nb_Swap; % K = 100; % Fixed price to pay
v_k = ones(Nb_Swap,1)*50; %round(rand(1,Nb_Swap)*4 + 1); % Volume (amount) of commodity per swap
F_0_tk = ones(Nb_Swap,1)*100; %round(rand(1,Nb_Swap)*3 + 100); % Valeur des contrats en 0
Tx_t_T = 0.03; %Tx_t_T = [0.03 0.03 0.03]; %Taux d'intérêt continu : r_t_T de t à T -- 3%
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
    
    Order_L = calc_Order_l2(alpha, sigma, time_, T_maturity, F_0_T, 'Spot', rho, e_dot, e_2dot);
    
    eps = -4;
    for i=0:1:16

        %Swap exact variation
        var = calc_SWAP_Exact_Variation2(alpha, sigma, time_, eps, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap);

        %Swap sensitivity variation
        approx_var = calc_SWAP_with_sensitivity2(alpha, sigma, time_, eps, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap, Order_L);

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

        Order_L = calc_Order_l2(alpha, sigma, time_, T_maturity, F_0_T, 'Spot', rho, e_dot, e_2dot);
    
        %Swap exact variation
        var = calc_SWAP_Exact_Variation2(alpha, sigma, time_, eps, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap);

        %Swap sensitivity variation
        approx_var = calc_SWAP_with_sensitivity2(alpha, sigma, time_, eps, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap, Order_L);

        error = approx_var - var;
        
        Error(1,i)=abs(error);
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
title('Variation of the error with the value of rho for the swap');
legend('show')


