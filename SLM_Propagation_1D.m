close all;
clear all; 
clc;

%% Setting up system parameters

s_factor = 1;       % Set this to 1 for default (actual) values. Set this to larger than 1 for scaling the fft2. This ...
                    % ...will introduce increasing errors as you increase its value largr.
Lambda = 532e-9;    %Wavelength
k = 2*pi/Lambda;    %Wave number
f_fourier = (400)*1e-3; %Focal length of the Fourier Transforming Lens
dx = s_factor*12.5e-6; %spatial period of sampling (pixels)
F_s = 1/dx;   %spatial freq of sampling (pixels)
N = 1024;
x = [-N/2:1:N/2-1];


%% Input phase profile here: (example of sinusoidal grating shown)
% other 1D phase profiles of length 1024 can be included
c = 2*pi;           % contrast
period_px = 50;      % period in terms of pixels
f_0 = 1/(dx*period_px);   % spatial frequency of the grating 
phi_sin = c/2 * sin(2*pi*f_0*x*dx)+c/2;
figure('Name','Sinusoidal grating Phase Profile (ColorMap)','NumberTitle','off');
imagesc(phi_sin/pi);
colormap gray;
h = colorbar;
ylabel(h,'\phi (units of \pi)');
axis off;


xx = dx*(-N/2:1:N/2-1); % The x axis
x = exp(i*phi_sin);		% The electric field

% Plotting the Phase profile in 1D
figure('NumberTitle','off','Name','1D Computation: Fourier Transform');
s(1) = subplot(2,2,1);
plot(xx,angle(x)/pi);
ylabel('Phase \Phi (units of \pi)');
xlabel('X axis');
s(2) = subplot(2,2,2);
plot(xx,abs(x));
ylabel('Amplitude');
xlabel('X axis');
title(s(1),'Phase profile SLM plane');
title(s(2),'Amplitude profile SLM plane (normalized)');
%% Computing the Fresnel Diffraction Integral
FFT = fft(x,N);
y = fftshift(FFT);

% Setting the axis
w_freq = linspace(-pi,pi-(2*pi)/N,N);
freq_proper = F_s*w_freq/(2*pi);        %Spatial frequency
clear x;
x = freq_proper*Lambda*f_fourier;       % converting from spatial frequency to coordinates

% Plotting the Image plane Field
s(4) = subplot(2,2,4);
plot(s_factor*x/(1e-3),abs(y));
ylabel('Amplitude');
xlabel('X axis (mm)');
s(3) = subplot(2,2,3);
plot(s_factor*x/(1e-3),angle(y));
ylabel('Phase \Phi (units of \pi)');
xlabel('X axis (mm)');
title(s(3),'Phase profile Image plane');
title(s(4),'Amplitude profile Image plane');

