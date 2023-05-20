% 直方图均衡化函数
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

%% 转换为灰度图像
image = rgb2gray(image);

%% 转换数据类型
image = im2double(image); % 或者使用 im2uint8(image)

%% 使用 histeq 函数进行直方图均衡化
ienhanced_image = histeq(image);

%% 显示原始图像及其直方图
figure(1);
subplot(2, 2, 1);
imshow(image);
title('原始图像');
subplot(2, 2, 2);
imhist(image);
title('原始直方图');

subplot(2, 2, 3);
imshow(ienhanced_image);
title('增强后的图像');
subplot(2, 2, 4);
imhist(ienhanced_image);
title('增强后的直方图');

%% 显示第二张图像及其直方图
figure(2);
image = image2;

image = rgb2gray(image);
image = im2double(image);
ienhanced_image = histeq(image);

subplot(2, 2, 1);
imshow(image);
title('原始图像');
subplot(2, 2, 2);
imhist(image);
title('原始直方图');

subplot(2, 2, 3);
imshow(ienhanced_image);
title('增强后的图像');
subplot(2, 2, 4);
imhist(ienhanced_image);
title('增强后的直方图');

%% 显示第三张图像及其直方图
figure(3);
image = image3;

image = rgb2gray(image);
image = im2double(image);
ienhanced_image = histeq(image);

subplot(2, 2, 1);
imshow(image);
title('原始图像');
subplot(2, 2, 2);
imhist(image);
title('原始直方图');

subplot(2, 2, 3);
imshow(ienhanced_image);
title('增强后的图像');
subplot(2, 2, 4);
imhist(ienhanced_image);
title('增强后的直方图');


