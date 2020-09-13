%% SABATIER WATER SEPARATOR PRESSURE DROP VERIFICATION
%   @author     Andrew Zlindra
%   Created     2020-01-24
%   @reviewer   Norman Kong
%   Reviewed    2020-02-14
%
%   ASSUMPTIONS:
%       - constant diameter along length of tube
%       - negligible head loss due to gravity
%       - flow is laminar (if not, script will throw error)
%       - flow is incompressible (gas is below Mach 0.3)
%
%   INITIAL PARAM:
%       verifydP(1,0.25,0.035,1.345e-5,0.524,4.5,'CH4')
%       (inputs are for methane @100C)
%       (Source: Fluid Mechanics - Fundamentals and Applications 3rd Ed.
%        Cengel and Cimbala)

function verifydP(length, OD ,t , dyn_visc, density, vol_flwrt, gas_name)
%   PURPOSE:
%       - determines the pressure drop for a specified length of tube
%   PARAM:
%       length      - length of tube [m]
%       OD          - outer diameter of tube [in]
%       t           - wall thickness of tube [in]
%       dyn_visc    - dynamic viscosity of gas [kg/m/s]
%       density     - density of gas [kg/m^3]
%       vol_flowrt  - volume flowrate of the gas through the tube [L/min]
%       gas_name    - name of gas [string]
%   RETURN:
%       this function returns nothing, but will display output on screen


% ---CONSTANTS---
g = 9.81;                       % [m/s^2]
density_H2O = 1000;             % [kg/m^3]
Pa2psi = 0.000145038;           % [Pa/psi]
in2m = 0.0254;                  % [m/in]
LPM2M3PS = 1/1000/60;           % [m^3*min/s/L]

% ---TUBE GEOMETRY---
ID = (OD - 2 * t) * in2m;       % [m]
r = ID / 2;
A = pi * r^2;

% ---FLOW CALCS---
v_avg = vol_flwrt*LPM2M3PS/A;   % [m/s]
Re = v_avg*ID/dyn_visc;

if Re <= 2300
    f = 64/Re;
else
    error('ERROR: Non-Laminar flow. Cannot continue. Exiting...')

end

% calculate head in terms of the gas medium
h_L_gas = f * length / ID * v_avg^2 / 2 / g;

% calculate the pressure in [psi]
dP = density * g * h_L_gas * Pa2psi;

% calculate head in terms of water
h_L_H2O = dP / density_H2O / g;


disp(['Analysis for: ' gas_name])
disp(['Gas head = ' num2str(h_L_gas) ' [m], delta_pressure = ' num2str(dP) '[psi], Water head = ' num2str(h_L_H2O*1000) '[mm]'])

end