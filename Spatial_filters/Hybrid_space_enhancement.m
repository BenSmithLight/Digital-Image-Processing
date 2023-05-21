% 混合空间增强
clc; clear;close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image3;

% 转换为灰度图像
image = rgb2gray(image);

% 将图像转换为double类型(0-1)
image = im2double(image);

%% 拉普拉斯突出细节

% 定义8邻域模板的拉普拉斯滤波器
laplacian_filter = [1 1 1; 1 -8 1; 1 1 1];

% 应用拉普拉斯滤波器
laplacian_filter = imfilter(image, laplacian_filter, 'replicate');

% 标定拉普拉斯
% laplacian_image = mat2gray(laplacian_image);

% 对增强后的图像进行调整，以便显示
laplacian_image = image - laplacian_filter;

% laplacian_image = mat2gray(laplacian_image);

% 将数值映射为0到255之间的整数
% laplacian_image = uint8(255 * laplacian_image);


% 输出
figure();
subplot(1, 3, 1);
imshow(image); title('原图像', 'FontSize', 20);
subplot(1, 3, 2);
imshow(laplacian_filter, []); title('拉普拉斯变换', 'FontSize', 20);
subplot(1, 3, 3);
imshow(laplacian_image); title('拉普拉斯突出细节', 'FontSize', 20);

%% 对原图像使用Sobel算子进行边缘强化

% 获取图像的大小
[M, N] = size(image);

% 定义梯度算子的模板
Sobel_x = [-1 -2 -1; 0 0 0; 1 2 1];
Sobel_y = [-1 0 1; -2 0 2; -1 0 1];

% 初始化梯度算子的输出图像
Ir = zeros(M, N);
Is = zeros(M, N);
Ip = zeros(M, N);
% 遍历每个像素点，计算梯度算子的输出值
for i = 2:M - 1

    for j = 2:N - 1
        % 获取邻域的像素值
        region = image(i - 1:i + 1, j - 1:j + 1);
        % 计算水平和垂直方向上的灰度差分
        dx_s = sum(sum(Sobel_x .* double(region)));
        dy_s = sum(sum(Sobel_y .* double(region)));
        % 计算梯度幅值
        Is(i, j) = sqrt(dx_s ^ 2 + dy_s ^ 2);
    end

end

% % 将像素值限制在0到1之间
% Is = Is / max(Is(:));
Sobel_image = Is + image;
% Is = Is / max(Is(:));

% % 将数值映射为0到255之间的整数
% Is = uint8(255 * Is);

% 叠加
% Is = mat2gray(Is);

% 输出
figure();
subplot(1, 3, 1);
imshow(image); title('原图像', 'FontSize', 20);
subplot(1, 3, 2);
imshow(Sobel_image); title('Sobel算子边缘强化', 'FontSize', 20);


%% 对Sobel算子边缘强化后的图像进行盒式滤波
% 创建盒式滤波器
filter_size = 5;  % 滤波器大小
box_filter = fspecial('average', filter_size);
% 应用滤波器
box_image = imfilter(Sobel_image, box_filter, 'replicate');

% 输出
subplot(1, 3, 3);
imshow(box_image); title('盒式滤波', 'FontSize', 20);

%% 将拉普拉斯图像与盒式滤波图像相乘
% 将图像转换为double类型(0-1)
% laplacian_image = im2double(laplacian_image);
% box_image = im2double(box_image);

% 相乘
enhanced_filter = (0.5.*laplacian_image) .* (0.5 .* box_image);

% 将像素值限制在0到1之间
% enhanced_image = enhanced_image / max(enhanced_image(:));

% 将数值映射为0到255之间的整数
% enhanced_image = uint8(255 * enhanced_image);

% 输出
figure;
subplot(1, 3, 1);
imshow(image); title('原图像', 'FontSize', 20);
subplot(1, 3, 2);
imshow(enhanced_filter); title('拉普拉斯与盒式滤波相乘', 'FontSize', 20);

%% 叠加原图和增强图像
% 将图像转换为double类型(0-1)
% enhanced_image = im2double(enhanced_image);

% enhanced_filter = mat2gray(enhanced_filter);

% 叠加
enhanced_image = image + enhanced_filter;

% 将像素值限制在0到1之间
% enhanced_image = enhanced_image / max(enhanced_image(:));
% enhanced_image = mat2gray(enhanced_image);

% 将数值映射为0到255之间的整数

% enhanced_image = uint8(255 * enhanced_image);

% 输出
subplot(1, 3, 3);
imshow(enhanced_image); title('叠加原图和增强图像', 'FontSize', 20);


%% 对混合图像进行伽马校正
img_gamma = imadjust(enhanced_image, [], [], 0.6); % gamma值可以调整

% 输出
figure;
imshow(img_gamma); title('伽马校正');
figure;
imshow(image);