% this is a 1d thermomechanical model for the calculation of in-plane
% process-induced residual stresses and strains during curing, driven by
% through-thickness temperature and cure gradients within a laminate plate

clearvars
close all

%% Pre-Processing
% Read Input File
ReadData;
% a switch to change boundary condition (0=Standard;1=test cure cycle)
InputData.control=0;
%% Processing

for iC=1:4
%     InputData.Vsh=InputData.Vshlist(iC); 
      InputData.L=InputData.Llist(iC); 
%     InputData.iTempSwitch=iC;
    [iexit, Output]=process(InputData);
    Temp{iC}= Output.T-273.15;
    Sigma{iC} = Output.Stress(2,:);
    Alpha{iC} = Output.alpha;
end
%% Post-Processing
draw_graphs;
