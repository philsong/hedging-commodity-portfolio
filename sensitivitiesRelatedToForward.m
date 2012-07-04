%    Fichier sensitivitiesRelatedToForward.m
%           -----------------
%   Ce script test le calcul de sensibilités par rapport aux forward
%   Formule (13)   
%

% Données initiales
addpath ('model_functions');
addpath ('future_sens_func');
addpath ('defined_functions');

F_0_T = 100;
T_maturity = 6/12;
alpha = 0.34;
sigma = 0.31;
dt = 7/360;

size_Vec = floor(T_maturity / dt);
vector_Future = zeros(size_Vec + 1,1);
index = 1;

% Calcul = F(t,T)
for i = 0 : dt : T_maturity
    
    % Time : t value
    time_ = i;
    
    % Difference
    %vector_Future(index) = calc_future_t_T(time_, T_maturity, alpha, sigma,...
    %                                  calc_Epsilon(time_,alpha), F_0_T);
    vector_Future(index) = calc_future_variations(F_0_T, alpha, sigma,...
                                       time_, T_maturity);
    
    index = index + 1;
end


% Calcul : diff
x = 0:dt:T_maturity;

figure;
plot(x,vector_Future);title('Future curve');
xlabel('Time');
ylabel('Future Value');
