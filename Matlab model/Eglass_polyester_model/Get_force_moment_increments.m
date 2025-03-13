function v=Get_force_moment_increments(StressT,z,z1,i2)

        Nx = StressT(1)*(z(i2+1)-z(i2));
        Ny = StressT(2)*(z(i2+1)-z(i2)); 
        Nxy = StressT(3)*(z(i2+1)-z(i2)); 
        
        v = [Nx,Ny,Nxy,Nx*z1(i2),Ny*z1(i2),Nxy*z1(i2)]';
        
end 