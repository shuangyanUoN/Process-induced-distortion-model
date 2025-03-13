% =========================================================================
% Chemnically induced incremental strain in resins
% =========================================================================
function v = Chemical_strain_increment(dt,ydot,Vsh,Em,Vf,Ef,v12m,v12f)

incrCuring = dt*ydot;
incrV = incrCuring*Vsh; %incremental specific change in volume
incrStrain = nthroot((1+incrV),3)-1;% incremental isotropic shrinkage strain

% longitudinal strain increment
E1f = Ef;
dch1 = incrStrain*Em*(1-Vf)/(E1f*Vf+Em*(1-Vf));

% transverse strain increment
dch2 = (1+v12m)*incrStrain*(1-Vf)-(v12f*Vf+v12m*(1-Vf))*dch1;

v = [dch1,dch2];
end