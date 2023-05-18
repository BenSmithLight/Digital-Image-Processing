% 读取图像
I = imread('../Picture/test1.jpeg');
% I = imread('../Picture/test2.jpeg');
% I = imread('../Picture/test3.jpeg');

image = I;

figure(1);
imshow(image);

% 将图像转换为double类型
image = im2double(image);

% 定义8邻域模板的拉普拉斯滤波器
laplacian_filter = [0 1 0; 1 -4 1; 0 1 0];

% 应用拉普拉斯滤波器
enhanced_image = imfilter(image, laplacian_filter);

% 对增强后的图像进行调整，以便显示
enhanced_image = image - enhanced_image;

% 将像素值限制在0到1之间
enhanced_image = max(0, min(1, enhanced_image));

% 显示增强后的图像
figure(2);
imshow(enhanced_image);



% 将图像转换为灰度图像
gray_image = rgb2gray(image);

% 计算图像的梯度
[dx, dy] = gradient(double(gray_image));

% 计算梯度幅值
gradient_magnitude = sqrt(dx.^2 + dy.^2);

gray_image = double(gray_image);

% 增强图像
enhanced_image = gray_image + 3*gradient_magnitude;

% 将像素值限制在0到255之间
enhanced_image = max(0, min(255, enhanced_image));

figure(3);
imshow(uint8(enhanced_image));