clear; close all; clc

img = imread('test.png');
bw = img>0;
ImgLabel(img,bw)


function ImgLabel(img,bw)

% 创建界面
Fig = figure('Position',[200,400,1600,600],'Name','GI','Color','white',...
    'menu','none','NumberTitle','off');
% 创建面板
Pnl1 = uipanel(Fig,'Position',[0,0,0.9,1]);
Pnl2 = uipanel(Fig,'Position',[0.9,0,0.1,1]);
% 创建按钮
bn = 5;
buttomName = {'显示伪彩','显示轮廓','显示边框','显示标注','保存图像'};
Bt = cell(bn,1);
for n = 1:bn    
    if n<5
        Bt{n} = uicontrol(Pnl2,'style','togglebutton',...
            'String',buttomName{n},'Fontsize',16,...
            'Units','normalized','Position',[0,(n-1)/bn,1,1/bn],...
            'Callback',@Show);
    else
        Bt{n} = uicontrol(Pnl2,'style','pushbutton',...
            'String',buttomName{n},'Fontsize',16,...
            'Units','normalized','Position',[0,(n-1)/bn,1,1/bn],...
            'Callback',@Save);
    end
end
% 创建绘图窗
Axes = cell(3,1);
for n = 1:3
    Axes{n} = axes(Pnl1,'Position',[(n-1)*1/3,0,1/3,1]);
end

% 初始化图像显示
imshow(img,'Parent',Axes{1})
imshow(bw,'Parent',Axes{2})
imshow(img,'Parent',Axes{3})

% 初始化参数与计算
img = im2double(img);
ed = bw-imerode(bw,strel('disk',2));
[label,num] = bwlabel(bw,8);
[edlabel,~] = bwlabel(ed,8);
bboxList = zeros(num,5);
for n = 1:num
    [y,x] = find(label==n);
    bboxList(n,:) = [min(x),min(y),max(x)-min(x),max(y)-min(y),n];
end

% 用MATLAB自带的色系生成伪彩
mycolor = jet;
mycolor = mycolor(1:ceil(64/num):end,:);
alpha = ones(1,num);
imgres = [];

    function Show(~,~)
        imgres = cat(3,img,img,img);
        
        if get(Bt{1},'Value')
            % 上色
            imgres = drawlabel2image(imgres,label,mycolor,alpha/2);
            set(Bt{1},'String','取消伪彩')
        else
            set(Bt{1},'String','显示伪彩')
        end
        if get(Bt{2},'Value')
            % 画轮廓
            imgres = drawlabel2image(imgres,edlabel,mycolor,alpha);
            set(Bt{2},'String','取消轮廓')
        else
            set(Bt{2},'String','显示轮廓')
        end
        if get(Bt{3},'Value')
            % 画框
            imgres = insertShape(imgres,'rectangle',bboxList(:,1:4),...
                'LineWidth',2,'color',mycolor);
            set(Bt{3},'String','取消边框')
        else
            set(Bt{3},'String','显示边框')
        end
        if get(Bt{4},'Value')
            % 标记
            imgres = insertObjectAnnotation(imgres,'rectangle',bboxList(:,1:4),bboxList(:,5),...
                'LineWidth',2,'Color',mycolor,'TextBoxOpacity',0.9,'FontSize',18);
            set(Bt{4},'String','取消标注')
        else
            set(Bt{4},'String','显示标注')
        end
        imshow(imgres,'Parent',Axes{3})
    end

    function Save(~,~)
        imwrite(imgres,['标注图',datestr(now,'yyyymmddTHHMMSS'),'.jpg'])
    end

end


% img-原始图像（255灰度或彩色）
% label-目标标签（非负整数）
% color-每个类的颜色(大小为N*3的矩阵）
% alpha-每个类颜色的不透明度（N*1的矩阵）
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
label = double(label);
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
