%% PREHEATER CONSTANT WALL TEMPERATURE CALC
%   @author     Andrew Zlindra
%   Created     2020-08-15
%   @reviewer   
%   Reviewed    
%
%   PURPOSE:
%       - calculate the rate of heat transfer to a fluid given a constant
%       wall temperature
%
%   ASSUMPTIONS:
%       - gas is at atmospheric pressure
%       - tube is assumed to be completely straight
%       - assume the tube outer surface temperature is constant along its
%       length
%       - assume tube wall is like a plate instead of radial (delta_X/k)
%       - assume fully developed flow
%       - assume a thermal entrance region exists
%       - assume ideal gas (Z~1)
%
%   SOURCES:
%       - gas data: NIST 
%



% steps:
%   1. get air film properties ~55C
%   2. get water properties at 90C
%   3. get SS properties at ~55C
%   4. calculate h_air, use Nu=3.66
%   5. calculate h_water, use ambient correlactions
%   6. use h_air and h_water -->
%   7. solve for T_out

% -- tube properties --
OD = 1 * 0.0254;            % [m]
wall = 0.035 * 0.0254;      % [m]
ID = OD - 2*wall;           % [m]
T_tube = 840;               % [degC]
perim = pi * ID;            % [m]
Area = pi * (ID/2)^2;       % [m^2]
L = 1.5 * 0.3048            % [m]

% -- air properties --
% pressure is around 3 psi, assume 1 atm absolute
% assume film temperature btw 20C and 400C = 210C = 480K
% density_air = 0.7056;
% cp_air = 1030;
% k_air = 0.03971;
% Ti_air = 20;
% Vdot_air = 4 / 1000 / 60;
% mdot_air = density_air * Vdot_air;
% Nu_air = 3.66;

Ti_air = 20;
T_f = (T_tube + Ti_air)/2 + 273.15;

properties = load('air_1atm');
density_air     = interp1(properties.T, properties.dens,    T_f);
cp_air          = interp1(properties.T, properties.cp,      T_f);
k_air           = interp1(properties.T, properties.k,       T_f);
mu_air          = interp1(properties.T, properties.mu,      T_f);
Pr_air          = interp1(properties.T, properties.Pr,      T_f);

Vdot_air = 4 / 1000 / 60;
mdot_air = density_air * Vdot_air;
Nu_air = 3.66;
v_air = Vdot_air / Area;

% -- stainless steel properties --
k_st = 16.2;
% k_st = 0.1;

% -- water properties
% assume Ts = Tinf then 
Nu_w = 0.6^2;
k_w = 0.6737;
h_w = Nu_w * k_w / OD;

% eqns:

ReD = density_air * v_air * ID / mu_air;

if ReD > 2300
    error("non-laminar flow")
    
end

L_entry = 0.05 * ReD * Pr_air * ID
Gz = ID/L_entry * ReD * Pr_air;
Nu_air_entry = 3.66 + 0.0668 * Gz / (1 + 0.04 * Gz^(2/3));
% Nu_air_entry = (3.66/tanh(2.264*Gz^(-1/3)+1.7*Gz^(-2/3))+0.0499*Gz*tanh(Gz^(-1)))/tanh(2.432*Pr_air^(1/6)*Gz^(-1/6));
% Nu_air = 0.023*ReD^0.8*Pr_air^0.4;

h_air = Nu_air * k_air / ID;
h_air_entry = Nu_air_entry * k_air / ID;

% wall = 0.25*0.0254;
U = 1/(1/h_air + wall/k_st);
U_entry = 1/(1/h_air_entry + wall/k_st);

T_o_entry = T_tube - (T_tube - Ti_air)*exp(- U_entry * perim * L_entry / mdot_air / cp_air)

% neglect entry effects
L_entry = 0;
T_o_entry = 20;

T_o = T_tube - (T_tube - T_o_entry)*exp(- U * perim * (L - L_entry) / mdot_air / cp_air)

q_air = mdot_air*cp_air*(T_o-Ti_air)
q_conv = h_air*perim*L*((T_tube - T_o)-(T_tube - Ti_air))/log((T_tube - T_o)/(T_tube - Ti_air))

