function Edens = PlanksLaw(lam,T);
% Edens = PlanksLaw(lam,T);
%   calculate radiant flux per unit wavelength (Edens) at wavelengths
%   given by lam for a blackbody at temperatures given by T.
%   n.b., function does not check inputs for vector dimensions or units
%   Inputs
%     lam     column vector with wavelengths (m)
%     T       row vector with temperatures (K)
%   Outputs
%     Edens   matrix (length(lam) x length(T)) of flux densities
%                 (W/m2)/m
%   reference   White, F.M.  1984.  Heat Transfer,  Addison-Wesley.              
  
%physical constants:
h =6.626196e-34;        % Planck's constant (J s)
c =2.99792458e8;        % speed of light in vacuum (m/s)
k =1.380622e-23;        % Boltzmann's constant (J/K)

Edensnum = (2*pi*h*c^2)*(lam .^(-5));
Edensden = exp((h*c/k) * (1 ./ lam) * (1 ./ T)) -1;

Edens = (Edensnum * ones(1,length(T)))  ./ Edensden;