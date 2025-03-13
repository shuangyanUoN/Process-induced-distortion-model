% Define autoclave boundary conditions
function [nt,T] = Autoclave_BC(dwell1,dwell2,roomtemp,ramp1,ramp2,cooling,hold1,hold2,nz,dt)
% Standard autoclave temperature setting
ramp1new = ramp1/60*dt;    % convert 2C/min to 2C/dt
ramp2new = ramp2/60*dt;    % convert 2C/min to 2C/dt
coolingnew = cooling/60*dt;
hold1new = hold1*60/dt;     % convert mins to dt
hold2new = hold2*60/dt;
time1 = round((dwell1-roomtemp)/ramp1new);   % in dt
time2 = round(time1+hold1new);
time3 = round(time2+(dwell2-dwell1)/ramp2new);
time4 = round(time3+hold2new);
time5 = round(time4+(dwell2-roomtemp)/coolingnew);
nt = time5;
T = (roomtemp+273.15)*ones(nz,nt);

    for iT=1:time1
        T(1,iT) = roomtemp+ramp1new*iT+273.15;     % heating up to 110C
        T(nz,iT) = T(1,iT);
    end 
    
    
    for iT=time1:time2 
        T(1,iT) = dwell1+273.15;     % dwell for 60mins at 110C, in kelvin
        T(nz,iT) = T(1,iT);
    end
    
    for iT=time2:time3
        T(1,iT) = dwell1+ramp2new*(iT-time2)+273.15;     % heating up to 180C
        T(nz,iT) = T(1,iT);
    end
    
    for iT=time3:time4
        T(1,iT) = dwell2+273.15;     % dwell for 120mins at 180C, in kelvin
        T(nz,iT) = T(1,iT);
    end
    
    for iT=time4:time5
        T(1,iT) = dwell2-coolingnew*(iT-time4)+273.15;     % dwell for 120mins at 180C, in kelvin
        T(nz,iT) = T(1,iT);
    end

end
