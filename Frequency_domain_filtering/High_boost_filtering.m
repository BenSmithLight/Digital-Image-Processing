% 高提升滤波
clc; clear; close all;

%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

%% 转换为灰度图像
image = rgb2gray(image);

% 傅里叶变换并平移到中心
img_fft = fftshift(fft2(image));

% 设计钝化模板
[M, N] = size(img_fft);
[U, V] = meshgrid(-N/2:N/2-1, -M/2:M/2-1);
D = sqrt(U.^2 + V.^2); % 距离频域中心的距离
D0 = 50; % 截止频率
H1 = 1 - exp(-D.^2 / (2 * D0^2)); % 高斯高通滤波器
H1 = 1 - H1; % 钝化模板

% 设计高提升滤波器
k = 5; % 增益系数
H2 = k - H1; % 高提升滤波器

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

