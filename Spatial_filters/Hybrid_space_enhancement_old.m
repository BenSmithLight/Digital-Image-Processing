% 混合空间增强
clc; clear;close;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

%% 转换为灰度图像
image = rgb2gray(image);

%% 拉普拉斯突出细节
% 将图像转换为double类型(0-1)
image = im2double(image);

% 定义8邻域模板的拉普拉斯滤波器
laplacian_filter = [0 1 0; 1 -4 1; 0 1 0];

% 应用拉普拉斯滤波器
laplacian_image = imfilter(image, laplacian_filter);

% 对增强后的图像进行调整，以便显示
laplacian_image = image - laplacian_image;

% 将像素值限制在0到1之间
laplacian_image = laplacian_image / max(laplacian_image(:));

% 将数值映射为0到255之间的整数
laplacian_image = uint8(255 * laplacian_image);

% 输出
figure();
subplot(1, 2, 1);
imshow(image); title('原图像');
subplot(1, 2, 2);
imshow(laplacian_image); title('拉普拉斯突出细节');

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

% 将像素值限制在0到1之间
Is = Is / max(Is(:));
Is = Is + image;
Is = Is / max(Is(:));

% 将数值映射为0到255之间的整数
Is = uint8(255 * Is);

% 输出
figure;
subplot(1, 2, 1);
imshow(Is); title('Sobel算子边缘强化');

%% 对Sobel算子边缘强化后的图像进行盒式滤波
% 创建盒式滤波器
filter_size = 5;  % 滤波器大小
box_filter = fspecial('average', filter_size);
% 应用滤波器
box_image = imfilter(Is, box_filter, 'replicate');

% 输出
subplot(1, 2, 2);
imshow(box_image); title('盒式滤波');

%% 将拉普拉斯图像与盒式滤波图像相乘
% 将图像转换为double类型(0-1)
laplacian_image = im2double(laplacian_image);
box_image = im2double(box_image);

% 相乘
enhanced_image = laplacian_image .* box_image;

% 将像素值限制在0到1之间
enhanced_image = enhanced_image / max(enhanced_image(:));

% 将数值映射为0到255之间的整数
enhanced_image = uint8(255 * enhanced_image);

% 输出
figure;
subplot(1, 3, 1);
imshow(image); title('原图像', 'FontSize', 20);
subplot(1, 3, 2);
imshow(enhanced_image); title('拉普拉斯与盒式滤波相乘', 'FontSize', 20);

%% 叠加原图和增强图像
% 将图像转换为double类型(0-1)
enhanced_image = im2double(enhanced_image);

% 叠加
mixed_image = image + enhanced_image;

% 将像素值限制在0到1之间
mixed_image = mixed_image / max(mixed_image(:));

% 将数值映射为0到255之间的整数

mixed_image = uint8(255 * mixed_image);

% 输出
subplot(1, 3, 3);
imshow(mixed_image); title('叠加原图和增强图像', 'FontSize', 20);


%% 对混合图像进行伽马校正
img_gamma = imadjust(mixed_image, [], [], 0.5); % gamma值可以调整

% 输出
figure;
subplot(1, 2, 1);
imshow(image); title('原图像', 'FontSize', 20);
subplot(1, 2, 2);
imshow(img_gamma); title('伽马校正的增强图像', 'FontSize', 20);