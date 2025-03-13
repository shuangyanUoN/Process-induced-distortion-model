% Curing simulation
function [ydot, alpha,T]=Curring_Process(alpha0,Ac,Ea,R,T,m, n,i1,i2,dt,nz,pho,Hr,Cp,r)

      if i2<2
        ydot = Curing(alpha0,Ac,Ea,R,T(i2,i1), m, n);
        alpha = alpha0+dt*ydot;
        T=T(i2,i1+1);
      elseif i2>(nz-1)
        ydot = Curing(alpha0,Ac,Ea,R,T(i2,i1), m, n);
        alpha = alpha0+dt*ydot;
        T=T(i2,i1+1);
      else
        ydot = Curing(alpha0,Ac,Ea,R,T(i2,i1), m, n);
        alpha = alpha0+dt*ydot;
        q = pho*Hr*ydot;
        q0 = q*dt/(pho*Cp);
        T = r*T(i2+1,i1) + (1-2*r)*T(i2,i1) + r*T(i2-1,i1) + q0;
      end