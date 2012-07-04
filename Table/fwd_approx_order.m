%    Fichier fwd_approx_order.m
%           -----------------
%   Ce script affiche dans un fichier texte les valeurs de 
%   l'approximation (13) et des erreurs (18) des prix forward 
%   en fonction de l'ordre choisi.
%   (La maturité T_maturity est à fixé manuellement).
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
T_maturity = 3/12;

% 2: VARIATION DE L'APPROXIMATION (13) SUIVANT L'ORDRE CHOISI
doc1 = fopen('Table/fwd_approx_order.txt','w');

order_l = 1;
for j=0:1:12
    
    fprintf(doc1,'\n\nMaturity : %f\n', T_maturity);
    fprintf(doc1,'Order : %i\n', order_l);
    
    fprintf(doc1,'Epsilon\t\t');
    fprintf(doc1,'Approx variations\t\t');
    fprintf(doc1,'Variations\t\t\t');
    fprintf(doc1,'Error\n');
      
    eps = -4;
    for i=0:1:16

        y = calc_future_variations2(F_0_T, alpha, sigma,...
                                       time_, T_maturity, eps, order_l);  
                                   
        v = calc_future_t_T(time_, T_maturity, alpha, sigma, eps,F_0_T) - F_0_T;
        
        h = y - v;

        fprintf(doc1,'%f\t',eps);
        fprintf(doc1,'%6.15f\t',y);
        fprintf(doc1,'%6.15f\t',v);
        fprintf(doc1,'%e\n',abs(h));
        
        eps = eps + 0.5; 

    end
    
    order_l = order_l + 1;
end
fclose(doc1);  