function y = sens_order_L(F0, order_l, alpha, sigma, time_, T_maturity)
%% Calcul de la sensibilité d'ordre L du prix forward initial

temp1 = func_g_1(alpha, sigma, time_, T_maturity);
temp2 = func_g_2(alpha, sigma, time_, T_maturity);

y = temp2^order_l*exp(-temp1)*F0;

end