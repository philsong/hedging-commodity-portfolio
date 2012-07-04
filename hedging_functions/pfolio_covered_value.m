function [y,v,c] = pfolio_covered_value(Long_Instruments_H,Short_Instruments_H)

% Parametres du modele
order_l = 10;
Maturity_Months = 3;

[~, ~, alpha, sigma, epsilon, time_, ~,...
    ~, ~, ~, ~, r_t_T, ~, phi] = data_Initialization(Maturity_Months);

[F_0_T, maturity, S_0, Nb_Cash_Flow, v_k,...
    t_k, K, F_0_tk] = instrumentSpecificationFunc();

Nb_Long_H = size(Long_Instruments_H,1); % I**
Nb_Short_H = size(Short_Instruments_H,1); % I*

lambda_init_long = 0.25;
lambda_init_short = 0.25;

lambda_long = calc_lambda(phi, lambda_init_long, time_, r_t_T);
lambda_short = calc_lambda(phi, lambda_init_short, time_, r_t_T);

teta_0_long = 0; % ?((1-phi).sens(0,H**)-lambda**.H**).n**
teta_0_short = 0; % ?((1+phi).sens(0,H*)+lambda*.H*).n*
teta_l_long = 0; % ?(1-phi).sens(L,H**).n**
teta_l_short = 0; % ?(1+phi).sens(L,H*).n*

v = zeros(Nb_Long_H+Nb_Short_H,1); % v** et v* coefficients sur le vecteur solution qui permet de modéliser la contrainte du problème de minimisation

A = zeros(Nb_Long_H+Nb_Short_H,order_l+1); % Matrice qui coefficiente le vecteur inconnu pour le problème de minimisation
Abis = ones(Nb_Long_H+Nb_Short_H,order_l+1); % Matrice qui coefficiente le vecteur inconnu pour le problème de minimisation

for i = 1 : size(Abis,1)
    for j = 2 : size(Abis,2)
        Abis(i,j) = 1/(j-1) * epsilon^(j-1);
    end
end

% Determination de teta_0_long

for i = 1 : Nb_Long_H
    if isequal(Long_Instruments_H(i,2),1)
        teta_0_long_temp = ((1-phi)*sens_order_0(F_0_T(Long_Instruments_H(i,3)), alpha, ...
            sigma, time_, maturity(Long_Instruments_H(i,3)))-lambda_long*calc_future_t_T(time_, maturity(Long_Instruments_H(i,3)),...
                                                                alpha, sigma, epsilon,F_0_T(Long_Instruments_H(i,3))));
        
        %%%
        teta_0_long = teta_0_long + teta_0_long_temp*Long_Instruments_H(i,1);
        A(i,1) = - teta_0_long_temp;
        %%%
        
        %%%
        v(i) = lambda_init_long*((1/calc_P_t_T(r_t_T, time_, maturity(Long_Instruments_H(i,3))))-1)*...
            calc_future_t_T(time_, maturity(Long_Instruments_H(i,3)),...
            alpha, sigma, epsilon,F_0_T(Long_Instruments_H(i,3)));
        %%%
        
    else if isequal(Long_Instruments_H(i,2),2)
        teta_0_long_temp = ((1-phi)*calc_sens_spot_0(time_, alpha, sigma, F_0_T(Long_Instruments_H(i,3)), S_0)...
                                  - lambda_long*calc_spot_t(time_, alpha, sigma, epsilon, F_0_T(Long_Instruments_H(i,3))));
        
        %%%
        teta_0_long = teta_0_long + teta_0_long_temp*Long_Instruments_H(i,1);
        A(i,1) = - teta_0_long_temp;
        %%%
        
        %%%
        v(i) = lambda_init_long*((1/calc_P_t_T(r_t_T, time_, maturity(Long_Instruments_H(i,3))))-1)*...
                  calc_spot_t(time_, alpha, sigma, epsilon, F_0_T(Long_Instruments_H(i,3)));
        %%%
        
        else if isequal(Long_Instruments_H(i,2),3)
                teta_0_long_temp = ((1-phi)*sens_SWAP_order_0(time_, r_t_T,...
                    alpha, sigma, F_0_tk(Long_Instruments_H(i,3),:), K(Long_Instruments_H(i,3)), t_k(Long_Instruments_H(i,3),:),...
                    v_k(Long_Instruments_H(i,3),:), Nb_Cash_Flow(Long_Instruments_H(i,3))) - lambda_long*...
                    calc_SWAP_t(alpha, sigma, time_, epsilon, r_t_T, K(Long_Instruments_H(i,3)),...
                    F_0_tk(Long_Instruments_H(i,3),:), t_k(Long_Instruments_H(i,3),:),...
                    v_k(Long_Instruments_H(i,3),:), Nb_Cash_Flow(Long_Instruments_H(i,3))));
                
                %%%
                teta_0_long = teta_0_long + teta_0_long_temp*Long_Instruments_H(i,1); 
                A(i,1) = - teta_0_long_temp;
                %%%
                
                %%%
                v(i) = lambda_init_long*((1/calc_P_t_T(r_t_T, time_, maturity(Long_Instruments_H(i,3))))-1)*...
                      calc_SWAP_t(alpha, sigma, time_, epsilon, r_t_T, K(Long_Instruments_H(i,3)),...
                      F_0_tk(Long_Instruments_H(i,3),:), t_k(Long_Instruments_H(i,3),:),...
                      v_k(Long_Instruments_H(i,3),:), Nb_Cash_Flow(Long_Instruments_H(i,3)));
                %%%
                
            end
        end
    end
