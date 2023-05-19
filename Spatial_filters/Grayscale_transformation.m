% 灰度变换
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

% 转换为灰度图像
image = rgb2gray(image);

% 对数变换
img_log = im2uint8(mat2gray(log(1 + double(image))));
% 伽马变换
img_gamma = imadjust(image, [], [], 0.5); % gamma值可以调整
% 显示结果
subplot(2, 2, 1); imshow(image); title('原图灰度化');
subplot(2, 2, 2); imshow(img_log); title('对数变换');
subplot(2, 2, 3); imshow(img_gamma); title('伽马变换');
