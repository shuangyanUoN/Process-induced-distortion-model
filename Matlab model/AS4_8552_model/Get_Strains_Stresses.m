function [StrainT,StressT]=Get_Strains_Stresses(angl,dch,dth,K)
         
        StrainPr1 = dch(1)+dth(1);   % longitudinal normal strain
        StrainPr2 = dch(2)+dth(2);   % transverse normal strain  
        
        c = cos(angl);
        s = sin(angl);
        Tr = [c^2,  s^2, -2*s*c;
        s^2,  c^2,  2*s*c;
        s*c, -s*c,  c^2-s^2];
    
        StrainPr = [StrainPr1;StrainPr2;0];
        StrainT =Tr*StrainPr;
        StressT = K*StrainT;

end
                                                                              
                                                                              
                                                                              