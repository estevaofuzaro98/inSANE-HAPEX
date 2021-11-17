% UQ_inSANE_HAPEX_v1.m
%
%   Final work developed for the course Uncertainty Quantification of
%   the Graduate Program in Mechanical Engineering at the Faculty of
%   Engineering of Ilha Solteira (FEIS/UNESP).
%
%   Theme: Global [S]ensitivity [An]alysis of an [E]nergy [Ha]rvesting
%   System with [P]eriodic [Ex]citation via Sobol Indices
%
%   d2x1/dt2 + 2*zeta*dx1/dt + k1*x1 - k2*(x1-x2) - chi*nu = f*cos(omega*t)
%   d2x2/dt2 + 2*zeta*dx2/dt - k2*(x1-x2) = 0
%   dnu/dt + Lambda*nu + kappa*(dx1/dt - dx2/dt) = 0
%                                   + initial conditions
%  where (alphabetical order)
%       chi         dimensionless piezoeletric coupling term (mechanical)
%       f           dimensionless excitation amplitude
%       k1          dimensionless stiffness of spring 1
%       k2          dimensionless stiffness of spring 2
%       kappa       dimensionless piezoeletric coupling term (eletrical)
%       Lambda      dimensionless reciprocal time constant
%       nu(t)       dimensionless voltage across the load resistance
%       omega       dimensionless excitation frequency
%       t           dimensionless time
%       x1(t)       dimensionless displacements of mass 1
%       x2(t)       dimensionless displacements of mass 2
%       zeta        mechanical damping ratio
%  
%   References:
%       ALMEIDA, E. F. de; CHAVARETTE, F. R.; FERREIRA, D. da C. Optimal linear
%       control applied in a energy harvesting dynamic system with periodic excitation.
%       In: Proceedings of the 25th International Congress of Mechanical Engineering.
%       ABCM, 2019. DOI: https://doi.org/10.26678/abcm.cobem2019.cob2019-0521.
%
%       ERTURK, A.; INMAN, D. J. Broadband piezoelectric power generation on highenergy
%       orbits of the bistable duffing oscillator with electromechanical coupling.
%       Journal of Sound Vibration, v. 330, p. 2339{2353, maio 2011.
%       DOI: https://doi.org/10.1016/j.jsv.2010.11.018.
%
%       NORENBERG, J. P.; PETERSON J. V. L. L.; LOPES, V. G.; LUO, R.; DE
%       LA ROCA, L.; PEREIRA, M; TELLES RIBEIRO, J. G.; CUNHA JR, A.;
%       STONEHENGE - Suite for Nonlinear Analysis of Energy Harvesting
%       Systems, Software Impacts, 2021.
%
%   Programmers: 
%       Estênio Fuzaro de Almeida           estenio.fuzaro@unesp.br
%       Estevão Fuzaro de Almeida           estevao.fuzaro@unesp.br
%       João Pedro Fernandes Salvador       jp.salvador@unesp.br
%       Lucas Veronez Goulart Ferreira      lucas.goulart@unesp.br
%
%   Professor:
%       Américo Cunha Júnior                americo.cunha@uerj.br
%
%  Last update: Nov 11, 2021

%% INITIALIZING... 
clc; clear; close all
disp(' ')
disp(' ---          INITIALIZING        ---');

%% 1 - MODEL PARAMETERS (NOMINAL)
disp(' ')
disp(' ---   DEFINING MODEL PARAMETERS  ---');
chi_n    = 0.05;        % piezoeletric coupling term (mechanical)
f_n      = 0.20;        % excitation amplitude
k1_n     = 0.09;        % mechanical stiffness k1
k2_n     = 0.02;        % mechanical stiffness k2
kappa_n  = 0.50;        % piezoeletric coupling term (eletrical)
Lambda_n = 0.05;        % reciprocal time constant
omega_n  = 0.80;        % excitation frequency
zeta_n   = 0.04;        % mechanical damping ratio

params = [chi_n, f_n, k1_n, k2_n, kappa_n, Lambda_n, omega_n, zeta_n];

%% 2 - PERIOD OF ANALYSIS & INITIAL CONDITIONS
disp(' ')
disp(' ---      DEFINING MODEL IC       ---');
% PERIOD OF ANALYSIS
ti = 0.0;           % inital time
tf = 400.0;         % final time
tinc = 0.01;        % increment time
Tan = ti:tinc:tf;   % period of analysis
save Tan Tan

% INITIAL CONDITIONS
y01 = 0.1;                  % initial displacement (x1)
y02 = 0.0;                  % initial velocity (dx1/dt)
y03 = 0.1;                  % initial displacement (x2)
y04 = 0.0;                  % initial velocity (dx2/dt)
y05 = 0.0;                  % initial voltage (nu)
IC = [y01;y02;y03;y04;y05]; % initial conditions
save IC IC

%% 3 - DEFINING A STATISTICAL SEED AND INITIALIZING UQLAB
disp(' ')
disp(' ---  DEFINING A SEED & RUN UQLAB ---');
disp(' ')
rng_stream = RandStream('mt19937ar','Seed',23031998);
RandStream.setGlobalStream(rng_stream);
uqlab;

%% 4 - TIME INTEGRATION VISUALIZATION
disp(' ')
disp(' ---        TIME INTEGRATION      ---');
[time,Y] = harvester_solver_time(params,IC,Tan);

TimeInit = round(time(end)*2/3);    % initial time = 2/3*Tan
x1=Y(:,1); dx1=Y(:,2); x2=Y(:,3); dx2=Y(:,4); volt=Y(:,5);

text = 18; line = 1.75; marker = 10;

% MASSA 1
plot_harvester_time(time,x1,dx1,TimeInit,tinc,line,text,'Mass',f_n);
% MASSA 2
plot_harvester_time(time,x2,dx2,TimeInit,tinc,line,text,'Mass',f_n);
% VOLTAGEM
plot_harvester_time(time,volt,volt,TimeInit,tinc,line,text,'Volt',f_n);

%% 5 - COMPUTATIONAL MODEL
disp(' ')
disp(' ---        MODEL CREATION        ---');
ModelOpts.mFile = 'harvester_solver_sobol';
ModelOpts.isVectorized = false;
myModel = uq_createModel(ModelOpts);

%% 6 - PROBABILISTIC INPUT MODEL
delta = 0.2;     % dispersion in relation to nominal parameters [%]

InputOpts.Marginals(1).Name = 'chi';
InputOpts.Marginals(1).Type = 'Uniform';
InputOpts.Marginals(1).Parameters = [1-delta 1+delta]*chi_n;

InputOpts.Marginals(2).Name = 'f';
InputOpts.Marginals(2).Type = 'Uniform';
InputOpts.Marginals(2).Parameters = [1-delta 1+delta]*f_n;

InputOpts.Marginals(3).Name = 'k1';
InputOpts.Marginals(3).Type = 'Uniform';
InputOpts.Marginals(3).Parameters = [1-delta 1+delta]*k1_n;

InputOpts.Marginals(4).Name = 'k2';
InputOpts.Marginals(4).Type = 'Uniform';
InputOpts.Marginals(4).Parameters = [1-delta 1+delta]*k2_n;

InputOpts.Marginals(5).Name = 'kappa';
InputOpts.Marginals(5).Type = 'Uniform';
InputOpts.Marginals(5).Parameters = [1-delta 1+delta]*kappa_n;

InputOpts.Marginals(6).Name = 'Lambda';
InputOpts.Marginals(6).Type = 'Uniform';
InputOpts.Marginals(6).Parameters = [1-delta 1+delta]*Lambda_n;

InputOpts.Marginals(7).Name = 'omega';
InputOpts.Marginals(7).Type = 'Uniform';
InputOpts.Marginals(7).Parameters = [1-delta 1+delta]*omega_n;

InputOpts.Marginals(8).Name = 'zeta';
InputOpts.Marginals(8).Type = 'Uniform';
InputOpts.Marginals(8).Parameters = [1-delta 1+delta]*zeta_n;

myInput = uq_createInput(InputOpts);

%% 7 - SENSITIVITY ANALYSIS
% PCE-BASED SOBOL INDICES
disp(' ')
disp(' --- SENSITIVITY ANALYSIS VIA PCE ---');
SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 2;

PCEOpts.Type = 'Metamodel';
PCEOpts.MetaType = 'PCE';
PCEOpts.FullModel = myModel;
PCEOpts.Degree = 8;
PCEOpts.ExpDesign.NSamples = 2e2;
tic
myPCE = uq_createModel(PCEOpts);
mySobolAnalysisPCE = uq_createAnalysis(SobolOpts);
mySobolResultsPCE = mySobolAnalysisPCE.Results;
toc

%% 8 - VALIDATING PCE MODEL
disp(' ')
disp(' ---     VALIDATING PCE MODEL     ---');
[X,Y,YPC] = validate_PCE(3e2);

figure()
plot(Y,YPC,'rx','MarkerSize',marker,'LineWidth',line)
hold on, grid on, grid minor, pbaspect([1 1 1])
rule = linspace(min(Y),max(Y),2);
plot(rule,rule,'b','LineWidth',line)
xlabel('Full-Order Model','fontsize',text);
ylabel('Surrogate','fontsize',text);

%% 9 - PRINTING RESULTS
disp(' ')
disp(' ---       PRINTING RESULTS       ---');
uq_print(mySobolAnalysisPCE)

SobolTotal = [mySobolResultsPCE.Total];
SobolFirstOrder = [mySobolResultsPCE.FirstOrder];

%% 10 - PLOTTING
disp(' ')
disp(' ---       PLOTTING RESULTS       ---');
plot_sobol_indices(mySobolAnalysisPCE,1,'PCE',myPCE.ExpDesign.NSamples);