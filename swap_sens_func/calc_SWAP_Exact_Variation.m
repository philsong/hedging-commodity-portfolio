function y = calc_SWAP_Exact_Variation(alpha, sigma, time_, epsilon_, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap)
% Descripton : fonction qui calcule la différence exact entre la valeur du
% swap à l'instant t et à l'instant 0.
% Formule (38)
%

swap_0 = calc_SWAP_t(alpha, sigma, 0, epsilon_, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap);
swap_t = calc_SWAP_t(alpha, sigma, time_, epsilon_, Tx_t_T, K, F_0_tk, t_k, v_k, Nb_Swap);

y = swap_t - swap_0;

end