%% PREHEATER INSULATION HEAT FLUX CALC
%
% PURPOSE:
%   - calculate heat transfer for various insulation thicknesses

clear; clc; clf;

Tinf = 20;
properties = load('air_1atm');
T_nichrome = 700;
g = 9.81;

OD_tube = 0.25 *0.0254;
wall_thick = 0.035 * 0.0254;
ID_tube = OD_tube - 2*wall_thick;
tape_thick = 0.0625 *0.0254;
% k_tape = 0.018;
k_tape = 0.035;

D_nichrome = OD_tube + 2*tape_thick;
% L = 2.5 * 0.3048;
V_dot = 4 /60 /1000;

rockwool_properties = load('mineral_wool_k.mat');


% k_tape = 0.033;
% k_tape = 0.07;

N = 1;
% ins_thick = linspace(0,5,N)*0.0254;
ins_thick = 0.08;

% q_store = zeros(N,1);
% T_s_calc = zeros(N,1);
% R2 = zeros(N,1);
% R1 = zeros(N,1);

M=20;
T_nichrome = linspace(400,1400,M);
% T_nichrome = 1400;

O=20;
L = linspace(0.1,3,O);



for i = (1:N) % insulation thickness iterator
    
    for j = (1:M) % nichrome temperature iterator
        
        for k = (1:O)
            [nichr_curve, gas_curve, q_gas,cp] = get_curve(OD_tube,wall_thick,L(k),T_nichrome(j),tape_thick,Tinf,k_tape,false,V_dot);
            k_rockwool = interp1(rockwool_properties.T, rockwool_properties.k, (T_nichrome(j)+Tinf)/2 + 273.15,'linear','extrap');
            if isnan(k_rockwool)
                error("k_rockwool is undefined")
            end

            T_s_guess = Tinf + 3;

            [q,T_s,R1(i),R2(i),q_integrated] = insulation_solver(g,T_nichrome(j),T_s_guess,Tinf,...
                D_nichrome,ins_thick(i),L(k),properties,k_rockwool,nichr_curve);
            q_store_const_wall_t(i,j,k) = q;
            T_s_calc(i,j,k) = T_s;
            q_store_const_heat_flux(i,j,k) = q_integrated;
            
            T_out_gas(i,j,k) = gas_curve(L(k));
            q_gas_store(i,j,k) = q_gas;
            cp_store(i,j,k) = cp;
        end
    end
end

