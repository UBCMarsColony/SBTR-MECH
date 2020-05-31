%% PLOT CIRCLES ALGORITHM
%   @author     Andrew Zlindra
%   Created     2020-01-24
%   @reviewer   
%   Reviewed    
%
%   PURPOSE:
%       - plot circles in a packed-hex format

clc; clear; clf;

tic
r = 1;  % packed circle radius
R = 10; % red circle radius
N = 11; % max horiz width

height = 2+(N-3)/2;
circ_start = 1+(N-3)/2;
circle(0,0,R,'r')

for iter = N:-1:height
    b = 2*r*(N - iter)*sind(60);
    if mod(iter,2) == 0 %even
        
        circle(r,b,r,'b')
        circle(-r,b,r,'b')
        circle(r,-b,r,'b')
        circle(-r,-b,r,'b')        
        
        for i = 1:circ_start-1
            circle(2*r*i+r,b,r,'b')
            circle(-2*r*i-r,b,r,'b')
            circle(2*r*i+r,-b,r,'b')
            circle(-2*r*i-r,-b,r,'b')            
            
        end
        
        circ_start = circ_start - 1;
    else %odd
        for i = 1:circ_start
            a = 2*r*i;
            circle(a,b,r,'b')
            circle(-a,b,r,'b')
            circle(a,-b,r,'b')
            circle(-a,-b,r,'b')
        
        end
        
        circle(0,b,r,'b')
        circle(0,-b,r,'b')
        
    end
    
    
end

disp(toc)



function circle(x,y,r,col)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp,col);
axis equal
grid on
hold on

end