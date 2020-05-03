%% The purpose of this piece of code is to generate a phase profile using prism and lens phase (in the image plane). 
close all;
clear all;
clc;

%% System Parameters
w_beam  = 0.535e-3;    % beam waist of the generated mode
lambda  = 532e-9;      % illumination wavelength
k = 2*pi/lambda;       % Wave number
dx = 12.5e-6;          % Pixel Pitch of Hamamatsu SLM (X13138-04) aka sampling freq
D = pwd;               % Working Directory of this file
f = 1000e-3;			   % focal length : 1000 mm lens

%% Options
saveFile = 1;  % options are: '1' or '0'

%% Creating a 2-D Mesh
Ncols = 1272;
Nrows = 1024;

xx = 1:Ncols;
yy = 1:Nrows;
[x,y] = meshgrid(xx,yy);


%% Grating profile
% (must be even number for periodicity in discrete time)
T_x = 50;                  % period of the grating in terms of pixels X axis
T_y = 50;                    % period of the grating in terms of pixels Y axis

[n_x,Sp_x] = my_square(Ncols,T_x);
[n_y,Sp_y] = my_square(Nrows,T_y);

% Uncomment to add another frequency grating
% (must be even number for periodicity in discrete time)
Tx_highfreq = 100;              % period of the grating in terms of pixels in X axis
Ty_highfreq = 100;			 % period of the grating in terms of pixels in Y axis	 
[n_x,Spx_highfreq] = my_square(Ncols,Tx_highfreq);
[n_y,Spy_highfreq] = my_square(Ncols,Ty_highfreq);
Ax_highfreq = 0;
Ay_highfreq = 0;
Spx_highfreq = Spx_highfreq * Ax_highfreq;
Spy_highfreq = Spy_highfreq * Ay_highfreq;

% Amplitude (remember, max value is pi)
A_x = pi;
A_y = 0;
Sp_x = Sp_x * A_x;
Sp_y = Sp_y * A_y;

%% Generating Phase Patterns ( all phase is in range [0,2 pi) )

% Grating profile
Phi_grating_x = zeros(1024,1272);
Phi_grating_highfreq_x= zeros(1024,1272);
Phi_grating_y = zeros(1024,1272);
Phi_grating_highfreq_y = zeros(1024,1272);

% multiplying the square wave with the matrix to create a matrix with a
% square wave
for iter_col = 1:1272
    for iter_row = 1:1024
        Phi_grating_x(iter_row,iter_col) = Sp_x(iter_col);         %high freq x
        Phi_grating_highfreq_x(iter_row,iter_col) = Spx_highfreq(iter_col); %low freq x
    end
end
for iter_row = 1:1024
    for iter_col = 1:1272
        Phi_grating_y(iter_row,iter_col) = Sp_y(iter_row);	% high freq y
        Phi_grating_highfreq_y(iter_row,iter_col) = Spy_highfreq(iter_col); %low freq y
    end
end

% Adding phase profiles moduli 2 pi
Phi_grating = mod(Phi_grating_x + Phi_grating_y + Phi_grating_highfreq_x + Phi_grating_highfreq_y,2*pi);
figure('Name','Grating Phase Profile','NumberTitle','off');
imshow(Phi_grating,[0 2*pi]);
colorbar;

% Shift in longitudinal direction
Phi_lens = mod(-k*(dx)^2/(2*f)*((x-Ncols/2).^2+(y-Nrows/2).^2),2*pi);
figure('Name','Fresnel-Lens Phase Profile (ColorMap)','NumberTitle','off');
imshow(Phi_lens,[0,2*pi]);
colorbar;

% Shift in the transverse direction (blazed grating or prism phase)
a = 1e-3;
Phi_prism = mod(-a*k*x*dx,2*pi);
figure('Name','Prism Phase Profile (ColorMap)','NumberTitle','off');
imshow(Phi_prism,[0,2*pi]);


% Sinusoidal Phase Grating

c = 2*pi;           % contrast
period_px = 100;      % period in terms of pixels
f_0 = 1/(dx*period_px);   % spatial frequency of the grating 
phi_sin = c/2 * sin(2*pi*f_0*x*dx)+c/2;
figure('Name','Sinusoidal grating Phase Profile (ColorMap)','NumberTitle','off');
imagesc(phi_sin/pi);
colormap gray;
h = colorbar;
ylabel(h,'\phi (units of \pi)');
axis off;


%% Final Kinoform: (for computation)
% Note: All computation is done in double precision. This is important. If
% I do the computation in 8 bit numbers, significant errors are introduced.
% Results were compared. 
Phi_total = mod(Phi_prism + Phi_lens + Phi_grating+ phi_sin,2*pi);
figure('Name','Total Phase Total_Phase_Profile_computation','NumberTitle','off');
imshow(Phi_total,[0,2*pi]);

Phi_total = 255/(2*pi) * Phi_total;         %Converting from [0,2pi] to [0,255]

%% Final kinoform: (for displaying onto SLM)
% Wavefront Correction:
S = fullfile(D,'Kinoforms','CAL_LSH0802080_532nm.bmp');
wvf_cor_532 = imread(S);
wvf_cor_532 = double(wvf_cor_532);
Phi_slm = mod(Phi_total + wvf_cor_532,256);
% Note: According to the Inspection sheet of the SLM. For 532 nm, at signal 210,
% we get 2 pi phase modulation. Thats how the SLM twisted nematic crystals
% are operating at 532 nm at room temperature.
Phi_slm = Phi_slm*210/255;   
% Appending zeros (because SLM ignores the last 8 columns)
Z = zeros(1024,8);
Phi_slm = cat(2,Phi_slm,Z);
figure('Name','Total_Phase_Profile_SLM','NumberTitle','off');
imshow(Phi_slm,[0 255]);

%% Saving File (using 8-bit numerics)

% Saving file
if saveFile == 1
	Phi_slm = uint8(Phi_slm);
	Phi_total = uint8(Phi_total);
	imwrite(Phi_slm,'Total_Phase_Profile_SLM.bmp','bmp');
	imwrite(Phi_total,'Total_Phase_Profile_computation.bmp','bmp');
end