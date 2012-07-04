function y = sens_SWAP_order_0(time_, r_t_T, alpha, sigma, F_0_tk, K, t_k, v_k, Nb_Flux_Swap)
% Description : formule 36
%

P_0_tk = zeros(size(t_k));
P_t_tk = zeros(size(t_k));

sens_fwd_order_0 = zeros(size(t_k));

% for i = 1 : Nb_Flux_Swap
%     sens_fwd_order_0(i) = sens_order_0(F_0_tk(i), alpha, sigma, time_, t_k(i));
% end 

for i = 1 : Nb_Flux_Swap
    sens_fwd_order_0(i) = sens_order_L(F_0_tk(i), 0, alpha, sigma, time_, t_k(i));
end 

for i = 1 : Nb_Flux_Swap
    P_0_tk(i) = calc_P_t_T(r_t_T, 0, t_k(i));
    P_t_tk(i) = calc_P_t_T(r_t_T, time_, t_k(i));
end


% Sommation = 0;
% for k = 1 : Nb_Swap
%     
%     temp1 = (P_t_tk(k) - P_0_tk(k))*(F_0_tk(k) - K);
%     temp2 = (P_t_tk(k)*v_k(k)*sens_fwd_order_0(k));
%     Sommation = Sommation + temp1 + temp2;
%     
% end

%temp1 = (P_t_tk - P_0_tk) .* (F_0_tk - K);
%temp2 = P_t_tk .* v_k .* sens_fwd_order_0;

temp1 = P_t_tk.*v_k.*(sens_fwd_order_0 - K);
temp2 = P_0_tk.*v_k.*(F_0_tk - K);

Sommation = sum(temp1) - sum(temp2);


y = Sommation;

end