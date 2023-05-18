% 读取图像
I = imread('../Picture/test1.jpeg');
% I = imread('../Picture/test2.jpeg');
% I = imread('../Picture/test3.jpeg');

image = I;

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

% 显示增强后的图像
figure(1);
imshow(uint8(enhanced_image));

figure(2);
imshow(image);
