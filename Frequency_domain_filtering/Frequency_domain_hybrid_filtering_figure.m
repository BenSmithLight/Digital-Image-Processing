% 混合频域增强
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

% 指定处理的图像
image = image3;

% 转换为灰度图像
image = rgb2gray(image);

% 将图像转换为double类型(0-1)
image = im2double(image);

%% 拉普拉斯变换增强细节
% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(image));

% 设计拉普拉斯滤波器
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离
H = -4 * pi^2 * D.^2; % 拉普拉斯滤波器

% 使用窗函数避免振铃现象
w = hamming(M) * hamming(N)'; % 汉明窗
H = H .* w; % 窗函数乘以滤波器

% 进行频域滤波
img_filter = img_fft .* H;

% 傅里叶反变换并取实部和绝对值
img_ifft = abs(real(ifft2(ifftshift(img_filter))));

% 归一化
img_ifft = mat2gray(img_ifft);

% 叠加
laplacian_image = image + img_ifft;

% 归一化
% laplacian_image = mat2gray(laplacian_image);

% 显示滤波器和结果图
figure;
subplot(2, 3, 1); imshow(image);
title('原图', 'FontSize', 20);

subplot(2, 3, 2); imshow(img_ifft);
title('拉普拉斯滤波', 'FontSize', 20);

subplot(2, 3, 3); imshow(laplacian_image);
title('拉普拉斯增强', 'FontSize', 20);

%% 高提升滤波
% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(image));

% 设计钝化模板
[M, N] = size(img_fft);
[U, V] = meshgrid(-N / 2:N / 2 - 1, -M / 2:M / 2 - 1);
D = sqrt(U .^ 2 + V .^ 2); % 距离频域中心的距离
D0 = 100; % 截止频率
H1 = 1 - exp(-D .^ 2 / (2 * D0 ^ 2)); % 高斯高通滤波器
H1 = 1 - H1; % 钝化模板

% 设计高提升滤波器
k = 1.2; % 增益系数
H2 = k - H1; % 高提升滤波器

% 循环显示不同类型的滤波器和结果图

for i = 1:2
    % 选择滤波器
    switch i
        case 1
            H = H1;
            title_str = '钝化模板';
        case 2
            H = H2;
            title_str = '高提升滤波器';
    end

    % 进行频域滤波
    img_filter = img_fft .* H;

    % 傅里叶反变换并取实部和绝对值
    img_ifft = abs(real(ifft2(ifftshift(img_filter))));
end

% 显示滤波器和结果图

% 叠加
highboost_image = image + img_ifft;

% 显示原图和结果图

subplot(2, 3, 4); imshow(highboost_image);
title('高提升滤波后的图像', 'FontSize', 20);

%% 对高增强滤波进行低通滤波
% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(highboost_image));

% 设计高斯低通滤波器
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离
D0 = 200; % 截止频率

% 高斯低通滤波器
H2 = exp(-D.^2 / (2 * D0^2));

% 进行频域滤波
img_filter = img_fft .* H2;

% 傅里叶反变换并取实部和绝对值
smooth_image = abs(real(ifft2(ifftshift(img_filter))));

% 显示滤波器和结果图

% 拉普拉斯增强后的图像与低通滤波后的图像相乘
mixed_image = laplacian_image .* smooth_image;

% 叠加
mixed_image = 1.2 * image + 0.4 * mixed_image;

% 绘制图形
subplot(2, 3, 5); imshow(smooth_image);
title('高斯低通滤波', 'FontSize', 20);

subplot(2, 3, 6); imshow(mixed_image);
title('混合增强后的图像', 'FontSize', 20);

%% 同态滤波
% 读取图像
mixed_image = uint8(mixed_image * 255);

% 取对数
img_log = log(double(mixed_image) + 1);

% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(img_log));

% 设计同态滤波器
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离
rH = 0.6; % 高频增益
rL = 0.5; % 低频增益
D0 = 50; % 截止频率
c = 10; % 衰减系数

% 生成同态滤波器
H = (rH - rL) * (1 - exp(-c * (D.^2 / D0^2))) + rL; 

% 进行频域滤波
img_filter = img_fft .* H;

% 傅里叶反变换并取实部
img_ifft = real(ifft2(ifftshift(img_filter)));

% 取指数并归一化
img_out = exp(img_ifft) - 1;
img_out = mat2gray(img_out);

%% 对混合图像进行伽马校正
% img_out = imadjust(img_out, [], [], 0.75); % gamma值可以调整

% 显示原图和结果图
figure;
subplot(2, 2, 1); imshow(image);
title('原图', 'fontSize', 20');
subplot(2, 2, 2);
imagesc(log(abs(img_fft) + 1)); % 使用对数变换和绝对值来增强可视化效果
colormap gray; colorbar;
title('原图的频谱图', 'fontSize', 20');
subplot(2, 2, 3); imshow(img_out);
title('同态滤波后的图像', 'fontSize', 20');

% 获取同态滤波后的频谱图
img_out = uint8(img_out * 255);
% 取对数
img_log = log(double(img_out) + 1);
% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(img_log));

% 绘制图形
subplot(2, 2, 4);
imagesc(log(abs(img_fft) + 1)); % 使用对数变换和绝对值来增强可视化效果
colormap gray; colorbar;
title('滤波后的频谱图', 'fontSize', 20');
