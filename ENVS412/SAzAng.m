function az = SAzAng(lat,dec,hvec);% function az = SAzAng(lat,dec,hvec);%  lat     : latitude (rad)%  dec     : solar declination (rad)%  hvec    : solar hour angle (rad)%  az      : solar azimuth angle (rad - w/ South = 0)y    =  (sin(lat).*cos(hvec).*cos(dec)) - (cos(lat).*sin(dec));x    =  sin(hvec) .* cos(dec);az   =  atan2(x, y);