function [iexit, Output]=process(InputData)

VarNames=fieldnames(InputData);

for ivar=1:size(VarNames,1)
   eval([VarNames{ivar} '=' 'InputData.' VarNames{ivar} ';']); 
end

% Prepare Analysis
[iexit,z,z1,dt,r]=Initialisations(L,nz,nt,kz,pho,Cp,tmax);
% Boundary Conditions
Boundary_Conditions;
% initialise everything
alpha = 0.00001*ones(nz,nt);  % initial curing degree
Em = zeros(nz,nt);
dch = zeros(nz,2);
dth = zeros(nz,2);
StrainPr = zeros(nz,3);
StressPr = zeros(nz,3);
NM = zeros(nz,6);
Stress = zeros(3,nz);
%% Start Analysis        
for i1=1:nt-1     % update time step
    for i2=1:nz    % update layers
        %% Cure kinemtics
        [ydot(i2,i1+1),alpha(i2,i1+1),T(i2,i1+1)]=Curring_Process(alpha(i2,i1),Ac,Ea,R,T, m, n,i1,i2,dt,nz,pho,Hr,Cp,r);
        %% Continuous fibre micromechanics
        [Em(i2,i1+1),K{i2,i1+1}]=Get_Stiffness(angl(i2),alpha(i2,i1+1),E100(i2),Ef(i2),vm,vf,Vf);
        %% Process-induced strain increments
        dch(i2,:) = Chemical_strain_increment(dt,ydot(i2,i1+1),Vsh,Em(i2,i1+1),Vf,Ef(i2),v12m,v12f);
        dth(i2,:) = Thermal_strain_increment(a1f,Ef(i2),Vf,am,Em(i2,i1+1),T(i2,i1+1),T(i2,i1),v12f,v12m);
        %% Total Process-induced Stresses and Strains                                                       
        [StrainPr(i2,:),StressPr(i2,:)]=Get_Strains_Stresses(angl(i2),dch(i2,:),dth(i2,:),K{i2,i1+1});
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
%% To post-Processing
Output.T=T;
Output.Stress=Stress;
Output.alpha=alpha;
end