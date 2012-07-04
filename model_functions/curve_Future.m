function y = curve_Future(F_0_T,alpha,sigma,T_maturity)

dt = 7/360;

size_Vec = floor(T_maturity / dt);
vector_Future = zeros(size_Vec + 1,1);
index = 1;

% Calcul = F(t,T)
for i = 0 : dt : T_maturity
    
    % Time : t value
    time_ = i;
    
    vector_Future(index) = calc_future_t_T(time_, T_maturity, alpha, sigma,...
                                      calc_Epsilon(time_,alpha), F_0_T);
    index = index + 1;
end

y = vector_Future;

end