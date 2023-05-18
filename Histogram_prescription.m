% 直方图规定化函数
clc; clear; close all;

%% 读取图像
image1 = imread('./Picture/test1.jpeg');
image2 = imread('./Picture/test2.jpeg');
image3 = imread('./Picture/test3.jpeg');

image1_goal = imread('./Picture/test1_change.jpeg');
image2_goal = imread('./Picture/test2_change.jpeg');
image3_goal = imread('./Picture/test3_change.jpeg');

%% 读取原始图像I
% image = image1;
% image = image2;
image = image3;

%% 读取目标图像
% image_goal = image1_goal;
% image_goal = image2_goal;
image_goal = image3_goal;

%% 将原始图像和目标图像转换为灰度图像
image = rgb2gray(image);
image_goal = rgb2gray(image_goal);

%% 计算原始图像和目标图像的灰度级数
M = max(image(:)) + 1;
N = max(image_goal(:)) + 1;

%% 计算原始图像和目标图像的灰度直方图
HI = imhist(image, M);
HT = imhist(image_goal, N);

%% 计算原始图像和目标图像的累积分布函数
CI = cumsum(HI) / sum(HI);
CT = cumsum(HT) / sum(HT);

%% 初始化灰度映射函数
map = zeros(M, 1);

%% 对每个灰度级，寻找最接近的累积分布值，并记录其索引
for i = 1:M
    [~, ind] = min(abs(CI(i) - CT));
    map(i) = ind - 1;
end

%% 对原始图像进行灰度映射，得到规定化后的图像
O = map(image + 1);

%% 显示原始图像、目标图像和规定化后的图像
subplot(3, 2, 1); imshow(image); title('原始图像');
subplot(3, 2, 2); imhist(image);; title('目标直方图');
subplot(3, 2, 3); imshow(image_goal); title('目标图像');
subplot(3, 2, 4); imhist(image_goal); title('目标直方图');
subplot(3, 2, 5); imshow(uint8(O)); title('规定化后的图像');
subplot(3, 2, 6); imhist(uint8(O)); title('规定化后的直方图');
