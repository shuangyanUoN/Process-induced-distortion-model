% =========================================================================
% Thermally induced incremental strain in resins
% =========================================================================
function v = Thermal_strain_increment(a1f,Ef,Vf,am,Em,T2,T1,v12f,v12m)

    a2f = a1f;
    
    a1cte = (a1f*Ef*Vf+am*Em*(1-Vf))/(Ef*Vf+Em*(1-Vf));

    a2cte = (a2f+v12f*a1f)*Vf+(am+v12m*am)*(1-Vf)-(v12f*Vf+v12m*(1-Vf))*a1cte;
    
    dT = T2-T1;     % incremental temperature
    dth1 = a1cte*dT;
    dth2 = a2cte*dT;
    
    v = [dth1, dth2];

end
    
    








