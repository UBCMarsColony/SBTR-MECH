%% SABATIER HEATING LENGTH CALCULATION
%   @author     Andrew Zlindra
%   Created     2020-01-14
%   @reviewer
%   Reviewed
%
%   ASSUMPTIONS:
%       -


function findHeatingLen(density_gas, nu, alpha, C_p, vol_flwrt, OD, t, ...
    T_in, T_out, porosity, density_nickel, density_silica_alumina, ...
    wt, SAperg, dP_reactor, L)
%   PURPOSE:
%       - determines the tube length required to heat up a gas
%   PARAM:
%       density_gas             - fluid density [kg/m^3]
%       nu                      - fluid kinematic viscosity [m^2/s]
%       alpha                   - fluid thermal diffusivity [m^2/s]
%       C_p                     - fluid specific heat [J/kg/K]
%       vol_flwrt               - volume flowrate of the fluid [L/min]
%       OD                      - outer diameter of the tube [in]
%       t                       - wall thickness of tube [in]
%       T_in                    - inlet gas temperature [degC]
%       T_out                   - outlet gas temperature [degC]
%       porosity                - void fraction of packed bed [-]
%       density_nickel          - density of nickel [kg/m^3]
%       density_silica_alumina  - density of silica and alumina [kg/m^3]
%       wt                      - weight fraction of catalyst [-]
%       SAperg                  - surface area per mass of packed bed particles [m^2/g]
%       dP_reactor              - differential pressure of the reactor [Pa]

%   RETURN:
%       T_s                     - temperature of packed bed particles [degC]
%       q                       - power input required [W]

% ---CONSTANTS---
g = 9.81; 			% [kg*m/s^2]
in2m = 0.0254;                  % [m/in]
LPM2M3PS = 1/1000/60;           % [m^3*min/s/L]



ID = (OD - 2*t) * in2m;
A_x = pi * (ID / 2)^2;


% ---UNIMPEDED FLOW---

v = dP_reactor * density_gas * ID^2 / 64 * nu / L * 2 * g;

Re_D = 4.5 * ID / nu;

% if Re_D > 4000 || Re_D < 90
%     error(['Reynolds number out of range. Re = ' num2str(Re_D)  '. Exiting...']) 
% end


% ---IMPEDED FLOW---

%v_imp = vol_flwrt * LPM2M3PS / A_x;
v_imp = 4.5;

% ---PARTICLE AREA---

density_collective = density_nickel * wt + density_silica_alumina * (1-wt);

mass = density_collective * A_x * L;

A_pt = SAperg * 1000 * mass;


% ---FIND Ts--

Pr = nu / alpha;

if Pr > 0.8 || Pr < 0.6
    error('Prandtl Number not valid for this calculation. Should be around 0.7. Exiting...')
end

j_H = 2.06 * Re_D^-0.575 / porosity;

St = j_H / Pr^(2/3);

h = St * density_gas * C_p * v_imp;

exponent = exp( -h * A_pt / ( density_gas * v_imp * A_x * C_p ) );

T_s = (T_out - T_in *  exponent) / (1 - exponent)

% ---FIND POWER REQUIRED---

T_lm = ( (T_s - T_in) - (T_s - T_out) ) / log( (T_s - T_in) / (T_s - T_out) );

q = h * A_pt * T_lm


end
