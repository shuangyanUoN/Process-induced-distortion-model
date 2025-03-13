function v= Get_strain_and_curvature(NM,K,z,nz,i1)

    ABD = Build_ABDmatrix(K,z,nz,i1);
    
    NMT = sum(NM);
    
    v = ABD\(NMT');

end