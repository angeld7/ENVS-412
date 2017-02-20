
% 1b ------------------------------------------------------------
% through the course of the day @ latitude 40/N on June 21

% June 21 julian date
jdate = 172; 
latdeg = 40; 
tnoon = 12;
time = (6:0.5:18)';
% Get flux throughtout the day
[SolDir, SolDiff] = SolFlux(jdate,latdeg, tnoon, time); 

TotFlux = SolDir + SolDiff;

%Create graph
figure
plot(time,TotFlux);
title('Flux on 6/21 at 40N Throughout the Day');
xlabel('time (h)'); ylabel('flux (W/m2)');

%------------------------------------------------------------------

% 1c --------------------------------------------------------------
% @ solar noon as f(latitude, time of year)

jdatevec = 0:30:365;
latdegvec = -90:25:90;
tnoon = 12;
time = 12;

Dirflux = zeros(length(jdatevec), length(latdegvec));
Difflux = zeros(length(jdatevec), length(latdegvec));

for datct = 1:length(jdatevec)
    for latct = 1:length(latdegvec)
        jdate = jdatevec(datct);
        lat = latdegvec(latct);
        % Get flux for date, and lat
        [SolDir, SolDiff] = SolFlux(jdate,lat, tnoon, time);
        Dirflux(datct,latct) = SolDir;
        Difflux(datct,latct) = SolDiff;
    end;
end;

Totflux = Dirflux + Difflux;


figure
plot(jdatevec,Totflux)
grid
set(gca,'xtick',0:30:360)
axis([  0  360  300  1100])
title('Flux at Solar Noon');
xlabel('date (julian)'); ylabel('flux (W/m2)');
legend(int2str(latdegvec'));

figure
surf(latdegvec,jdatevec,Totflux)
title('Flux at Solar Noon');
xlabel('latitude (deg)'); ylabel('date (julian)'); zlabel('flux (W/m2)');

figure
contourf(latdegvec,jdatevec,Totflux)
colorbar
title('Flux at Solar Noon');
xlabel('latitude (deg)'); ylabel('date (julian)');

%---------------------------------------------------------------------

% 2b -----------------------------------------------------------------
% As f(latitude, time of year)

latdegvec = -90:20:90;
jdatevec = 15:30:345;
daylengths = zeros(length(jdatevec), length(latdegvec));
for datect = 1:length(jdatevec)
    for latct = 1:length(latdegvec)
        % get solar declination with the julian date
        soldec = SolDec(jdatevec(datect)); 
        % get the latitude in radians
        lat = latdegvec(latct)*pi/180;
        % calculate the day length for the date and latitude
        daylengths(datect,latct) = DayLength(lat,soldec); 
    end;
end;

figure
plot(jdatevec,daylengths)
grid
set(gca,'xtick',0:30:360)
title('Day Length');
xlabel('date (julian)'); ylabel('day length (h)');
legend(int2str(latdegvec'));

figure
surf(latdegvec,jdatevec,daylengths)
title('Day Length');
xlabel('latitude (deg)'); ylabel('date (julian)'); 
zlabel('day length (h)');

figure
contourf(latdegvec,jdatevec,daylengths)
colorbar
title('Day Length');
xlabel('latitude (deg)'); ylabel('date (julian)');

%---------------------------------------------------------------------

% 3 
% Predict the solar radiant inputs to two plates over the course of the
% day @ 40N latitude on June 21

% 3a -----------------------------------------------------------------
% flat on ground
latRad = 40 * pi / 180; % 40N latitude in radians
dec = SolDec(172); % Solar declination on June 21
time = (6:0.5:18)'; % times throughout the day
solrads = zeros(length(time),1);
for timect = 1:length(time) % loop through times
    % get solar hr angle
    hrang = SolHrAng(time(timect),12); 
     % get zenith angle
    zenang = SZAng(latRad,dec,hrang);
    % get direct beem radiation
    sdir = Qrdir(zenang,1.013e5,0.01,1);
    % get diffuse radiation
    sdiff = Qdiff(zenang,1.013e5,0.01,sdir);      
    % get radiaiton for flat plate
    solrads(timect) = FlatRad(zenang,sdir,sdiff);
end;

%Create graph
figure
plot(time,solrads);
title('Flux on Flat Ground @ 40N on June 21');
xlabel('time (h)'); ylabel('flux (W/m2)');

%---------------------------------------------------------------------

% 3b -----------------------------------------------------------------
% elevated 20 degrees from the ground and facing SSE 

latRad = 40 * pi / 180; % 40N latitude in radians
dec = SolDec(172); % Solar declination on June 21
time = (6:0.5:18)'; % times throughout the day
% zenith of the plate normal (20 deg) in radians
platezenith = 20 * pi / 180; 
% azimuth of the plate normal (-157 deg) in radians
plateazimuth = -157 * pi / 180;

solrads = zeros(length(time),1);
angles = zeros(length(time),1);
for timect = 1:length(time) % loop through times
    % get solar hr angle
    hrang = SolHrAng(time(timect),12); 
    % get zenith angle
    zenang = SZAng(latRad,dec,hrang);
    % get solar azimuth angle
    solaz = SAzAng(latRad,dec,hrang);
    % get direct beem radiation
    sdir = Qrdir(zenang,1.013e5,0.01,1);
    % get diffuse radiation
    sdiff = Qdiff(zenang,1.013e5,0.01,sdir);      
    % get radiaiton for flat plate
    [rad,ang] = SlopRad(solaz,zenang,plateazimuth,platezenith,sdir,sdiff);
    solrads(timect) = rad;
    angles(timect) = ang / pi * 180;
end;

%Create graph
figure
plot(time,solrads);
title('Flux on Plate 20 Deg Off Ground Facing SSE, @ 40N on June 21');
xlabel('time (h)'); ylabel('flux (W/m2)');

%---------------------------------------------------------------------

% 4 ------------------------------------------------------------------
% Habitat data

S = [200 800 900 1000 900 800 200
     100 400 450 500 450 400 100
     0 0 0 0 0 0 0];

h = [5 10 18 18 18 10 10
     4 8 16 16 14 8 8
     3 3 3 3 3 3 3];

Te = [10 19 28 32 33 23 15
      12 15 20 27 28 21 16
      17 17 17 17 17 18 17];

time = 6:2:18;

% 4a -----------------------------------------------------------------

%c = 4 * emissivity * Stephen-Boltzmann constant
c = 4 * .85 * 5.67e-8; 
Tb = zeros(3,7);
%loop through times
for t = 1:7
    %loop through habitats
    for l = 1:3
        %Find steady state body temperature
        %Equation derrived from Energy = SWRad - LWRad - Convection
        Tb(l,t) = (S(l,t)*.85 + c*Te(l,t)^4 + h(l,t)*Te(l,t)) / (c*Te(l,t)^3 + h(l,t));        
    end;
end






