
close all;
clear all;
%---------------------------------------------------------
    image=imread('image1.bmp');%load the target image
    if size(size(image))==[1,3]
            Target=double(rgb2gray(image));
    elseif size(size(image))==[1,2]     
        Target=double(image);%binary
    end 
    [m,n]=size(Target);
    Target=Target./max(max(Target));
    avg=mean(mean(Target));
	Ah = fftshift(ifft2(fftshift(Target)));
	error = [];
	iteration_num = 10;
    %--------------------------------------------- 
% input beam�� I suppose it is a gaussian beam
    x = linspace(-10,10,n);
	y = linspace(-10,10,m);% 
	[X,Y] = meshgrid(x,y);
	x0 = 0;     		% center
	y0 = 0;     		% center
	sigma = 5; 			% beam waist
	A = 10;      		% peak of the beam 
	res = ((X-x0).^2 + (Y-y0).^2)./(2*sigma^2);
	input_intensity = A  * exp(-res);

    %begin iteration
for i=1:iteration_num
  Bh = abs(input_intensity) .* exp(1i*angle(Ah));
  Ci = fftshift(fft2(fftshift(Bh)));
  avg2=mean(mean(abs(Ci)));
  Ci=(Ci./avg2).*avg;%Ci has the same average value as target
  Di = Target.* exp(1i*angle(Ci));
  Ah = fftshift(ifft2(fftshift(Di)));
 error = [error; (mean(mean((abs(Ci)-Target).^2)))^0.5];   
end
%------------------draw the result
% 	figure
% 	subplot(2,2,1);
% 	imshow(Target);
% 	title('Original image')
% 	subplot(2,2,2);
%     colormap(gray)
%     Ci=Ci./max(max(abs(Ci)));
%     imshow(abs(Ci));
% 	title('reconstructed image');
%     subplot(2,2,3);
%     imshow(mat2gray(input_intensity));
%     title('input intensity');
%     subplot(2,2,4);
%     imshow(abs(Ci)-Target);
%     title('error(RECOS-ORIG)');
% figure
% i = 1:1:i;
% plot(i,(error'));
% title('Error');
phase=angle(Ah)+pi;%range(0,2pi)
X000=0%phase*128/pi;%like CGH.bmp in double
imwrite(uint8(X000),'phase.bmp')
%！！！！！！！！！！！！！！！！！！！！！！！！！！add grating
Tx=2;
Xcontrast=0;
Ty=2;
Ycontrast=0;%pi;
phasex0=mod(mod([ceil(-n/2):ceil(n/2)-1],Tx)*Xcontrast/(Tx-1),2*pi);
phasey0=mod(mod([ceil(-m/2):ceil(m/2)-1],Ty)*Ycontrast/(Ty-1),2*pi);
[X0,Y0]=meshgrid(phasex0,phasey0);
phase0=mod(X0+Y0,2*pi);
X001=phase0*128/pi;
imwrite(uint8((phase0)*128/pi),'grating.bmp')
%add frenel lens
X002=double(Digital_Lens(150,0));
%add flatness correction
Y000=double(imread('CAL_LSH0802080_460nm.bmp'));
alpha=168;%value for 2pi in datasheet,for 460nm;alpha=210 for 532nm
Z000=X000+X001+Y000+X002;
Z001=mod(Z000,256);
Z002=Z001*alpha/255;
Z003=uint8(Z002);
imwrite(Z003,'desired_pattern.bmp')

   
