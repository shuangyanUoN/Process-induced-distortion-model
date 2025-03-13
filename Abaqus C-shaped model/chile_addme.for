! -------------keep text no longer than 72 characters ------------- here
! 1. For writing out variables, note FORTRAN unit numbers used by ABAQUS
! such as 1,2,6,7,8,10,12,19-30,73 in abaqus/standard
! 2. By default Fortran will assign the type integer to variables whose 
! names begin with the letters I,J,K,L,M,N and type real to all other 
! undeclared variables
! =================================================================== !
!                        USDFLD - CURE PROCESS                        !
! =================================================================== !
      SUBROUTINE USDFLD(FIELD,STATEV,PNEWDT,DIRECT,T,CELENT,
     1 TIME,DTIME,CMNAME,ORNAME,NFIELD,NSTATV,NOEL,NPT,LAYER,
     2 KSPT,KSTEP,KINC,NDI,NSHR,COORD,JMAC,JMATYP,MATLAYO,
     3 LACCFLA)
C
       INCLUDE 'ABA_PARAM.INC'
C
        CHARACTER*80 CMNAME,ORNAME
        CHARACTER*3 FLGRAY(15)
        DIMENSION FIELD(NFIELD),STATEV(NSTATV),DIRECT(3,3),
     1 T(3,3),TIME(2)
        DIMENSION ARRAY(15),JARRAY(15),JMAC(*),JMATYP(*),COORD(*)
C
      ! assign variables
        REAL :: R = 8.3145          !Gas constant
        REAL :: A = 7.0E4           !Cure rate coefficient [s-1]
        REAL :: Ea = 65000.0        !Activation energy [J/mol]
        REAL :: m = 0.5, n = 1.5    !Exponential constants
        REAL :: C = 30.0            !Diffusion constant
        REAL :: a_CT = 5.171e-3     !Critical degree of cure at T=0K [K-1]
        REAL :: a_C0 = -1.5148      !Constant accounting for increased temperatue
        REAL :: a_C, K1, CURING,ALPHA,TEMPK
        
      ! get temperatue at each material point
        CALL GETVRM('TEMP',ARRAY,JARRAY,FLGRAY,JRCD,JMAC,JMATYP,
     1 MATLAYO,LACCFLA)
        TEMPK=ARRAY(1)+273.15
            ! Incr 1 & Step 1 - start of the rubbery phase
            IF ((KINC.EQ.1).AND.(KSTEP.EQ.1)) THEN
                  ALPHA=1E-4
                  CURING=0.0
                  ELSE
                    ALPHA=STATEV(2)
                    ! get curing rate
                    a_C=a_C0+a_CT*TEMPK
                    K1=A*exp(-Ea/(R*TEMPK))
                    CURING=K1*((1.0-ALPHA)**n)*(ALPHA**m)/(
     *                      1.0+exp(C*(ALPHA-a_C)))
                    ! update degree of cure
                    ALPHA=ALPHA+CURING*DTIME
            END IF
      ! update state variables
        STATEV(1)=CURING
        STATEV(2)=ALPHA
        STATEV(3)=TEMPK
      ! update self-defined field
        FIELD(1)=ALPHA
      ! write all the state variable to file at each increment for node1
      
C       IF(KSTEP.EQ.1)THEN
C           IF((NOEL.EQ.8601).OR.(NOEL.EQ.2875).OR.(NOEL.EQ.5750).OR.
C      *      (NOEL.EQ.11500).OR.(NOEL.EQ.11615))THEN
C         OPEN(105,file='E:\ABAQUS\CHILEModel\out.txt',position='append')
C          WRITE(105,*),'NOEL',NOEL,STATEV(2),STATEV(4),STATEV(5),
C      *    STATEV(6),STATEV(7),STATEV(8)
C         CLOSE(105)
C           END IF
C       END IF

      RETURN
      END
! =================================================================== !
!                         HETVAL - HEAT GENERATION                    !
! =================================================================== !
       SUBROUTINE HETVAL(CMNAME,TEMP,TIME,DTIME,STATEV,FLUX,
     1 PREDEF,DPRED)
C
      INCLUDE 'ABA_PARAM.INC'
C
        CHARACTER*80 CMNAME
C
      DIMENSION TEMP(2),STATEV(*),PREDEF(*),TIME(2),FLUX(2),
     1 DPRED(*)
C
      REAL :: rho=1580.0      !nominal laminate density [kg/m3]
      REAL :: Ht=574000.0   !Ultimate heat of reaction [J/kg]
      REAL :: CURING
      ! FLUX(1) - Heat flux, r (thermal energy per time per volume)
        CURING=STATEV(1)
        FLUX(1) = rho*Ht*CURING

      RETURN
      END
! =================================================================== !
!                   UEXPAN - CHEMICAL & THERMAL STRAINS               !
! =================================================================== !
        SUBROUTINE UEXPAN(EXPAN,DEXPANDT,TEMP,TIME,DTIME,PREDEF,
     1 DPRED,STATEV,CMNAME,NSTATV,NOEL)
