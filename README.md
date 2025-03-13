# Process-induced-distortion-model
Complementary paper can be found here: https://doi.org/10.1016/j.compstruct.2025.119022

Simplified model for the tool-part interaction in spring-in of L-shape composite laminates


# How to use the Abaqus model
1. Download all three files and put them in the same folder

2. Open CHILE_Curved_Part_3D.py, change work directory to your current folder

3. Change path of your subroutine file, that's the 'chile_addme.for' file

4. Run CHILE_Curved_Part_3D.py in Abaqus via 'File > Run script'

5. The simulation results can be compared with the experimental findings presented here: https://doi.org/10.1016/j.compositesa.2009.11.008 

# How to use Matlab model
1. Download all the files and put them in the same folder

2.1 For AS4/8552 model, execute main file: process.m

2.2 For Eglass/polyester model, execute main file: main.m

3. The results can be compared with the numerical predictions presented here: https://doi.org/10.1177/002199839202600502
