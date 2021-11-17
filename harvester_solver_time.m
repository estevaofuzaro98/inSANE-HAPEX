function [time,Y] = harvester_solver_time(X,IC,Tan)
  
% MODEL PARAMETERS
    chi    = X(1);    % piezoeletric coupling term (mechanical)
    f      = X(2);    % excitation amplitude
    k1     = X(3);    % mechanical stiffness k1
    k2     = X(4);    % mechanical stiffness k2
    kappa  = X(5);    % piezoeletric coupling term (eletrical)
    Lambda = X(6);    % reciprocal time constant
    omega  = X(7);    % excitation frequency
    zeta   = X(8);    % mechanical damping ratio
    
% ODE SPACE-STATES
    dydt = @(t,y)[y(2);
                  - 2.*zeta.*y(2) - k1.*y(1) + k2.*(y(1) - y(3)) + chi.*y(5) + f.*cos(omega.*t);
                  y(4);
                  - 2.*zeta.*y(4) + k2.*(y(1) - y(3));
                  - Lambda.*y(5) - kappa.*(y(2) - y(4))];
               
% ODE45 (Runge-Kutta45) SOLVER
    opt = odeset('RelTol',1.0e-6,'AbsTol',1.0e-9,'OutputFcn',@odetpbar);
    [time,Y] = ode45(dydt,Tan,IC,opt);  % ODE45 solver
end