if M > 1 && N > 1
    subplot(1,2,1)
    hold on
    [X,Y]=meshgrid(ins_thick,T_nichrome);
    contourf(X,Y,q_store_const_wall_t',20)
    c = colorbar;
    c.Label.String = 'Heat Loss through the insulation [W]';
    xlabel('Insulation Thickness [m]')
    ylabel('Nichrome Temp [\circC]')
    title(['Heat Loss Const Wall Temp @ length = ' num2str(L/0.3048) ' ft'])
    subplot(1,2,2)
    hold on
    [X,Y]=meshgrid(ins_thick,T_nichrome);
    contourf(X,Y,q_store_const_heat_flux',20)
    c = colorbar;
    c.Label.String = 'Heat Loss through the insulation [W]';
    xlabel('Insulation Thickness [m]')
    ylabel('Nichrome Temp [\circC]')
    title(['Heat Loss Const Heat Flux @ length = ' num2str(L/0.3048) ' ft'])
    
    figure
    hold on
    [X,Y]=meshgrid(ins_thick,T_nichrome);
    contourf(X,Y,q_store_const_wall_t' - q_store_const_heat_flux',20)
    c = colorbar;
    c.Label.String = 'Heat Loss through the insulation [W]';
    xlabel('Insulation Thickness [m]')
    ylabel('Nichrome Temp [\circC]')
    title(['q_const_wall_t - q_const_heat_flux @ length = ' num2str(L/0.3048) ' ft'])
elseif M > 1 && O > 1
%     figure
    hold on
    [X,Y]=meshgrid(L,T_nichrome);
    contourf(X,Y,squeeze(q_store_const_heat_flux),20,'DisplayName','Insulation Heat Loss')
%     colormap 'hot'
    hold on
    c = colorbar;
    c.Label.String = 'Heat Loss through the insulation [W]';
    
    [dd,hh] = contour(X,Y,squeeze(T_out_gas),'LevelList',[315 350 370 380 410 450 540],'DisplayName',...
        'T_{gas out}','LineColor','c','LineWidth',1);
    clabel(dd,hh,'Color','c','fontweight','bold','LabelSpacing',400);
    hh.LevelList = round(hh.LevelList, 1);
    
    [d,h] = contour(X,Y,squeeze(q_gas_store),10,'LineColor','m','LineWidth',1,...
        'ShowText','on','DisplayName','q_{gas}');
    clabel(d,h,'Color','m','fontweight','bold','LabelSpacing',400);
    h.LevelList = round(h.LevelList, 1);
    
    xlabel('Length [m]')
    ylabel('Nichrome Temp [\circC]')
    title(['Heat Loss @ insulation thickness = ' num2str(ins_thick) ...
        ' [m], Flowrate = ' num2str(V_dot*60*1000) ' [LPM]'])
    legend('Location','northwestoutside')
    
%     figure(2)
%     hold on
%     [X,Y]=meshgrid(L,T_nichrome);
%     contour(X,Y,squeeze(T_out_gas),'LevelList',400)
%     c = colorbar;
%     c.Label.String = 'Outlet Gas Temp';
%     xlabel('Length [m]')
%     ylabel('Nichrome Temp [\circC]')
%     title(['Outlet Gas Temp @ insulation thickness = ' num2str(ins_thick) ' [m]'])
else

    figure
    hold on
    plot(ins_thick,q_store_const_wall_t(:,1), 'displayname','q_{const wall temp}')
    plot(ins_thick,q_store_const_heat_flux(:,1),'DisplayName','q_{const heat flux}')
    xlabel('Insulation Thickness [m]')
    ylabel('Heat Transfer [W], Temp [\circC]')
    title('Insulation Thickness Inspection')

    ylim([0,max(q_store_const_wall_t(:,1))])
    plot(ins_thick,T_s_calc(:,1),'displayname','T_{insulation surface}')
    grid on
    yyaxis right
    plot(ins_thick,R2,'displayname','R_{ins}')
    plot(ins_thick,R1,'displayname','R_{conv}')
    ylabel('Thermal Resistance [K/W]')
    legend('location','e')
end

% plottools('on')

% save('vars.mat','h','D','D_nichrome','k_tape')

disp("done")
function [nichome_temp_curve, gas_temp_curve, q_gas,cp] = get_curve(OD,wall,L,T_n,tape_thick,Ti_air,k_tape,plot,Vdot_air)
    preheatLoopThermalEntryConstantHeatFluxInsulation
    nichome_temp_curve = nichrome_curve;
    gas_temp_curve = gas_curve;
    q_gas = q;
    cp = cp_air;
end

function [q_const_wall_temp,T_s,R_conv,R_ins,q_const_heat_flux] = ...
    insulation_solver(g,T_nichrome,T_s_guess,Tinf,D_nichrome,ins_thick,...
    L,properties,k_rockwool,wall_curve)
    while 1
        
        T_f = (T_s_guess + Tinf)/2 + 273.15;
        
        density_air     = interp1(properties.T, properties.dens,    T_f);
%         cp_air          = interp1(properties.T, properties.cp,      T_f);
        k_air           = interp1(properties.T, properties.k,       T_f);
        mu_air          = interp1(properties.T, properties.mu,      T_f);
        Pr_air          = interp1(properties.T, properties.Pr,      T_f);       
        
        D = D_nichrome + 2*ins_thick;

        R_ins = log(D/D_nichrome)/2/pi/k_rockwool/L;

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

        R_conv = 1/h/A;
        R = R_conv+R_ins;
        % high R equals low q

        q_const_wall_temp = (T_nichrome - Tinf)/R;

        T_s = T_nichrome - q_const_wall_temp*log(D/D_nichrome)/2/pi/k_rockwool/L;
        
        if abs(T_s - T_s_guess) < 1
            break
        end
        T_s_guess = T_s;
        
    end
    
%     if exist(wall_curve)
        q_const_heat_flux = 1/(1/h/pi/D + log(D/D_nichrome)/2/pi/k_rockwool)*integral(wall_curve,1e-5,L);
%     else
%         q_const_heat_flux = 0;
%     end
end
