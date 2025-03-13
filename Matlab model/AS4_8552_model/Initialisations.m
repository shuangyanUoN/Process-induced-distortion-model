function [iexit,z,z1,dt,r]=Initialisations(nz,dz,pho,Cp_min,kz_max,dt)
               
L = nz*dz;
    for ii = 1:nz+1
        z(ii,1) = -(L/2)+(ii-1)*dz; 
    end
% distance from the laminate line of symmetry to the respective lamina
z2 = z+dz/2;
z1 = z2(1:end-1);
    
    r = kz_max/(pho*Cp_min)*dt/dz^2;     % stable if r<0.5
    
    report_r=['r=' num2str(r)];
    disp(report_r)

    if r>0.5
        astring=['The solution procedure is not stable: r=' num2str(r)];
        disp(astring)
        iexit=0;
        return
    else
        iexit=1;
    end

end