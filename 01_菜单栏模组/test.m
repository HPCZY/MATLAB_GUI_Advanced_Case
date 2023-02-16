clear; close all; clc

menutest()

function menutest()

Fig = figure('Name','test','Position',[600,400,600,600],...
    'menu','none','Color','white','NumberTitle','off');

M0 = uimenu(Fig,'Text','Œƒº˛');
M1 = uimenu(Fig,'Text','±‡º≠'); 

M0_1 = uimenu(M0,'Text','œ‘ æ∫ÏÕº'); 
M0_2 = uimenu(M0,'Text','œ‘ æ¿∂Õº'); 

M0_1.MenuSelectedFcn = @doit1;
M0_1.Checked = 'off';
M0_1.Separator = 'off';
M0_1.Accelerator = 'A';

M0_2.MenuSelectedFcn = @doit2;
M0_2.Checked = 'off';
M0_2.Separator = 'off';
M0_2.Accelerator = 'B';

Axes = axes(Fig,'Position',[0.1,0.1,0.8,0.8]);

    function doit1(~,~)
        M0_1.Checked = 'on';
        M0_2.Checked = 'off';
        im = cat(3,ones(100),zeros(100),zeros(100));
        imshow(im,'Parent',Axes)
    end

    function doit2(~,~)
        M0_1.Checked = 'off';
        M0_2.Checked = 'on';
        im = cat(3,zeros(100),zeros(100),ones(100));
        imshow(im,'Parent',Axes)
    end

end




