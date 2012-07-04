% Script : Portofolio values:
%1 -> naked
%2 -> covered

addpath ('future_sens_func');
addpath ('model_functions');
addpath ('swap_sens_func');
addpath ('defined_functions');
addpath ('hedging_functions');
addpath ('spot_sens_func');

%[~, ~, alpha, sigma, epsilon, time_, ~,...
%   ~, ~, ~, ~, r_t_T, ~, phi] = data_Initialization(0);

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
% F_0_T_Hedging = [45 50 42.3];

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

% curve_Fut = curve_Future(F_0_T_Naked,alpha,sigma,maturity_Naked);
% figure;title('Curve Future');
% plot(curve_Fut),legend('maturity 5 years, price = 63.47$ at t = 0');


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

%%%% Calcul de D : les coûts maximum assumés
%%%% 10% du portefeuille nu à l'horizon time_ (s dans le pdf)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% POUR ETUDIER LA VARIATION EN FONCTION DU TEMPS, FIXER D, LES COUTS ACCEPTES %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


D = 0.1*calc_future_t_T(time_, maturity_Naked, alpha_naked, sigma_naked, epsilon, F_0_T_Naked)*Nb_Type_Naked_Long;

%%%% Calcul de V_i_* (car on a que des positions courtes)
v = zeros(1,Nb_Type_Hedging_Short);

for i = 1 : Nb_Type_Hedging_Short

    v(i) = lambda_init_short*...
    (calc_P_t_T(r_t_T, time_, maturity_Hedging(i))^(-1)-1)*...
    calc_future_t_T(time_, maturity_Hedging(i), alpha_hedge(i), sigma_hedge(i), epsilon, F_0_T_Hedging(i));
       
end

%%%% v = 0.056411213523399
%%%%     0.095692304242677
%%%%     0.136318436027830

%%%% On a Moy_v(i) = 0.10 donc on aurait n = 60 au maximum pour tous les
%%%% n_i dans l'expérience

save('Minimization_F_coefficients','teta_0_Naked_Long', 'teta_Hedging_0_short','teta_l_Naked_Long','teta_Hedging_l_short','epsilon','Max_Order','v','D');

options = optimset('Algorithm','active-set'); % interior-point
[n,FVAL] = fmincon(@min_F, [0 0 0], v, D, [], [], [0 0 0], [], [], options);


strIntro = sprintf('** Here is the strategy you must follow **\n\n\n');

str1 = sprintf('Number of contract types for the hedging: %d\n\n',Nb_Type_Hedging_Short);

str2 = sprintf('1: Uranium Futures \t F_0 = %f \t alpha = %f \t sigma = %f \t Maturity = %d/12 \n',F_0_T_Hedging(1),alpha_hedge(1),sigma_hedge(1),round(maturity_Hedging(1)*12));
str3 = sprintf('2: Non Fat Dry Milk Futures \t F_0 = %f \t alpha = %f \t sigma = %f \t Maturity = %d/12\n',F_0_T_Hedging(2),alpha_hedge(2),sigma_hedge(2),round(maturity_Hedging(2)*12));
str4 = sprintf('3: Feeder Cattle Futures \t F_0 = %f \t alpha = %f \t sigma = %f \t Maturity = %d/12\n\n',F_0_T_Hedging(3),alpha_hedge(3),sigma_hedge(3),round(maturity_Hedging(3)*12));

str5 = sprintf('The number of Uranium contracts to use : %d\n',round(n(1)));
str6 = sprintf('The number of Dry Milk contracts to use : %d\n',round(n(2)));
str7 = sprintf('The number of product Cattle feeding to use : %d\n\n',round(n(3)));
 
str8 = sprintf('The approximated value of the covered portfolio is : %f\n\n\n', FVAL);

% display(strIntro);
% display(str1);
% display(str2);
% display(str3);
% display(str4);
% display(str5);
% display(str6);
% display(str7);
% display(str8);

fid = fopen('Result_Hedging_Operation.txt','w'); 
fprintf(fid,strIntro);
fprintf(fid,str1);
fprintf(fid,str2);
fprintf(fid,str3);
fprintf(fid,str4);
fprintf(fid,str5);
fprintf(fid,str6);
fprintf(fid,str7);
fprintf(fid,str8);
fclose(fid);

% Val_max_n = 255;
% temp = 100000000;
% 
% for i = 250 : Val_max_n+1
%     
%     for j = 250 : Val_max_n+1
%         
%         for k = 250 : Val_max_n+1
%             
%             temp1 = subs(F,{n1,n2,n3},[i-1 j-1 k-1]);
%             
%             if(temp > temp1)
%                 
%                 n_1 = i-1; n_2 = j-1; n_3 = k-1;
%                 temp = temp1;
%                 
%             end
%             
%             
%         end
%         
%     end
%     
% end
% 
% temp
% [n_1, n_2, n_3]

%%% Calcul de la fonction F(n1,n2,n3) à minimizer
% syms n1 n2 n3
% 
% F = abs(teta_0_Naked_Long - teta_Hedging_0_short*[n1;n2;n3]);
% 
% for l = 1 : Max_Order
%     f_temp = (1/factorial(l))*epsilon^l...
%              *abs(teta_l_Naked_Long(l) - teta_Hedging_l_short(l,:)*[n1;n2;n3]);
%     
%     F = F + f_temp; 
% end



