% Problem 1 ---------------------------------------
%C temperature of the air
Ta = 15; 
%C temperature of the rat's core
Tc = 37; 

% m^3 volume of rat
V = 3.0e-4; 

%m total radius
rt = nthroot(V/(8*pi), 3); %rt=.0229

% m radius of fat layer from
rf = 0.95*rt; %rf=0.0217
% m radius of core
rc = 0.85*rt; %rc=0.0194

% m length of the rat
L = V / (pi*rt^2);%L=0.1828

% W/m K thermal conductivity of fat
kf = 0.18; 
% W/m K thermal conductivity of skin
ks = 0.56; 

% m Shape factor for fat layer
Sf = (2*pi*L)/log(rf/rc); %Sf=10.3282

% m Shape factor for skin layer
Ss = (2*pi*L)/log(rt/rf); %Ss=22.3960

% K/W Resistance of fat
Rf = 1/(kf*Sf); %Rf=0.5379
% K/W Resistance of skin
Rs = 1/(ks*Ss); %Rs=0.0797

% m^2 surface area of the skin (ignoring ends)
A = 2*pi*rt*L; %A=0.0263

% W/m^2 K Convection coefficent (wind speed 1 m/s)
hc1 = findHc(300,1,0); %hc1=19.9799
% Convection coefficent (wind speed 5 m/s)
hc5 = findHc(300,5,0); %hc5=68.221

%view factor
vf = 0.8;
%W m^-2 k^-4 Stephan-Boltzmann  constant
q = 5.67e-8; 
% emmisivity (assuming 1)
em = 1; 

% K/W Evironmental resisitance @ ws 1 m/s
Re1 = 1/(A*(hc1+4*Ta^3*vf*q*em)); %Re1=1.9064
% K/W Evironmental resisitance @ ws 5 m/s
Re5 = 1/(A*(hc5+4*Ta^3*vf*q*em)); %Re5=0.5583

% W Conduction heat loss
Q1 = (Ta-Tc)/(Rs+Rf+Re1); %Q1=-8.7164
% W Conduction heat loss
Q5 = (Ta-Tc)/(Rs+Rf+Re5); %Q5=-18.7081

% C Temperature of Rat's fat layer
Tf1 = Q1*Rf+Tc; %T1f=32.3115
% C Temperature of Rat's fat layer0
Tf5 = Q5*Rf+Tc; %Tf5=26.9369
0
% C Temperature of Rat's skin
Ts1 = Q1*Rs+Tf1; %Ts1=31.6165
% C Temperature of Rat's skin
Ts5 = Q5*Rs+Tf5; %Ts5=25.4452

%Answers 
%a.) Temp @ rf = 32.3115 C, Temp @ rt = 31.6165 C
%b.) 8.7164 W
%c.) Temp @ rf = 26.9369 C, Temp @ rt = 25.4452 C
% The core will need a metabolic rate of 18.708 W
% The higher wind speed causes the temperature of the creature to drop at a
% higher rate.

% Problem 2 ---------------------------------------------------------------



function hc = findHc(m, u, z)
    %Calculate the convection coefficient
    %ReFunc function used to find the Reynolds number
    %NuFunction function used to find the Nussalt number
    %m g mass of the organism
    %u m/w wind speed
    %z m height
    %hc W/m^2 K convection coefficient
    
    %D characteristic dimension
    D = (m*1e-6)^(1/3);
    %Re Reynolds number    
    Re = 6.54e4 * u * D;
    %find Nussalts number
    Nu = 0.34*Re^.6;
    hc = Nu / (38.9*D);
    zD = z / D;
    if(zD > .45 && zD < .6)
        multiplier = .7;
    elseif (zD > 100)
        multiplier = 0;
    else
        multiplier = .3;
    end
    hc = hc + (Re >= 2e4) * hc * multiplier;
end