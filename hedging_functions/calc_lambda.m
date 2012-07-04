function y = calc_lambda(phi, lambda_init, time_, Tx_t_T)

temp1 = (phi/calc_P_t_T(Tx_t_T, 0, time_));
temp2 = lambda_init*(1/calc_P_t_T(Tx_t_T, 0, time_)-1);
y = temp1 + temp2;
end

