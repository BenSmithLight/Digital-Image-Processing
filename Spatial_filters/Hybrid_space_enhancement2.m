% 混合空间增强(用高提升滤波代替拉普拉斯)
clc; clear;

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
subplot(4, 2, 1);
imshow(image); title('原图像');
subplot(4, 2, 2);
imshow(boosted_image); title('高提升滤波');

%% 对原图像使用Sobel算子进行边缘强化
% 将图像转换为double类型(0-1)
image = im2double(image);
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
subplot(4, 2, 3);
imshow(Is); title('Sobel算子边缘强化');

%% 对Sobel算子边缘强化后的图像进行盒式滤波
% 创建盒式滤波器
filter_size = 5;  % 滤波器大小
box_filter = fspecial('average', filter_size);
% 应用滤波器
box_image = imfilter(Is, box_filter, 'replicate');

% 输出
subplot(4, 2, 4);
imshow(box_image); title('盒式滤波');

%% 将拉普拉斯图像与盒式滤波图像相乘
% 将图像转换为double类型(0-1)
boosted_image = im2double(boosted_image);
box_image = im2double(box_image);

% 相乘
enhanced_image = boosted_image .* box_image;

% 将像素值限制在0到1之间
enhanced_image = enhanced_image / max(enhanced_image(:));

% 将数值映射为0到255之间的整数
enhanced_image = uint8(255 * enhanced_image);

% 输出subplot(3, 2
subplot(4, 2, 5);
imshow(enhanced_image); title('拉普拉斯与盒式滤波相乘');

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
subplot(4, 2, 6);
imshow(mixed_image); title('叠加原图和增强图像');


%% 对混合图像进行伽马校正
img_gamma = imadjust(mixed_image, [], [], 0.5); % gamma值可以调整

% 输出
subplot(4, 2, 7);
imshow(img_gamma); title('伽马校正');
subplot(4, 2, 8);
imhist(img_gamma); title('伽马校正直方图');