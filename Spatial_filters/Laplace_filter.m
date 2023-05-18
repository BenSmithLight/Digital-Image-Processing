% 8邻域拉普拉斯滤波器
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

%% 转换为灰度图像
image = rgb2gray(image);

% 将图像转换为double类型
image = im2double(image);

% 定义8邻域模板的拉普拉斯滤波器
laplacian_filter = [0 1 0; 1 -4 1; 0 1 0];

% 应用拉普拉斯滤波器
enhanced_image = imfilter(image, laplacian_filter);

% 对增强后的图像进行调整，以便显示
enhanced_image = image - enhanced_image;

% 将像素值限制在0到1之间
enhanced_image = max(0, min(1, enhanced_image));

% 显示增强后的图像
figure(1);
subplot(1, 2, 1);
imshow(image);
subplot(1, 2, 2);
imshow(enhanced_image);