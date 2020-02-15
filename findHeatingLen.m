%% SABATIER HEATING LENGTH CALCULATION
%   @author     Andrew Zlindra
%   Created     2020-01-14
%   @reviewer
%   Reviewed
%
%   ASSUMPTIONS:
%       -


function findHeatingLen(density, vol_flwrt, OD, C_p, T_s, T_in, T_out, k_f)
%   PURPOSE:
%       - determines the tube length required to heat up a gas
%   PARAM:
%       density     - fluid density
%       vol_flwrt   - volume flowrate of the fluid
%       OD          - outer diameter of the tube
%       C_p         - C_p of the fluid
%       T_s         - outer surface temperature of the tube
%       T_in        - inlet gas temperature
%       T_out       - outlet gas temperature
%       k_f         - thermal conductivity of the fluid
%   RETURN:

perim = pi*OD;

m_dot = density * vol_flwrt;

h = Nu*k_f/OD;

L = m_dot * C_p / h / perim * ln( (T_s - T_out) / (T_s - T_in) );



end