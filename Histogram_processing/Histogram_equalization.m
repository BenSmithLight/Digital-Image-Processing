% 直方图均衡化
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

% 指定处理的图像
image = image1;

% 转换为灰度图像
image = rgb2gray(image);

%% 使用 histeq 函数进行直方图均衡化
ienhanced_image = histeq(image);

%% 显示原始图像及其直方图
figure();
subplot(2, 2, 1); imshow(image); title('原始图像', 'FontSize', 20);
subplot(2, 2, 2); imhist(image); title('原始直方图', 'FontSize', 20); set(gca, 'FontSize', 14)

subplot(2, 2, 3); imshow(ienhanced_image); title('均衡化图像', 'FontSize', 20);
subplot(2, 2, 4); imhist(ienhanced_image); title('均衡化直方图', 'FontSize', 20); set(gca, 'FontSize', 14)

%% 显示第二张图像及其直方图
figure();
image = image2;

image = rgb2gray(image);
ienhanced_image = histeq(image);

subplot(2, 2, 1); imshow(image);
title('原始图像', 'FontSize', 20);
subplot(2, 2, 2); imhist(image);
title('原始直方图', 'FontSize', 20);
set(gca, 'FontSize', 14)

subplot(2, 2, 3); imshow(ienhanced_image);
title('均衡化图像', 'FontSize', 20);
subplot(2, 2, 4); imhist(ienhanced_image);
title('均衡化直方图', 'FontSize', 20);
set(gca, 'FontSize', 14)

%% 显示第三张图像及其直方图
figure();
image = image3;

image = rgb2gray(image);
ienhanced_image = histeq(image);

subplot(2, 2, 1); imshow(image);
title('原始图像', 'FontSize', 20);
subplot(2, 2, 2); imhist(image);
title('原始直方图', 'FontSize', 20);
set(gca, 'FontSize', 14)

subplot(2, 2, 3); imshow(ienhanced_image);
title('均衡化图像', 'FontSize', 20);
subplot(2, 2, 4); imhist(ienhanced_image);
title('均衡化直方图', 'FontSize', 20);
set(gca, 'FontSize', 14)
