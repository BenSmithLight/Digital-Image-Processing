% 混合频域增强
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

%% 转换为灰度图像
image = rgb2gray(image);

%% 同态滤波
% 取对数
img_log = log(double(image) + 1);

% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(img_log));

% 傅里叶变换并平移到中心
% 设计同态滤波器
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离

figure;
imagesc(log(abs(img_fft) + 1)); % 使用对数变换和绝对值来增强可视化效果
colormap gray;
colorbar;
title('频谱图');

% 循环显示不同参数下的结果
figure;
rH = 0.6; % 高频增益
rL = 0.6; % 低频增益
D0 = 50; % 截止频率
c = 1; % 衰减系数

H = (rH - rL) * (1 - exp(-c * (D.^2 / D0^2))) + rL; % 同态滤波器

% 进行频域滤波
img_filter = img_fft .* H;

% 傅里叶反变换并取实部
img_ifft = real(ifft2(ifftshift(img_filter)));

% 取指数并归一化
img_out = exp(img_ifft) - 1;
img_out = mat2gray(img_out);

% 显示滤波器和结果图
subplot(2, 2, 1);
imagesc(H);
colormap gray;
colorbar;
title(sprintf('rH=%g,rL=%g,D0=%g,c=%g', rH, rL, D0, c));

subplot(2, 2, 2);
imshow(img_out);
title('同态滤波后的图像');

% 显示原图和结果图
subplot(2, 2, 3);
imshow(image);
title('原图');
subplot(2, 2, 4);
imshow(img_out);
title('同态滤波后的图像');

% 将图像转换为double类型(0-1)
image = im2double(img_out);

%% 拉普拉斯变换增强细节
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

% 归一化
img_ifft = img_ifft / max(img_ifft(:));

% 叠加
laplacian_image = image + img_ifft;

% 归一化
laplacian_image = laplacian_image / max(laplacian_image(:));

% 显示滤波器和结果图
figure;
subplot(2, 2, 1);
imshow(image);
title('原图');

subplot(2, 2, 2);
imagesc(H);
colormap gray;
colorbar;
title('拉普拉斯滤波器');

subplot(2, 2, 3);
imshow(img_ifft);
title('滤波后的图像');

subplot(2, 2, 4);
imshow(laplacian_image);
title('叠加后的图像');

