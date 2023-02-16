clear; close all; clc

img = imread('test.png');
bw = img>0;
ImgLabel(img,bw)


function ImgLabel(img,bw)

% ��������
Fig = figure('Position',[200,400,1600,600],'Name','GI','Color','white',...
    'menu','none','NumberTitle','off');
% �������
Pnl1 = uipanel(Fig,'Position',[0,0,0.9,1]);
Pnl2 = uipanel(Fig,'Position',[0.9,0,0.1,1]);
% ������ť
bn = 5;
buttomName = {'��ʾα��','��ʾ����','��ʾ�߿�','��ʾ��ע','����ͼ��'};
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
% ������ͼ��
Axes = cell(3,1);
for n = 1:3
    Axes{n} = axes(Pnl1,'Position',[(n-1)*1/3,0,1/3,1]);
end

% ��ʼ��ͼ����ʾ
imshow(img,'Parent',Axes{1})
imshow(bw,'Parent',Axes{2})
imshow(img,'Parent',Axes{3})

% ��ʼ�����������
img = im2double(img);
ed = bw-imerode(bw,strel('disk',2));
[label,num] = bwlabel(bw,8);
[edlabel,~] = bwlabel(ed,8);
bboxList = zeros(num,5);
for n = 1:num
    [y,x] = find(label==n);
    bboxList(n,:) = [min(x),min(y),max(x)-min(x),max(y)-min(y),n];
end

% ��MATLAB�Դ���ɫϵ����α��
mycolor = jet;
mycolor = mycolor(1:ceil(64/num):end,:);
alpha = ones(1,num);
imgres = [];

    function Show(~,~)
        imgres = cat(3,img,img,img);
        
        if get(Bt{1},'Value')
            % ��ɫ
            imgres = drawlabel2image(imgres,label,mycolor,alpha/2);
            set(Bt{1},'String','ȡ��α��')
        else
            set(Bt{1},'String','��ʾα��')
        end
        if get(Bt{2},'Value')
            % ������
            imgres = drawlabel2image(imgres,edlabel,mycolor,alpha);
            set(Bt{2},'String','ȡ������')
        else
            set(Bt{2},'String','��ʾ����')
        end
        if get(Bt{3},'Value')
            % ����
            imgres = insertShape(imgres,'rectangle',bboxList(:,1:4),...
                'LineWidth',2,'color',mycolor);
            set(Bt{3},'String','ȡ���߿�')
        else
            set(Bt{3},'String','��ʾ�߿�')
        end
        if get(Bt{4},'Value')
            % ���
            imgres = insertObjectAnnotation(imgres,'rectangle',bboxList(:,1:4),bboxList(:,5),...
                'LineWidth',2,'Color',mycolor,'TextBoxOpacity',0.9,'FontSize',18);
            set(Bt{4},'String','ȡ����ע')
        else
            set(Bt{4},'String','��ʾ��ע')
        end
        imshow(imgres,'Parent',Axes{3})
    end

    function Save(~,~)
        imwrite(imgres,['��עͼ',datestr(now,'yyyymmddTHHMMSS'),'.jpg'])
    end

end


% img-ԭʼͼ��255�ҶȻ��ɫ��
% label-Ŀ���ǩ���Ǹ�������
% color-ÿ�������ɫ(��СΪN*3�ľ���
% alpha-ÿ������ɫ�Ĳ�͸���ȣ�N*1�ľ���
function colorimg = drawlabel2image(img,label,color,alpha)

[row,col,dim] = size(img);
% ����ǻҶ�ͼ���ǲ�ɫͼ
if dim==1
    img = cat(3,img,img,img);
elseif dim==3
else
    error('������Ҷ�ͼ��RGBͼ')
end

% Ԥ����
label = double(label);
nlabel = max(label(:));

% color����:���"��������>�ṩ����ɫ"��������ѭ���Զ�������ɫ
while size(color,1)<nlabel
    color = cat(1,color,color);
end
% color����:���"��������<<�ṩ����ɫ"��������ѭ���Զ�������ɫ
if size(color,1)>2*nlabel
    gap = floor(size(color,1)/nlabel);
    color = color(1:gap:end,:);
end
% alpha����:���"��������>�ṩ��͸����"��������ѭ���Զ�����͸����
alpha = alpha(:);
while length(alpha)<nlabel
    alpha = cat(1,alpha,alpha);
end

% ������������Ŀ�겿�֣�
mask = double(label>0);
bg = img.*double(~mask);

% ��label��ɫ
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
