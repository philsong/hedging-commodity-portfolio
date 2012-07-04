function y = calc_SWAP_with_sensitivity(alpha, sigma, time_, epsilon, r_t_T, K, F_0_tk, t_k, v_k, Nb_Swap)
% Description : Calcul de la différence du swap
% Avec les sensibilités (approxmiation) 
% Formule (37)
%

% Calcul de l'ordre nécessaire pour approximer la cours du Future avec
% erreur rho = 10^-12
Order_L = calc_Order_Required(alpha, sigma, time_, r_t_T, F_0_tk, t_k, v_k, Nb_Swap);

sens_Swap_Order_0 = sens_SWAP_order_0(time_, r_t_T, alpha, sigma,...
                                    F_0_tk, K, t_k, v_k, Nb_Swap);

S = 0;
for l = 1 : Order_L

    S = S + ((sens_SWAP_order_l(time_, r_t_T, l, ...
                      alpha, sigma, F_0_tk, t_k, v_k, Nb_Swap)*epsilon^l)/factorial(l));
end

y = sens_Swap_Order_0 + S;

end