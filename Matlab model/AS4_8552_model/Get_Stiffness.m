function [K]=Get_Stiffness(fibreorient,E11f,E22f,G12f,G23f,v12f,Vf,Er,Gr,vr)


% calcuate effective material properties using SCFM

E33f=E22f;
G13f=G12f;
v13f=v12f;

kf=E22f/(2.*(1-v12f-2.*v12f.*v12f));

kr=Er./(2.*(1-vr-2.*vr.*vr));

kt=((kf+Gr).*kr+(kf-kr).*Gr.*Vf)./((kf+Gr)-(kf-kr).*Vf);

v12 = v12f.*Vf+vr.*(1-Vf)+((vr-v12f).*(kr-kf).*Gr.*(1-Vf).*Vf)./((kf+Gr).*kr+(kf-kr).*Gr.*Vf);

E11 = E11f.*Vf+Er.*(1-Vf)+(4.*(vr-v12f^2).*kf.*kr.*Gr.*(1-Vf).*Vf)./((kf+Gr).*kr+(kf-kr).*Gr.*Vf);

G12 = Gr.*((G12f+Gr)+(G12f-Gr).*Vf)./((G12f+Gr)-(G12f-Gr).*Vf);

G23 = (Gr.*(kr.*(Gr+G23f)+2.*G23f.*Gr+kr.*(G23f-Gr).*Vf))./(kr.*(Gr+G23f)+2.*G23f*Gr-(kr+2.*Gr).*(G23f-Gr).*Vf);

E22 = 1./(0.25./kt+0.25./G23+v12.*v12./E11);

v23 = (2.*E11.*kt-E11.*E22-4.*v12.*v12.*kt.*E22)./(2.*E11.*kt);

E33=E22;
G13=G12;
v13=v12;
v32=v23;
v21=v12.*E22./E11;
v31=v21;

%% evaluate stiffness matrix
aCons = 1/(1-v12*v21);
K = aCons*[E11,      v21*E11, 0;
           v12*E22,  E22,     0;
           0,       0,      G12/aCons];

%% evaluate transformation matrix Tr
c = cos(fibreorient);
s = sin(fibreorient);
Tr = [c^2,  s^2, -2*s*c;
      s^2,  c^2,  2*s*c;
      s*c, -s*c,  c^2-s^2];
% transformed stiffness matrix
K = Tr*K*Tr.';
end