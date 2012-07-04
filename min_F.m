function F = min_F(n)

load('Minimization_F_coefficients','teta_0_Naked_Long', 'teta_Hedging_0_short','teta_l_Naked_Long','teta_Hedging_l_short','epsilon','Max_Order','v','D');

F = abs(teta_0_Naked_Long - teta_Hedging_0_short*[n(1);n(2);n(3)]);

for l = 1 : Max_Order
    f_temp = (1/factorial(l))*abs(epsilon)^l...
        *abs(teta_l_Naked_Long(l) - teta_Hedging_l_short(l,:)*[n(1);n(2);n(3)]);
    
    F = F + f_temp;
end

end