%% OBTAIN CONFIDENCE ENVELOPE USING PC-KRIGING
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

InputOpts.Marginals(1).Name = 'chi';
InputOpts.Marginals(1).Type = 'Constant';
InputOpts.Marginals(1).Parameters = chi_n;
% InputOpts.Marginals(1).Type = 'Uniform';
% InputOpts.Marginals(1).Parameters = [0 1];

InputOpts.Marginals(2).Name = 'f';
InputOpts.Marginals(2).Type = 'Constant';
InputOpts.Marginals(2).Parameters = f_n;
% InputOpts.Marginals(2).Type = 'Uniform';
% InputOpts.Marginals(2).Parameters = [0 2];

InputOpts.Marginals(3).Name = 'k1';
InputOpts.Marginals(3).Type = 'Constant';
InputOpts.Marginals(3).Parameters = k1_n;
% InputOpts.Marginals(3).Type = 'Uniform';
% InputOpts.Marginals(3).Parameters = [0 1];

InputOpts.Marginals(4).Name = 'k2';
InputOpts.Marginals(4).Type = 'Constant';
InputOpts.Marginals(4).Parameters = k2_n;
% InputOpts.Marginals(4).Type = 'Uniform';
% InputOpts.Marginals(4).Parameters = [0 1];

InputOpts.Marginals(5).Name = 'kappa';
InputOpts.Marginals(5).Type = 'Constant';
InputOpts.Marginals(5).Parameters = kappa_n;
% InputOpts.Marginals(5).Type = 'Uniform';
% InputOpts.Marginals(5).Parameters = [0 1];

InputOpts.Marginals(6).Name = 'Lambda';
InputOpts.Marginals(6).Type = 'Constant';
InputOpts.Marginals(6).Parameters = Lambda_n;
% InputOpts.Marginals(6).Type = 'Uniform';
% InputOpts.Marginals(6).Parameters = [0 1];

InputOpts.Marginals(7).Name = 'omega';
% InputOpts.Marginals(7).Type = 'Constant';
% InputOpts.Marginals(7).Parameters = omega_n;
InputOpts.Marginals(7).Type = 'Uniform';
InputOpts.Marginals(7).Parameters = [0 1];

InputOpts.Marginals(8).Name = 'zeta';
InputOpts.Marginals(8).Type = 'Constant';
InputOpts.Marginals(8).Parameters = zeta_n;
% InputOpts.Marginals(8).Type = 'Uniform';
% InputOpts.Marginals(8).Parameters = [0 1];

myInput = uq_createInput(InputOpts);

% PCE-BASED KRIGING
disp(' ')
disp(' --- ANALYSIS VIA PC-KRIGING ---');

MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCK';
MetaOpts.Input = myInput;
MetaOpts.PCE.Degree = 8;
MetaOpts.ExpDesign.Sampling = 'Sobol';
MetaOpts.ExpDesign.NSamples = 50;
MetaOpts.Mode = 'sequential';

mySPCK = uq_createModel(MetaOpts);

uq_print(mySPCK)
uq_display(mySPCK)