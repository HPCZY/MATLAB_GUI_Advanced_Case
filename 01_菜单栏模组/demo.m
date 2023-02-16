clear; close all; clc

MenuTest()

function MenuTest()

% 主界面
H.Fig = figure('Name','test','Position',[900,500,600,400],...
    'menu','none','Color','white','NumberTitle','off');
% 菜单栏
CreateMenu(H)

    % 菜单栏生成函数
    function CreateMenu(HMenu)
        % 获取菜单列表
        [~,~,menuList] = xlsread('menulist.xlsx');
        menuList = menuList(2:end,:);
        menuNum = size(menuList,1);
        % 重排序
        [~,idx] = sort(cell2mat(menuList(:,1)));
        menuList = menuList(idx,:);
        
        % 开始创建
        params = {'Text','MenuSelectedFcn','Checked','Separator','Accelerator'};
        for mn = 1:menuNum
            menuinfo = menuList(mn,:);
            % 初始化
            Hname = strcat('HMenu.',menuinfo{2});
            if menuinfo{1}==0
                str = strcat(Hname,'=uimenu(HMenu.Fig);');
            else
                str = strcat(Hname,'=uimenu(','HMenu.',menuList{menuinfo{1},2},');');
            end
            eval(str)
            % 设置参数
            for n = 1:5
                if isnan(menuinfo{n+2})
                   continue
                end
                if n==2
                    str = strcat(Hname,'.',params{n},'=@',menuinfo{n+2},';');  
                else
                    str = strcat(Hname,'.',params{n},'=menuinfo{',num2str(n+2),'};');  
                end
                eval(str)
            end
        end
    end

end




