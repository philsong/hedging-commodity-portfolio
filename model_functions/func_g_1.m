function y = func_g_1(alpha, sigma, time_, T_maturity)
%% Calcul de la fonction g1(t,T,alpha,sigma)

temp = exp(-2*alpha*(T_maturity-time_)) - exp(-2*alpha*T_maturity);

y = temp*sigma^2/(4*alpha);

end