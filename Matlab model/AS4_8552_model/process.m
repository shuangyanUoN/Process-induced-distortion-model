
clearvars
close all

%% Pre-Processing
% Read Input File
ReadData_AS48552;

% get variables from InputData file
VarNames=fieldnames(InputData);
for ivar=1:size(VarNames,1)
   eval([VarNames{ivar} '=' 'InputData.' VarNames{ivar} ';']); 
end

% Prepare Analysis
[iexit,z,z1,dt,r]=Initialisations(nz,dz,pho,Cp_min,kz_max,dt);
% Boundary Conditions
[nt,T] = Autoclave_BC(dwell1,dwell2,roomtemp,ramp1,ramp2,cooling,hold1,hold2,nz,dt);
% initialise parameters
alpha = 0.00001*ones(nz,nt);  % initial curing degree
cure_rate = zeros(nz,nt);
Er = zeros(nz,nt);
Gr = zeros(nz,nt);
vr = zeros(nz,nt);
dch = zeros(nz,2);
dth = zeros(nz,2);
StrainPr = zeros(nz,3);
StressPr = zeros(nz,3);
NM = zeros(nz,6);
Stress = zeros(3,nz);

%% Start Analysis        
for i1=1:nt-1     % update time step
    for i2=1:nz    % update layers
        %% Cure kinetics
        [cure_rate(i2,i1)] = Cure_kinetics(alpha(i2,i1), A, Ea, R, T(i2,i1), m, n, a_C0, a_CT, C);
        [alpha(i2,i1+1),T(i2,i1+1)] = Cure_Process(alpha(i2,i1),cure_rate(i2,i1),T,i1,i2,dt,nz,pho,Ht,dz);
        
        %% calculate resin properties
        [Er(i2,i1+1),Gr(i2,i1+1),vr(i2,i1+1)] = CHILE_model(alpha(i2,i1+1),T(i2,i1+1),Tc1,Tc2,Er0,Er100,Gr0,Gr100,vr0,vr100);
        
        %% Continuous fibre micromechanics
        [K{i2,i1+1}] = Get_Stiffness(fibreorient(i2),E11f,E22f,G12f,G23f,v12f,Vf,Er(i2,i1+1),Gr(i2,i1+1),vr(i2,i1+1));

        %% Process-induced strain increments
        dch(i2,:) = Chemical_strain_increment(alpha(i2,i1+1),alpha_gel,alpha_vir,cure_rate(i2,i1),dt,ch1,ch2);
        dth(i2,:) = Thermal_strain_increment(alpha(i2,i1+1),alpha_vir,T(i2,i1+1),T(i2,i1),cte1,cte2);

        %% Total Process-induced Stresses and Strains                                                       
        [StrainPr(i2,:),StressPr(i2,:)] = Get_Strains_Stresses(fibreorient(i2),dch(i2,:),dth(i2,:),K{i2,i1+1});

        %% Effective plate force & moment increments
        NM(i2,:)=Get_force_moment_increments(StressPr(i2,:),z,z1,i2);

    end
    %% Laminate global strain and curvature
    Re = Get_strain_and_curvature(NM,K,z,nz,i1);

    %% Laminate ply strains and stresses increments   
    StressEl = Get_Ply_Stresses(Re,StrainPr,K,z1,i1,nz);
    % Laminate ply strains and stresses 
    Stress = Stress + StressEl;

end

%% Post-processing
draw_graphs;