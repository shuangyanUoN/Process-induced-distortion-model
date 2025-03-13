InputData.R = 8.3144598;   % universal gas constant [J/(mol*K)]
InputData.Vf = 0.54;     % fibre volume fraction

%% Initialisation parameters
InputData.dt = 0.2;    % s, r<0.5 so that the solution is stable
InputData.layer = 100;            % number of layers
InputData.thickness = 0.19e-3;      % nominal ply thickness [m]
InputData.dz = InputData.thickness*4;      % discretised thickness
InputData.nz = InputData.layer/4;
%% thermal properties
InputData.pho = 1570;     % effective composite material density [kg/m^3]
InputData.Cp_min = 857.41;      % specific heat (an estimate)
InputData.kz_max = 1.132;   % W/mC thermal contherductivity in through-thickness direction

%% MRCC
InputData.roomtemp = 25;
InputData.dwell1 = 110;
InputData.hold1 = 60;    % in mins
InputData.dwell2 = 180;
InputData.hold2 = 120;    % in mins
InputData.ramp1 = 1;    % degree/min
InputData.ramp2 = 1;
InputData.cooling = 5;
%% define fibre orientation at each lamina 
InputData.fibreorient=zeros(1,InputData.nz);    % UD laminates
%                      1  2  3  4  5   6  7  8  9  10 11 12 13 14 15 16
% InputData.fibreorient=[0 ,90, 0,90,0, 90, 0,90, 0, 90, 0,90, 0,90, 0,90,...
%                        90, 0,90, 0,90, 0,90, 0,90, 0, 90, 0,90, 0,90, 0];  % 32

%% Cure kinetic constants
InputData.Ht = 574000;  % total heat of reaction
InputData.Ea = 65000;   % activation energy
InputData.A = 70000;    % pre-exponential cure rate coefficient
InputData.m = 0.5;      % reaction orders determined experimentally
InputData.n = 1.5;      % reaction orders determined experimentally
InputData.C = 30;       % diffusion constant
InputData.a_C0 = -1.5148;   % critical DoC at T=0K
InputData.a_CT = 5.171e-3;  % constant accounting for temperature dependence

%% fibre properties
InputData.E11f=228000e6;
InputData.E22f=17200e6;
InputData.E33f=17200e6;
InputData.G12f=27600e6;
InputData.G13f=27600e6;
InputData.G23f=5730e6;
InputData.v12f=0.2;
InputData.v13f=0.2;
InputData.v23f=0.5;

%% resin properties
InputData.Er0=4.67e6;
InputData.Er100=4670e6;
InputData.vr0=0.4999;
InputData.vr100=0.37;
InputData.Gr0=11e6;
InputData.Gr100=1704e6;
InputData.alpha_gel = 0.31;
InputData.alpha_vir = 0.88;

%% CHILE model for resin 8552 (Johnston et al)
InputData.Tc1 = -45.7;         % prior to Tc1, Er=Er0 [K]
% InputData.Tc1b = 0.0;           % accounts for the variation in slope of dEr/dT* curve seen in tests on other materials [K]
InputData.Tc2 = -12;            % after Tc2, Er=Er0 [K]

%% thermal and chemical strain (UD)
% InputData.ch1 = 0.0;        % fibre direction   
InputData.ch1 = 0.48e-2;    % transverse direction
InputData.ch2 = 0.48e-2;    % transverse direction
% InputData.cte1 = 0.0;       % fibre direction    
InputData.cte1 = 31e-6;       % fibre direction    
InputData.cte2 = 31e-6;     % transverse direction