%% 读取图像
image1 = imread('../Picture/test1.jpeg');
image2 = imread('../Picture/test2.jpeg');
image3 = imread('../Picture/test3.jpeg');

image = image1;

image = rgb2gray(image);

%% 设置滤波器参数
r_h = 0.5;
r_l = 0.25;
D_0 = 10;
c = 1;
%% 读取图片并进行傅立叶变换
img = im2double(image);
max0 = max(img(:));
min0 = min(img(:));
img = log(img+1e-12);
img_f = fftshift(fft2(img));
%% 获取滤波器
[h,w] = size(img_f);
[x,y] = meshgrid(-w/2:w/2,-h/2:h/2);
H = h_generate_2d(r_h,r_l,c,x,y,D_0,D_0);
H = imresize(H,[h,w]);
%% 进行频域滤波
img_f_filter = img_f.*H;
%% 显示频谱
figure,
set(gcf,'position',[100,100,1020*1,520*0.6]);
subplot(1,3,1);colormap gray;
imagesc(log(abs(img_f)+1e-12));
title('滤波前频谱')
subplot(1,3,2);colormap gray;
imagesc(H);
title('滤波器')
subplot(1,3,3);colormap gray;
imagesc(log(abs(img_f_filter)+1e-12));
title('滤波后频谱')
%% 反变换到空域
img_out = real(ifft2(ifftshift(img_f_filter)));
img_out = exp(img_out);
img_out = (img_out-min(img_out(:)));
img_out = img_out/max(img_out(:));
img_out=img_out*(max0-min0)+min0;
img = exp(img);
%% 显示结果图片
figure,
set(gcf,'position',[100,100,1020*0.8,520*0.6]);
subplot(1,2,1);
imagesc(img);colormap gray;colorbar
title('原始图片')
subplot(1,2,2);
imagesc(img_out);colormap gray;colorbar
title('同态滤波后图片')
%% 滤波器计算函数
function h = h_generate_2d(r_h,r_l,c,x,y,D_0,D_1)
    h = (r_h-r_l)*(1-exp(-c*(x.^2+y.^2)/(D_0^2+D_1^2)))+r_l;
end