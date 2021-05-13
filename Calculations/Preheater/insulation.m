%% PREHEATER INSULATION HEAT FLUX CALC
%
% PURPOSE:
%   - calculate heat transfer for various insulation thicknesses

clear; clc; clf;

Tinf = 20;
properties = load('air_1atm');
T_nichrome = 600;
g = 9.81;

OD_tube = 0.25 *0.0254;
wall_thick = 0.035 * 0.0254;
tape_thick = 0.0625 *0.0254;
k_tape = 0.016;

D_nichrome = OD_tube + 2*tape_thick;
L = 2.5 * 0.3048;


rockwool_properties = load('mineral_wool_k.mat');
k_rockwool = interp1(rockwool_properties.T, rockwool_properties.k, (T_nichrome+Tinf)/2 + 273.15);

if isnan(k_rockwool)
    error("k_rockwool is undefined")
end

% k_tape = 0.033;
% k_tape = 0.07;

N = 1000;
ins_thick = linspace(0,5,N)*0.0254;

q_store = zeros(N,1);
T_s_calc = zeros(N,1);
R2 = zeros(N,1);
R1 = zeros(N,1);
wall_curve = get_curve(OD_tube,wall_thick,L,T_nichrome,tape_thick,Tinf,k_tape);

for i = (1:N)
    T_s_guess = Tinf + 3;
    
    while 1
        
        T_f = (T_s_guess + Tinf)/2 + 273.15;
        
        density_air     = interp1(properties.T, properties.dens,    T_f);
%         cp_air          = interp1(properties.T, properties.cp,      T_f);
        k_air           = interp1(properties.T, properties.k,       T_f);
        mu_air          = interp1(properties.T, properties.mu,      T_f);
        Pr_air          = interp1(properties.T, properties.Pr,      T_f);       
        
        D = D_nichrome + 2*ins_thick(i);

        R2(i) = log(D/D_nichrome)/2/pi/k_rockwool/L;

        A = pi*D*L;
        beta = 1/T_f;
        Gr = g*beta*(T_s_guess-Tinf)*D^3/(mu_air/density_air)^2;
        Ra = Gr*Pr_air;

        if Ra > 1e12
            error('Ra not okay')
            Ra
        end

        Nu = (0.6 + (0.387 * Ra^(1/6) )/(1 + (.559/Pr_air)^(9/16) )^(8/27) )^2;

%         v = 0.5;
%         Re = density_air*v*D/mu_air;
%         Nu = 0.3 + (0.62*sqrt(Re)*Pr_air^(1/3)*(1+(0.4/Pr_air)^(2/3))^(-1/4))*(1+(Re/282000)^(5/8))^0.8;

        h = k_air*Nu/D;

        % R = 1/h/A + ins_thick/k_tape;

        R1(i) = 1/h/A;
        R = R1(i)+R2(i);
        % high R equals low q

        q = (T_nichrome - Tinf)/R;

        T_s = T_nichrome - q*log(D/D_nichrome)/2/pi/k_rockwool/L;
        
        if abs(T_s - T_s_guess) < 1
            break
        end
        T_s_guess = T_s;
        
    end
    q_store(i) = q;
    T_s_calc(i) = T_s;
    
    
    q_integrated = 1/(1/h/pi/D + log(D/D_nichrome)/2/pi/k_rockwool)*integral(wall_curve,1e-5,L);
    q_integrated_store(i) = q_integrated;
end
figure
hold on
plot(ins_thick,q_store, 'displayname','q_{const wall temp}')
plot(ins_thick,q_integrated_store,'DisplayName','q_{integrated}')
xlabel('Insulation Thickness [m]')
ylabel('Heat Transfer [W], Temp [\circC]')
title('Insulation Thickness Inspection')

ylim([0,max(q_store)])
plot(ins_thick,T_s_calc,'displayname','T_s')
grid on
yyaxis right
plot(ins_thick,R2,'displayname','R_{ins}')
plot(ins_thick,R1,'displayname','R_{conv}')
ylabel('Thermal Resistance [K/W]')
legend('location','e')
% plottools('on')

% save('vars.mat','h','D','D_nichrome','k_tape')

disp("done")
function [nichome_temp_curve] = get_curve(OD,wall,L,T_n,tape_thick,Ti_air,k_tape)
    Vdot_air = 4/60/1000;
    plot = true;
    preheatLoopThermalEntryConstantHeatFluxInsulation
    nichome_temp_curve = nichrome_curve;
end
