function hc = findHc(m, u, z)
    %Calculate the convection coefficient
    %ReFunc function used to find the Reynolds number
    %NuFunction function used to find the Nussalt number
    %m mass of the organism
    %u wind speed
    %z height
    %D characteristic dimension
    %Re Reynolds number    
    %find Nussalts number
    D = (m*1e-6)^(1/3);
    Re = 6.54e4 * u * D;
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