% Define boundary conditions

%% Standard autoclave temperature setting
if control==0

for iT=1:(30/400)*nt    %time series 0-30mins temp = 20C-78C
    T(1,iT) = iT*(78-20)/(30*nt/400)+20+273.15;     % in kelvin
    T(nz,iT) = T(1,iT);
end 
for iT=(30/400)*nt:(90/400)*nt    %time series 30-90mins, temp=78C
    T(1,iT) = 78+273.15;     % in kelvin
    T(nz,iT) = T(1,iT);
end
for iT=(90/400)*nt:(150/400)*nt    %time series 90-150mins, temp=78C-90C
    T(1,iT) = (iT-90*nt/400)*(90-78)/(60*nt/400)+78+273.15;     % in kelvin
    T(nz,iT) = T(1,iT);
end
for iT=(150/400)*nt:(210/400)*nt    %time series 150-210mins, temp=90C
    T(1,iT) = 90+273.15;     % in kelvin
    T(nz,iT) = T(1,iT);
end
for iT=(210/400)*nt:(240/400)*nt    %time series 210-240mins, temp=90-126C
    T(1,iT) = (iT-210*nt/400)*(126-90)/(30*nt/400)+90+273.15;     % in kelvin
    T(nz,iT) = T(1,iT);
end
for iT=(240/400)*nt:(300/400)*nt    %time series 240-300mins, temp=126C
    T(1,iT) = 126+273.15;     % in kelvin
    T(nz,iT) = T(1,iT);
end
for iT=(300/400)*nt:(330/400)*nt    %time series 300-330mins, temp=126C-20C
    T(1,iT) = (iT-300*nt/400)*(20-126)/(30*nt/400)+126+273.15;     % in kelvin
    T(nz,iT) = T(1,iT);
end
for iT=(330/400)*nt:(400/400)*nt    %time series 330-400mins, temp=20C
    T(1,iT) = 20+273.15;     % in kelvin
    T(nz,iT) = T(1,iT);
end
T(:,1)=T(1,1);

elseif control==1
%%

    for iT=1:(30/400)*nt    %time series 0-30mins temp = 20C-80C
        T(1,iT) = iT*(80-20)/(30*nt/400)+20+273.15;     % in kelvin
        T(nz,iT) = T(1,iT);
    end 
    for iT=(30/400)*nt:(150/400)*nt    %time series 30-150mins, temp=80C
        T(1,iT) = 80+273.15;     % in kelvin
        T(nz,iT) = T(1,iT);
    end
Tp=zeros(3);
    if iTempSwitch == 1
        Tp = [195,225,255];
    elseif iTempSwitch == 2
        Tp = [240,270,300];
    elseif iTempSwitch == 3
        Tp = [320,350,380];
    end
        for iT=(150*nt/400):(Tp(1)*nt/400)    %time series 150-Tp1 mins, temp=80-130C
            T(1,iT) = (iT-150*nt/400)*(130-80)/((Tp(1)-150)*nt/400)+80+273.15;     % in kelvin
            T(nz,iT) = T(1,iT);
        end
        for iT=(Tp(1)*nt/400):(Tp(2)*nt/400)    %time series Tp1-Tp2mins, temp=130C
            T(1,iT) = 130+273.15;     % in kelvin
            T(nz,iT) = T(1,iT);
        end
        for iT=(Tp(2)*nt/400):(Tp(3)*nt/400)  %time series Tp2-Tp3mins, temp=130C-20C
            T(1,iT) = (iT-Tp(2)*nt/400)*(20-130)/((Tp(3)-Tp(2))*nt/400)+130+273.15;     % in kelvin
            T(nz,iT) = T(1,iT);
        end
        for iT=(Tp(3)*nt/400):(400*nt/400)    %time series Tp3-400mins, temp=20C
            T(1,iT) = 20+273.15;     % in kelvin
            T(nz,iT) = T(1,iT);
        end
        T(:,1)=T(1,1);
end