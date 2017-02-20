function [jday,jcent,jephday,jephcent,jephmill] = julianDate(year,month,day,hour,tmin,sec,UTC)
% This function computes the julian day (days since January 1, in the year -4712 
% at 12:00:00) and julian century from the local time and timezone information 
% (UTC = delta from Greenwich). Ephemeris are calculated with a delta_t=0 seconds. 
% adapted from routines by Ibrahim Reda and Afshin Andreas for NREL
%  Inputs
%    year, month, day, hour, tmin, sec - local time
%           defaults  year - 2000, hour - 12, tmin, sec - 0
%    UTC   - deviation of local time from Universal time (Greenwich time) US EST = -7;
%  Outputs  
%    jday      : julian date= floor(365.25*(Y+4716)) + floor(30.6001*(M+1)) + D + B - 1524.5;
%    jcent     : julian century  = (jday - 2451545) / 36525;      
%    jephday   : julian ephemeris day = julian day + (delta_t/86400);
%            delta_t = 0; % 33.184;
%    jephcent  : julian ephemeris century = (julian ephemeris day - 2451545) / 36525;
%    jephmill  : julian ephemeris millenium = julian ephemeris century / 10; 
%


if (nargin < 4),
    hour = 12;  tmin = 0; sec = 0; UTC = 0;
end;
if (isempty(year)),
    year = 2000;
end;
if (isempty(hour)),
    hour = 12;
end;
if (isempty(tmin)),
    tmin = 0;
end;
if (isempty(sec)),
    sec = 0;
end;
if (isempty(UTC)),
    UTC = 0;
end;



if(month == 1 | month == 2)
    Y = year - 1;
    M = month + 12;
else
    Y = year;
    M = month; 
end
ut_time = ((hour - UTC)/24) + (tmin/(60*24)) + (sec/(60*60*24)); % time of day in UT time. 
D = day + ut_time; % Day of month in decimal time, ex. 2sd day of month at 12:30:30UT, D=2.521180556


% In 1582, the gregorian calendar was adopted
if(year == 1582)
    if(month == 10)
        if(day <= 4) % The Julian calendar ended on October 4, 1582
            B = 0;    
        elseif(day >= 15) % The Gregorian calendar started on October 15, 1582
            A = floor(Y/100);
            B = 2 - A + floor(A/4);    
        else
            disp('This date never existed!. Date automatically set to October 4, 1582');
            month = 10;
            day = 4; 
            B = 0;
        end
    elseif(month<10) % Julian calendar 
        B = 0;
    else % Gregorian calendar
        A = floor(Y/100);
        B = 2 - A + floor(A/4);
    end
    
elseif(year<1582) % Julian calendar
    B = 0;
else
    A = floor(Y/100); % Gregorian calendar
    B = 2 - A + floor(A/4);
end

jday = floor(365.25*(Y+4716)) + floor(30.6001*(M+1)) + D + B - 1524.5;
delta_t = 0; % 33.184;
jephday = jday + (delta_t/86400);        % julian ephemeris day
jcent = (jday - 2451545) / 36525;        % julian century
jephcent = (jephday - 2451545) / 36525;  % julian ephemeris century
jephmill = jephcent / 10;                % julian ephemeris millenium