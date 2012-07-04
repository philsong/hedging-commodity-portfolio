function [F_0_T, S_0, alpha, sigma, epsilon_, time_, T_maturity, F_0_tk, K, t_k, v_k, Tx_t_T, Nb_Cash_Flow, phi] = data_Initialization(Maturity_Months)

% FUTURE DATA

T_maturity = Maturity_Months / 12;
F_0_T = 100;
alpha = 0.15;
sigma = 0.41;

% SPOT DATA

S_0 = 90;

% SWAP DATA

Nb_Cash_Flow = 3;
K = 100; % Fixed price to pay
v_k = round(rand(1,Nb_Cash_Flow)*4 + 1); % Volume (amount) of commodity per swap
F_0_tk = round(rand(1,Nb_Cash_Flow)*3 + 100); % Valeur des contrats en 0
Tx_t_T = 0.03; % Taux d'intérêt continu : r_t_T de t à T -- 3%

t_k = zeros(Nb_Cash_Flow,1); % Date d'échange des flux
for i = 1 :  Nb_Cash_Flow
    t_k(i) = T_maturity*i/Nb_Cash_Flow ;
end

% TIME INSTANT OF EVALUATION

time_ = 5/24;

% Réalisation du facteur d'incertitude

epsilon_ = 0.5;
%epsilon_ = calc_Epsilon(time_,alpha);
% HEDGING : COST COEFFICIENT

phi = 0.001;

end