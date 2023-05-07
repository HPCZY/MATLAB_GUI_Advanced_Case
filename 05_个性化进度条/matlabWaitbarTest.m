clear; clc

%% 初始化进度条
hwb = waitbar(0,'开始了哦','Name','MATLAB进度条测试1');

%% 算法
iter = 500;
tstart = tic;
for i = 1:iter
    % 核心算法
    pause(0.01)
    % --------
 
    % 更新进度条
    if ~rem(i,10)
        % 当前用时
        tnow = toc(tstart);
        % 剩余时间
        trem = tnow/i*(iter-i);
        tips = {['用时：',num2str(round(tnow,1)),...
                '，剩余：',num2str(round(trem,1))];
                [num2str(i),' / ',num2str(iter)]};
        waitbar(i/iter,hwb,tips)
    end
end
toc
% 关闭进度条
close(hwb)