


jdatevec = 15:30:345;
latdeg = 40;
tnoon = 12;
time = [6:0.5:18]';

Dirflux = zeros(length(time),length(jdatevec));
Difflux = zeros(length(time),length(jdatevec));

for datct = 1:length(jdatevec);
    jdate = jdatevec(datct);
    [SolDir, SolDiff] = SolFlux(jdate,latdeg, tnoon, time);
    Dirflux(:,datct) = SolDir;
    Difflux(:,datct) = SolDiff;
end;

Totflux = Dirflux + Difflux;


figure
plot(time,Totflux,'o-')
xlabel('time (h)');  ylabel('flux (W/m2)');  grid
legend(int2str(jdatevec'))

figure
surf(jdatevec,time,Totflux)
figure
contourf(jdatevec,time,Totflux)
colorbar