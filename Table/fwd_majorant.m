%    Fichier fwd_majorant.m
%           -----------------
%   Ce script affiche dans un fichier texte les valeurs du majorant en
%   fonction de l'ordre choisi pour e*=e**=4 et e*=e**=3.
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



% 4: VARIATION DES VALEURS DES MAJORANTS EN FONCTION DE L'ORDRE POUR e* =
% e** = 4
e_dot = 4; 
e_2dot = 4;
max_e_dot = max(e_dot,e_2dot);

c = calc_Function_C(alpha,sigma,e_dot,time_,T_maturity);

doc1 = fopen('Table/fwd_majorant.txt','w');

order_l = 1;
for j=0:1:12
    
    fprintf(doc1,'\n\nMaturity : %f\n', T_maturity);
    fprintf(doc1,'Order : %i\n', order_l);
    
    fprintf(doc1,'Epsilon\t\t\t');
    fprintf(doc1,'Error\t\t');
    fprintf(doc1,'Majorants\n');
      
    eps = -4;
    for i=0:1:16

        y = calc_future_variations2(F_0_T, alpha, sigma,...
                                       time_, T_maturity, eps, order_l);                             
        v = calc_future_t_T(time_, T_maturity, alpha, sigma, eps,F_0_T) - F_0_T;
        h = y - v;
        
        
        k = c*calc_sens_spot(time_, alpha, sigma, F_0_T, order_l+1)*(max_e_dot^(order_l+1)/factorial(order_l+1));
        
        fprintf(doc1,'%f\t',eps);
        fprintf(doc1,'%e\t',abs(h));
        fprintf(doc1,'%e\n',k);

        
        eps = eps + 0.5; 

    end
    
    order_l = order_l + 1;
end

fprintf(doc1,'\n_______________________________________\n');

% 4: VARIATION DES VALEURS DES MAJORANTS EN FONCTION DE L'ORDRE POUR e* =
% e** = 3
e_dot = 3; 
e_2dot = 3;
max_e_dot = max(e_dot,e_2dot);

c = calc_Function_C(alpha,sigma,e_dot,time_,T_maturity);

order_l = 1;
for j=0:1:12
    
    fprintf(doc1,'\n\nMaturity : %f\n', T_maturity);
    fprintf(doc1,'Order : %i\n', order_l);
    
    fprintf(doc1,'Epsilon\t\t\t');
    fprintf(doc1,'Error\t\t');
    fprintf(doc1,'Majorants\n');
      
    eps = -3;
    for i=0:1:12

        y = calc_future_variations2(F_0_T, alpha, sigma,...
                                       time_, T_maturity, eps, order_l);                             
        v = calc_future_t_T(time_, T_maturity, alpha, sigma, eps,F_0_T) - F_0_T;
        h = y - v;
        
        
        k = c*calc_sens_spot(time_, alpha, sigma, F_0_T, order_l+1)*(max_e_dot^(order_l+1)/factorial(order_l+1));
        
        fprintf(doc1,'%f\t',eps);
        fprintf(doc1,'%e\t',abs(h));
        fprintf(doc1,'%e\n',k);

        
        eps = eps + 0.5; 

    end
    
    order_l = order_l + 1;
end


fclose(doc1);  