end
    

% Determination de teta_0_short

for i = 1 : Nb_Short_H
    if isequal(Short_Instruments_H(i,2),1)
        teta_0_short_temp = ((1+phi)*sens_order_0(F_0_T(Short_Instruments_H(i,3)), alpha, ...
            sigma, time_, maturity(Short_Instruments_H(i,3)))+lambda_short*calc_future_t_T(time_, maturity(Short_Instruments_H(i,3)),...
                                                                alpha, sigma, epsilon,F_0_T(Short_Instruments_H(i,3)))...
                                                                );
        %%%                                           
        teta_0_short = teta_0_short + teta_0_short_temp*Short_Instruments_H(i,1);
        A(i+Nb_Long_H,1) = teta_0_short_temp;
        %%%
        
        %%%
        v(i+Nb_Long_H) = lambda_init_short*((1/calc_P_t_T(r_t_T, time_, maturity(Short_Instruments_H(i,3))))-1)*...
            calc_future_t_T(time_, maturity(Short_Instruments_H(i,3)),...
            alpha, sigma, epsilon,F_0_T(Short_Instruments_H(i,3)));   
        %%%
                                                            
    else if isequal(Short_Instruments_H(i,2),2)
            teta_0_short_temp = ((1+phi)*calc_sens_spot_0(time_, alpha, sigma, F_0_T(Short_Instruments_H(i,3)), S_0)...
                                  + lambda_short*calc_spot_t(time_, alpha, sigma, epsilon, F_0_T(Short_Instruments_H(i,3))));
        
        %%%
        teta_0_short = teta_0_short + teta_0_short_temp*Short_Instruments_H(i,1);
        A(i+Nb_Long_H,1) = teta_0_short_temp;
        %%%
        
        %%%
        v(i+Nb_Long_H) = lambda_init_short*((1/calc_P_t_T(r_t_T, time_, maturity(Short_Instruments_H(i,3))))-1)*...
                calc_spot_t(time_, alpha, sigma, epsilon, F_0_T(Short_Instruments_H(i,3)));
        %%%
        
        else if isequal(Short_Instruments_H(i,2),3)
                teta_0_short_temp = ((1+phi)*sens_SWAP_order_0(time_, r_t_T,...
                    alpha, sigma, F_0_tk(Short_Instruments_H(i,3),:), K(Short_Instruments_H(i,3)), t_k(Short_Instruments_H(i,3),:),...
                    v_k(Short_Instruments_H(i,3),:), Nb_Cash_Flow(Short_Instruments_H(i,3))) + lambda_short*...
                    calc_SWAP_t(alpha, sigma, time_, epsilon, r_t_T, K(Short_Instruments_H(i,3)),...
                    F_0_tk(Short_Instruments_H(i,3),:), t_k(Short_Instruments_H(i,3),:),...
                    v_k(Short_Instruments_H(i,3),:), Nb_Cash_Flow(Short_Instruments_H(i,3))));
                
                %%%
                teta_0_short = teta_0_short + teta_0_short_temp*Short_Instruments_H(i,1);
                A(i+Nb_Long_H,1) = teta_0_short_temp;
                %%%
                
                %%%
                 v(i+Nb_Long_H) = lambda_init_short*((1/calc_P_t_T(r_t_T, time_, maturity(Short_Instruments_H(i,3))))-1)*...
                      calc_SWAP_t(alpha, sigma, time_, epsilon, r_t_T, K(Short_Instruments_H(i,3)),...
                      F_0_tk(Short_Instruments_H(i,3),:), t_k(Short_Instruments_H(i,3),:),...
                      v_k(Short_Instruments_H(i,3),:), Nb_Cash_Flow(Short_Instruments_H(i,3)));
                %%%
                
            end
        end
    end
