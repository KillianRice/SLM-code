%Binary phase grating with translational symmetry producing even number of
%spots: 8
close all;
clear all;

N = 2048;  		%Size of image will still be 1024 x 1272
x_axis = 1:N;
T = 512;
%% Transition points obtained after optimization
x_n = [0.1812,0.2956,0.3282,0.4392, 0.5000,0.6812,0.7956,0.8282,0.9392]; % transitions
x_n_T = round(x_n*T) + 1;                                   % rounded off to integer
phi_n = [0 pi 0 pi 0 pi 0 pi 0 pi];
n = 1:T;

% 1st
[y1,n] = unitstep_dt(n(1),1,n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(1)+1,n(end));
F0 = phi_n(1)*(y1-y2);

% 2nd
[y1,n] = unitstep_dt(n(1),x_n_T(1),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(2),n(end));
F1 = phi_n(2)*(y1-y2);

% 3rd
[y1,n] = unitstep_dt(n(1),x_n_T(2),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(3),n(end));
F2 = phi_n(3)*(y1-y2);

% 4th
[y1,n] = unitstep_dt(n(1),x_n_T(3),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(4),n(end));
F3 = phi_n(4)*(y1-y2);

% 5th
[y1,n] = unitstep_dt(n(1),x_n_T(4),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(5),n(end));
F4 = phi_n(5)*(y1-y2);

% 6th
[y1,n] = unitstep_dt(n(1),x_n_T(5),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(6),n(end));
F5 = phi_n(6)*(y1-y2);

% 7th
[y1,n] = unitstep_dt(n(1),x_n_T(6),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(7),n(end));
F6 = phi_n(7)*(y1-y2);

% 8th
[y1,n] = unitstep_dt(n(1),x_n_T(7),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(8),n(end));
F7 = phi_n(8)*(y1-y2);

% 9th
[y1,n] = unitstep_dt(n(1),x_n_T(8),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(9),n(end));
F8 = phi_n(9)*(y1-y2);

% 10th
[y1,n] = unitstep_dt(n(1),x_n_T(9),n(end));
F9 = phi_n(10)*y1;
%% Finaly phase profile
F = F0 + F1 + F2 + F3+ F4+ F5+F6+F7+F8+F9;
figure('Name','Single period','NumberTitle','off');
plot(n/T,F/pi);
ylabel('\phi (units of \pi)');
axis([0 inf -0.5 1.5]);

rep = N/T;                      % Number of repitions
func = repmat(F,1,rep);         % Repeating one period 

figure('Name','Damman Grating Phase Profile (1D)','NumberTitle','off');
plot(x_axis,func/pi);
axis([0 N -0.5 1.5]);
xlabel('Pixels');
ylabel('\phi (units of \pi)');
clearvars -except func N x_axis
%% extending to 2D
for iter_col = 1:1272
    for iter_row = 1:1024
        Phi_x(iter_row,iter_col) = func(iter_col);         %high freq
    end
end
for iter_row = 1:1024
    for iter_col = 1:1272
        Phi_y(iter_row,iter_col) = func(iter_row);
    end
end

figure('Name','Damman Grating Phase Profile (2D)','NumberTitle','off');
Phi = mod(Phi_x+Phi_y,2*pi);  
imagesc(Phi/pi,[0 2]);  
colormap gray;
h = colorbar;
ylabel(h,'\phi (units of \pi)');
axis off;
%% Saving the 2D file as .bmp (8 bit)
Phi = 255/(2*pi) * Phi;         %Converting from [0,2pi] to [0,255]
Phi = uint8(Phi);
imwrite(Phi,'Dammann_2D_phase_8.bmp','bmp');
