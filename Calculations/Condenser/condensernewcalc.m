% TODO: THIS CALCULATION

%% MATLAB

%% STEPS
%
% 1. find U --> h_int, h_cooling (guess T_s)
%    find using the condensation correlation and annulus correlation, skip thermal entry, ask if necessary to calculate
% 2. H/E eqns solve those


%% ASSUMPTIONS

% - pressure 1 atm absolute

%% UNIVERSAL CONSTANTS

g = 9.81;


%% CONDENSER PROPERTIES

L = 13 * 0.0254;

ID = 0.5 * 0.0254;
OD = 1.25 * 0.0254;


%% STEAM PROPERTIES

T_sat = 100;
V_dot_gas = 4 / 60 / 1000;
T_h1 = 400;


%% COOLANT PROPERTIES

T_c1 = 18;
V_dot_cool = 6 / 60 / 1000

%% FIND h_int

T_s = 20; % guess

Ja = (C_p * (T_s - T_sat)) / (h_fg)

h_fg_prime = h_fg * (1+ 0.68*Ja)

P = k_l * L * (T_sat - T_s) / ( mu_l * h_fg_prime * (v_l^2 / g)^(1/3) )

if P <= 15.8

elseif 15.8 < P && 

end

