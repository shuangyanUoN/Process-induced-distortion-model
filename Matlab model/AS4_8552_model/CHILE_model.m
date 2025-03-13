% CHILE model (Johnston et al)
function [Er,Gr,vr] = CHILE_model(alpha,T,Tc1,Tc2,Er0,Er100,Gr0,Gr100,vr0,vr100)
%     Tg = 164.6*alpha^2+51.0*alpha+2.67; %[C] Ersoy et al (2005)
    Tg = 268 + 220*alpha-273.15;   % [C] Johnston (1997)
    Td = Tg-T;
    
    if Td < Tc1
        Er = Er0;
        Gr = Gr0;
        vr = vr0;
        elseif (Tc1 < Td) & (Td < Tc2)
            Er = Er0 + (Td-Tc1)/(Tc2-Tc1)*(Er100-Er0);
            vr = vr0 + (Td-Tc1)/(Tc2-Tc1)*(vr100-vr0);
            Gr = Gr0 + (Td-Tc1)/(Tc2-Tc1)*(Gr100-Gr0);
    else
        Er = Er100;
        vr = vr100;
        Gr = Gr100;
    end
end