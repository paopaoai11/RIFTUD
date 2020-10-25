      SUBROUTINE EFFIC (ES,ER,J)
      IMPLICIT NONE
      REAL MU
!
      real A,ALPH1,ALPH0,ALUNC,AA,A3A2S,A3A2R,A2,AR,AS
      real BET2M,BB,BWSR
      real CR,CS,CHRDR
      real D0,D1,D1A,D2M,D
      real EN,ER,ES,ELOCS,ELOSS,ELOSR,E,EWSR
      real GAM
      real HS,HR,H
      INTEGER J
      INTEGER K,K2
      INTEGER NSTAR
      real PI
      real REFR,RER,RH2RT2,REFS,RES
      real SIGS,STAR,SRH1,SRH2,SRH,SRS
      real TOSR,TOSS
      real VOVCR1
      real X
      real Y,Y2,YC
      real W,WOWCRM
      real SIMPS1
      external SIMPS1
!
      COMMON/EFF/GAM,VOVCR1,W,PI,STAR,MU,D1,ALPH1,NSTAR,ALPH0,ALUNC,SIGS 
     1,D0,HS,CS,WOWCRM,D1A,D2M,HR,BET2M,EN,RH2RT2,CR
      COMMON/SH/AA,BB,YC
      REAL SHUB,SHUB2
      EXTERNAL SHUB,SHUB2
      A(X)= (GAM-1.)/(GAM+1.)*X*X
      D(Y)= 1./1.68+Y/2.88+Y*Y/4.4+Y*Y*Y/6.24
      H(Y)= (1./1.2+3.*Y/1.6+5.*Y*Y/2.+7.*Y**3/2.4+9.*Y**4/2.8)/D(Y) 
      E(Y)=2.*(1./1.92+Y/3.2+Y*Y/4.8+Y**3/6.72)/D(Y)
      GO TO (1,2),J
    1 AS = A(VOVCR1)
      REFS=.03734
      RES= W/PI/STAR/MU/D1/COS(ALPH1)
      ELOCS=1.
      IF(NSTAR.NE.2.OR.ALUNC.NE.0.0) ELOCS=ALUNC/2./SIN(ALUNC/2.)
      ELOSS= ELOCS*SIGS
      A3A2S= 1.+(D0**2-D1**2)/4./SIGS/HS/D1/ELOCS 
      TOSS= .05*SIGS*STAR
      ES=CS*E(AS)*REFS/RES**.2*ELOSS*A3A2S/(COS(ALPH1)-CS*H(AS)*REFS/RES 
     1**.2*ELOSS-TOSS)
      GO TO 3
    2 AR = A(WOWCRM)
      REFR=.11595
      CHRDR=0.5*SQRT((D1A-D2M-HR+HS)**2+(D1A-D2M)**2) 
      RER=W/PI*CHRDR/HR/MU/D2M/COS(BET2M)
      ELOSR=EN*CHRDR/2./SQRT(2.)/D2M
      BWSR=PI/8.*((D1A-D2M-HR+2.*HS)*(D1A-D2M+HR)-(D1A-D2M-HR)**2) 
      SRS=PI/2.*(D1A-D2M-HR)*((PI/2.-1.)*D1A+D2M+HR)
!     EXTERNAL SHUB,SHUB2
      K= 0
      K2=0
      AA= (D1A-D2M-HR+2.*HS)/2.
      BB= (D1A-D2M+HR)/2.
      YC=D1A/2.
      A2=AA/2.
      Y2=YC-BB/2.*SQRT(3.)
      SRH1=2.*PI*SIMPS1(0.0,A2,SHUB,K)
      IF(K.GT.0) WRITE(6,10) K
   10 FORMAT(3H K=,I2)
      SRH2=2.*PI*SIMPS1(Y2,YC,SHUB2,K2)
      IF(K2.GT.0) WRITE(6,11) K2
   11 FORMAT(4H K2=,I2)
      SRH=SRH1+SRH2
      EWSR=(SRS+SRH)/EN
      A3A2R=1.+EWSR/BWSR
      TOSR= 0.04/PI*EN*(1.-RH2RT2)/(1.+RH2RT2)
      ER=CR*E(AR)*REFR/RER**.2*ELOSR*A3A2R/(COS(BET2M)-CR*H(AR)*REFR/RER 
     1**.2*ELOSR-TOSR)
!     write(6,*)'SUBR. EFFIC; J = ',J,'ER = ',ER
!     write(6,*)'SUBR. EFFIC; CR = ',CR,'E = ',E(AR),' REFR = ',REFR
!     write(6,*)'SUBR. EFFIC; RER = ',RER,'ELOSR = ',ELOSR,' A3A2R = ',
!    &A3A2R
!     write(6,*)'SUBR. EFFIC; CR = ',CR,'H(AR) = ',H(AR),' TOSR = ',
!    &TOSR
!     write(6,*)'W = ',W,' CHRDR = ',CHRDR,' HR = ',HR,' MU = ',MU,
!    &'D2M = ',D2M,' COS(BET2M) = ',COS(BET2M)
!     IF(ER.GT.1.)CALL EXIT(77)

    3 RETURN
      END
