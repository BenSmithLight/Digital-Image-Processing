% 读取图像
I = imread('../Picture/test1.jpeg');
% I = imread('../Picture/test2.jpeg');
% I = imread('../Picture/test3.jpeg');

image = I;
k = 5

% 定义平滑滤波器
blur_filter = fspecial('gaussian', [5 5], 2); % 5x5的高斯滤波器，标准差为2

% 应用平滑滤波器，得到平滑版本的图像
smoothed_image = imfilter(image, blur_filter, 'replicate');

% 计算非锐化掩蔽图像
unsharp_mask = image - smoothed_image;

% 增强图像
enhanced_image = image + k * unsharp_mask;

% 将强度重新映射回0-255
enhanced_image = uint8(enhanced_image);

% 显示增强后的图像
figure(1);
imshow(enhanced_image);

figure(2);
imshow(image);
