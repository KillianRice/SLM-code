% A multilevel phase grating 
clear all;
close all;

N = 2048*2;      % Size of the 1D grating
x = 1:N;
T = 128;     % Period of the Dammam grating in pixels (must be even and a factor of N)
L = 8;      % The number of discrete phase levels
n = 1:T/2;   % The axis for one period

% Transition points
phi = [0,0.25,0.5,1.5]; % phi(n) in the research paper
x_n = [0.13,0.235,0.337];
x_n_T = round(x_n*T) + 1;
% The phase profile for one single period
% F = 3 (# of Transition coordinates) or (degrees of freedom) or (This sets the number of spots = 2F-1)

% F = 0
[y1,n] = unitstep_dt(n(1),1,n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(1)+1,n(end));
F0 = (2*pi/L)*phi(1)*(y1-y2);

% F = 1
[y1,n] = unitstep_dt(n(1),x_n_T(1),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(2),n(end));
F1 = (2*pi/L)*phi(2)*(y1-y2);

% F = 2
[y1,n] = unitstep_dt(n(1),x_n_T(2),n(end));
[y2,n] = unitstep_dt(n(1),x_n_T(3),n(end));
F2 = (2*pi/L)*phi(3)*(y1-y2);

% F = 3
[y1,n] = unitstep_dt(n(1),x_n_T(3),n(end));
F3 = (2*pi/L)*phi(4)*y1;

% Computing the other half and getting the full period
F = F0+F1+F2+F3;


[F_rev,n_rev] = fold(F,n);      % A function from my DSP course which reflects a function
F = [F_rev,F];                  % concatenating the two reflections
rep = N/T;                      % Number of repitions
func = repmat(F,1,rep);         % Repeating one period 

figure('Name','Multilevel phase grating (1D)','NumberTitle','off');
plot(x,func);
xlabel('Pixels');
ylabel('Phase (units of \pi)');
clear F F0 F1 F2 F3 F_rev L n n_rev phi rep T x y1 y2
