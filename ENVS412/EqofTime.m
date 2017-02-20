function [EOTtot,EOTecc,EOTtilt] = EqofTime(jdate);
% [EOTtot,EOTecc,EOTtilt] = EqofTime(jdate);
%   calculate equation of time for julian dates from equations provided by 
%   analemma.com (http://www.analemma.com/Pages/framesPage.html)
%   Input
%     jdate     = julian date (1-366) as column vector
%   Output
%     EOTtot    = total Eq of time effect (min   Solar - mean time)
%     EOTecc    = effect of orbital eccentricity
%     EOTtilt   = effect of rotational tilt
  
a1 = 0.985653269 * pi/180;		% Average Angle/Day (rad)
a2 = 3.988919668 * 180/pi;		% Minutes per rad of Earth's Rotation
a3 = 0.397948631;               % Earth's Tilt (sine)
a4 = 0.917407699;               % Earth's Tilt (cosine)
a5 = 78.746118 * pi/180;		% Value of v on March 21 (rad)
a6 = 23.45 *pi/180;             % earth's tilt (rad)

w = (a1*(jdate-2) + 2*0.16713*sin(a1*(jdate-2)))-a5;
dec = asin(sin(w)*sin(a6));

EOTecc = (a1*(jdate-2) - (a1*(jdate-2) + 2*0.016713*sin(a1*(jdate-2))))*a2;

epsang = a1*(jdate-80);
epsc1  = (epsang >= 3*pi/2);
epsc2  = (epsang <  3*pi/2) & (epsang >=   pi/2);
epscor = epsang - (epsc1*2*pi) - (epsc2*pi);
EOTtilt = a2 * (epscor - atan(cos(a6)*tan(epscor)));
EOTtot = EOTecc + EOTtilt;


% % rough est
% beta = 2*pi*(jdate-81)/365;
% EOTrgh = 9.87*sin(2*beta)-7.53*cos(beta)-1.5*sin(beta);
% 

