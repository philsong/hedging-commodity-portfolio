function y = calc_Function_C(alpha, sigma, epsi_boundary, time_, T_maturity)
% Description : Calcul de la fonction C = max(c*, c**)
% Formule (20)

c1 = min(1, exp(-epsi_boundary*func_g_2(alpha,sigma,time_,T_maturity)));
c2 = max(1, exp(epsi_boundary*func_g_2(alpha,sigma,time_,T_maturity)));
y = max(c1,c2);

end