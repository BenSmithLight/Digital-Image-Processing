% 混合频域增强
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image3;

%% 转换为灰度图像
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

% 进行频域滤波
img_filter = img_fft .* H;

% 傅里叶反变换并取实部和绝对值
img_ifft = abs(real(ifft2(ifftshift(img_filter))));

% 归一化
img_ifft = img_ifft / max(img_ifft(:));

% 叠加
laplacian_image = image + img_ifft;

% 显示滤波器和结果图
figure;
subplot(2, 2, 1);
imagesc(H);
colormap gray;
colorbar;
title('拉普拉斯滤波器');

subplot(2, 2, 2);
imshow(img_ifft);
title('滤波后的图像');

% 叠加原图
laplacian_image = image + img_ifft;

subplot(2, 2, 3);
imshow(image);
title('原图');

subplot(2, 2, 4);
imshow(laplacian_image);
title('叠加后的图像');

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
k = 1; % 增益系数
H2 = k - H1; % 高提升滤波器
H2 = 1 * H2; % 增益系数为2

% 循环显示不同类型的滤波器和结果图
figure;

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

    % 显示滤波器和结果图
    subplot(2, 2, i * 2 - 1);
    imagesc(H);
    colormap gray;
    colorbar;
    title(title_str);

    subplot(2, 2, i * 2);
    imshow(img_ifft, []);
    title('滤波后的图像');
end

% 叠加
highboost_image = image + img_ifft;

% 显示原图和结果图
figure;
subplot(1, 2, 1);
imshow(image);
title('原图');

subplot(1, 2, 2);
imshow(highboost_image);
title('叠加后的图像');

figure;
subplot(1, 2, 1);
imshow(laplacian_image);
title('拉普拉斯增强后的图像');

subplot(1, 2, 2);
imshow(highboost_image);
title('高提升增强后的图像');

%% 对高增强滤波进行低通滤波
% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(highboost_image));

% 设计不同类型的低通滤波器
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离
D0 = 50; % 截止频率

% 理想低通滤波器
H1 = double(D <= D0);

% 高斯低通滤波器
H2 = exp(-D.^2 / (2 * D0^2));

% 巴特沃斯低通滤波器
n = 2; % 滤波器阶数
H3 = 1 ./ (1 + (D / D0).^(2 * n));

% 循环显示不同类型的滤波器和结果图
figure;
H = H2;
title_str = '高斯低通滤波器';
% 进行频域滤波
img_filter = img_fft .* H;

% 傅里叶反变换并取实部和绝对值
smooth_image = abs(real(ifft2(ifftshift(img_filter))));

% 显示滤波器和结果图
subplot(1, 2, 1);
imagesc(H);
colormap gray;
colorbar;
title(title_str);

subplot(1, 2, 2);
imshow(smooth_image);
title('滤波后的图像');

% 拉普拉斯增强后的图像与低通滤波后的图像相乘
% 均进行重映射
laplacian_image = uint8(laplacian_image * 255);
smooth_image = uint8(smooth_image * 255);

laplacian_image = im2double(laplacian_image);
smooth_image = im2double(smooth_image);

mixed_image = laplacian_image .* smooth_image;

% 重新映射
mixed_image = mixed_image / max(mixed_image(:));

% 叠加
mixed_image = image + mixed_image;

% 归一化
mixed_image = mixed_image / max(mixed_image(:));

figure;
subplot(1, 2, 1);
imshow(image);
title('原图');

subplot(1, 2, 2);
imshow(mixed_image);
title('混合增强后的图像');

%% 同态滤波
%% 读取图像
image = uint8(mixed_image * 255) ;

% 取对数
img_log = log(double(image) + 1);

% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(img_log));

% 傅里叶变换并平移到中心
% 设计同态滤波器
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离

figure;
imagesc(log(abs(img_fft) + 1)); % 使用对数变换和绝对值来增强可视化效果
colormap gray;
colorbar;
title('频谱图');

% 循环显示不同参数下的结果
figure;
rH = 0.5; % 高频增益
rL = 0.5; % 低频增益
D0 = 50; % 截止频率
c = 1; % 衰减系数

H = (rH - rL) * (1 - exp(-c * (D.^2 / D0^2))) + rL; % 同态滤波器

% 进行频域滤波
img_filter = img_fft .* H;

% 傅里叶反变换并取实部
img_ifft = real(ifft2(ifftshift(img_filter)));

% 取指数并归一化
img_out = exp(img_ifft) - 1;
img_out = mat2gray(img_out);

% 显示滤波器和结果图
subplot(2, 2, 1);
imagesc(H);
colormap gray;
colorbar;
title(sprintf('rH=%g,rL=%g,D0=%g,c=%g', rH, rL, D0, c));

subplot(2, 2, 2);
imshow(img_out);
title('同态滤波后的图像');

% 显示原图和结果图
subplot(2, 2, 3);
imshow(image);
title('原图');
subplot(2, 2, 4);
imshow(img_out);
title('同态滤波后的图像');