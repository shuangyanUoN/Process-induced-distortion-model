function StressEl = Get_Ply_Stresses(Re,StrainT,K,z1,i1,nz)
    
    StressEl = zeros(3,nz);
    
    Strainx = Re(1) + z1*Re(4);
    Strainy = Re(2) + z1*Re(5);
    Strainxy = Re(3) + z1*Re(6);
    
    StrainXY = [Strainx,Strainy,Strainxy];
    
    Strain_el= (StrainXY-StrainT)';
  
   for i3 = 1:nz
    StressEl(:,i3) = K{i3,(i1+1)}*Strain_el(:,i3);
   end
   
end 
