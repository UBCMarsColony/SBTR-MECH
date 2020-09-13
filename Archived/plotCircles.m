%% PLOT CIRCLES
%   @author     Andrew Zlindra
%   Created     2020-01-24
%   @reviewer   
%   Reviewed    
%   NOTE: uses a radial algorithm but doesn't 100% work
%         IN OTHER WORDS: DO NOT USE THIS CODE LOL


clc; clear; clf;

r = 1;
N = 3; %number of loops around the center circle

circle(0,0,r)


for iter = 1:N
    n_circ = 6*iter;
    for i = 1:n_circ
        d_theta = 60/iter;
        theta = 60/iter*i;
        if mod(theta,60) == 0
            a = 2*r*iter*cosd(theta);
            b = 2*r*iter*sind(theta);
        else
           
           if (theta < 60 && theta > 0) || (theta < 240 && theta > 180)
                
           end
           a1 = 2*r*iter*cosd(theta + d_theta);
           a2 = 2*r*iter*cosd(theta - d_theta);
           b1 = 2*r*iter*sind(theta + d_theta);
           b2 = 2*r*iter*sind(theta - d_theta);
           a = (a1+a2)/2;
           b = (b1+b2)/2;
        end
        

        circle(a,b,r)

    end
end

function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp,'b');
axis equal
grid on
hold on

end