
function cure_rate = Cure_kinetics(alpha, A, Ea, R, T, m, n, a_C0, a_CT, C) 

K=A*exp(-Ea/(R*T));

a_C = a_C0+a_CT*T;


cure_rate = K*alpha.^m.*(1-alpha).^n/(1+exp(C*(alpha-a_C)));


end