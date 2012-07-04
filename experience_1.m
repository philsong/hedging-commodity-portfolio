
addpath ('future_sens_func');
addpath ('model_functions');
addpath ('defined_functions');
addpath ('hedging_functions');


% Produits %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

F_0_CRUDE = 106.875;
alpha_CRUDE = 0.346;
sigma_CRUDE = 0.5;

F_0_PLATINUM = 1627;
alpha_PLATINUM = -0.1;
sigma_PLATINUM = 0.2124;

F_0_SUGAR = 0.2563;
alpha_SUGAR = 0.3;
sigma_SUGAR = 0.8;

F_0_COAL = 56.67;
alpha_COAL = 0.05;
sigma_COAL = 0.1377;

F_0_Nonfat_DRYMILK = 128.5;
alpha_DRYMILK = 0.3;
sigma_DRYMILK = 0.38;

save('Crude_Parameters','F_0_CRUDE', 'alpha_CRUDE','sigma_CRUDE');
save('Platinum_Parameters','F_0_PLATINUM', 'alpha_PLATINUM','sigma_PLATINUM');
save('Sugar_Parameters','F_0_SUGAR', 'alpha_SUGAR','sigma_SUGAR');
save('Coal_Parameters','F_0_COAL', 'alpha_COAL','sigma_COAL');
save('DRYMILK_Parameters','F_0_Nonfat_DRYMILK', 'alpha_DRYMILK','sigma_DRYMILK');

% Données %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

order_l = 12; %ordre choisi arbitrairement

alpha = 0.3; 
sigma = 0.38; 

time_ = 1/24; %horizon de 15 jours
Nb_Long = 1000;
F_0 = 63.47;

F_H = 128.5; %données récupérées

T_maturity = 5; %données récupérées, maturité de 5 ans
T_maturity_H = 5/12; %données récupérées, maturité de 2 mois

phi = 0.001;
Tx_t_T = 0.03;

lambda_init_short = 0.1;
lambda_phi_short = calc_lambda(phi, lambda_init_short, time_, Tx_t_T);

%epsilon_ = calc_Epsilon(time_, alpha);
epsilon_ = 0.5;
teta_Hedging_short = zeros(1,order_l+1); %coefficients du n

teta_Naked = zeros(1,order_l+1);

D = 0.1*calc_future_t_T(time_, T_maturity, alpha_CRUDE, sigma_CRUDE, epsilon_,F_0)*Nb_Long; %Valeur max de la contrainte, 10% de la valeur du portefeuille



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                         %
% Formule du portefeuille couvert dans le cas d'un portefeuille à         %
%         - 1 future F_0 en position longue de 5 ans                      %
%         - couvert part un 1 future F_H en position courte de 2 mois     %       
%                                                                         %
% =  Sens(0, F_0) - (1+phi) * Sens(0,F_H) + lambda_phi_long * F_H         %
%  + sum((-1)^l)/(l!) * (Sens(l, F_0) - (1+phi) * Sens(l, F_H)) * eps^l   %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


teta_Hedging_short(1) = ((1+phi)*...
        sens_order_0(F_H, alpha, sigma, time_, T_maturity_H) + lambda_phi_short...
        *calc_future_t_T(time_, T_maturity_H, alpha, sigma, epsilon_,F_H));
    
teta_Naked(1) = sens_order_0(F_0, alpha_CRUDE, sigma_CRUDE, time_, T_maturity)*Nb_Long;
    
for i = 2 : order_l+1
teta_Hedging_short(i) = ((1+phi)*sens_order_L(F_H, i-1, alpha, sigma, time_, T_maturity_H));
teta_Naked(i) = sens_order_L(F_0, i-1, alpha_CRUDE, sigma_CRUDE, time_, T_maturity)*Nb_Long;
end

v = lambda_init_short*((1/calc_P_t_T(Tx_t_T, time_, T_maturity_H))-1)*...
            calc_future_t_T(time_, T_maturity_H,...
            alpha, sigma, epsilon_,F_H);
        
save('Minimization_F_coefficients','teta_Naked', 'teta_Hedging_short','epsilon_','order_l','v','D');

options = optimset('Algorithm','interior-point');
[n,FVAL] = fmincon(@min_F2, 100, v, D, [], [], 0, [], [], options);

strIntro = sprintf('** Here is the strategy you must follow **\n\n\n');

str1 = sprintf('Hedging strategy with one unique short contract type\n\n');

str2 = sprintf('1: Non Fat Dry Milk Futures \t F_0 = %f \t alpha = %f \t sigma = %f \t Maturity = %d/12 \n',F_0_Nonfat_DRYMILK,alpha_DRYMILK,sigma_DRYMILK,round(T_maturity_H*12));

str3 = sprintf('The number of contracts to use : %d\n',round(n));
 
str4 = sprintf('The approximated value of the covered portfolio is : %f\n\n\n', FVAL);

 
display(strIntro);
display(str1);
display(str2);
display(str3);
display(str4);

fid = fopen('Result_Hedging_Operation_Simple.txt','w'); 
fprintf(fid,strIntro);
fprintf(fid,str1);
fprintf(fid,str2);
fprintf(fid,str3);
fprintf(fid,str4);
fclose(fid);


% curve_CRUDE = curve_Future(F_0_CRUDE,alpha_CRUDE,sigma_CRUDE,T_maturity);
% figure_handle1 = figure(1);
% plot(curve_CRUDE),legend('maturity 5 years, price = 106.875$ at t = 0');
% set(figure_handle1,'name','CRUDE OIL FUTURE');
% 
% curve_PLATINUM = curve_Future(F_0_PLATINUM,alpha_PLATINUM,sigma_PLATINUM,T_maturity);
% figure_handle2 = figure(2);
% plot(curve_PLATINUM),legend('maturity 5 years, price = 1627$ at t = 0');
% set(figure_handle2, 'name', 'PLATINUM FUTURE');

% curve_SUGAR = curve_Future(F_0_SUGAR,alpha_SUGAR,sigma_SUGAR,T_maturity);
% figure_handle3 = figure(3);
% plot(curve_SUGAR),legend('maturity 5 years, price = 0.2563$ at t = 0');         
% set(figure_handle3, 'name', 'SUGAR FUTURE');
% 
% curve_COAL = curve_Future(F_0_COAL,alpha_COAL,sigma_COAL,T_maturity);
% figure_handle4 = figure(4);
% plot(curve_COAL),legend('maturity 5 years, price = 56.67$ at t = 0');
% set(figure_handle4, 'name', 'COAL FUTURE');
