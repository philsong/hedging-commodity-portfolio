%    Fichier sens_Relate_Spot.m
%           -----------------
%   Ce script test le calcul de sensibilités par rapport aux Spots
%   Formule (25)   
%

% Données initiales
addpath ('model_functions');
addpath ('spot_sens_func');
addpath ('defined_functions');

F_0_T = 100;
S_0 = 100;
T_maturity = 3/12;
alpha = 0.34;
sigma = 0.31;
dt = 7/360;

size_Vec = floor(T_maturity / dt);
vector_Spot_Sens = zeros(size_Vec + 1,1);
index = 1;

% Calcul = F(t,T)
for i = 0 : dt : T_maturity
    
    % Time : t value
    time_ = i;
    
    % Sensitivity
    vector_Spot_Sens(index) = calc_spot_change(F_0_T, alpha, sigma,...
                                       time_, S_0);
    
    index = index + 1;
end


% Calcul : diff
x = 0 : dt : T_maturity;

figure;
plot(x,vector_Spot_Sens);title('Diff Spot Sens curve');
xlabel('Time');
ylabel('Diff Spot Sens Value');