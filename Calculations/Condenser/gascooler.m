%% SABATIER GAS COOLER HEAT TRANSFER CALCULATION
%   @author     Andrew Zlindra and Norman Kong
%   Created     2020-09-14
%   @reviewer   Norman Kong and Andrew Zlindra
%   Reviewed    2020-09-14
%
%% ASSUMPTIONS
%
% - pressure 1 atm absolute
% - wall temperature is constant

clear

%% COOLER PROPERTIES/DIMENSIONS

ID = 0.5 * 0.0254;          % [m]
OD = 1.25 * 0.0254;         % [m]

A_int = pi * (ID/2)^2;      % [m^2]

deltaX = 0.0275 * 0.0254;   % [m]
k_ss = 17;                  % [W/m/K]

%% STEAM PROPERTIES

% *** IDEAL GAS ***
V_dot_gas = 4 / 60 / 1000;  % [m^3/s]

% inlet
T_h1 = 400;
rho_h1 = 0.3266;
mu_h1 = 24.45e-6;
Pr_h1 = 0.924;
k_h1 = 0.05476;
cp_h1 = 2070;

% outlet
T_h2 = 100;
rho_h2 = 0.5976;
mu_h2 = 12.28e-6;
Pr_h2 = 1.018;
k_h2 = 0.02509;
cp_h2 = 2080;

%% COOLANT PROPERTIES

rho_c1 = 998.8;
T_c1 = 18;
V_dot_cool = 6 / 60 / 1000;
k_coolant = 0.5927;
cp_coolant = 4187;

%% CALCULATION

% calculate steam velocity and mass flowrate

v_steam = V_dot_gas / A_int;
m_dot_steam = rho_h1 * V_dot_gas;

% calculate h_int using inlet properties

ReD_int_h1 = rho_h1 * v_steam * ID / mu_h1;

x_th_entry_h1 = ID * 0.034 * ReD_int_h1 * Pr_h1;

GzD_h1 = ID / x_th_entry_h1 * ReD_int_h1 * Pr_h1;

NuD_int_h1 = 3.66 + ( 0.0668 * GzD_h1) / (1 + 0.04 * GzD_h1^(2/3) );

h_int_h1 = NuD_int_h1 / ID * k_h1;


% calculate h_int using outlet properties

ReD_int_h2 = rho_h2 * v_steam * ID / mu_h2;

x_th_entry_h2 = ID * 0.034 * ReD_int_h2 * Pr_h2;

GzD_h2 = ID / x_th_entry_h2 * ReD_int_h2 * Pr_h2;

NuD_int_h2 = 3.66 + ( 0.0668 * GzD_h2) / (1 + 0.04 * GzD_h2^(2/3) );

h_int_h2 = NuD_int_h2 / ID * k_h2;  



% calculate coolant mass flowrate

m_dot_coolant = rho_c1 * V_dot_cool;


% calculate h_ext

DiDo = ID / OD;

% NOTE: consider convection on outer side of condenser
NuI = 5.74;

h_ext = NuI / (OD - ID) * k_coolant;

% calculate U

U = 1 / (  1/h_ext + 1/h_int_h1 + deltaX/k_ss);
% calculate Cr

Cmin = m_dot_steam * cp_h1;
Cmax = m_dot_coolant * cp_coolant

Cr = Cmin/Cmax;

% calculate q

q = m_dot_steam * cp_h1 * (T_h2 - T_h1);

T_c2 = T_c1 - q / m_dot_coolant / cp_coolant;

delta_T_mean = ( (T_h1 - T_c2) - (T_h2 - T_c1) ) / (log( (T_h1 - T_c2) / (T_h2 - T_c1) ))


% calculate heat transfer area

A = - q / U / delta_T_mean;

% calculate length

L = A / pi / ID; % [m]