%% condenser single phase calculation

% steps:
% (1) find convection coeff for water
% (2) find convection coeff for steam
% (3) solve for U
% (4) calculate NTU
% (5) find effectiveness
% (6) find q
% (7) find Tc_out
% (7b)verify Tfilm for Twater
% (8) calculate LMTD
% (9) calculate Th_out


% (1)
Tc1 = 20;
V_dot_water = 6;
m_dot_water = 6/60/1000*999;
Cwater = 4.181e3;

% water film properties
% assume Tf ~ 40C (313K)
rho_c1 = 991;       % [kg/m^3]
mu_c1 = 631e-6;     % [Ns/m^2]
Pr_water = 4.16;    % [-]
k_water = 634e-3;   % [W/m/K]



% H/E dimensions [in]
OD_water = 1.25;
t = 0.0275;
ID_water = OD_water - 2*t;
OD_steam = 0.5;
ID_steam = OD_steam - 2*t;
L = 13;
A = pi*OD_steam*L;

D_h_water = 0.0254 * (ID_water - OD_steam);

A_water = 0.0254^2 * pi/4 * (ID_water^2 - OD_steam^2);

v_water = V_dot_water / 60 / 1000 / A_water;

Re_water = rho_c1 * v_water * D_h_water / mu_c1;

Nu_D_water = 0.023 * Re_water^0.8 * Pr_water^0.4;

h_water = Nu_D_water * k_water / D_h_water


% (2)
% to find internal conv coeff. calculate gravity controlled coeff and shear
% controlled coeff & take the larger value

% assume pressure around atmospheric (Tsat = 100C)

rho_l = 1/1.024*1e3;
rho_v = 1/1.6734;
k_l = 664e-3;
g = 9.81;
mu_l = 389e-6;
T_sat = 100;
T_v = 400;
T_w = 50; % asuume need to verify
cp_l = 4.217e3;
cp_v = 2.029e3;

hfg = 2257e3;
Ja = cp_l * (T_w - T_sat)/hfg;
hfg_prime = hfg*(1+0.68*Ja);
h_con_gravity = 0.943 * ( g * rho_l * (rho_l - rho_v) * k_l^3 * hfg_prime / mu_l / (T_sat - T_w) / (0.0254*L) )^0.25 * ( 1 + cp_v / hfg_prime * (T_v - T_sat))^0.25

h_con_forced = (0.55+0.29) * 3.66 * k_l / (0.0254*ID_steam)

U = h_water*h_con_gravity/(h_water+h_con_gravity)

Cmin = m_dot_water * Cwater;

NTU = U*A*0.0254^2/Cmin

eff = 1 - exp(-NTU)

qmax = Cmin*(400-20);

q = eff*qmax

T_out = q/m_dot_water/Cwater + 20