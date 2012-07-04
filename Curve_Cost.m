function [ ] = Curve_Cost( )

% Script : Portofolio values:
%1 -> naked
%2 -> covered

addpath ('future_sens_func');
addpath ('model_functions');
addpath ('swap_sens_func');
addpath ('defined_functions');
addpath ('hedging_functions');
addpath ('spot_sens_func');

[~, ~, ~, ~, epsilon, time_, ~,...
    ~, ~, ~, ~, r_t_T, ~, phi] = data_Initialization(0);
Max_Order = 12; % Ordre p dans le pdf

%%% Contrat du portefeuille nu
Nb_Type_Naked_Long = 1000; % J**
F_0_T_Naked = 63.47;
% F_0_T_Naked = F_0_CRUDE;
maturity_Naked = 60/12;

sigma_naked = 0.5;
alpha_naked = 0.346;

%%%
%%% Contrats du portefeuille de couverture
Nb_Type_Hedging_Short = 3; % I*

%%% Multiple sigma/alpha %%%
%%%%%%%%%%%%%%%% Uranium / Dry Milk / Cattle (foin) %%%%%%%%%%%%%%%%%%%%%
F_0_T_Hedging = [51.0 128.5 148.675];
alpha_hedge = [0.23 0.3 0.45];
sigma_hedge = [0.3 0.38 0.2];

maturity_Hedging = [5/12 5/12 5/12];
%%%

%%% Data sur les coups cf. Paper
lambda_init_long = 0.25;
lambda_init_short = 0.25;
lambda_long = calc_lambda(phi, lambda_init_long, time_, r_t_T);
lambda_short = calc_lambda(phi, lambda_init_short, time_, r_t_T);
%%%

cost_max = 0.0011; % En pourcentage : 0,11%
cost_init = 0.00011; % Min : 0,011%
cpt = 1;
stepSize = 0.00001; % Evolution de 0,001%
f_values = zeros(cost_max/cost_init + 1,4);

for cost =  cost_init : stepSize : cost_max


%%%% Cacul portefeuille nu : Teta_0_V et Somme des Teta_l_V

teta_l_Naked_Long = zeros(Max_Order,1);

teta_0_Naked_Long =  sens_order_0(F_0_T_Naked, alpha_naked, sigma_naked, time_, maturity_Naked) * Nb_Type_Naked_Long;
        
for l = 1 : Max_Order
    
    teta_l_Naked_Long(l) = sens_order_L(F_0_T_Naked, l, alpha_naked, sigma_naked, time_, maturity_Naked)...
                           *Nb_Type_Naked_Long;
    
end
%%%%

%%%% Caclul des coefficients du portefeuille de couverture
teta_Hedging_0_short = zeros(1, Nb_Type_Hedging_Short); 
teta_Hedging_l_short = zeros(Max_Order,Nb_Type_Hedging_Short);

for i = 1 : Nb_Type_Hedging_Short
    
    teta_Hedging_0_short(i) =  (1+phi)*...
                               sens_order_0(F_0_T_Hedging(i), alpha_hedge(i), sigma_hedge(i), time_, maturity_Hedging(i))...
                               + lambda_short*...
                               calc_future_t_T(time_, maturity_Hedging(i), alpha_hedge(i), sigma_hedge(i), epsilon, F_0_T_Hedging(i));
    
end

for l = 1 : Max_Order
    
    for i = 1 : Nb_Type_Hedging_Short

%        teta_Hedging_l_short(l,i) =(1+phi)*...
%                                   sens_order_L(F_0_T_Hedging(i), l, alpha, sigma, time_, maturity_Hedging(i));

         %%% Multiple sigma/alpha %%%
         teta_Hedging_l_short(l,i) =(1+phi)*...
                                   sens_order_L(F_0_T_Hedging(i), l, alpha_hedge(i), sigma_hedge(i), time_, maturity_Hedging(i));
        
    end
    
end
%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% POUR ETUDIER LA VARIATION EN FONCTION DU TEMPS, FIXER D, LES COUTS ACCEPTES %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


D = cost*calc_future_t_T(time_, maturity_Naked, alpha_naked, sigma_naked, epsilon, F_0_T_Naked)*Nb_Type_Naked_Long;

%%%% Calcul de V_i_* (car on a que des positions courtes)
v = zeros(1,Nb_Type_Hedging_Short);

for i = 1 : Nb_Type_Hedging_Short

    v(i) = lambda_init_short*...
    (calc_P_t_T(r_t_T, time_, maturity_Hedging(i))^(-1)-1)*...
    calc_future_t_T(time_, maturity_Hedging(i), alpha_hedge(i), sigma_hedge(i), epsilon, F_0_T_Hedging(i));
       
end

save('Minimization_F_coefficients','teta_0_Naked_Long', 'teta_Hedging_0_short','teta_l_Naked_Long','teta_Hedging_l_short','epsilon','Max_Order','v','D');

options = optimset('Algorithm','interior-point');
[n,FVAL] = fmincon(@min_F, [0 0 0], v, D, [], [], [0 0 0], [], [], options);

f_values(cpt,1) = FVAL;
f_values(cpt,2) = round(n(1));
f_values(cpt,3) = round(n(2));
f_values(cpt,4) = round(n(3));

cpt = cpt + 1;

end

str = cell(104);

str{1} = sprintf('** Hedging efficiency reactions to the hedging cost D modification **\n\n\n');

str{2} = sprintf('Variations from 0.011% to 0.11% of the naked portfolio value\n\n');

str{3} = sprintf('F_VALUE \t n1 \t n2 \t n3 \n\n\n');

for i=4:103
    str{i} = sprintf('%f \t %d \t %d \t %d\n',f_values(i-3,1),f_values(i-3,2),f_values(i-3,3),f_values(i-3,4)); 
end
fid = fopen('Result_D_sensitivity.txt','w'); 


for i=1:103
fprintf(fid,str{i});
end
fclose(fid);

f_values_display = zeros(100);

for i=1:100
    f_values_display(i)=f_values(i,1);
end
p = plot(cost_init:stepSize:cost_max, f_values_display);
xlabel('percentage of the naked portfolio value');
ylabel('Covered portfolio value');
legend('Objective function');
title('Test 4 : The evolution of the hedging efficiency when the hedging cost grows');
set(p,'Color','red','LineWidth',1);
set(gca,'XTickLabel',{'0.011%';'0.044%';'0.077%';'0.11%'})
end

