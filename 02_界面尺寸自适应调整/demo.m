clear; close all; clc

GUI3()

% �ȱ�������
function GUI1()

Fig = figure('Position',[500,400,600,400],'Name','GUI','Color','white',...
    'menu','none','NumberTitle','off');

fileList = {'��Ա1','��Ա2','��Ա3','��Ա4','��Ա5','��Ա6',};
Pnl1 = uipanel(Fig,'Units','normalized','Position',[0.05,0.05,0.2,0.9]);
Pnl2 = uipanel(Fig,'Units','normalized','Position',[0.25,0.05,0.7,0.9]);

Bt = uicontrol(Pnl1,'style','pushbutton','String','��ť','Fontsize',12,...
    'Units','normalized','Position',[0,0.9,1,0.1]);
Lb = uicontrol(Pnl1,'style','listbox','String',fileList,'Fontsize',12,...
    'Unit','normalized','Position',[0,0,1,0.9]);

Menu = uicontrol(Pnl2,'style','popupmenu','String',fileList,'Fontsize',12,...
    'Units','normalized','Position',[0.05,0.9,0.6,0.1]);

Bt1 = uicontrol(Pnl2,'style','pushbutton','String','-','Fontsize',12,...
    'Units','normalized','Position',[0.7,0.9,0.1,0.1]);
Bt2 = uicontrol(Pnl2,'style','pushbutton','String','��','Fontsize',12,...
    'Units','normalized','Position',[0.8,0.9,0.1,0.1]);
Bt3 = uicontrol(Pnl2,'style','pushbutton','String','X','Fontsize',12,...
    'Units','normalized','Position',[0.9,0.9,0.1,0.1]);

Axes = axes('Parent',Pnl2,'XGrid','Off','YGrid','Off',...
    'Units','normalized','Position',[0.05,0.05,0.9,0.8]);
end


% �̶��ߴ�
function GUI2()

wt = 800;
ht = 600;

Fig = figure('Position',[500,100,wt,ht],'Name','GUI','Color','white',...
    'menu','none','NumberTitle','off');
Fig.Resize = 'off'; % �������
FigSize = Fig.Position(3:4);

fileList = {'��Ա1','��Ա2','��Ա3','��Ա4','��Ա5','��Ա6',};

Pnl1 = uipanel(Fig,...
    'Units','Pixels','Position',[0.05,0.05,0.2,0.9].*[FigSize,FigSize]);
Pnl1Size = Pnl1.Position(3:4);
Pnl2 = uipanel(Fig,...
    'Units','Pixels','Position',[0.25,0.05,0.7,0.9].*[FigSize,FigSize]);
Pnl2Size = Pnl2.Position(3:4);

Bt = uicontrol(Pnl1,'style','pushbutton','String','��ť','Fontsize',12,...
    'Units','Pixels','Position',[0,0.9,1,0.1].*[Pnl1Size,Pnl1Size]);
Lb = uicontrol(Pnl1,'style','listbox','String',fileList,'Fontsize',12,...
    'Unit','Pixels','Position',[0,0,1,0.9].*[Pnl1Size,Pnl1Size]);

fileList = {'��Ա1','��Ա2','��Ա3','��Ա4','��Ա5','��Ա6',};
Menu = uicontrol(Pnl2,'style','popupmenu','String',fileList,'Fontsize',12,...
    'Units','Pixels','Position',[0.05,0.9,0.6,0.1].*[Pnl2Size,Pnl2Size]);

Bt1 = uicontrol(Pnl2,'style','pushbutton','String','-','Fontsize',12,...
    'Units','Pixels','Position',[0.7,0.9,0.1,0.1].*[Pnl2Size,Pnl2Size]);
Bt2 = uicontrol(Pnl2,'style','pushbutton','String','��','Fontsize',12,...
    'Units','Pixels','Position',[0.8,0.9,0.1,0.1].*[Pnl2Size,Pnl2Size]);
Bt3 = uicontrol(Pnl2,'style','pushbutton','String','X','Fontsize',12,...
    'Units','Pixels','Position',[0.9,0.9,0.1,0.1].*[Pnl2Size,Pnl2Size]);

