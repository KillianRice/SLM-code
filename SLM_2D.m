% This piece of code can take a phase profile and give you the resulting
% electric field in the fourier plane. 

close all;
clear all;
clc;
%% Setting up system parameters

s_factor = 1;       % Set this to 1 for default (actual) values. Set this to larger than 1 for scaling the fft2. This ...
                    % ...will introduce increasing errors as you increase its value largr.

D = pwd;               % Working Directory of this file
Lambda = 532e-9;    %Wavelength
k = 2*pi/Lambda;    %Wave number
f_fourier = 77e-3; %Focal length of the Fourier Transforming Lens
T_s = s_factor*12.5e-6; %spatial period of sampling (pixels)
F_s = 1/T_s;   %spatial freq of sampling (pixels)

%% Reading image file and converting to proper phase scaling

S = fullfile(D,'Dammann_2D_phase_8.bmp');   %input the phase profile
Phi = imread(S);
% Phi = Phi(:,:,1);
Phi = 2*pi/255 * double(Phi);
Phi = Phi(:,1:1272);
figure('NumberTitle','off','Name','2D Computation: Fourier Transform');
s(2) = subplot(2,2,2);
imshow(Phi,[0 2*pi]);
title(s(2),'Input Phase profile');

%% Generating 2D Eletric Field
Ncols = 1272; % X axis
Nrows = 1024; % Y axis

xx = T_s*(-Ncols/2:1:Ncols/2-1);
yy = T_s*(-Nrows/2:1:Nrows/2-1);

u_amp = 1;
u = exp(i*Phi);

s(1) = subplot(2,2,1);
imagesc(xx,yy,u_amp);
xlabel('X_{SLM} axis');
ylabel('Y_{SLM} axis');
title(s(1),'Amplitude profile SLM plane (normalized)');


%% The Fourier transform (2D) 
% The electric field in the Fourier plane
v = fft2(u);
v = fftshift(v);

% Axes
w_freq_cols = linspace(-pi,pi-(2*pi)/Ncols,Ncols);
freq_proper_cols = F_s*w_freq_cols/(2*pi);        % Spatial frequency
x_cols = freq_proper_cols*Lambda*f_fourier;       % converting from spatial frequency to coordinates

w_freq_rows = linspace(-pi,pi-(2*pi)/Nrows,Nrows);
freq_proper_rows = F_s*w_freq_rows/(2*pi);        % Spatial frequency
x_rows = freq_proper_rows*Lambda*f_fourier;       % converting from spatial frequency to coordinates

% Display image

s(3) = subplot(2,2,3);
imagesc(s_factor*x_cols/(1e-3),s_factor*x_rows/(1e-3),abs(v).^2);
title(s(3),'Amplitude profile Image plane');
xlabel('X_{image} (mm)');
ylabel('Y_{image} (mm)');



