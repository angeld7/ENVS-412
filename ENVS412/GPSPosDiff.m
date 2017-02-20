% *****************************************************************************
% Description: 2-D Position difference from 2 latitude and longitude pairs,
%              returns distance in metres.
% *****************************************************************************
%
% Returns -1 if either of the lat/long pairs are 0.0, 0.0
% Returns -2 if not called with 4 input argumants
% 
% Inputs:      Latitude1, Longitude1, Latitude2, Longitude2 (strings)
% Returns:     DistanceDiff - Difference in meters between inputs (string)
% 
% *****************************************************************************
% Version: 1
% Release Date: 16/04/2003
% Author: Steve Dodds
% E-Mail: stevedodds@dsl.pipex.com
% *****************************************************************************
function DistanceDiff = GPS_PosnDiff(Latitude1, Longitude1, Latitude2, Longitude2)

LAT_DISTANCE_IN_METRES_PER_DEGREE = 111323.6944;  % circumference of the earth about the equator is 24,902.4 mi. (40,076.5 km)
LONG_DISTANCE_IN_METRES_PER_DEGREE = 111135.0000; % circumference about the poles is 24,860.2 mi. (40,008.6 km)

if nargin ~= 4 % check correct number of input arguments
    DistanceDiff = '-2';
else
    Lat1 = str2num(Latitude1);
    Long1 = str2num(Longitude1);
    Lat2 = str2num(Latitude2);
    Long2 = str2num(Longitude2);
    
    if (((Lat1 == 0) && (Long1 == 0)) || ((Lat2 == 0) && (Long2 == 0)))
        DistanceDiff = '-1'; % one of the lat/long pairs are 0,0
    else
        LatitudeAngularDelta  = (Lat1  - Lat2);   % Calculated angular difference between the two position's latitudes.
        LongitudeAngularDelta = (Long1 - Long2);  % Calculated angular difference between the two position's longitudes.

        % Convert from angular differences in degrees, distance differences in metres:
        Theta = (Lat1 + Lat2) * (pi / 360.0);
        LatitudeDistanceDelta  = LatitudeAngularDelta  * LAT_DISTANCE_IN_METRES_PER_DEGREE;  % Calculated distance difference between the two position's latitudes.
        LongitudeDistanceDelta = LongitudeAngularDelta * LONG_DISTANCE_IN_METRES_PER_DEGREE; % Calculated distance difference between the two position's longitudes.
        LongitudeDistanceDelta = LongitudeDistanceDelta * cos(Theta);

        % Apply Pythagoras:
        DistanceDelta = (LongitudeDistanceDelta * LongitudeDistanceDelta) + (LatitudeDistanceDelta * LatitudeDistanceDelta);
        DistanceDelta = sqrt(DistanceDelta); % Calculated XY-Distance between the two positions.
        
        % convert result back to a string
        DistanceDiff = num2str(DistanceDelta);
    end
end
