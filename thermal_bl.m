OD = 0.25 * 0.0254;
w = 0.035 * 0.0254;

rho = 1.2;
mu = 1.8e-5;
T = 200+273;
Pr = 0.703;

D = OD-2*w;
A = pi/4*D^2;
Q = 4/60/1000;

u = Q/A;

ReD = rho*u*D/mu;

if ReD > 2300
    disp('Turbulent')
else
    disp('Laminar')
end
    

d_lam = 5*D/sqrt(ReD)

d_th = d_lam/Pr^(1/3)


d_lam/D*100
% if d_lam/D < 5% then we can use the external flow calculation as an
% approximation

% for 1" tube the thermal boundary layer is much larger