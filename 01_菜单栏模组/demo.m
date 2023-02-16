clear; close all; clc

MenuTest()

function MenuTest()

% ������
H.Fig = figure('Name','test','Position',[900,500,600,400],...
    'menu','none','Color','white','NumberTitle','off');
% �˵���
CreateMenu(H)

    % �˵������ɺ���
    function CreateMenu(HMenu)
        % ��ȡ�˵��б�
        [~,~,menuList] = xlsread('menulist.xlsx');
        menuList = menuList(2:end,:);
        menuNum = size(menuList,1);
        % ������
        [~,idx] = sort(cell2mat(menuList(:,1)));
        menuList = menuList(idx,:);
        
        % ��ʼ����
        params = {'Text','MenuSelectedFcn','Checked','Separator','Accelerator'};
        for mn = 1:menuNum
            menuinfo = menuList(mn,:);
            % ��ʼ��
            Hname = strcat('HMenu.',menuinfo{2});
            if menuinfo{1}==0
                str = strcat(Hname,'=uimenu(HMenu.Fig);');
            else
                str = strcat(Hname,'=uimenu(','HMenu.',menuList{menuinfo{1},2},');');
            end
            eval(str)
            % ���ò���
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




