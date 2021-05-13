%% PREHEATER EXPERIMENTAL DATA PLOTTER
% PURPOSE:
%   - Plot preheater experimental data

clear; clc; clf;

folder_dir = 'C:\Users\andre\Downloads\';
filename = 'Second Nichrome Test'; % gas outlet T low
filename = 'Third Nichrome Test'; % gas outlet T low
filename = 'Fourth Nichrome Test';
% filename = 'Fifth Nichrome Test';

T = importfile([folder_dir filename '.csv'], [2, Inf]);

sgtitle('Nichrome Experimental Data')

% plot data vs time
subplot(1,2,1)
hold('on')
grid('on')
plot(T.Time,T.NichromeInletTempC,'DisplayName','Nichrome in T','LineWidth',2)
plot(T.Time,T.NichromeMidpointC,'DisplayName','Nichrome mid T','LineWidth',2)
plot(T.Time,T.NichromeOutletTempC,'DisplayName','Nichrome out T','LineWidth',2)
plot(T.Time,T.GasTempC,'DisplayName','Gas outlet T','LineWidth',2)

legend('Location','SE')
title(filename)
xlabel('Time [s]')
ylabel('Temp. [\circC]')

% plot relay data vs time
yyaxis right
% plot(T.Time,T.Relay,'DisplayName','Relay Status')
duty = dutycycle(double(T.Relay));
plot(linspace(0,T.Time(end),length(duty)),duty*100,'DisplayName','Relay Duty Cycle')
ylabel('Relay Duty Cycle [%]')

L = 2.5; % [ft]

% choose whether to do a 3D surface or 2D X-section
plt = 1;
if plt == 1
    subplot(1,2,2)
    time = 2000;
    tube = [L/4 L/2 3*L/4];
    [ d, ix ] = min( abs( T.Time - time ) );
    nichromeTdist = [T.NichromeInletTempC(ix) ...
                        T.NichromeMidpointC(ix) ...
                        T.NichromeOutletTempC(ix)];
    plot(tube,nichromeTdist,'o-','DisplayName','Nichrome Temp.')
    hold on
    grid on
    nichrome_temp_fit = fit(tube', nichromeTdist', 'poly1' );
    plot([0 L], nichrome_temp_fit([0 L]),'DisplayName','Nichrome Temp. Curve Fit')
    
    
    plot([0 L],[22 T.GasTempC(ix)],'DisplayName','Gas Temp.')
    xlabel('Tube Length [ft]')
    ylabel('Temp. [\circC]')
    title('Nichrome Temp. vs Tube Length')
    legend('Location','se')
else
    subplot(1,2,2)
    tube = ones(height(T),3).*[0 L/2 L];
    % plot3(tube,[T.NichromeInletTempC T.NichromeMidpointC T.NichromeOutletTempC],T.Time)
    surf(tube,T.Time,[T.NichromeInletTempC T.NichromeMidpointC T.NichromeOutletTempC])

    grid on
    xlabel('Tube Length [ft]')
    ylabel('Time [s]')
    zlabel('Temp. [\circC]')
    title('Temp. Distribution along the length over Time')
end
