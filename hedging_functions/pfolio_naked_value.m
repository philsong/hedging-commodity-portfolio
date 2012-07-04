function [y,b,cc] = pfolio_naked_value(Long_Instruments, Short_Instruments)

% Parametres du modele
order_l = 10;
Maturity_Months = 3;

[~, ~, alpha, sigma, epsilon, time_, ~,...
    ~, ~, ~, ~, r_t_T, ~, ~] = data_Initialization(Maturity_Months);

[F_0_T, maturity, S_0, Nb_Cash_Flow, v_k,...
    t_k, K, F_0_tk] = instrumentSpecificationFunc();

Nb_Long = size(Long_Instruments,1); % J**
Nb_Short = size(Short_Instruments,1); % J*

sens_0_long = 0; % Sommation des sens(0,V**).m**
sens_0_short = 0; % Sommation des sens(0,V*).m*
sens_l_long = 0; % Sommation des sens(l,V**).m**
sens_l_short = 0; % Sommation des sens(l,V*).m*

b = zeros(order_l+1,1);

% Determination de sens_0_long
for i = 1 : Nb_Long
    if isequal(Long_Instruments(i,2),1)
        
        sens_0_long = sens_0_long + sens_order_0(F_0_T(Long_Instruments(i,3)), alpha, ...
            sigma, time_, maturity(Long_Instruments(i,3)))*Long_Instruments(i,1);
        
    else if isequal(Long_Instruments(i,2),2)
            
            sens_0_long = sens_0_long + calc_sens_spot_0(time_, alpha, sigma, F_0_T(Long_Instruments(i,3)), S_0)...
                *Long_Instruments(i,1);
            
        else if isequal(Long_Instruments(i,2),3)
                
                sens_0_long = sens_0_long + sens_SWAP_order_0(time_, r_t_T,...
                    alpha, sigma, F_0_tk(Long_Instruments(i,3),:), K(Long_Instruments(i,3)), t_k(Long_Instruments(i,3),:), v_k(Long_Instruments(i,3),:), Nb_Cash_Flow(Long_Instruments(i,3)))...
                    *Long_Instruments(i,1);
                
            end
            
        end
        
    end
end

% Determination de sens_0_short
for i = 1 : Nb_Short
    if isequal(Short_Instruments(i,2),1)
        
        sens_0_short = sens_0_short + sens_order_0(F_0_T(Short_Instruments(i,3)), alpha, ...
            sigma, time_, maturity(Short_Instruments(i,3)))*Short_Instruments(i,1);
        
    else if isequal(Short_Instruments(i,2),2)
            
            sens_0_short = sens_0_short + calc_sens_spot_0(time_, alpha, sigma, F_0_T(Short_Instruments(i,3)), S_0)...
                *Short_Instruments(i,1);
            
        else if isequal(Short_Instruments(i,2),3)
                
                sens_0_long = sens_0_long + sens_SWAP_order_0(time_, r_t_T,...
                    alpha, sigma, F_0_tk(Short_Instruments(i,3),:), K(Short_Instruments(i,3)), t_k(Short_Instruments(i,3),:), v_k(Short_Instruments(i,3),:), Nb_Cash_Flow(Short_Instruments(i,3)))...
                    *Short_Instruments(i,1);
                
            end
            
        end
        
    end
end


%%%
temp1 = sens_0_long - sens_0_short;
b(1) = temp1;
%%%%

temp3 = 0;
for i = 1 : order_l
    % Determination de sens_l_long
    for j = 1 : Nb_Long
        if isequal(Long_Instruments(j,2),1)
            
            sens_l_long = sens_l_long + sens_order_L(F_0_T(Long_Instruments(j,3)), i, alpha, sigma, time_,...
                maturity(Long_Instruments(j,3)))*Long_Instruments(j,1);
            
        else if isequal(Long_Instruments(j,2),2)
                sens_l_long = sens_l_long + calc_sens_spot(time_, alpha, sigma, F_0_T(Long_Instruments(j,3)), i)...
                    *Long_Instruments(j,1);
            else if isequal(Long_Instruments(j,2),3)
                    
                    sens_l_long = sens_l_long + sens_SWAP_order_l(time_, r_t_T, i, ...
                        alpha, sigma, F_0_tk(Long_Instruments(j,3),:), t_k(Long_Instruments(j,3),:), v_k(Long_Instruments(j,3),:), Nb_Cash_Flow(Long_Instruments(j,3)))...
                        *Long_Instruments(j,1);
                    
                end
                
            end
            
        end
    end
    
    
    % Determination de sens_l_short
    for j = 1 : Nb_Short
        if isequal(Short_Instruments(j,2),1)
            sens_l_short = sens_l_short + sens_order_L(F_0_T(Short_Instruments(j,3)), i, alpha, sigma, time_,...
                maturity(Short_Instruments(j,3)))*Short_Instruments(j,1);
            
        else if isequal(Short_Instruments(j,2),2)
                sens_l_short = sens_l_short + calc_sens_spot(time_, alpha, sigma, F_0_T(Short_Instruments(j,3)), i)...
                    *Short_Instruments(j,1);
                
            else if isequal(Short_Instruments(j,2),3)
                    
                    sens_l_short = sens_l_short + sens_SWAP_order_l(time_, r_t_T, i, ...
                        alpha, sigma, F_0_tk(Short_Instruments(j,3),:), t_k(Short_Instruments(j,3),:), v_k(Short_Instruments(j,3),:), Nb_Cash_Flow(Short_Instruments(j,3)))...
                        *Short_Instruments(j,1);
                    
                end
                
            end
            
        end
    end
    
    %%%
    temp2 = sens_l_long - sens_l_short;
    b(i+1) = temp2;
    temp3 = temp3 + (((-1)^i)/factorial(i))*temp2*(epsilon)^i;
    %%%
end

cc = [temp1 temp3];

y = temp1 + temp3;

end

