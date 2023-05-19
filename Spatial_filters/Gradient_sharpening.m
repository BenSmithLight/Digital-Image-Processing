% 一阶导数（梯度）滤波器
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

%% 转换为灰度图像
image = rgb2gray(image);

% 获取图像的大小
[M, N] = size(image);

% 定义梯度算子的模板
Roberts_x = [0 1 0; -1 0 0; 0 0 0];
Roberts_y = [1 0 0; 0 -1 0; 0 0 0];
Sobel_x = [-1 -2 -1; 0 0 0; 1 2 1];
Sobel_y = [-1 0 1; -2 0 2; -1 0 1];
Prewitt_x = [-1 -1 -1; 0 0 0; 1 1 1];
Prewitt_y = [-1 0 1; -1 0 1; -1 0 1];
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
        dx_r = sum(sum(Roberts_x .* double(region)));
        dy_r = sum(sum(Roberts_y .* double(region)));
        dx_s = sum(sum(Sobel_x .* double(region)));
        dy_s = sum(sum(Sobel_y .* double(region)));
        dx_p = sum(sum(Prewitt_x .* double(region)));
        dy_p = sum(sum(Prewitt_y .* double(region)));
        % 计算梯度幅值
        Ir(i, j) = sqrt(dx_r ^ 2 + dy_r ^ 2);
        Is(i, j) = sqrt(dx_s ^ 2 + dy_s ^ 2);
        Ip(i, j) = sqrt(dx_p ^ 2 + dy_p ^ 2);
    end

end

% 将输出图像转换为无符号整数类型
Ir = uint8(Ir);
Is = uint8(Is);
Ip = uint8(Ip);

Ir = Ir + image;
Is = Is + image;
Ip = Ip + image;

Ir = uint8(Ir);
Is = uint8(Is);
Ip = uint8(Ip);

% 显示原始图像、Roberts算子、Sobel算子和Prewitt算子的输出图像
subplot(2, 2, 1); imshow(image); title('原始图像');
subplot(2, 2, 2); imshow(Ir); title('Roberts算子锐化后的图像');
subplot(2, 2, 3); imshow(Is); title('Sobel算子锐化后的图像');
subplot(2, 2, 4); imshow(Ip); title('Prewitt算子锐化后的图像');
