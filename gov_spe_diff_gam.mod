/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Lars Ljunqsvist and Thomas Sargent model of fiscal policies in growth 
model from chapter 11 of "Recursive macroeconomic theory" 3rd ed.

Let's reproduce the figure 11.9.2 chap11, p396: "response to PERMANENT increase in 
g(governement spending) at t=10

It represents two similar economies but with s slight difference in the gamma parameter. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/


/*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

Remark : the script model is available on the internet via "Practicing Dynare" 
(Barillas, Bhandari, Colacito, Kitao, Matthes, Sargent, Shin,2010), however
it seems that the script does not work with dynare 4.5.3. So it needs to be adapted

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

/* the model:
Sargent and Ljungvist first model is characterised by an inelastic labor supply,
an exogenous stream of government expenditures and several kinds of distoring taxes.
*/

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//Declares the endogenous variables;
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

var c k;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
//declares the exogenous variables:

//consumption tax (tauc), 
//capital tax (tauk), 
// government spending (g) 
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	varexo tauc tauk g;

	parameters bet gam del alpha A;
	bet=.95; // discount factor
	gam=.2; // CRRA parameter
	del=.2; // depreciation rate
	alpha=.33; // capital's share
	A=1; // total factor productivity
	/*------------------------------------------------------------
    model
    ------------------------------------------------------------*/
	model;
    // equation 11.3.8a:

	k=A*k(-1)^alpha+(1-del)*k(-1)-c-g;

    //equation 1.3.8e + 11.3.8.g
	c^(-gam) = bet*(c(+1)^(-gam))*((1+tauc)/(1+tauc(+1)))*((1-del)+
	(1-tauk(+1))*alpha*A*k(-1)^(alpha-1));
	end;
	
    /*%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Computation of the model
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%*/

    initval;
	k=1.5;
	c=0.6;
	g = .2;
	tauc = 0;
	tauk = 0;
	end;
	steady;

// The following values determine the new steady state
// after the shocks:
	
    endval;
	k=1.5;
	c=0.6;
	g =.4;
	tauc =0;
	tauk =0;
	end;
    steady;
	
// The following lines produce a g sequence with a once and for all jump in g shocks
// we use shocks to undo that for the first 9 periods and leave g at
// it?s initial value of 0.2
	
	
   

    shocks;
    var g;
    periods 1:9;
    values 0.2;
    end;

    simul(periods=1000);  

	 /*---------------------------------------------------------------
    graphs and plots for other endogenous variables
    ---------------------------------------------------------------*/
    
    //compute the initial steady state for consumption and capital for the plots
    c0=c(1);
    k0=k(1);
    g0=ex0_(3,1);


    /*-----------------------------------------------------------------
    we must store the different value of k and c for the two values of gamma
    In order to do so lets first store them in the first column of a matrix
    ------------------------------------------------------------------*/
    
    /*-------------------------------------------------------------------
    in a 2nd time let's change the parameter gam=.2 and restart the code
    without forgetting to put somme slash before the next command (value 
    for gamma=2), and removing the same slash for the other command
    ------------------------------------------------------------------*/
    
    //values for gamma=2

    /*
    kgamma(:,1)=k;
    cgamma(:,1)=c;
    rbig(:,1)=cgamma(2:1001,1).^(-gam)./(bet*cgamma(3:1002,1).^(-gam));
    */

    //values for gamma=.2
    /*
    kgamma(:,2)=k;
    cgamma(:,2)=c;
    rbig(:,2)=cgamma(2:1001,2).^(-gam)./(bet*cgamma(3:1002,2).^(-gam));
    */

    // let N be the periods to plot
    
   N=40;
    /*-----------------------------------------------------------------
    the following equations compute the other endogenous variables use 
    in the plots below. These equations were taken from RMT 3 p 391
    -----------------------------------------------------------------*/

    // equation 11.6.8h

   rbig0=1/bet;

    // equation 11.6.8c

   nuq0=alpha*A*k0^(alpha-1);

   nuq=alpha*A*kgamma(1:1000,:).^(alpha-1);

    // equation 11.6.8d

    wq0=A*k0^alpha-k0*alpha*A*k0^(alpha-1);

    wq=A*kgamma(1:1000,:).^alpha-k0*alpha*A*kgamma(1:1000,:).^(alpha-1);
    
    
    y0=A*k0^alpha;
    y=A*kgamma(1:1000,:).^alpha;

    i0=k(1)-(1-del)*k0;
   
    i=kgamma(2:1001,:)-(1-del)*kgamma(1:1000,:);
    
  /*------------------------------------------------------------------
    Now we plot the responses of the endogenous variables to the shock
    ------------------------------------------------------------------*/
     
    figure(2)
    plot(x,[y0*ones(N,1)],'--k',x,y(1:N,1),'k',x,y(1:N,2),'-.k','Linewidth',1.5)
    
    title('production response to an increase in government spending at $t=10$ with different $\gamma$','interpreter','latex','Fontsize',12)
    set(gca,'Fontsize',12)
    
    print -depsc fig_g_gam.eps
    x=0:N-1;
   figure(1)

    //subplot for capital 'k'
    
    subplot(2,3,1)
    plot(x,[k0*ones(N,1)],'--k',x,kgamma(1:N,1),'k',x,kgamma(1:N,2),'-.k','Linewidth',1.5)
    
    //note: the timing we lag capital to correct ofr syntax
    
    title('capital','interpreter','latex','Fontsize',12)
    set(gca,'Fontsize',12)

   
    //subplot for consumption
    
   subplot(2,3,2)
   plot(x,[c0*ones(N,1)],'--k',x,cgamma(2:N+1,1),'k',x,cgamma(2:N+1,2),'-.k','Linewidth',1.5)
    
    //note the timing we lag capital to correct ofr syntax
   
    title('consumption','interpreter','latex','Fontsize',12)
    set(gca,'Fontsize',12)

    //subplot for cost of capital 'Rbarr'
    
   subplot(2,3,3)
   plot(x,[rbig0*ones(N,1)],'--k',x,rbig(1:N,1),'k',x,rbig(1:N,2),'-.k','Linewidth',1.5)
    
    //note the timing we lag capital to correct ofr syntax
    
   title('Cost of capital $\overline{R}$','interpreter','latex','Fontsize',12)
   set(gca,'Fontsize',12)

    //subplot for rental rate 'eta'
    
   subplot(2,3,4)
   plot(x,[nuq0*ones(N,1)],'--k',x,nuq(1:N,1),'k',x,nuq(1:N,2),'-.k','Linewidth',1.5)
    
    //note the timing we lag capital to correct ofr syntax
    
   title('$\eta$','interpreter','latex','Fontsize',12)
   set(gca,'Fontsize',12)

    //subplot(2,3,5)
    //plot(x,[i0*ones(N,1)],'--k',x,i(1:N,1),'k',x,i(1:N,2),'-.k','Linewidth',1.5)
    //note the timing we lag capital to correct ofr syntax
    //title('Gross investment','interpreter','latex','Fontsize',12)
    //set(gca,'Fontsize',12)
    //subplot for the experiment proposed'
    
    subplot(2,3,6)
    plot([0:9],oo_.exo_simul(1:10,3),'k','Linewidth',1.5);
    hold on;
    plot([10:N-1],oo_.exo_simul(11:N,3),'k','Linewidth',1.5);
    hold on;
    plot(x,[g0*ones(N,1)],'--k','LineWidth',1.5)
    title('Government spending','interpreter','latex','Fontsize',12)
    axis([0 N -.1 .5])
    set(gca,'Fontsize',12)

    print -depsc fig_g_multi_gam.eps
    
    
   

    