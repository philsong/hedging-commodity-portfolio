function y = calc_Order_l2(alpha, sigma, time_, T_maturity, F_0_T, type, rho, e_dot, e_2dot)
% Description : calcul de l'ordre requis -
% Formule (32)

% Initialization
%rho = 10^-12;
%e_dot = 3; % Eps standard random Gaussian, true real numbers e. and e.. and = 3
%e_2dot = 3;

max_e_dot = max(e_dot,e_2dot);

% Func : c (20)
c = calc_Function_C(alpha,sigma,e_dot,time_,T_maturity);

% Calculate p (32)
p=1;


if isequal(type,'Spot')
    while ((c*calc_sens_spot(time_, alpha, sigma, F_0_T, p+1)*(max_e_dot^(p+1)/factorial(p+1)))...
            > rho)
        p = p+1;
    end
else if isequal(type, 'Future')
        while ((c*sens_order_L(F_0_T, p+1, alpha, sigma, time_,...
                               T_maturity)*(max_e_dot^(p+1)/factorial(p+1)))> rho)
            p = p+1;
        end
    end
end

y = p;

end