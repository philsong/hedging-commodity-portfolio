function F = min_F2(n)

load('Minimization_F_coefficients','teta_Naked', 'teta_Hedging_short','epsilon_','order_l','v','D');

F = abs(teta_Naked(1) - teta_Hedging_short(1)*n);

for l = 1 : order_l
    f_temp = (1/factorial(l))*epsilon_^l...
        *abs(teta_Naked(l+1) - teta_Hedging_short(l+1)*n);
    
    F = F + f_temp;
end

end