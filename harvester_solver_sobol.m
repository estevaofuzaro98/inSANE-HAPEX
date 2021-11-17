function MeanPower = harvester_solver_sobol(X)

% PERIOD OF ANALYSIS
    load Tan Tan

% INITIAL CONDITIONS
    load IC IC
    
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
    %opt = odeset('RelTol',1.0e-6,'AbsTol',1.0e-9,'OutputFcn',@odetpbar);
    opt = odeset('RelTol',1.0e-6,'AbsTol',1.0e-9);
    [time,Y] = ode45(dydt,Tan,IC,opt);  % ODE45 solver

% REMOVING TRANSIENT
    TimeInit = round(time(end)*2/3);    % initial time = 2/3*Tan
    
% OUTPUT POWER
    OutVolt = Y(TimeInit:end,5);                            % output voltage
    T = time(end) - time(TimeInit);                         % stationary period
    OutPower = Lambda.*OutVolt.^2;                          % output power
    MeanPower = (1/T).*trapz(time(TimeInit:end),OutPower);  % mean power
end