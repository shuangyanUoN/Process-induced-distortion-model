
function v = Curing(y, Ac, Ea, R, T, m, n) 

v=Ac*exp(-Ea/(R*T))*y.^m.*(1-y).^n;

end