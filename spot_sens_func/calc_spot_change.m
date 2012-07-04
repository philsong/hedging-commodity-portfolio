function y = calc_spot_change(F_0_T, alpha, sigma, time_, S_0)
% Description : calcul de la différence du prix par rapport à la
% sensibilité pour les spots
% Formule (25)

epsilon_ = calc_Epsilon(time_, alpha);
order_l = calc_Order_l(alpha, sigma, time_, time_, F_0_T, 'Spot');

% Calculate variation spot
sum = 0;
for l = 1 : order_l
    sum = sum + (1/factorial(l))*calc_sens_spot(time_, alpha, sigma, F_0_T, l)*(epsilon_)^l;
end

y = calc_sens_spot_0(time_, alpha, sigma,F_0_T, S_0) + sum;

end