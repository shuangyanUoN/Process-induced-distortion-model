clear all
close all

%% Pre-Processing
% Read Input File
ReadData;
VarNames=fieldnames(InputData);

for ivar=1:size(VarNames,1)
   eval([VarNames{ivar} '=' 'InputData.' VarNames{ivar} ';']); 
end

tmax = 75*60;      % total heat diffusion time [s]
nt = 75*60;        % number of time steps
timestep=1:1:nt;
time1=timestep/nt*75;
dt = tmax/nt;
E0 = 2.757;
E100 = 1000*E0;
Ef=73080;
E1f=73080;
    % isotropic plane strain bulk modulus of fibre
E1f = Ef;
kf = Ef/(2*(1-vf-2*vf*vf));
Gf = Ef/(2*(1+vf));
%% Start Analysis
alpha(1) = 0.0001;

for i1=1:nt-1     % update time step
    ydot = Curing(alpha(i1),Ac,Ea,R,373, m, n);
    alpha(i1+1) = alpha(i1)+dt*ydot;
    alphaa=alpha(i1+1);
    Em = (1-alphaa)*E0+alphaa*E100;
    Emm(i1+1)=Em/1000; %GPa
E1m = Em;
Gm = Em/(2*(1+vm));
G12m = Gm;
G23m = Gm;
G12f = Gf;
G23f = Gf;
v12m =vm;
v12f = vf;
    %%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%
    Eeff2(i1+1)=E2/1000; %GPa
    
end

figure (1)
plot(time1,Emm,'-')
hold all
plot(time1,Eeff2,'-.')
xlabel('Time [mins]');
ylabel('Young''s Modulus [GPa]');
legend('Resin modulus','Effective transverse modulus');
box on
xlim([0,70]);
ylim([0,9]);