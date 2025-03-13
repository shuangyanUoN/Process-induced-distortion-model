% =========================================================================
% Thermally induced incremental strain in resins
% =========================================================================
function [dth1, dth2] = Thermal_strain_increment(alpha,alpha_vir,T2,T1,cte1,cte2)


% thermal shrinakge th2=31.0e-6
% thermal shrinakge happens in between resin gelation and virtrification


    dT = T2-T1;     % incremental temperature

if alpha > alpha_vir
    dth1 = cte1*dT;
    dth2 = cte2*dT;
else
    dth1 = 0;
    dth2 = 0;
end


end
    
    








