function frenellens=Digital_Lens(f2,delta)
%unit:mm
%f2 is the focal length of Fourier Transform lens
%delta is the axial shift, +:away
%Initializing Hologram Matrices
H=1272;%%Horizontal pixels             
V=1024;%%Vertical pixels
x=-H/2:1:(H/2-1);
y=-V/2:1:(V/2-1);
x=x*12.5e-3;%(in mm) Scales the hologram in the V direction
y=y*12.5e-3;%(in mm) Scales the hologram in the H direction
[X,Y]=meshgrid(x, y);  
r=sqrt(X.^2 + Y.^2);
nx=0;
ny=0;
gy=ny/(V*12.5e-3);
gx=nx/(H*12.5e-3);
lambda=0.532e-3; % units mm
k=2*pi/lambda;
%ff=10;  %units mm
%T=pi/lambda/ff*(X.^2+Y.^2);
%f=450;
%T=-k*(X.^2+Y.^2)/2*(1/f);
% T=-k*(X.^2+Y.^2)/2*(1/f2-1/(f2+delta));
T = -k/2 * (X.^2 + Y.^2) * (1/(f2-delta) - 1/f2);
HOL=mod(T+2*pi*(X*gx+Y*gy),2*pi);
SLM=HOL-min(HOL(:));
SLM=SLM/max(SLM(:))*255;
% fig=figure;
% set(fig,'Position',[120 0 1272 1080],'MenuBar','none','ToolBar','none','resize','off');%fullscreen SLM
% set(gca,'position',[0 0 1 1],'Visible','off')
% imagesc(SLM)
% imwrite(uint8(SLM),'frenel_lens.bmp')
% axis image
% axis off
% colormap gray
frenellens=uint8(SLM);


