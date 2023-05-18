% 低通滤波器
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

% 转换为灰度图像
image = rgb2gray(image);

%% 设置参数
% 获取图像的大小
[M, N] = size(image);
% 定义高斯低通滤波器的标准差
sigma = 1;
% 定义盒式低通滤波器的窗口大小
w = 3;

%% 高斯低通滤波器和盒式低通滤波器
% 初始化高斯低通滤波器和盒式低通滤波器的输出图像
Ig = zeros(M, N);
Ib = zeros(M, N);
% 遍历每个像素点，计算高斯低通滤波器和盒式低通滤波器的输出值
for i = 1:M

    for j = 1:N
        % 定义邻域的范围，避免越界
        rmin = max(1, i - w);
        rmax = min(M, i + w);
        cmin = max(1, j - w);
        cmax = min(N, j + w);
        % 获取邻域的像素值
        region = image(rmin:rmax, cmin:cmax);
        % 计算邻域的大小
        [m, n] = size(region);
        % 初始化高斯低通滤波器和盒式低通滤波器的权重矩阵
        wg = zeros(m, n);
        wb = ones(m, n) / (m * n);
        % 计算高斯低通滤波器的权重矩阵
        for u = 1:m

            for v = 1:n
                x = u - floor(m / 2) - 1;
                y = v - floor(n / 2) - 1;
                wg(u, v) = exp(- (x ^ 2 + y ^ 2) / (2 * sigma ^ 2)) / (2 * pi * sigma ^ 2);
            end

        end

        % 计算高斯低通滤波器和盒式低通滤波器的输出值
        Ig(i, j) = sum(sum(wg .* double(region)));
        Ib(i, j) = sum(sum(wb .* double(region)));
    end

end

%% 显示图像
% 将输出图像转换为无符号整数类型
Ig = uint8(Ig);
Ib = uint8(Ib);
% 显示原始图像、高斯低通滤波后的图像和盒式低通滤波后的图像
subplot(1, 3, 1); imshow(image); title('原始图像');
subplot(1, 3, 2); imshow(Ig); title('高斯低通滤波后的图像');
subplot(1, 3, 3); imshow(Ib); title('盒式低通滤波后的图像');
