% Script : SWAP testing
% Description : ce script renvoie la variation de la valeur du SWAP entre
% l'instant 0 et l'instant t en premier lieu de manière exacte (processus
% stochastique) puis après avec approximation (Taylor-expansion)
%

addpath ('future_sens_func');
addpath ('model_functions');
addpath ('swap_sens_func');
addpath ('defined_functions');

F_0_T = 100;
alpha = 0.34;
sigma = 0.31;

Nb_Swap = 3; % M le nbre d'échanges différents (échange de flux)
Months = 4;
T_maturity = Months/12;
time_ = 1/24 ; % Instant t où on procède l'évaluation


t_k = zeros(Nb_Swap,1); % Date d'échange des flux
for i = 1 :  Nb_Swap
    t_k(i) = T_maturity*i/Nb_Swap ;
end

% K = 100; % Fixed price to pay
K = F_0_T / Nb_Swap; 
v_k = ones(Nb_Swap,1)*50;%round(rand(1,Nb_Swap)*4 + 1); % Volume (amount) of commodity per swap
F_0_tk = ones(Nb_Swap,1)*100; %round(rand(1,Nb_Swap)*3 + 100); % Valeur des contrats en 0
%Tx_t_T = [0.03 0.03 0.03]; % Taux d'intérêt continu : r_t_T de t à T -- 3%
Tx_t_T = 0.03;
% Ici est posée la valeur d'Epsilon (le facteur d'incertitude)
epsilon_ = 0.5;%calc_Epsilon(time_, alpha);

swap_Approx = calc_SWAP_with_sensitivity(alpha, sigma, time_, epsilon_, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap);
swap_Exact = calc_SWAP_Exact_Variation(alpha, sigma, time_, epsilon_, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap);
diff = swap_Exact - swap_Approx;
% Saving

file = fopen('SWAP_Results.txt','a');

str1 = sprintf('Approximative variation\t  Exact variation \t The error term  \t Value of Epsilon (uncertainty factor) \n');
str2 = sprintf('\n     %d  \t        %d   \t  %d   \t\t  %d  (maturity : %d months)',swap_Approx,swap_Exact,diff,epsilon_,Months);

%fprintf(file,str1);
fprintf(file,str2);
display(str1);
display(str2);
