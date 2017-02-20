function EOTrgh = EOTimeRough(jdate);
% EOTrgh = EOTimeRough(jdate);
%   calculate equation of time for julian dates from equations provided by 
%   www.susdesign.com/popups/sunangle/eot.php
%   agrees with more elaborate algorithm's within 0.6 min at extremes, 
%   better on most days
%   Input / Output
%     jdate     = julian date (1-366) as column vector
%     EOT       = total Eq of time effect (min   Solar - mean time)
  
beta = 2*pi*(jdate-81)/365;
EOTrgh = 9.87*sin(2*beta)-7.53*cos(beta)-1.5*sin(beta);