C
C         IMPLICIT NONE
      INCLUDE 'ABA_PARAM.INC'
C
      CHARACTER*80 CMNAME
        ! CTE has taken into account of lay-up sequence
        ! the value listed here are for XP laminates
        REAL :: a11 = 0.0, a22 = 32.6e-6, a33 = 32.6e-6
        REAL :: c11 = 0.0, c22 = 0.48e-2, c33 = 0.48e-2
        ! degree of cure at gelation adn vitrification
        REAL :: a_gel = 0.33, a_vitr = 0.88, a_end = 0.914
        REAL :: IncrAlpha,CURING,ALPHA,Epsilon
        REAL :: ZERO = 0.0
C
      DIMENSION EXPAN(*),DEXPANDT(*),TEMP(2),TIME(2),PREDEF(*),
     1 DPRED(*),STATEV(NSTATV)
      ! EXPAN - Increments of thermal strain
      ! TEMP(2) - Temperature increment
C     
        CURING=STATEV(1)
        ALPHA=STATEV(2)

        IncrAlpha=DTIME*CURING
        IF (ALPHA.LE.a_gel) THEN
            ! Pre-gelation phase (resin shrinkage & thermal expansion 
            ! do not contribute to residual strains)
            EXPAN(1)=0.0
            EXPAN(2)=0.0
            EXPAN(3)=0.0
            ELSE IF ((ALPHA.GT.a_gel).AND.(ALPHA.LT.a_vitr)) THEN
            ! Rubbery phase (between gelation and vitrification)
            ! Chemical shrinkage + thermal expansion
            ! thermal expansion has been taken into consideration in cii
                  EXPAN(1)=-IncrAlpha*c11/(a_vitr-a_gel)
                  EXPAN(2)=-IncrAlpha*c22/(a_vitr-a_gel)
                  EXPAN(3)=-IncrAlpha*c33/(a_vitr-a_gel)
            ELSE
            ! Glassy phase, thermal contraction only
                  EXPAN(1)=a11*TEMP(2)
                  EXPAN(2)=a22*TEMP(2)
                  EXPAN(3)=a33*TEMP(2)    
        END IF
        IF (TIME(2).EQ.ZERO) THEN
            Epsilon = ZERO
            ELSE
            Epsilon = Epsilon+EXPAN(3)
        END IF

        STATEV(4)=EXPAN(3)
        STATEV(5)=Epsilon

      RETURN
      END
! =================================================================== !
!                       UMAT - CHILE Constitutive                     !
! =================================================================== ! 
      SUBROUTINE UMAT(STRESS,STATEV,DDSDDE,SSE,SPD,SCD,
     1 RPL,DDSDDT,DRPLDE,DRPLDT,
     2 STRAN,DSTRAN,TIME,DTIME,TEMP,DTEMP,PREDEF,DPRED,CMNAME,
     3 NDI,NSHR,NTENS,NSTATV,PROPS,NPROPS,COORDS,DROT,PNEWDT,
     4 CELENT,DFGRD0,DFGRD1,NOEL,NPT,LAYER,KSPT,JSTEP,KINC)

C         IMPLICIT NONE
C
      INCLUDE 'ABA_PARAM.INC'
C

      CHARACTER*80 CMNAME
      DIMENSION STRESS(NTENS),STATEV(NSTATV),
     1 DDSDDE(NTENS,NTENS),DDSDDT(NTENS),DRPLDE(NTENS),
     2 STRAN(NTENS),DSTRAN(NTENS),TIME(2),PREDEF(1),DPRED(1),
     3 PROPS(NPROPS),COORDS(3),DROT(3,3),DFGRD0(3,3),DFGRD1(3,3),
     4 JSTEP(4)

      REAL :: oldDDSDDE(NTENS,NTENS)
      ! engineering constants for AS4 fibre (unidirectional) 
      ! and 8552 resin (isotropic)
      REAL :: E11f=228000e6, E22f=17200e6, E33f=17200e6
      REAL :: G12f=27600e6, G13f=27600e6,G23f=5730e6
      REAL :: v12f=0.2, v13f=0.2, v23f=0.5
      REAL :: Er0=4.67e6, Er100=4670e6
      REAL :: vr0=0.499,vr100=0.37
      REAL :: Gr0=11e6,Gr100=1704e6
      REAL :: Vf=0.57
      ! critical temperature constants of TempD [K]
      REAL :: Tc1=-45.7, Tc2=-12
      REAL :: Alpha
      REAL :: Tg,TempC,TempD
      REAL :: E11,E22,E33
      REAL :: Er,vr,Gr
      REAL :: G12,G13,G23
      REAL :: v12,v13,v23,v32,v21,v31
      REAL :: kf,kr,kt,Delta
      INTEGER :: I,J

      ! read DoC and calcualte Tg (C)
        Alpha=STATEV(2)
        ! condition to use this Tg(alpha) - predefined temp=0
