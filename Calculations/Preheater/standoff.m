%% STANDOFF SIMULATOR
% PURPOSE:
%   - calculate rate of heat transfer of a standoff assuming it is a solid
%   stainless steel rod

clear; clc; clf;

properties = load('air_1atm.mat');
g = 9.81;
T_inf = 20;
T_s_guess = 300;

T_f = (T_s_guess+T_inf)/2 +273.15;

nu_air          = interp1(properties.T, properties.nu,      T_f);
k_air           = interp1(properties.T, properties.k,       T_f);
mu_air          = interp1(properties.T, properties.mu,      T_f);
Pr_air          = interp1(properties.T, properties.Pr,      T_f);

L = 4*0.0254;
T_b = 400;
OD = 0.25 * 0.0254;
k_steel = 17;

p = pi*OD;
% Af = pi/4*(OD^2 - (OD-2*delta_x)^2);
Af = pi/4*(OD^2);


beta = 1/T_f;
Gr = g*beta*(T_s_guess-T_inf)*OD^3/nu_air^2;
Ra = Gr*Pr_air;

Nu = (0.6 + 0.387*Ra^(1/6)/(1+(0.559/Pr_air)^(9/16))^(8/27))^2;
h = Nu*k_air/OD;

m = sqrt(h*p/k_steel/Af);
l = Af/p;
q = sqrt(h*p*k_steel*Af)*(T_b-T_inf)*tanh(m*(L+l))

y = @(x) (T_b-T_inf)* cosh(m*(L+l-x))/cosh(m*(L+l)) + 20;
fplot(y)
xlim([0 L+l])
ylim([0 520])
xlabel("Length [m]")
ylabel("Temperature [\circC]")
grid on


