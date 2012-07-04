function [] = curve_D()


% Script : Portofolio values:
%1 -> naked
%2 -> covered

addpath ('future_sens_func');
addpath ('model_functions');
addpath ('swap_sens_func');
addpath ('defined_functions');
addpath ('hedging_functions');
addpath ('spot_sens_func');

[~, ~, ~, ~, epsilon, ~, ~,...
    ~, ~, ~, ~, r_t_T, ~, phi] = data_Initialization(0);
Max_Order = 12; % Ordre p dans le pdf


load('Crude_Parameters','F_0_CRUDE', 'alpha_CRUDE','sigma_CRUDE');
load('Platinum_Parameters','F_0_PLATINUM', 'alpha_PLATINUM','sigma_PLATINUM');
load('Sugar_Parameters','F_0_SUGAR', 'alpha_SUGAR','sigma_SUGAR');
load('Coal_Parameters','F_0_COAL', 'alpha_COAL','sigma_COAL');
load('DRYMILK_Parameters','F_0_Nonfat_DRYMILK', 'alpha_DRYMILK','sigma_DRYMILK');


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
% F_0_T_Hedging = [45 50 42.3];

%%% Multiple sigma/alpha %%%
%%%%%%%%%%%%%%%% Uranium / Dry Milk / Cattle (foin) %%%%%%%%%%%%%%%%%%%%%
F_0_T_Hedging = [51.0 128.5 148.675];
alpha_hedge = [0.2 0.3 0.45];
sigma_hedge = [0.45 0.38 0.2];

maturity_Hedging = [6/12 8/12 7/12];

%%% Data sur les coups cf. Paper
lambda_init_long = 0.25;
lambda_init_short = 0.25;

%%%

% curve_Fut = curve_Future(F_0_T_Naked,alpha,sigma,maturity_Naked);
% figure;title('Curve Future');
% plot(curve_Fut),legend('maturity 5 years, price = 63.47$ at t = 0');

T_eval =  min(maturity_Hedging);
dt = 1/48; % 1 semaine

tailleV = T_eval / dt;
FVal_t = zeros(1, tailleV+1);
Cpt = 1;
for time_ = 0 : dt : T_eval
%%%% Cacul portefeuille nu : Teta_0_V et Somme des Teta_l_V
lambda_long = calc_lambda(phi, lambda_init_long, time_, r_t_T);
lambda_short = calc_lambda(phi, lambda_init_short, time_, r_t_T);
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

%%%% Calcul de V_i_* (car on a que des positions courtes)
v = zeros(1,Nb_Type_Hedging_Short);

for i = 1 : Nb_Type_Hedging_Short

    v(i) = lambda_init_short*...
           (calc_P_t_T(r_t_T, time_, maturity_Hedging(i))^(-1)-1)*...
           calc_future_t_T(time_, maturity_Hedging(i), alpha_hedge(i), sigma_hedge(i), epsilon, F_0_T_Hedging(i));
       
end

%%%% Calcul de D : les coûts maximum assumés
%%%% 10% du portefeuille nu à l'horizon time_ (s dans le pdf)
D = 0.1*calc_future_t_T(time_, maturity_Naked, alpha_naked, sigma_naked, epsilon,F_0_T_Naked)*Nb_Type_Naked_Long;
save('Minimization_F_coefficients','teta_0_Naked_Long', 'teta_Hedging_0_short','teta_l_Naked_Long','teta_Hedging_l_short','epsilon','Max_Order','v','D');

    options = optimset('Algorithm','interior-point'); % 
    [n, FVal_t(Cpt)] = fmincon(@min_F, [0 0 0], v, D, [], [], [0 0 0], [], [], options)
    Cpt = Cpt + 1;
end

FVal_t_ts = timeseries(FVal_t(1:end),1:size(FVal_t,2));
FVal_t_ts.Name = 'Test 3 : The evolution of the hedging efficiency when the horizon grows';
FVal_t_ts.TimeInfo.Units = 'weeks';
FVal_t_ts.TimeInfo.StartDate='01-Jan-2004';
FVal_t_ts.TimeInfo.Format = 'mmm dd'; % Set format for display on x-axis.
FVal_t_ts.Time=FVal_t_ts.Time-FVal_t_ts.Time(1); % Express time relative to the start date.
p = plot(FVal_t_ts);
title('Test 3 : The evolution of the hedging efficiency when the horizon grows');
xlabel('time');
ylabel('Covered portfolio value');
legend('Objective function');
set(p,'Color','red','LineWidth',1);

end