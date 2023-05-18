% 低通滤波器(使用Matlab的fspecial函数)
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

% 转换为灰度图像
image = rgb2gray(image);

% 创建高斯滤波器
sigma = 2;  % 标准差
filter_size = 5;  % 滤波器大小
gaussian_filter = fspecial('gaussian', filter_size, sigma);
% 应用滤波器
gaussian_image = imfilter(image, gaussian_filter, 'replicate');


% 创建盒式滤波器
filter_size = 5;  % 滤波器大小
box_filter = fspecial('average', filter_size);
% 应用滤波器
box_image = imfilter(image, box_filter, 'replicate');

% 显示原始图像、高斯低通滤波后的图像和盒式低通滤波后的图像
subplot(1, 3, 1); imshow(image); title('原始图像');
subplot(1, 3, 2); imshow(gaussian_image); title('高斯低通滤波后的图像');
subplot(1, 3, 3); imshow(box_image); title('盒式低通滤波后的图像');
