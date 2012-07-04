function f = calc_sens_spot(time_, alpha, sigma, F_0_T, l)

% Input : sigma (volatilité), alpha, prix future et spot observé à l'instant t = 0

temp1 = (-1)*func_g_1(alpha,sigma,time_,time_);
temp2 = func_g_2(alpha,sigma,time_,time_);

f = (temp2^l)*exp(temp1)*F_0_T;


end