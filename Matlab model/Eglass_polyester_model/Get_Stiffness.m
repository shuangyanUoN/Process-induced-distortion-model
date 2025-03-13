function [Em,K]=Get_Stiffness(angle,alpha,E100,Ef,vm,vf,Vf)

% isotropic plane strain bulk modulus of fibre
E1f = Ef;
kf = Ef/(2*(1-vf-2*vf*vf));
Gf = Ef/(2*(1+vf));
E0 = E100/1000;
Em = (1-alpha)*E0+alpha*E100;
E1m = Em;
Gm = Em/(2*(1+vm));
G12m = Gm;
G23m = Gm;
G12f = Gf;
G23f = Gf;
v12m =vm;
v12f = vf;
% isotropic plane strain bulk modulus of resin
km = Em/(2*(1-vm-2*vm*vm));
% major Poisson's ratio
v12 = v12f*Vf+v12m*(1-Vf)+((v12m-v12f)*(km-kf)*G23m*(1-Vf)*Vf)/ ...
                                        ((kf+G23m)*km+(kf-km)*G23m*Vf);
% inplane shear modulus
G12 = G12m*((G12f+G12m)+(G12f-G12m)*Vf)/((G12f+G12m)-(G12f-G12m)*Vf);
% transverse shear modulus
G23 = (G23m*(km*(G23m+G23f)+2*G23f*G23m+km*(G23f-G23m)*Vf))/ ...
            (km*(G23m+G23f)+2*G23f*G23m-(km+2*G23m)*(G23f-G23m)*Vf);
% effective plane strain bulk modulus of the composite
kt = ((kf+G23m)*km+(kf-km)*G23m*Vf)/((kf+G23m)-(kf-km)*Vf);
% longitudinal Young's modulus
E1 = E1f*Vf+E1m*(1-Vf)+(4*(v12m-v12f^2)*kf*km*G23m*(1-Vf)*Vf)/ ...
                       ((kf+G23m)*km+(kf-km)*G23m*Vf);
% transverse Young's modulus
E2 = 1/(0.25/kt+0.25/G23+v12*v12/E1);

% evaluate stiffness matrix
v21 = E2*v12/E1;
%v21 = v12;
aCons = 1/(1-v12*v21);
K = aCons*[E1,      v21*E1, 0;
           v12*E2,  E2,     0;
           0,       0,      G12/aCons];
% evaluate transformation matrix Tr

c = cos(angle);
s = sin(angle);
Tr = [c^2,  s^2, -2*s*c;
      s^2,  c^2,  2*s*c;
      s*c, -s*c,  c^2-s^2];
% transformed stiffness matrix
K = Tr*K*Tr.';
    
end