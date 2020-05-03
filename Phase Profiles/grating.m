%����������������������������������������������������add grating
function X001=grating(Tx,Xcontrast,Ty,Ycontrast)
% Tx=2;
% Xcontrast=0;
% Ty=2;
% Ycontrast=0;%pi;
m=1024;
n=1272;
phasex0=mod(mod([ceil(-n/2):ceil(n/2)-1],Tx)*Xcontrast/(Tx-1),2*pi);
phasey0=mod(mod([ceil(-m/2):ceil(m/2)-1],Ty)*Ycontrast/(Ty-1),2*pi);
[X0,Y0]=meshgrid(phasex0,phasey0);
phase0=mod(X0+Y0,2*pi);
X001=phase0*128/pi;
X001=uint8(X001);
% imwrite(uint8((phase0)*128/pi),'grating.bmp')
