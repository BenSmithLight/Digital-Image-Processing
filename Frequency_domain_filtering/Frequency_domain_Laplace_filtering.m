% 频域拉普拉斯
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

%% 转换为灰度图像
image = rgb2gray(image);

% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(image));

% 设计拉普拉斯滤波器
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离
H = -4 * pi^2 * D.^2; % 拉普拉斯滤波器

% 进行频域滤波
img_filter = img_fft .* H;

% 傅里叶反变换并取实部和绝对值
img_ifft = abs(real(ifft2(ifftshift(img_filter))));

% 显示滤波器和结果图
figure;
subplot(1, 2, 1);
imagesc(H);
colormap gray;
colorbar;
title('拉普拉斯滤波器');

subplot(1, 2, 2);
imshow(img_ifft, []);
title('滤波后的图像');
