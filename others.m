close all
clear all
clc

I = imread('./Picture/test1.jpeg');

I = im2double(I);

M = 2 * size(I, 1); %滤波器的行数

N = 2 * size(I, 2); %滤波器的列数

u = -M / 2:(M / 2 - 1);

v = -N / 2:(N / 2 - 1);

[U, V] = meshgrid(u, v);

D = sqrt(U .^ 2 + V .^ 2);

D0 = 20; %截至频率

H = 1 - exp(- (D .^ 2) ./ (2 * (D0 ^ 2))); %设计高斯高通滤波器

J = fftshift(fft2(I, size(H, 1), size(H, 2))); %时域图像转换到频域

K = J .* H; %滤波

L = ifft2(ifftshift(K)); %频域转换到时域图像

L = L(1:size(I, 1), 1:size(I, 2)); %改变图像大小

DI = I + L;

figure;

subplot(131); imshow(I); %显示原始图像

subplot(132); imshow(L); %显示高斯高通滤波后的图像

subplot(133); imshow(DI); %显示高斯高通滤波后的图像
