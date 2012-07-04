function y = calc_future_t_T(time_, T_maturity, alpha, sigma, epsilon_,F_0_T)
%% Calcul du prix future à l'instant t, de maturité T
% Input : sigma (volatilité), alpha, prix future observé à l'instant t = 0

if  isequal(time_,0) 
    y = F_0_T;    
else
    temp1 = (-1)*func_g_1(alpha,sigma,time_,T_maturity);
    temp2 = func_g_2(alpha,sigma,time_,T_maturity)*epsilon_;
    y = exp(temp1 + temp2)*F_0_T;
end

end