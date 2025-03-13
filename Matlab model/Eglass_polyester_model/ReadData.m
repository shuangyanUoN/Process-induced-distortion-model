InputData.R = 8.3144598;   % universal gas constant [J/(mol*K)]
InputData.pho = 1890;     % effective composite material density [kg/m^3]
InputData.Cp = 1260;      % specific heat
InputData.kz = 0.2163;   % thermal conductivity in through-thickness direction

% Define constants
InputData.tmax = 400*60;      % total heat diffusion time [s]
InputData.nz = 30;            % number of layers
InputData.nt = 400*60;        % number of time steps
InputData.timestep=1:1:InputData.nt;

% define laminate thickness
% InputData.L = 0.0254;      % total thickness [m]
InputData.Llist = [0.0138,0.0185,0.0254,0.0508];
% Cure kinetic and chemical shrinkage parameters of polyester resin
InputData.m = 0.524;      % reaction orders determined experimentally
InputData.n = 1.476;      % reaction orders determined experimentally
InputData.Ac = 6.167e20;  % pre-exponential factor [1/s]
InputData.Ea = 1.674e5;  % apparent activation energy of the cure reaction [J/mol]
InputData.Hr = 77.5e3;   % reaction enthalpy of polyester resin [J/kg]
InputData.Vsh = 0.06;
% InputData.Vshlist = [0.06,0.03,0.01,0.0];
InputData.Vf = 0.54;     % fibre volume fraction

% Glass fibre properties
%InputData.Ef = 7.308e4;
InputData.Ef = ones(InputData.nz)*7.308e4;
InputData.vf = 0.22;
InputData.v12f = InputData.vf; 
InputData.v13f = InputData.vf; 
InputData.v23f = InputData.vf;
InputData.Gf = 2.992e4;
InputData.a1f = 5.04e-6; 
InputData.a2f = InputData.a1f;

% Polyester properties
% InputData.E100 = 2.757e3;% fully cured resin modulus [MPa]
InputData.E100 = ones(InputData.nz)*2.757e3;
InputData.vm = 0.40; 
InputData.v12m = InputData.vm;
InputData.am = 7.20e-5;

% define fibre orientation at each lamina
 InputData.angl = zeros(1,InputData.nz);
