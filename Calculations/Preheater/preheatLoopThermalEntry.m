%% SABATIER PREHEAT LOOP CALCULATION
%   @author     Andrew Zlindra
%   Created     2020-08-15
%   @reviewer   
%   Reviewed    
%
%   ASSUMPTIONS:
%       - gas is at atmospheric pressure
%       - line is assumed to be completely straight (when in fact it is
%       curled)
%       - tube outer surface temperature = water temperature (assume water
%       is a thermal reservoir)
%       - assume the tube outer surface temperature is constant along its
%       length
%       - assume the temperature of the water is uniform
%       - assume that the water isn't boiling (<100C)
%       - assume tube wall is like a plate instead of radial (delta_X/k)
%       - assume fully developed flow
%       - assume a thermal entrance region exists
%       - assume air is an ideal gas (Z~1)
%
%   PARAMS:
%
%   RETURNS:
%
%   EXAMPLE PARAMS:
%
%   SOURCES:
%
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
OD = 0.25 * 0.0254;         % [m]
wall = 0.035 * 0.0254;      % [m]
ID = OD - 2*wall;           % [m]
T_tube = 90;                % [degC]
perim = pi * ID;            % [m]
Area = pi * (ID/2)^2;       % [m^2]
L = 6 * 0.3048

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

% @ 330K film
density_air = 1.07;
cp_air = 1008;
k_air = 0.02821;
Ti_air = 20;
Vdot_air = 4 / 1000 / 60;
mdot_air = density_air * Vdot_air;
Nu_air = 3.66;
kine_visc_air = 1.981e-5;
v_air = Vdot_air / Area;
Pr_air = 0.708;

% 300K filme
% density_air = 1.177;
% cp_air = 1006;
% k_air = 0.02544;
% Ti_air = 20;
% Vdot_air = 4 / 1000 / 60;
% mdot_air = density_air * Vdot_air;
% kine_visc_air = ;
% v_air = Vdot_air / Area;
% Pr_air = 


% -- stainless steel properties --
k_st = 16.2;

% -- water properties
% assume Ts = Tinf then 
Nu_w = 0.6^2;
k_w = 0.6737;

% eqns:

ReD = density_air * v_air * ID / kine_visc_air;

if ReD > 2300
    error("non-laminar flow")
    
end

L_entry = 0.05 * ReD * Pr_air * ID
Gz = ID/L_entry * ReD * Pr_air;
Nu_air_entry = 3.66 + 0.0668 * Gz / (1 + 0.04 * Gz^(2/3));


h_air = Nu_air * k_air / ID;
h_air_entry = Nu_air_entry * k_air / ID;

h_w = Nu_w * k_w / OD;

U = 1/(1/h_air + wall/k_st + 1/h_w);
U_entry = 1/(1/h_air_entry + wall/k_st + 1/h_w);

T_o_entry = T_tube - (T_tube - Ti_air)*exp(- U_entry * perim * L_entry / mdot_air / cp_air)


T_o = T_tube - (T_tube - T_o_entry)*exp(- U * perim * (L - L_entry) / mdot_air / cp_air)

