% Curing simulation
function [alpha,T]=Cure_Process(alpha0,cure_rate,T,i1,i2,dt,nz,pho,Ht,dz)
        
%     temperature-dependent Cp and kz
    Cp = 2.8702*T(i2,i1)+776.83;
    kz = 0.0019*T(i2,i1)+0.7891;
    r = kz/(pho*Cp)*dt/dz^2;

      if (i2==1) || (i2==nz)
        alpha = alpha0+dt*cure_rate;
        T=T(i2,i1+1);
      else
        alpha = alpha0+dt*cure_rate;
        q = pho*Ht*cure_rate;
        q0 = q*dt/(pho*Cp);
        T = r*T(i2+1,i1) + (1-2*r)*T(i2,i1) + r*T(i2-1,i1) + q0;
      end