end

temp1 = teta_0_long - teta_0_short;

temp3 = 0;
for i = 1 : order_l
    % Determination de teta_l_long
    for j = 1 : Nb_Long_H
        if isequal(Long_Instruments_H(j,2),1)
            teta_l_long_temp = (1-phi)*sens_order_L(F_0_T(Long_Instruments_H(j,3)), i, alpha, sigma, time_,...
                maturity(Long_Instruments_H(j,3)));
            
            %%%
            teta_l_long = teta_l_long + teta_l_long_temp*Long_Instruments_H(j,1);
            A(j,i+1) = - teta_l_long_temp;
            %%%
            
        else if isequal(Long_Instruments_H(j,2),2)
                teta_l_long_temp = (1-phi)*calc_sens_spot(time_, alpha, sigma, F_0_T(Long_Instruments_H(j,3)), i);
                
                %%%
                teta_l_long = teta_l_long + teta_l_long_temp*Long_Instruments_H(j,1);
                A(j,i+1) = - teta_l_long_temp;
                %%%
                
            else if isequal(Long_Instruments_H(j,2),3)
                    teta_l_long_temp = (1-phi)*sens_SWAP_order_l(time_, r_t_T, i, ...
                        alpha, sigma, F_0_tk(Long_Instruments_H(j,3),:), t_k(Long_Instruments_H(j,3),:),...
                        v_k(Long_Instruments_H(j,3),:), Nb_Cash_Flow(Long_Instruments_H(j,3)));
                    
                    %%%
                    teta_l_long = teta_l_long + teta_l_long_temp*Long_Instruments_H(j,1);
                    A(j,i+1) = - teta_l_long_temp;
                    %%%
                    
                end    
            end
        end
    end
    
    
    % Determination de teta_l_short
    for j = 1 : Nb_Short_H
        if isequal(Short_Instruments_H(j,2),1)
            teta_l_short_temp = (1+phi)*sens_order_L(F_0_T(Short_Instruments_H(j,3)), i, alpha, sigma, time_,...
                maturity(Short_Instruments_H(j,3)));
            
            %%%
            teta_l_short = teta_l_short + teta_l_short_temp*Short_Instruments_H(j,1);
            A(j+Nb_Long_H,i+1) = teta_l_short_temp;
            %%%
            
        else if isequal(Short_Instruments_H(j,2),2)
                teta_l_short_temp = (1+phi)*calc_sens_spot(time_, alpha, sigma, F_0_T(Short_Instruments_H(j,3)), i);
                
                %%%
                teta_l_short = teta_l_short + teta_l_short_temp*Short_Instruments_H(j,1);
                A(j+Nb_Long_H,i+1) = teta_l_short_temp;
                %%%
                
            else if isequal(Short_Instruments_H(j,2),3)
                    teta_l_short_temp = (1+phi)*sens_SWAP_order_l(time_, r_t_T, i, ...
                        alpha, sigma, F_0_tk(Short_Instruments_H(j,3),:), t_k(Short_Instruments_H(j,3),:),...
                        v_k(Short_Instruments_H(j,3),:), Nb_Cash_Flow(Short_Instruments_H(j,3)));
                    
                    %%%
                    teta_l_short = teta_l_short + teta_l_short_temp*Short_Instruments_H(j,1);
                    A(j+Nb_Long_H,i+1) = teta_l_short_temp;
                    %%%
                    
                end   
            end       
        end
    end
    
    temp2 = teta_l_long - teta_l_short;
    
    
    temp3 = temp3 + (((-1)^i)/factorial(i))*temp2*(epsilon)^i;
end

y = temp1 + temp3;

Anubis= (A.*Abis)';

A = A';
c = sum(Anubis,1);

end


