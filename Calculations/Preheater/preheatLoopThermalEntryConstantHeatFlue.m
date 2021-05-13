%% PREHEATER CONSTANT WALL HEAT FLUX CALC
% PURPOSE:
%   - plot the wall and bulk gas temperature curves for a constant heat
%   flux tube


% -- tube properties --
OD = 1 * 0.0254;            % [m]
wall = 0.035 * 0.0254;      % [m]
ID = OD - 2*wall;           % [m]
T_w = 500;               % [degC]
perim = pi * ID;            % [m]
Area = pi * (ID/2)^2;       % [m^2]
L = 1.5 * 0.3048;            % [m]

radius = ID/2;
a = L/2;

Ti_air = 20;
T_f = (T_w + Ti_air)/2 + 273.15;

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


ReD = density_air*v_air*ID/mu_air;
Gz_at_a = ReD*Pr_air*ID/a;

if Gz_at_a < 667
    NuD = 4.364+0.263*Gz_at_a^0.506*exp(-41/Gz_at_a);
elseif Gz_at_a > 2e4
    NuD = 1.302*Gz_at_a^(1/3)-1;
else
    NuD = 1.302*Gz_at_a^(1/3)-0.5;
end

heat_flux = (T_w - Ti_air)/(radius/NuD/k_air+perim*a/mdot_air/cp_air);

q = heat_flux*pi*ID*L;

gas_curve = @(x) Ti_air + heat_flux.*perim.*x./mdot_air./cp_air;

NuD = @(Gz) (4.364+0.263.*Gz.^0.506.*exp(-41./Gz)).*(Gz<667) ...
    + (1.302.*Gz.^(1/3)-1).*(Gz>2e4) ...
    + (1.302.*Gz.^(1/3)-0.5).*(Gz<2e4).*(Gz>667);
% need to find NuD as f(x)
wall_curve = @(x) gas_curve(x) + heat_flux.*radius./NuD(ReD.*Pr_air.*ID./x)./k_air;
% figure
fplot(wall_curve)
hold on
fplot(gas_curve)
xlim([0 L])
ylim([0 wall_curve(L)])
xlabel('Length [m]')
ylabel('Temp [\circC]')
legend('Wall Temp Curve','Gas Temp Curve','location','SE')
grid on

