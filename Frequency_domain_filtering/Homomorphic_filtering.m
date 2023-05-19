% 同态滤波
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

%% 转换为灰度图像
image = rgb2gray(image);

% 取对数
img_log = log(double(image) + 1);

% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(img_log));

% 设计同态滤波器
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离

% 设置不同的参数组合
% params = [1.2, 0.9, 50, 100; % 原始参数
%           1, 1, 20, 0; % 减小c
%           1, 1, 20, 0; % 增大D0
%           1, 1, 20, 0]; % 调整rH和rL
params = [0.6, 0.6, 50, 1];

figure;
imagesc(log(abs(img_fft) + 1)); % 使用对数变换和绝对值来增强可视化效果
colormap gray;
colorbar;
title('频谱图');

% 循环显示不同参数下的结果
figure(2);
for i = 1:size(params, 1)
    rH = params(i, 1); % 高频增益
    rL = params(i, 2); % 低频增益
    D0 = params(i, 3); % 截止频率
    c = params(i, 4); % 衰减系数
    
    H = (rH - rL) * (1 - exp(-c * (D.^2 / D0^2))) + rL; % 同态滤波器
    
    % 进行频域滤波
    img_filter = img_fft .* H;

    % 傅里叶反变换并取实部
    img_ifft = real(ifft2(ifftshift(img_filter)));

    % 取指数并归一化
    img_out = exp(img_ifft) - 1;
    img_out = mat2gray(img_out);
    
    % 显示滤波器和结果图
    subplot(4, 2, i * 2 - 1);
    imagesc(H);
    colormap gray;
    colorbar;
    title(sprintf('rH=%g,rL=%g,D0=%g,c=%g', rH, rL, D0, c));
    
    subplot(4, 2, i * 2);
    imshow(img_out);
    title('同态滤波后的图像');
end

figure(3);
% 显示原图和结果图
subplot(1, 2, 1);
imshow(image);
title('原图');
subplot(1, 2, 2);
imshow(img_out);
title('同态滤波后的图像');


