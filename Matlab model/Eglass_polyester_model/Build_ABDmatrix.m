function v = Build_ABDmatrix(K,z,nz,i1)

    A = zeros(3,3);
    B = zeros(3,3);
    D = zeros(3,3);
    for i2=1:nz     % update layers
        A = A + K{i2,i1+1}*(z(i2+1)-z(i2));
        B = B + K{i2,i1+1}*0.5*(z(i2+1)^2 - z(i2)^2);
        D = D + K{i2,i1+1}*(1/3)*(z(i2+1)^3 - z(i2)^3);
    end
    v = [A B;B D];
end