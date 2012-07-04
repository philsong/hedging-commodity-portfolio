function [F_0_T, maturity, S_0, Nb_Cash_Flow, v_k, t_k, K, F_0_tk] = instrumentSpecificationFunc()
% Description : fonction qui définit les caractéristiques des produits et
% on remplit dès à présent des valeurs de 3 futures, et 2 Swap


nb_Fut = 5;
nb_Swap = 2;

% FUTURES

F_0_T = zeros(nb_Fut,1);
maturity = zeros(nb_Fut,1);

% Les maturités des Futures

maturity(1) = 4/12;
maturity(2) = 5/12;
maturity(3) = 60/12; % Maturité 5 ans
maturity(4) = 2/12; % Maturité 2 mois
maturity(5) = 0;

% Les prix des Futures

F_0_T(1) = 100;
F_0_T(2) = 105;
F_0_T(3) = 63.47; % Valeur maturité 5 ans
F_0_T(4) = 61.6; % 2 mois
F_0_T(5) = 0; % Pour valeur nulle





% SPOT : Le prix Spot du commodity
%S_0 = zeros(nb_Spot,1);

S_0 = 90;





% SWAPS : le nombre de flux, les volumes des flux, les instants, et les
% valeurs des futures aux maturités

Nb_Cash_Flow_Max = 5;
Nb_Cash_Flow = zeros(nb_Swap, 1);
v_k = zeros(nb_Swap, Nb_Cash_Flow_Max);
t_k = zeros(nb_Swap, Nb_Cash_Flow_Max);
K = zeros(nb_Swap,1);
F_0_tk = zeros(nb_Swap, Nb_Cash_Flow_Max);

% Nombre de flux pour le contrat 1 et 2

Nb_Cash_Flow(1) = 5;
Nb_Cash_Flow(2) = 2;

% -> maturités des SWAP : mat_tk
mat_tk = zeros(nb_Swap,1);
mat_tk(1) = 4/12;
mat_tk(2) = 3/12;

% Les instants d'échange de flux
            
step = mat_tk(1)/Nb_Cash_Flow(1);
t_k(1,1) = step;
t_k(1,2) = t_k(1,1) + step;
t_k(1,3) = t_k(1,2) + step;
t_k(1,4) = t_k(1,3) + step;
t_k(1,5) = mat_tk(1);

step = mat_tk(2)/Nb_Cash_Flow(2);
t_k(2,1) = step;
t_k(2,2) = mat_tk(2);

% Le volume échangé aux instant t_k

v_k(1,1) = 2; v_k(1,2) = 2; v_k(1,3) = 2; v_k(1,4) = 2; v_k(1,5) = 2;
v_k(2,1) = 3; v_k(2,2) = 3;

% Le prix fixe payé par l'acheteur

K(1) = 50;
K(2) = 70;

% Les prix futures aux maturités : contrat n°1 puis 2

F_0_tk(1,1) = 85;
F_0_tk(1,2) = 90;
F_0_tk(1,3) = 95;
F_0_tk(1,4) = 100;
F_0_tk(1,5) = 110;

F_0_tk(2,1) = 100;
F_0_tk(2,2) = 120;


end