function y = calc_Order_Required(alpha, sigma, time_, r_t_T, F_0_tk, t_k, v_k, Nb_Swap)


% Initialization
rho = 10^-12;
e_dot = 4; % Eps standard random Gaussian, true real numbers e. and e.. and = 3
e_2dot = 4;

max_e_dot = max(e_dot,e_2dot);

c = calc_Function_C(alpha, sigma, e_dot, time_, t_k(end,1));

p = 1;              

while ((c*sens_SWAP_order_l(time_, r_t_T, ...
        p+1, alpha, sigma, F_0_tk, t_k, v_k, Nb_Swap)*(max_e_dot^(p+1)/factorial(p+1)))> rho)
    
            p = p+1;
end

y = p;

end