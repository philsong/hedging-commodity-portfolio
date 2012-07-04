function y = sens_order_0(F_0, alpha, sigma, time_, T_maturity)
%% Calcul de la sensibilité d'ordre 0 du prix forward initial

temp = (-1) * func_g_1(alpha, sigma, time_, T_maturity);

y = ((exp(temp)-1)*F_0);

end