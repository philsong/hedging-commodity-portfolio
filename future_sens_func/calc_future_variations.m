function y = calc_future_variations(F_0_T, alpha, sigma, time_, T_maturity)
% Description : calcul de la différence du prix par rapport à la
% sensibilité pour les futures
% Formule (13)

epsilon = calc_Epsilon(time_, alpha);
order_l = calc_Order_l(alpha, sigma, time_, T_maturity, F_0_T, 'Future');

% Calculate variation future
S = 0;
for n = 1 : order_l
    S = S + ((sens_order_L(F_0_T, n, alpha, sigma, time_,...
                           T_maturity)*epsilon^n)/factorial(n));
end

temp1 = sens_order_0(F_0_T, alpha, sigma, time_, T_maturity);

y = temp1 + S;

end

