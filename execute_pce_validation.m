%% EXECUTE PCE VALIDATION
clear; close all; clc;

tic
disp(' ')
disp(' ---          INITIALIZING        ---');
text = 18.0; line = 1.8; marker = 10.0;

% DEFINING A STATISTICAL SEED AND INITIALIZING UQLAB
disp(' ')
disp(' ---  DEFINING A SEED & RUN UQLAB ---');
disp(' ')
rng_stream = RandStream('mt19937ar','Seed',23031998);
RandStream.setGlobalStream(rng_stream);
uqlab;

% MODEL PARAMETERS (NOMINAL)
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

% COMPUTATIONAL MODEL
disp(' ')
disp(' ---        MODEL CREATION        ---');
ModelOpts.mFile = 'harvester_solver_sobol';
ModelOpts.isVectorized = false;
myModel = uq_createModel(ModelOpts);

% PROBABILISTIC INPUT MODEL
delta = 0.2;

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

% PCE-BASED SOBOL INDICES
disp(' ')
disp(' --- SENSITIVITY ANALYSIS VIA PCE ---');

PCEOpts.Type = 'Metamodel';
PCEOpts.MetaType = 'PCE';
%PCEOpts.Method = 'OLS';
PCEOpts.Input = myInput;
PCEOpts.FullModel = myModel;
PCEOpts.Degree = 8;
PCEOpts.ExpDesign.NSamples = 1e3;

myPCE = uq_createModel(PCEOpts);

SobolOpts.Type = 'Sensitivity';
SobolOpts.Method = 'Sobol';
SobolOpts.Sobol.Order = 2;

mySobolAnalysisPCE = uq_createAnalysis(SobolOpts);
mySobolResultsPCE = mySobolAnalysisPCE.Results;

% VALIDATING PCE MODEL
disp(' ')
disp(' ---     VALIDATING PCE MODEL     ---');
[X,Y,YPC] = validate_PCE(5e2);

figure()
set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
plot(Y,YPC,'rx','MarkerSize',marker,'LineWidth',line)
set(gca,'fontsize',text,'XColor','k','YColor','k','GridColor','k');
hold on, grid on, grid minor, pbaspect([1 1 1])
rule = linspace(min(Y),max(Y),2);
plot(rule,rule,'b','LineWidth',line)
legend('Estimated','Ideal')
xlabel('Full-Order Model','fontsize',text);
ylabel('Surrogate','fontsize',text);

%PRINTING RESULTS
disp(' ')
disp(' ---       PRINTING RESULTS       ---');
uq_print(mySobolAnalysisPCE)

SobolTotal = [mySobolResultsPCE.Total];
SobolFirstOrder = [mySobolResultsPCE.FirstOrder];
SobolSecondOrder = [mySobolResultsPCE.AllOrders{2}];
toc