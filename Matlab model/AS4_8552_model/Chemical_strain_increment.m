% =========================================================================
% Chemnically induced incremental strain in resins
% =========================================================================
function [dch1,dch2] = Chemical_strain_increment(alpha,alpha_gel,alpha_vir,ydot,dt,ch1,ch2)

% chemcial shrinakge for XP ch1=0.48e-2; ch2=0.48e-2
% chemical shrinakge happens in between resin gelation and virtrification

dalpha = ydot*dt;

if alpha < alpha_gel
    dch1 = 0;
    dch2 = 0;
elseif (alpha > alpha_gel) && (alpha < alpha_vir) 
    dch1 = dalpha/(alpha_vir-alpha_gel)*ch1;
    dch2 = dalpha/(alpha_vir-alpha_gel)*ch2;
else
    dch1 = 0;
    dch2 = 0;
end