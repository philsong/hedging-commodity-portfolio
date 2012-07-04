%    Fichier fwd_sens__maturity.m
%           -----------------
%   Ce script affiche dans un fichier texte les valeurs des sensibilité 
%   des prix forward en fonction de la maturité.
%   (L'ordre l est à fixé manuellement).
%

close all
clc

% Données initiales
addpath ('model_functions');
addpath ('spot_sens_func');
addpath ('defined_functions');
addpath ('future_sens_func');

F_0_T = 100;
S_0 = 100;
alpha = 0.34;
sigma = 0.31;
dt = 7/360;


    
% Time : t value
time_ = 3/24;
order_l = 12;

% 1: VARIATION DES SENSIBILITE FWD SUIVANT LA MATURITE
doc1 = fopen('Table/fwd_sens_maturite.txt','w');

T_maturity = 1/12;
for j=0:1:5
    
    fprintf(doc1,'\n\nMaturity : %f\n', T_maturity);
    fprintf(doc1,'Order : %i\n', order_l);
    
    fprintf(doc1,'Epsilon\t\t\t\t');
    fprintf(doc1,'Sensibilité\n');
    
    eps = -4;
    for i=0:1:16

        S = 0;
        for n = 1 : order_l
            S = S + ((sens_order_L(F_0_T, n, alpha, sigma, time_,...
                                   T_maturity)*eps^n)/factorial(n));
        end

        fprintf(doc1,'%f\t\t',eps);
        fprintf(doc1,'%6.15f\n',S);
        eps = eps + 0.5; 

    end
    
    T_maturity = T_maturity + 2/12;
end
fclose(doc1);  

