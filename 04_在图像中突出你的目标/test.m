clear; close all; clc

img = imread('test.png');
bw = img>100;
% 改成你自己的图像和算法
ed = bw-imerode(bw,strel('disk',4));
[label,num] = bwlabel(bw,8);
[edlabel,~] = bwlabel(ed,8);


figure('Position',[300,100,1200,800])
subplot(231),imshow(img),title('原图')
subplot(232),imshow(bw),title('二值图')
subplot(233),imshow(ed),title('标记图')
subplot(234),imagesc(label),title('标记图')
subplot(235),imagesc(edlabel),title('标记图')


tic
bboxList = zeros(num,5);
for n = 1:num
    [y,x] = find(label==n);
    bboxList(n,:) = [min(x),min(y),max(x)-min(x),max(y)-min(y),n];
end
toc


mycolor = [1,0,0;0,1,0;0,0,1;1,1,0;0,1,1];

% 画框
img = im2double(img);
img1 = insertShape(img,'rectangle',bboxList(:,1:4),...
    'LineWidth',2,'color',mycolor);
% 标记
img2 = insertObjectAnnotation(img,'rectangle',bboxList(:,1:4),bboxList(:,5),...
    'LineWidth',2,'Color',mycolor,'TextBoxOpacity',0.5,'FontSize',18);

alpha = [1,1,1,1,1];
% 画轮廓
img3 = drawlabel2image(img,edlabel,mycolor,alpha);
% 上色
img4 = drawlabel2image(img,label,mycolor,alpha/2);

figure('Position',[100,100,1750,850])
subplot(221),imshow(img1),title('画框')
subplot(222),imshow(img2),title('标记图')
subplot(223),imshow(img3),title('轮廓图')
subplot(224),imshow(img4),title('上色')



function colorimg = drawlabel2image(img,label,color,alpha)

[row,col,dim] = size(img);
% 检测是灰度图还是彩色图
if dim==1
    img = cat(3,img,img,img);
elseif dim==3
else
    error('请输入灰度图或RGB图')
end

% 预处理
img = im2double(img);
label = uint16(label);
nlabel = max(label(:));

% color修正:如果"分类数量>提供的颜色"，会利用循环自动增加颜色
while size(color,1)<nlabel
    color = cat(1,color,color);
end
% color修正:如果"分类数量<<提供的颜色"，会利用循环自动分配颜色
if size(color,1)>2*nlabel
    gap = floor(size(color,1)/nlabel);
    color = color(1:gap:end,:);
end
% alpha修正:如果"分类数量>提供的透明度"，会利用循环自动增加透明度
alpha = alpha(:);
while length(alpha)<nlabel
    alpha = cat(1,alpha,alpha);
end

% 保留背景（非目标部分）
mask = double(label>0);
bg = img.*double(~mask);

% 各label上色
obj = zeros(row,col,3,nlabel);
for idx = 1:nlabel
    objmask = double(label==idx);    
    R = img(:,:,1).*objmask*(1-alpha(idx))+objmask*color(idx,1)*alpha(idx);
    G = img(:,:,2).*objmask*(1-alpha(idx))+objmask*color(idx,2)*alpha(idx);
    B = img(:,:,3).*objmask*(1-alpha(idx))+objmask*color(idx,3)*alpha(idx);
    obj(:,:,:,idx) = cat(3,R,G,B);
end

colorimg = sum(obj,4)+bg;

end