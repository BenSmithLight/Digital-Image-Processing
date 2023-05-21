% 混合空间增强(用高提升滤波代替拉普拉斯，去掉Sobel算子边缘强化)
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image3;

%% 转换为灰度图像
image = rgb2gray(image);

%% 高提升滤波
% 定义滤波器阶数
k = 1;

% 定义平滑滤波器
blur_filter = fspecial('gaussian', [5 5], 2); % 5x5的高斯滤波器，标准差为2

% 应用平滑滤波器，得到平滑版本的图像
smoothed_image = imfilter(image, blur_filter, 'replicate');

% 计算非锐化掩蔽图像
unsharp_mask = image - smoothed_image;

% 增强图像
boosted_image = image + k * unsharp_mask;

% 将强度重新映射回0-255
boosted_image = uint8(boosted_image);

% 输出
figure();
subplot(2, 2, 1);
imshow(image); title('原图像', 'FontSize', 20);
subplot(2, 2, 2);
imshow(boosted_image); title('高提升滤波', 'FontSize', 20);

%% 对混合图像进行伽马校正
img_gamma = imadjust(boosted_image, [], [], 0.5); % gamma值可以调整

% 输出
subplot(2, 2, 3);
imshow(img_gamma); title('伽马校正', 'FontSize', 20);
subplot(2, 2, 4);
imhist(img_gamma); title('伽马校正直方图', 'FontSize', 20);