function  T = Ttime(Tmax, Tmin, time, a,b,c, daylen);
%estimate temps through day - Parton and Logan 1981
%Tmax     =  maximum temperature (C or K)
%Tmin     =  minimum temperature (C or K)
%time     =  time of day         (0-24hr)
%a        =  time lag of max temp after noon (hr)
%b        =  slope of exponential temp decay at nite
%c        =  time lag min temp after sunup (h)
%daylen   =  time from sunup to sundown (hr)

%  coefficients
%     conditions          a         b         c
% soil+150 cm            1.86      2.20      -0.17
% soil+ 10 cm            1.52      2.00      -0.18
% soil+  0 cm            0.50      1.81       0.49
% soil- 10 cm            0.45      2.28       1.83

%Trange   =  Tmax - Tmin (K)
%tdawn    =  time of minimum temp (hr)
%tdusk    =  time of sundown (hr)
%day      =  true if during sin curve period
%deltime  =  time past start of period (hr)
%sinelen  =  time of sin curve period (daylen - c)
%Tempdusk =  temp at dusk (C or K)
%dt       =  temp during the day
%nt       =  temp @ night

tdawn    = 12.0 - (daylen / 2.0) + c;
tdusk    = 12.0 + (daylen / 2.0);
Trange   = Tmax - Tmin;
sinelen  = daylen - c;
Tempdusk = Trange * sin( (pi*sinelen) / (daylen+(2*a)) ) + Tmin;

day      = ( (time >= tdawn)  &  (time <= tdusk) );
deltime = (day .* (time-tdawn)) + ((1-day) .* (rem(time+24-tdusk,24)));
dt = day .* (Trange * sin( (pi*day.*deltime) / (daylen+(2*a)) ) + Tmin);
nt = (1-day) .* (Tmin + ((Tempdusk-Tmin) * exp (-b*deltime / (24.0-daylen)) ));
T = nt + dt;
%[tdawn tdusk Tempdusk a b c]
%[time day deltime dt nt T]
