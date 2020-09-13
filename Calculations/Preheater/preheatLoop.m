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

% -- air properties --
% pressure is around 3 psi, assume 1 atm absolute
% assume film temperature btw 20C and 400C = 210C = 480K
% density_air = 0.7056;
% cp_air = 1030;
% k_air = 0.03971;
% To_air = 400;
% Ti_air = 20;
% Vdot_air = 4 / 1000 / 60;
% mdot_air = density_air * Vdot_air;
% Nu_air = 3.66;

% @ 330K film
% density_air = 1.07;
% cp_air = 1008;
% k_air = 0.02821;
% To_air = 30;
% Ti_air = 20;
% Vdot_air = 4 / 1000 / 60;
% mdot_air = density_air * Vdot_air;
% Nu_air = 3.66;

% 300K filme
density_air = 1.177;
cp_air = 1006;
k_air = 0.02544;
To_air = 30;
Ti_air = 20;
Vdot_air = 4 / 1000 / 60;
mdot_air = density_air * Vdot_air;
Nu_air = 3.66;



% -- stainless steel properties --
k_st = 16.2;
% -- water properties
% assume Ts = Tinf then 
Nu_w = 0.6^2;
k_w = 0.6737;

% -- tube properties --
OD = 0.25 * 0.0254;
wall = 0.035 * 0.0254;
ID = OD - 2*wall;
T_tube = 90;
perim = pi * ID;

% eqns:

h_air = Nu_air * k_air / ID;

h_w = Nu_w * k_w / OD;

U = 1/(1/h_air + wall/k_st + 1/h_w);

L = log( (T_tube - To_air) / (T_tube - Ti_air) ) * - mdot_air * cp_air / U / perim

L_feet = L * 3.28
