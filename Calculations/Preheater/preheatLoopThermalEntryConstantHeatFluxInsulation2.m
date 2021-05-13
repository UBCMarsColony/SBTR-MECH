%% PREHEATER CONSTANT HEAT FLUX WITH TAPE INSULATION CALC
%
%   @author Andrew Zlindra
%   Created     2021-05-03
%   @reviewer   
%   Reviewed  
%
%   PURPOSE:
%       - plot the wall, bulk gas, and nichrome temperature curves for a constant heat
%       flux tube

% -- tube properties --
if ~exist('OD','var')
    clear; clc; clf;
    OD = .25 * 0.0254;          % [m]
    wall = 0.035 * 0.0254;      % [m]
    L = 2.5 * 0.3048;           % [m]
    T_n = 700;                  % [degC]
    tape_thick = 0.0625*0.0254;
    Ti_air = 20;
    k_tape = 0.018;
    plot = true;
    Vdot_air = 4 / 1000 / 60;
end 

ID = OD - 2*wall;           % [m]
perim = pi * ID;            % [m]
Area = pi * (ID/2)^2;       % [m^2]

r_w = ID/2;

r_n = r_w + wall + tape_thick;
a = 3*L/4;
properties = load('air_1atm');

T_out_guess = T_n;
while 1
    T_f = (T_out_guess + Ti_air)/2 + 273.15;


    density_air     = interp1(properties.T, properties.dens,    T_f);
    cp_air          = interp1(properties.T, properties.cp,      T_f);
    k_air           = interp1(properties.T, properties.k,       T_f);
    mu_air          = interp1(properties.T, properties.mu,      T_f);
    Pr_air          = interp1(properties.T, properties.Pr,      T_f);


    mdot_air = density_air * Vdot_air;
    v_air = Vdot_air / Area;

    ReD = density_air*v_air*ID/mu_air;
    Gz_at_a = ReD*Pr_air*ID/a;

    NuD = @(Gz) (4.364+0.263.*Gz.^0.506.*exp(-41./Gz)).*(Gz<667) ...
        + (1.302.*Gz.^(1/3)-1).*(Gz>2e4) ...
        + (1.302.*Gz.^(1/3)-0.5).*(Gz<2e4).*(Gz>667);

    X = r_w/NuD(Gz_at_a)/k_air+perim*a/mdot_air/cp_air;

    % mu2 = interp1(properties.T,properties.mu,T_n); %new
    % NuD = @(Re) 0.027*Re^0.8*Pr_air^(1/3)*(mu_air/mu2)^0.14; %new
    % NuD = @(Re) 0.023*Re^0.8*Pr_air^0.4; %new
    % f = (.79*log(ReD)-1.64)^(-2);
    % NuD = @(Re) ((f/8)*(Re-1000)*Pr_air)/(1+12.7*sqrt(f/8)*(Pr_air^(2/3)-1)); %new
    % X = r_w/NuD(ReD)/k_air+perim*a/mdot_air/cp_air; %new

    Y = (r_n - r_w)/X/k_tape;
    T_w_at_a = (T_n + Ti_air*Y)/(Y+1);

    heat_flux = (T_w_at_a - Ti_air)/X;

    q = heat_flux*pi*ID*L;

    gas_curve = @(x) Ti_air + heat_flux.*perim.*x./mdot_air./cp_air;
    q_req = mdot_air*cp_air*(gas_curve(L) - Ti_air);


    % need to find NuD as f(x)
    wall_curve = @(x) gas_curve(x) + heat_flux.*r_w./NuD(ReD.*Pr_air.*ID./x)./k_air;
    % wall_curve = @(x) gas_curve(x) + heat_flux.*r_w./NuD(ReD)./k_air; %new


    nichrome_curve = @(x) heat_flux.*(r_n - r_w)./k_tape + wall_curve(x);

    if abs(wall_curve(L) - T_out_guess) < 1
        break
    end
    T_out_guess = wall_curve(L);
    
end


if plot == true
    % figure
    fplot(wall_curve,'DisplayName','Wall Temp Curve')
    hold on
    fplot(gas_curve,'DisplayName','Gas Temp Curve')
    fplot(nichrome_curve,'DisplayName','Nichrome Temp Curve')
    xlim([0 L])
    ylim([0 nichrome_curve(L)])
    xlabel('Length [m]')
    ylabel('Temp [\circC]')
    legend('location','SE')
    grid on
end

