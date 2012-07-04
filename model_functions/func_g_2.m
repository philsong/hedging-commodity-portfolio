function y = func_g_2(alpha, sigma, time_, T_maturity)
%% Calcul de la fonction g1(t,T,alpha,sigma)

temp = sqrt((exp(2*alpha*time_)-1)/(2*alpha));

y = sigma*exp(-alpha*T_maturity)*temp;

end