C         Tg=164.6*Alpha*Alpha+51.0*Alpha+2.67
        Tg = 268.0 + 220.0*Alpha-273.15
        TempC=STATEV(3)-273.15
        TempD=Tg-TempC
      ! output variable as sdv - checking
       STATEV(6)=Tg
       STATEV(7)=TempD
      ! CHILE constitutive description
C         IF (TempD<Tc1) THEN
C             Er=Er0
C         ELSE IF ((Tc1<TempD).AND.(TempD<Tc2)) THEN
C             Er=Er0+(TempD-Tc1)*(Er100-Er0)/(Tc2-Tc1)
C         ELSE
C             Er=Er100
C         END IF
        IF (Alpha<0.3) THEN
                Er=Er0
                vr=vr0
                Gr=Gr0
            ELSE IF ((TempD<Tc1).AND.(Alpha>0.3)) THEN
                Er=Er0
                vr=vr0
                Gr=Gr0
            ELSE IF ((Tc1<TempD).AND.(TempD<Tc2).AND.(Alpha>0.3)) THEN
                Er=Er0+(TempD-Tc1)*(Er100-Er0)/(Tc2-Tc1)
                vr=vr100+(TempD-Tc1)*(vr0-vr100)/(Tc2-Tc1)
                Gr=Gr0+(TempD-Tc1)*(Gr100-Gr0)/(Tc2-Tc1)
        ELSE
            Er=Er100
            vr=vr100
            Gr=Gr100
        END IF

      ! calculate engineering constants based on SCFM
        kf=E22f/(2*(1-v12f-2*v12f**2))
        kr=Er/(2*(1-vr-2*vr**2))
        kt=((kf+Gr)*kr+(kf-kr)*Gr*Vf)/((kf+Gr)-(kf-kr)*Vf)

        v12 = v12f*Vf+vr*(1-Vf)+
     *      ((vr-v12f)*(kr-kf)*Gr*(1-Vf)*Vf)/
     *       ((kf+Gr)*kr+(kf-kr)*Gr*Vf)

        G12 = Gr*((G12f+Gr)+(G12f-Gr)*Vf)/
     *       ((G12f+Gr)-(G12f-Gr)*Vf)

        G23 = (Gr*(kr*(Gr+G23f)+2.*G23f*Gr+kr*(G23f-Gr)*Vf))/
     *       (kr*(Gr+G23f)+2*G23f*Gr-(kr+2*Gr)*(G23f-Gr)*Vf)

        E11 = E11f*Vf+Er*(1-Vf)+(4*(vr-v12f**2)*
     *        kf*kr*Gr*(1-Vf)*Vf)/((kf+Gr)*kr+(kf-kr)*Gr*Vf)

        E22 = 1/(1/(4*kt)+1/(4*G23)+v12*v12/E11)

        v23 = (2*E11*kt-E11*E22-4*v12**2*kt*E22)/(2*E11*kt)

      ! output variable as sdv - checking
      STATEV(8)=Er
      STATEV(9)=Gr
      STATEV(10)=G12
      STATEV(11)=G23
      STATEV(12)=v12
      STATEV(13)=v23
      STATEV(14)=E11
      STATEV(15)=E22

      ! for transverse isotropic material (22=33)
        E33=E22
        G13=G12
        v13=v12
        v32=v23
        v21=v12*E22/E11
        v31=v21

      ! stiffness matrix
      DO I=1,NTENS
          DO J=1,NTENS
          DDSDDE(I,J)=0.0D0
          ENDDO
      ENDDO
      Delta=(1-v12*v21-v23*v32-v31*v13-2*v21*v32*v13)/(E11*E22*E33)
      DDSDDE(1,1)=(1-v23*v32)/(E22*E33*Delta)
      DDSDDE(2,2)=(1-v13*v31)/(E11*E33*Delta)
      DDSDDE(3,3)=(1-v12*v21)/(E11*E22*Delta)
      DDSDDE(4,4)=G23
      DDSDDE(5,5)=G13
      DDSDDE(6,6)=G12
      DDSDDE(1,2)=(v21+v31*v23)/(E22*E33*Delta)
      DDSDDE(1,3)=(v31+v21*v32)/(E22*E33*Delta)
      DDSDDE(2,1)=DDSDDE(1,2)
      DDSDDE(2,3)=(v32+v12*v31)/(E11*E33*Delta)
      DDSDDE(3,1)=DDSDDE(1,2)
      DDSDDE(3,2)=DDSDDE(2,3)

      STATEV(16)=DDSDDE(1,1)
      STATEV(17)=DDSDDE(1,3)
      STATEV(18)=DSTRAN(1)
      STATEV(19)=DSTRAN(2)
      STATEV(20)=DSTRAN(3)

       DO I=1,NTENS
          DO J=1,NTENS
               STRESS(I)=STRESS(I)+DDSDDE(I,J)*DSTRAN(J)
          ENDDO
        ENDDO

C         IF (noel .EQ. )
C         WRITE (7,*) DSTRAN(1), DSTRAN(2)

      RETURN
      END