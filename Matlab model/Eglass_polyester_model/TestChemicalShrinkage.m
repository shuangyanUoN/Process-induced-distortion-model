clear all
close all

%% Pre-Processing
% Read Input File
ReadData;

VarNames=fieldnames(InputData);

for ivar=1:size(VarNames,1)
   eval([VarNames{ivar} '=' 'InputData.' VarNames{ivar} ';']); 
end

tmax = 150*60;      % total heat diffusion time [s]
nt = 150*60;        % number of time steps
timestep=1:1:nt;
time1=timestep/nt*150;
dt = tmax/nt;
E0 = 2.757;
E100 = 1000*E0;
Ef=73080;
E1f=73080;
%% Start Analysis
alpha(1) = 0.00001;
Strain1T(1) = 0;
Strain2T(1) = 0;
for i1=1:nt-1     % update time step
    ydot = Curing(alpha(i1),Ac,Ea,R,(273.15+100), m, n);
    alpha(i1+1) = alpha(i1)+dt*ydot;
    Em(i1+1,:) = (1-alpha(i1+1))*E0+alpha(i1+1)*E100;
    dch(i1+1,:)= Chemical_strain_increment(dt,ydot,Vsh,Em(i1+1),Vf,E1f,v12m,v12f);
    dch1=dch(i1+1,1);
    dch2=dch(i1+1,2);
    Strain1T(i1+1) = Strain1T(i1)-dch1;
    Strain2T(i1+1) = Strain2T(i1)-dch2;
end

    figure (1)
    plot(time1,Strain1T*100,'-')
    hold on
    plot(time1,Strain2T*100,'-.')
    xlim([0 150]);
    xlabel('Time [mins]');
    ylabel('Chemical Shrinkage Strain [%]');
    legend('Longitudinal','Transverse');