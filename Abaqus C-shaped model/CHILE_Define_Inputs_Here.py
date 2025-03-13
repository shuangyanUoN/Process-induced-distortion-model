## ============================================== ##
##          C-section curved AS4/8552 part        ##
## ============================================== ##

## ============================================== ##
##               Geometry features                ##
## ============================================== ##
pi = 3.14159265
thickness = 0.25e-3                 # ply thickness [m]
angle_degree = 135                  # angle in degree
TubeRadius = 25e-3                  # outer radius of the part         
depth = TubeRadius/2                # width of the part
## ============================================== ##
##        Thermal & Chemical shrinkage            ##
## ============================================== ##
ndepar = 20
V_f = 57.42e-2
DoC_max = 0.914
# # thermal shrinkage (unidirectional)
# a11 = 0.0                           # coef. of thermal expansion [/C]
# a22 = 32.6e-6                       # coef. of thermal expansion [/C]
# a33 = a22                           # coef. of thermal expansion [/C]
# # chemical shrinkage (unidirectional)
# c11 = 0.0                           # percentage shrinakge [100%]
# c22 = 0.48e-2                       # percentage shrinakge [100%]
# c33 = c22                           # percentage shrinakge [100%]
# thermal shrinkage (cross-ply)
a11 = 0.0                         # coef. of thermal expansion [/C]
a22 = 0.0                         # coef. of thermal expansion [/C]
a33 = 42.5e-6                     # coef. of thermal expansion [/C]
# chemical shrinkage (cross-ply)
c11 = 0.0                         # percentage shrinakge [100%]
c22 = 0.0                         # percentage shrinakge [100%]
c33 = 0.98e-2                     # percentage shrinakge [100%]
## ============================================== ##
##                Thermal properties              ##
## ============================================== ##
rho = 1580.0                        # effective composite material density [kg/m^3]
k33 = 0.50                          # thermal conductivity [W/mK]
Cp = 1350.0                         # specific heat [J/kg K]
Cp_uncured = 1450.0              #specific heat [J/kg K]
Cp_cured = 1250.0
## ============================================== ##
##       Processing temperature and pressure   	  ##
## ============================================== ##
predefined_temp = 0.0
MRCC = ((0.0, 20.0), (50*60,120), (110*60,120.0), 
    (140*60,180.0), (260*60,180.0), (340*60,20.0))      # MRCC (time-temp)
totalPeriod = 340*60
pressure=0.7e6
## ============================================== ##
##                      Mesh                      ##
## ============================================== ##
seedPartSize = 0.0005
seedEdgeNumber = 1

