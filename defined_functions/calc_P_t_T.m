function y = calc_P_t_T(r_t_T, time_, T_maturity)
% Description : fonction de calcul du zéro coupon

y = exp(-r_t_T*(T_maturity - time_));

end