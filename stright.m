% 读取图像
% I = imread('../Picture/test1.jpeg');
% I = imread('../Picture/test2.jpeg');
I = imread('../Picture/test3.jpeg');
% 转换为灰度图像
% I = rgb2gray(I);
I = im2double(I); % 或者使用 im2uint8(image)
% 显示原始图像及其直方图
figure;
subplot(2, 2, 1);
imshow(I);
title('原始图像');
subplot(2, 2, 2);
imhist(I);
title('原始直方图');
% 使用 histeq 函数进行直方图均衡化
J = histeq(I);
% 显示增强后的图像及其直方图
subplot(2, 2, 3);
imshow(J);
title('增强后的图像');
subplot(2, 2, 4);
imhist(J);
title('增强后的直方图');
