% Script : Portofolio values:
%1 -> naked
%2 -> covered

addpath ('future_sens_func');
addpath ('model_functions');
addpath ('swap_sens_func');
addpath ('defined_functions');
addpath ('hedging_functions');
addpath ('spot_sens_func');

% NAKED PORTOFOLIO V - - - - - - - - - - - - - - - - - - - - - - - - - 

% colonne 1 -> volume du contrat
% colonne 2 -> type du contrat
% colonne 3 -> Indice : IDENTIFIANT DU CONTRAT

Nb_Type_Long = 1; % J**
Nb_Type_Short = 1; % J*

Long_Instruments = zeros(Nb_Type_Long,3); % Matrice des positions longues
Short_Instruments = zeros(Nb_Type_Short,3); % Matrice des positions courtes

Long_Instruments(1,2) = 1; % Future
%Long_Instruments(2,2) = 2; % Spot
%Long_Instruments(3,2) = 3; % Swap
%Long_Instruments(4,2) = 3; % Swap
%Long_Instruments(5,2) = 1; % Future

Short_Instruments(1,2) = 1; % Future
%Short_Instruments(2,2) = 2; % Spot
%Short_Instruments(3,2) = 3; % Swap
%Short_Instruments(4,2) = 1; % Future

% Indexation sur le produit indexé 1, 2 ou 3 (dépendant du nombres de produits différents)

Short_Instruments(1,3) = 3;
%Short_Instruments(2,3) = 1; 
%Short_Instruments(3,3) = 1; 
%Short_Instruments(4,3) = 3; % 3e type défini dans instruSpecificationFunc

Long_Instruments(1,3) = 5;
%Long_Instruments(2,3) = 1;
%Long_Instruments(3,3) = 1;
%Long_Instruments(4,3) = 2;
%Long_Instruments(5,3) = 2;

% Volume
for i = 1 : Nb_Type_Long
    Long_Instruments(i,1) = round(rand(1,1) * 10 + 1);
end

% Volume
for i = 1 : Nb_Type_Short
    Short_Instruments(i,1) = 1; %round(rand(1,1) * 10 + 1); 
end

% HEDGING PORTOFOLIO H - - - - - - - - - - - - - - - - - - - - - - - - - 

% colonne 1 -> volume du contrat
% colonne 2 -> type du contrat
% colonne 3 -> Indice : IDENTIFIANT DU CONTRAT

Nb_Type_Long_H = 1; % I**
Nb_Type_Short_H = 1; % I*

Long_Instruments_H = zeros(Nb_Type_Long_H,3); % Matrice des positions longues
Short_Instruments_H = zeros(Nb_Type_Short_H,3); % Matrice des positions courtes

Long_Instruments_H(1,2) = 1; % Future
%Long_Instruments_H(2,2) = 2; % Spot
%Long_Instruments_H(3,2) = 3; % Swap

Short_Instruments_H(1,2) = 1; % Future
%Short_Instruments_H(2,2) = 2; % Spot
%Short_Instruments_H(3,2) = 3; % Swap
%Short_Instruments_H(4,2) = 1; % Future

% Indexation sur le produit indexé 1, 2 ou 3 (dépendant du nombres de produits différents)

Short_Instruments_H(1,3) = 5;
%Short_Instruments_H(2,3) = 1; 
%Short_Instruments_H(3,3) = 1; 
%Short_Instruments_H(4,3) = 2; % 3e type défini dans instruSpecificationFunc

Long_Instruments_H(1,3) = 4;
%Long_Instruments_H(2,3) = 1;
%Long_Instruments_H(3,3) = 1;

for i = 1 : Nb_Type_Long_H
    Long_Instruments_H(i,1) = round(rand(1,1) * 10 + 1); % Volume
end

for i = 1 : Nb_Type_Short_H
    Short_Instruments_H(i,1) = round(rand(1,1) * 10 + 1); % Volume
end


[y,b,cc] = pfolio_naked_value(Long_Instruments, Short_Instruments);
[z,v,ccc] = pfolio_covered_value(Long_Instruments_H, Short_Instruments_H);

% sol = inv(A'*A)*A'*b

c = [cc ccc]
v = [0 0 v']

D = 1000 % Valeur supposée des couts

lb = zeros(Nb_Type_Long_H+Nb_Type_Short_H,1);
[x, fval, exitflag, output, lambda]=linprog(c',v,D,[],[],lb)


w = y + z; % Valeur du portefeuille couvert = valeur du portefeuille nu V + valeur du portefeuille de hedging H

str = sprintf('valeur du portefeuille nu: %d',y);
str2 = sprintf('valeur du portefeuille couvert: %d',z);

display(str);
display(str2);