clear; close all; clc

GUI()

function GUI()
WW = 1000;
WH = 800;
band = 10;

Fig = figure('Position',[500,100,WW,WH],'Name','GUI','Color','white',...
    'menu','none','NumberTitle','off');
Fig.ResizeFcn = @ResizeWindow; % 核心语句
FigSize = Fig.Position(3:4);


Pnl1 = uipanel(Fig,'Units','pixels','Position',[band,band,200,FigSize(2)-2*band]);
Pnl1Size = Pnl1.Position(3:4);

Pnl2 = uipanel(Fig,'Units','pixels','Position',...
    [band*2+Pnl1Size(1),band,FigSize(1)-Pnl1Size(1)-band*3,FigSize(2)-2*band]);
Pnl2Size = Pnl2.Position(3:4);
BtLoad = uicontrol(Pnl1,'style','pushbutton','String','加载图像','Fontsize',12,...
    'Units','pixels','Position',[0,Pnl1Size(2)-30,Pnl1Size(1),30],...
    'Callback',@LoadImage);
BtAdd = uicontrol(Pnl1,'style','pushbutton','String','增加窗口','Fontsize',12,...
    'Units','pixels','Position',[0,Pnl1Size(2)-60,Pnl1Size(1),30],...
    'Callback',@AddWindow);

Lb = uicontrol(Pnl1,'style','listbox',...
    'String',[],'Fontsize',12,...
    'Units','pixels','Position',[0,0,Pnl1Size(1),Pnl1Size(2)-60],...
    'Callback',@ShowImage);


% 存图像信息
fileList  = [];
imageList = [];

% 窗口信息
windowList = {};
windowNum = 0;

    function LoadImage(~,~)
        folderPath = uigetdir('.\','请选择一个路径');
        fileList = dir(fullfile(folderPath,'*.png'));
        fileList = {fileList.name};
        fileNum = length(fileList);
        set(Lb,'String',fileList);
        for i = 1:fileNum
            imageList{i} = imread(fullfile(folderPath,fileList{i}));
        end
    end

    function ShowImage(~,~)
        if ~isempty(imageList)
            AddWindow()
            imgidx = get(Lb,'Value');
            objIdx = windowNum;
            set(windowList{objIdx}.Menu,'Value',imgidx+1)
            imshow(imageList{imgidx},'Parent',windowList{objIdx}.Axes)
        end
    end

    function ChooseImage(~,~)
        % 你现在到底在操作哪一个窗口        
        dalei = get(Fig,'currentobject');
        objIdx = int16(str2double(dalei.Parent.Tag));
        % 操作
        imgidx = get(windowList{objIdx}.Menu,'Value')-1;
        if imgidx>0
            imshow(imageList{imgidx},'Parent',windowList{objIdx}.Axes)
        end
    end

    function MinWindow(~,~)
        % 课后作业
    end

    function MaxWindow(~,~)
        % 课后作业
    end

    function CloseWindow(~,~)
        % 你现在到底在操作哪一个窗口        
        dalei = get(Fig,'currentobject');
        objIdx = int16(str2double(dalei.Parent.Tag));
        % 操作 
        delete(windowList{objIdx}.Pnl)
        windowList(objIdx) = [];        
        windowNum = windowNum-1;
        if windowNum>0
            updata()
        end
    end

    function AddWindow(~,~)
        windowNum = windowNum+1;
        
        Pnl = uipanel(Pnl2,'Tag',num2str(windowNum),...
            'Units','pixels','Position',[0,0,1,1]);
        
        Menu = uicontrol(Pnl,'style','popupmenu',...
            'String',cat(2,{'请选择'},fileList),'Fontsize',12,...
            'Units','pixels','Position',[0,0,1,1],...
            'Callback',@ChooseImage);
        
        Bt1 = uicontrol(Pnl,'style','pushbutton','String','-','Fontsize',12,...
            'Units','pixels','Position',[0,0,1,1],...
            'Callback',@MinWindow);
        Bt2 = uicontrol(Pnl,'style','pushbutton','String','口','Fontsize',12,...
            'Units','pixels','Position',[0,0,1,1],...
            'Callback',@MaxWindow);
        Bt3 = uicontrol(Pnl,'style','pushbutton','String','X','Fontsize',12,...
            'Units','pixels','Position',[0,0,1,1],...
            'Callback',@CloseWindow);
        
        Axes = axes(Pnl,'Units','pixels','Position',[0,0,1,1]);
        
        SW.Pnl = Pnl;
        SW.Menu = Menu;
        SW.Bt1 = Bt1;
        SW.Bt2 = Bt2;
        SW.Bt3 = Bt3;
        SW.Axes = Axes;
        
        windowList{windowNum} = SW;
        updata()
    end

    function updata()
        % 计算尺寸
        rows = floor(sqrt(windowNum));
        cols = ceil(windowNum/rows);
        height = Pnl2Size(2)/rows;
        width = Pnl2Size(1)/cols;
        % 循环定位
        pos = zeros(rows*cols,4);
        for r = 1:rows
            for c = 1:cols
                idx = (r-1)*cols+c;
                pos(idx,:) = [(c-1)*width,(rows-r)*height,width,height];
            end
        end
        % 更新参数
        PnlSize = [width,height];
        for i = 1:windowNum
            % Panl
            windowList{i}.Pnl.Position = pos(i,:);
            windowList{i}.Pnl.Tag = num2str(i);
            % Menu
            windowList{i}.Menu.Position = [0,PnlSize(2)-30,PnlSize(1)-90,30];
            % Bt123不变
            windowList{i}.Bt1.Position = [PnlSize(1)-90,PnlSize(2)-30,30,30];
            windowList{i}.Bt2.Position = [PnlSize(1)-60,PnlSize(2)-30,30,30];
            windowList{i}.Bt3.Position = [PnlSize(1)-30,PnlSize(2)-30,30,30];
            % Axes等比缩放
            windowList{i}.Axes.Position = [0,0,PnlSize(1),PnlSize(2)-30];
        end
    end

    function ResizeWindow(~, ~)
        FigSize = Fig.Position(3:4);
        if FigSize(1)>=WW && FigSize(1)>=WH
            % Pnl1宽度不变
            Pnl1.Position(4) = FigSize(2)-2*band;
            Pnl1Size = Pnl1.Position(3:4);
            % Pnl2等比缩放
            Pnl2.Position(3:4) = [FigSize(1)-band*3-Pnl1Size(1),FigSize(2)-2*band];
            Pnl2Size = Pnl2.Position(3:4);
            % Lb拉长
            Lb.Position(4) = Pnl1Size(2)-BtLoad.Position(4)*2;
            % Bt不变
            BtLoad.Position(2) = Pnl1Size(2)-BtLoad.Position(4);
            BtAdd.Position(2) = Pnl1Size(2)-BtLoad.Position(4)*2;
            updata()
        end
    end

end
