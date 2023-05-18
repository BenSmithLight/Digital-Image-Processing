% 直方图均衡化函数
clc; clear; close all;

%% 读取图像
image1 = imread('./Picture/test1.jpeg');
image2 = imread('./Picture/test2.jpeg');
image3 = imread('./Picture/test3.jpeg');

%% 转换为灰度图像
image1 = rgb2gray(image1);
image2 = rgb2gray(image2);
image3 = rgb2gray(image3);

%% 转换数据类型
image1 = im2double(image1); % 或者使用 im2uint8(image)
image2 = im2double(image2);
image3 = im2double(image3);

%% 显示原始图像及其直方图
figure;
subplot(3, 2, 1);
imshow(image1);
title('原始图像');
subplot(3, 2, 2);
imhist(image1);
title('原始直方图');

subplot(3, 2, 3);
imshow(image2);
title('原始图像');
subplot(3, 2, 4);
imhist(image2);
title('原始直方图');

subplot(3, 2, 5);
imshow(image3);
title('原始图像');
subplot(3, 2, 6);
imhist(image3);
title('原始直方图');

%% 使用 histeq 函数进行直方图均衡化
enhanced_image1 = histeq(image1);
enhanced_image2 = histeq(image2);
enhanced_image3 = histeq(image3);

figure();
% 显示增强后的图像及其直方图
subplot(3, 2, 1);
imshow(enhanced_image1);
title('增强后的图像');
subplot(3, 2, 2);
imhist(enhanced_image1);
title('增强后的直方图');

subplot(3, 2, 3);
imshow(enhanced_image2);
title('增强后的图像');
subplot(3, 2, 4);
imhist(enhanced_image2);
title('增强后的直方图');

subplot(3, 2, 5);
imshow(enhanced_image3);
title('增强后的图像');
subplot(3, 2, 6);
imhist(enhanced_image3);
title('增强后的直方图');
