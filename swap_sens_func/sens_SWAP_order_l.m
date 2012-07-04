function y = sens_SWAP_order_l(time_, r_t_T, order, alpha, sigma, F_0_tk, t_k, v_k, Nb_Swap)
% Description : formule 37
%

sens_fwd_order_l = zeros(size(t_k));

P_t_tk = zeros(size(t_k));

for i = 1 : Nb_Swap
        sens_fwd_order_l(i) = sens_order_L(F_0_tk(i), order, alpha, sigma, time_, t_k(i));
end


for i = 1 : Nb_Swap
    P_t_tk(i) = calc_P_t_T(r_t_T, time_, t_k(i));
end


% Sommation = 0;
% for k = 1 : Nb_Swap
%     
%     temp2 = P_t_tk(k)*v_k(k)*sens_fwd_order_l(k);
%     Sommation = Sommation + temp2;
%     
% end

temp = P_t_tk .* v_k .* sens_fwd_order_l;
Sommation = sum(temp);


y = Sommation;

end