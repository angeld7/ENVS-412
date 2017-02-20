%----- Problem 2 a and b
animals = [1 100 10000 1000000];
hc = zeros(4,1);
absorbivity = .7;
flux = 850;
heatlosses = zeros(4,1);
heatFlux = zeros(4,1);
for x = 1:4
    hc(x) = findHc(@findReynoldsNumAir20,@hcNuAir20,animals(x),2,0);
    heatlosses(x) = findHeatLoss(hc(x),animals(x),10,0);
    A = findArea(animals(x));
    heatFlux(x) = A*absorbivity*flux - A*5.67e-8*10;
end
%-------------------------

%---- Problem 3 a

m = 5;
d = 0;
z0 = .02;

heights = [.05 .1 .2 .4 1 1.5 2]';
windSpeeds = zeros(length(heights),1);
hc = zeros(length(heights),1);

U = findShearVelocity(3,1.5,d,z0);
for x = 1:length(heights)
    windSpeeds(x) = findWindSpeed(U,heights(x),d,z0);
    hc(x) = findHc(@findReynoldsNumAir20,@hcNuAir20,m,windSpeeds(x),heights(x));
end
results = [heights windSpeeds hc];
%-------------------------

%problem 3 b -------------------------

%steady-state body temperatures
Tb = zeros(length(heights),1);
for x = 1:length(heights)
   Tb(x) = findSteadyStateTemp(.8, 780, 25, hc(x));
end

%------------------------------------

%problem 3 c -------------------------

%steady-state body temperatures
Tb = zeros(length(heights),1);
airTemps = zeros(length(heights),1);
for x = 1:length(heights)
   airTemps(x) = findAirTemp(heights(x), 45, 25, 1.5, z0);
   Tb(x) = findSteadyStateTemp(.8, 780, airTemps(x), hc(x));
end
%--------------------------------------
%probem 4 -------------------------------
m = 523.6;
h = 0;
A = findArea(m);
D = findD(m);

%problem 4 b & c

%Get Re for 3/ms
Re = findReynoldsNumAir20(3,D);
%Get Nu
Nu = 0.34*Re^.6;
%find k from Nu, D and known convection coeffiecent
k = Nu / (4.536275215 * D);
%Test on 6 m/s to see how it compares to the other known h
Re = findReynoldsNumAir20(6,D);
Nu = 0.34*Re^.6;
hc3 = Nu / (k*D);
%hc3 = 6.8757 value from readings = 7.0104, pretty close

%Wind speed 1 m/s
Re = findReynoldsNumAir20(1,D);
Nu = 0.34*Re^.6;
hc1 = Nu / (k*D);

%Water @ 5 m/s
%For water I will change use the water's k value from chart, but I
%will alter it porportionally to the amount I had to alter the k value
%for air. I don't have any cooling curves for air so it's the best I
%can do.
k = 1.67 * k / 38.9; %38.9 is the value from the chart for air
u = 5;
Re = 9.95e5*u*D;
Nu = 0.34*Re^.6;
hcw5 = Nu / (k*D);
%----------------------------------------
function windSpeed = findWindSpeed(U,z,d,z0)
    %find wind speed at height z
    %U shear velocity
    %z height
    %d zero plane displacement
    %z0 roughness length
    windSpeed = (U/.41)*log((z-d)/z0);
end

function U = findShearVelocity(u,z,d,z0)
    %find shear velocity from windspeed equation
    %u wind speed
    %z height above ground
    %d zero plade displacement
    %z0 roughness length
    %U the shear velocity
    U = (.41*u)/log((z-d)/z0);
end

function airTemp = findAirTemp(z, Ts, Tr, zr, z0)
    %Ts soil surf temp
    %Tr air temp @ reference height
    %z height above ground
    %zr reference height above ground
    %z0 roughness length
    
    % Convective environment - air temp
    % airTemp - Ts    ln(z/z0 + 1)
    % ------------ =  --------------
    %    Tr - Ts      ln(zr/z0 + 1)
    
    airTemp = (Tr-Ts)*log(z/z0 + 1)/log(zr/z0 +1) + Ts;
end

function D = findD(m)
    %calculate characteristic dimension
    %m mass in grams
    %D characteristic dimension in meters
    D = (m*1e-6)^(1/3);
end

function Re = findReynoldsNumAir20(u, D)
    %calculate reynolds number for Air @ 20 deg C
    %u wind speed in m/s
    %D characteristic dimension in m
    %Re Reynolds number
    Re = 6.54e4 * u * D;
end

function hc = hcNuAir20(Nu, D)
    hc = Nu / (38.9*D);
end

function hc = findHc(ReFunc, NuFunc, m, u, z)
    %Calculate the convection coefficient
    %ReFunc function used to find the Reynolds number
    %NuFunction function used to find the Nussalt number
    %m mass of the organism
    %u wind speed
    %z height
    %D characteristic dimension
    %Re Reynolds number    
    %find Nussalts number
    D = findD(m);
    Re = ReFunc(u, D);
    Nu = 0.34*Re^.6;
    hc = NuFunc(Nu, D);
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

function A = findArea(mass)
    %find volume in meters cubed (density of water is assumed)
    V = mass * 1e-6;
    %find radius
    r = (V/(4*pi/3))^(1/3);
    %find area
    A = 4*pi*r^2;
end

function heatLoss = findHeatLoss(hc, mass, Ts, Ta)
    %hc convection coefficient
    %mass mass of the animal in grams(assumed to be spherical)
    %Ts surface temperature
    %Ta air temperature
    %heatLoss heat the organism loses in Watts
    
    %find area
    A = findArea(mass);
    
    heatLoss = hc*A*(Ts-Ta);
end

function temp = findSteadyStateTemp(e, S, Ta, hc)
    %Find the steady state bony temperature for an organism
    %e emissivity
    %S solar flux density
    %Ta air temperature
    %hc convection coeffecient
    %temp the steady state body temperature

    %c = 4 * emissivity * Stephen-Boltzmann constant
    c = 4 * e * 5.67e-8; 
    %Find steady state body temperature
    %Equation derrived from Energy = SWRad - LWRad - Convection
    temp = (S*e + c*Ta^4 + hc*Ta) / (c*Ta^3 + hc);  
end