Axes = axes('Parent',Pnl2,'XGrid','Off','YGrid','Off',...
    'Units','Pixels','Position',[0.05,0.05,0.9,0.8].*[Pnl2Size,Pnl2Size]);

end

% ���ģʽ
function GUI3()

wt = 600;
ht = 400;

Fig = figure('Position',[500,100,wt,ht],'Name','GUI','Color','white',...
    'menu','none','NumberTitle','off');
Fig.ResizeFcn = @ResizeWindow; % �������
FigSize = Fig.Position(3:4);

fileList = {'��Ա1','��Ա2','��Ա3','��Ա4','��Ա5','��Ա6',};

Pnl1 = uipanel(Fig,...
    'Units','Pixels','Position',[20,20,120,ht-20]);
Pnl1Size = Pnl1.Position(3:4);
Pnl2 = uipanel(Fig,...
    'Units','Pixels','Position',[150,20,420,ht-20]);
Pnl2Size = Pnl2.Position(3:4);

Bt = uicontrol(Pnl1,'style','pushbutton','String','��ť','Fontsize',12,...
    'Units','Pixels','Position',[0,Pnl1Size(2)-30,Pnl1Size(1),30]);
Lb = uicontrol(Pnl1,'style','listbox','String',fileList,'Fontsize',12,...
    'Unit','Pixels','Position',[0,0,Pnl1Size(1),Pnl1Size(2)-30]);

fileList = {'��Ա1','��Ա2','��Ա3','��Ա4','��Ա5','��Ա6',};
Menu = uicontrol(Pnl2,'style','popupmenu','String',fileList,'Fontsize',12,...
    'Units','Pixels','Position',[0,Pnl2Size(2)-30,Pnl2Size(1)-100,30]);

Bt1 = uicontrol(Pnl2,'style','pushbutton','String','-','Fontsize',12,...
    'Units','Pixels','Position',[Pnl2Size(1)-90,Pnl2Size(2)-30,30,30]);
Bt2 = uicontrol(Pnl2,'style','pushbutton','String','��','Fontsize',12,...
    'Units','Pixels','Position',[Pnl2Size(1)-60,Pnl2Size(2)-30,30,30]);
Bt3 = uicontrol(Pnl2,'style','pushbutton','String','X','Fontsize',12,...
    'Units','Pixels','Position',[Pnl2Size(1)-30,Pnl2Size(2)-30,30,30]);

Axes = axes('Parent',Pnl2,'XGrid','Off','YGrid','Off',...
    'Units','Pixels','Position',[0,0,Pnl2Size(1),Pnl2Size(2)-30]);
imagesc(rand(100),'Parent',Axes)

    function ResizeWindow(~, ~)        
        FigSize = Fig.Position(3:4);
        if FigSize(1)>=wt && FigSize(1)>=ht
            % Pnl1��Ȳ���
            Pnl1.Position(4) = FigSize(2)-40;
            Pnl1Size = Pnl1.Position(3:4);
            % Pnl2�ȱ�����        
            Pnl2.Position(3:4) = [FigSize(1)-40-Pnl1Size(1),FigSize(2)-40];
            Pnl2Size = Pnl2.Position(3:4);                
            % Lb����
            Lb.Position(4) = Pnl1Size(2)-Bt.Position(4)-1;        
            % Bt����
            Bt.Position(2) = Pnl1Size(2)-Bt.Position(4);         
            % Menu����
            Menu.Position(2:3) = [Pnl2Size(2)-Menu.Position(4), Pnl2Size(1)-100];
            % Bt123����
            Bt1.Position(1:2) = [Pnl2Size(1)-90,Pnl2Size(2)-Bt1.Position(4)];
            Bt2.Position(1:2) = [Pnl2Size(1)-60,Pnl2Size(2)-Bt2.Position(4)];
            Bt3.Position(1:2) = [Pnl2Size(1)-30,Pnl2Size(2)-Bt3.Position(4)];
            % Axes�ȱ�����
            Axes.Position(3:4) = [Pnl2Size(1),Pnl2Size(2)-Menu.Position(4)];        
        else
            Fig.Position(3:4) = [wt,ht];
        end
    end

end
