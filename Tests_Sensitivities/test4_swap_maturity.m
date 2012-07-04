%    Fichier test4_swap_maturity.m
%   Script de tests des valeurs d'erreur pour le swap en fonction des
%   valeurs de la maturité.
%           -----------------

close all
clc

format('shortE')
addpath ('../model_functions');
addpath ('../spot_sens_func');
addpath ('../defined_functions');
addpath ('../future_sens_func');
addpath ('../swap_sens_func');

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
Order_L = 11;

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
    
    for i = 1 :  Nb_Swap
        t_k(i) = T_maturity*i;
    end
    
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
for j=1:5

    T_maturity = 3/12;
    for i=1:1:8
        for k = 1 :  Nb_Swap
            t_k(k) = T_maturity*k;
        end
        %Swap exact variation
        var = calc_SWAP_Exact_Variation2(alpha, sigma, time_, eps, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap);

        %Swap sensitivity variation
        approx_var = calc_SWAP_with_sensitivity2(alpha, sigma, time_, eps, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap, Order_L);

        error = approx_var - var;
        
        Error(1,i) = abs(error);
        T_maturity = T_maturity + 3/12;
    end
    axis([3 24 0 1e-11]);
    str = sprintf('Shock = %d',eps);
    figure(2), plot(Maturity,Error,'DisplayName',str);
    hold all
    eps = eps + 2;
end
ylabel('Error');
xlabel('Maturity');
title('Variation of the error with the maturity for the swaps');
legend('show')
