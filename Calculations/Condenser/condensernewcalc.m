%% SABATIER GAS COOLER HEAT TRANSFER CALCULATION
%   @author     Andrew Zlindra and Norman Kong
%   Created     2020-09-19
%   @reviewer   Norman Kong and Andrew Zlindra
%   Reviewed    2020-09-19
%
%% ASSUMPTIONS
%
% - pressure 1 atm absolute
% - wall temperature is constant


clear

g = 9.81;

%% COOLER PROPERTIES/DIMENSIONS

ID = 0.5 * 0.0254;          % [m]
OD = 1.25 * 0.0254;         % [m]

A_int = pi * (ID/2)^2;      % [m^2]

deltaX = 0.0275 * 0.0254;   % [m]
k_ss = 17;                  % [W/m/K]


L = 7 * 0.0254;

A = pi * ID * L;

%% COOLED GAS PROPERTIES

h_fg = 2257000; % [J/kg]

% *** IDEAL GAS ***
V_dot_gas = 4 / 60 / 1000;  % [m^3/s]

% steam properties
T_h2 = 100;
rho_h2 = 0.5976;
mu_h2 = 12.28e-6;
Pr_h2 = 1.018;
k_h2 = 0.02509;
cp_h2 = 2080;

T_sat = T_h2;

% condensed water properties

rho_h3 = 958.3;
cp_h3 = 4216;
k_h3 = 0.6791;
v_h3 = 2.94e-7;
mu_h3 = rho_h3 * v_h3;
Pr_h3 = 1.75;

%% COOLANT PROPERTIES

rho_c2 = 998.8;
T_c2 = 18;
V_dot_cool = 6 / 60 / 1000;
k_coolant = 0.5927;
cp_coolant = 4187;

T_s = T_c2;


%% CALCULATION

% calculate steam velocity and mass flowrate

v_steam = V_dot_gas / A_int;
m_dot_steam = rho_h2 * V_dot_gas;


% calculate coolant mass flowrate

m_dot_coolant = rho_c2 * V_dot_cool;


% steam --> water

Ja = cp_h3 * (T_s - T_sat) / h_fg;

h_prime_fg = h_fg * (1 + 0.68 * Ja);


P = k_h3 * L * (T_sat - T_s) / (mu_h3 * h_prime_fg *( v_h3^2 / g )^(1/3) ); 

if (P <= 15.8)

    h_int = 0.943 * P ^(-1/4) * k_h3 / ( v_h3^2 / g )^(1/3);

elseif (15.8 < P <= 2530)

    h_int = 1/P * (0.68 * P + 0.89)^(0.82) * k_h3 / ( v_h3^2 / g )^(1/3); 

elseif ( P > 2530 && Pr_h3 > 1)

    h_int = 1/P * ((0.024 * P - 53 ) * Pr_h3^(1/2) + 89)^(4/3) * k_h3 / ( v_h3^2 / g )^(1/3); 
end



% calculate h_ext

DiDo = ID / OD;

% NOTE: consider convection on outer side of condenser
NuI = 5.74;

h_ext = NuI / (OD - ID) * k_coolant;

% calculate U

U = 1 / (  1/h_ext + 1/h_int + deltaX/k_ss);


Cmin = m_dot_coolant * cp_coolant;

NTU = U * A / Cmin;

eff = 1 - exp(-NTU);

q_max = Cmin * (T_h2 - T_c2);

q = eff * q_max;

T_c3 = q/m_dot_coolant/cp_coolant + T_c2;

q_req = m_dot_steam * h_fg;