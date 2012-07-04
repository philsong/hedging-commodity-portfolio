function y = calc_SWAP_t(alpha, sigma, time_, epsilon, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Flux)
% Description : cette fonction permet la valorisation du SWAP à l'instant t
% Formule (34)
%

P_t_tk = zeros(size(t_k));
F_t_tk = zeros(size(t_k));
Value_Swap_t = 0;

for i = 1 : Nb_Flux
   
    P_t_tk(i) = calc_P_t_T(Tx_t_T, time_, t_k(i));
    
    F_t_tk(i) = calc_future_t_T(time_, t_k(i), alpha, sigma, epsilon, F_0_tk(i));
    
    Value_Swap_t = Value_Swap_t + P_t_tk(i)*v_k(i)*(F_t_tk(i) - K);
    
end

% Ans
y = Value_Swap_t;

end